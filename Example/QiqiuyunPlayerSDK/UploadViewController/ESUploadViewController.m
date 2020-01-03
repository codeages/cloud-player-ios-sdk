//
//  ESUploadViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESUploadViewController.h"
#import "ESPopoverView.h"
#import "ESUploadSimulator.h"
#import "ESUploadTableViewCell.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import <CoreServices/CoreServices.h>
#import "ESUploadTableViewSectionHeader.h"
#import "NSString+extno.h"
#import <AFNetworking/AFNetworking.h>
#import <ESCloudPlayerSDK/NSString+Hash.h>

@interface ESUploadViewController ()<UIDocumentPickerDelegate, ESUploadSimulatorDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) ESUploadSimulator *uploadSimulator;
@property (nonatomic, strong) JGProgressHUD *HUD;
@property (nonatomic, weak) ESUploadManager *uploadMgr;

@property (nonatomic, strong) NSMutableArray *uploadTasks;
@property (nonatomic, strong) AFHTTPSessionManager *apiSession;

@end

@implementation ESUploadViewController
- (NSString *)tipText {
    return @"上传过程只是演示，资源不会真正上传。上传成功后 返回的是演示固定的资源。";
}

- (AFHTTPSessionManager *)apiSession {
    if (!_apiSession) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPRequestSerializer *requestSer = [AFHTTPRequestSerializer serializer];
        [requestSer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        _apiSession = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SCHOOL_HOST] sessionConfiguration:sessionConfig];
        _apiSession.requestSerializer = requestSer;
    }
    return _apiSession;
}

- (ESUploadSimulator *)uploadSimulator {
    if (!_uploadSimulator) {
        _uploadSimulator = [[ESUploadSimulator alloc]initWithProgressInterval:0.1];
        _uploadSimulator.delegate = self;
    }
    return _uploadSimulator;
}

- (JGProgressHUD *)HUD {
    if (!_HUD) {
        _HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        JGProgressHUDPieIndicatorView *indicatorView = [[JGProgressHUDPieIndicatorView alloc] init];
        _HUD.indicatorView = indicatorView;
        _HUD.textLabel.text = @"上传中";
    }
    return _HUD;
}


