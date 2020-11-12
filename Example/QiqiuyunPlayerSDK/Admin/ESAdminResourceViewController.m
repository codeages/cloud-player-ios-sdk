//
//  ESAdminResourceViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/12.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESAdminResourceViewController.h"
#import "ESUploadTableViewCell.h"
#import <QMUIKit/QMUIAlertController.h>
#import <QMUIKit/QMUITextField.h>
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import "ESJWTTokenTool.h"

@interface ESAdminResourceViewController ()<MGSwipeTableCellDelegate>
@property (weak, nonatomic)  UITextField *fileNameTextField;
@property (nonatomic, strong) AFHTTPSessionManager *apiSession;

@end

@implementation ESAdminResourceViewController
- (NSString *)tipText {
    return @"点击名称播放，左滑可以编辑和删除";
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

- (NSArray<UIView *> *)rightButtons
{
    MGSwipeButton *editButton = [MGSwipeButton buttonWithTitle:@"编辑" backgroundColor:[UIColor colorWithRGB:0xF1F1F1] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        return YES;
    }];
    [editButton setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    editButton.buttonWidth = 60;
                                
    MGSwipeButton *delButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor colorWithRGB:0xFD4852]];
    delButton.buttonWidth = 60;
    delButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    return @[delButton, editButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resourceModels = nil;
    self.title = @"管理资源库";
    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:@"ESUploadTableViewCell" bundle:nil] forCellReuseIdentifier:@"ESUploadTableViewCell"];
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchResourceList];
    }];
    [self.tableView setMj_header:header];
    [[self.tableView mj_header] beginRefreshing];
}

#pragma mark -
- (void)fetchResourceList{
    @weakify(self);
    [self showProgressInView:self.view];
    [self.apiSession GET:@"api/resources" parameters:@{@"limit":@"100", @"start":@"0", @"order":@"DESC",@"sortBy":@"id"} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
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

- (void)deleteResources:(NSUInteger)index {
    ESDownloadResourceModel *model = self.resourceModels[index];
    NSString *path = [NSString stringWithFormat:@"api/resources/%@/delete",model.no];
    [self showProgressInView:self.view];
    @weakify(self);
    [self.apiSession POST:path parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        [self dissMissProgressInView:self.view];
        [self  fetchResourceList];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dissMissProgressInView:self.view];
        [self showError:error view:self.view];
    }];
}


- (void)updateResource:(NSUInteger)index fileName:(NSString *)fileName{
    if (fileName.length <= 0) {
        return;
    }
    ESDownloadResourceModel *model = self.resourceModels[index];
    fileName = [NSString stringWithFormat:@"%@.%@",fileName,model.fileName.pathExtension];
    [self showProgressInView:self.view];
    NSString *path = [NSString stringWithFormat:@"api/resources/%@/update",model.no];
    [self.apiSession POST:path parameters:@{@"no":model.no?:@"",@"name":fileName} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dissMissProgressInView:self.view];
        [[self.tableView mj_header] beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dissMissProgressInView:self.view];
        [self showError:error view:self.view];
    }];
}


- (void)getDownloadURL:(NSUInteger)index{
    ESDownloadResourceModel *model = self.resourceModels[index];
    NSString *path = [NSString stringWithFormat:@"api/resources/%@/downloadUrl",model.no];
    [self.apiSession GET:path parameters:@{@"no":model.no} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError:error view:self.view];
    }];
}

- (void)getShareURL:(NSUInteger)index{
    ESDownloadResourceModel *model = self.resourceModels[index];
    NSString *path = [NSString stringWithFormat:@"api/resources/%@/shareUrl",model.no];
    [self.apiSession GET:path parameters:nil headers:nil progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showError:error view:self.view];
    }];
}
- (void)modeifyResource:(NSInteger)index{
    @weakify(self);
        QMUIAlertController *aVC = [[QMUIAlertController alloc]initWithTitle:@"修改的资源文件名" message:nil preferredStyle:QMUIAlertControllerStyleAlert];
        [aVC addTextFieldWithConfigurationHandler:^(QMUITextField *_Nonnull textField) {
            @strongify(self)
            textField.placeholder = @"请输入文件名";
            self.fileNameTextField = textField;
        }];

        QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"确认" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
            @strongify(self)
            if (self.fileNameTextField.text.length <= 0) {
                [self showMessage:@"请输入文件名"];
                return;
            }
            [self updateResource:index fileName:self.fileNameTextField.text];
        }];

        QMUIAlertAction *cAction = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *_Nonnull aAlertController, QMUIAlertAction *_Nonnull action) {
        }];

        [aVC addAction:action];
        [aVC addAction:cAction];
        [aVC showWithAnimated:YES];
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
    ESDownloadResourceModel *resource = self.resourceModels[indexPath.row];
    cell.fileNameLabel.text = resource.fileName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}


#pragma mark -
-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
    if (direction == MGSwipeDirectionRightToLeft) {
        if (index == 0) {
            @weakify(self);
            MGSwipeButton *delButton = [MGSwipeButton buttonWithTitle:@"确认删除" backgroundColor:[UIColor colorWithRGB:0xFD4852] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
                @strongify(self);
                NSIndexPath *path = [self.tableView indexPathForCell:cell];
                [self deleteResources:path.row];
                return YES;
            }];
            delButton.titleLabel.font = [UIFont systemFontOfSize:14];
            delButton.buttonWidth = 100;
            delButton.tag = 10001;
            cell.rightButtons = @[delButton];
            [cell refreshButtons:NO];
            return NO;
        }else if (index == 1){
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self modeifyResource:indexPath.row];
        }
    }
    return YES;
}

-(nullable NSArray<UIView*>*) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
                               swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings{
    if (direction == MGSwipeDirectionRightToLeft) {
        swipeSettings.transition = MGSwipeTransitionClipCenter;
        swipeSettings.allowsButtonsWithDifferentWidth = YES;
        expansionSettings.fillOnTrigger = YES;
        expansionSettings.threshold = 1.1;
        return [self rightButtons];
    }
    return @[];
}

- (void)swipeTableCell:(MGSwipeTableCell *)cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive{
    MGSwipeButton *firstButton = (MGSwipeButton *)[cell.rightButtons firstObject];
    if (firstButton.tag == 10001) {
         [cell refreshButtons:YES];
    }
}


@end