- (NSArray *)documentTypes {
    return @[
        @[@"public.movie"],
        @[@"public.audio"],
        @[
            @"com.adobe.pdf",
            @"com.microsoft.word.doc",
            @"com.microsoft.excel.xls",
            @"org.openxmlformats.wordprocessingml.document",
            @"org.openxmlformats.spreadsheetml.sheet"
        ],
        @[@"com.microsoft.powerpoint.ppt", @"org.openxmlformats.presentationml.presentation"],
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传课程资源";
    self.uploadMgr = [ESUploadManager defaultManager];
    self.uploadMgr.baseURL = [NSURL URLWithString:SCHOOL_HOST];
    self.uploadMgr.startPath = START_UPLOAD;
    self.uploadMgr.finishPath = FINISH_UPLOAD;

    [self.uploadMgr progress:YES handler:^(ESUploadManager *mgr) {
        
    }];
    
    [self.uploadMgr success:YES handler:^(ESUploadManager *mgr) {
        
    }];
    
    [self.uploadMgr failure:YES handler:^(ESUploadManager *mgr) {
        
    }];

    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:@"ESUploadTableViewCell" bundle:nil] forCellReuseIdentifier:@"ESUploadTableViewCell"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"上传" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(uploadFileClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *uploadItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = uploadItem;
    [self fetchResourceList];
}

- (void)fetchResourceList{
    @weakify(self);
    [self showProgressInView:self.view];
    [self.apiSession GET:@"api/resources" parameters:@{@"limit":@"20", @"start":@"0", @"order":@"DESC",@"sortBy":@"id"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        [self dissMissProgressInView:self.view];
        if (responseObject) {
            self.resourceModels = [NSArray modelArrayWithClass:ESDownloadResourceModel.class json:responseObject].mutableCopy;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dissMissProgressInView:self.view];
        [self showError:error view:self.view];
    }];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resourceModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESUploadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ESUploadTableViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        ESDownloadResourceModel *resource = self.resourceModels[indexPath.row];
        cell.fileNameLabel.text = [NSString stringWithFormat:@"课时%ld：%@", (long)indexPath.row, resource.fileName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [ESUploadTableViewSectionHeader createUploadTableViewSectionHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
}
#pragma mark -
- (void)uploadFileClick:(UIButton *)sender {
    NSArray *titles = @[@"发布视频", @"发布音频", @"发布文档", @"发布PPT"];
    NSArray *images = @[
        [UIImage imageNamed:@"upload_video_icon"],
        [UIImage imageNamed:@"upload_audio_icon"],
        [UIImage imageNamed:@"upload_doc_icon"],
        [UIImage imageNamed:@"upload_ppt_icon"],
    ];
    ESPopoverView *popover = [[ESPopoverView alloc] initWithView:sender titles:titles images:images];
    popover.backColor = [UIColor whiteColor];
    popover.titleColor = [UIColor blackColor];
    popover.selectedTitleColor = [UIColor grayColor];
    popover.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    __weak typeof(self) _self = self;
    popover.selectRowAtIndex = ^(NSInteger index) {
        __strong typeof(_self) self = _self;
        [self openDocumentPicker:index];
    };
    [popover show];
}

- (void)openDocumentPicker:(NSInteger)index {
    NSArray *documentTypes = [[self documentTypes] objectAtIndex:index];
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc]initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(nonnull NSArray<NSURL *> *)urls {
    [self dismissViewControllerAnimated:YES completion:nil];
    //授权
    BOOL fileAuthorized = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileAuthorized) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc]init];
        NSError *error;

        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *_Nonnull newURL) {
            //读取文件
            NSString *fileName = [newURL lastPathComponent];
            NSError *error = nil;
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            if (error) {
                [self showError:error view:self.view];
            } else {
                [self showProgressInView:self.view];
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
                    //写入沙盒Temp
                   NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
                   [fileData writeToFile:filePath atomically:YES];
                   NSString *extno = [NSString extno];
                   NSString *fileHash = [filePath hashFileAtPath];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self dissMissProgressInView:self.view];
                       ESUploadInfo *uploadInfo = [[ESUploadInfo alloc]initWithFileURL:[NSURL fileURLWithPath:filePath] fileName:fileName fileHash:fileHash];
                       uploadInfo.extno = extno;
                       ESUploadDirectivesInfo *directives = [[ESUploadDirectivesInfo alloc]init];
                       directives.watermarks = @"http://www.edusoho.com/bundles/topxiaweb/v2/img/logo.png?v3.20.4";
                       uploadInfo.directives = directives;
                       [self startUploadFile:uploadInfo];
                   });
                });
            }
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        NSLog(@"授权失败");
    }
}

- (void)simulator:(ESUploadSimulator *)simulator didUpdateProgress:(double)progress {
    if (progress > 0) {
        [self.HUD setProgress:progress animated:YES];
        if (progress >= 1) {
            [self.HUD dismissAnimated:YES];
            [self showSuccess:@"上传成功" view:self.view];
            [self.tableView reloadData];
            self.HUD = nil;
        }
    }
}

- (void)startUploadFile:(ESUploadInfo *)info {
    ESUploadTask *task = [self.uploadMgr upload:info];
    @weakify(self);
    [task progress:YES handler:^(ESUploadTask *t) {
        CGFloat progress = t.progress.completedUnitCount / (t.progress.totalUnitCount * 1.0);
        if (!self.HUD.visible) {
            [self.HUD showInView:self.view animated:YES];
        }
        [self.HUD setProgress:progress animated:YES];
    }];

    [task success:YES handler:^(ESUploadTask *t) {
        @strongify(self);
        [self.HUD dismissAnimated:YES];
        [self fetchResourceList];
        [self showSuccess:@"上传成功" view:self.view];
    }];

    [task failure:YES handler:^(ESUploadTask *t) {
        @strongify(self);
        [self.tableView reloadData];
        [self.HUD dismissAnimated:YES];
        [self showError:t.error view:self.view];
    }];
    [self.tableView reloadData];
    
}

@end
