//
//  ESBaseTableViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESBaseTableViewController.h"
#import "ESTopTipView.h"
#import "ESPPTViewController.h"
#import "ESVideoViewController.h"
#import "ESDocumetntViewController.h"
#import "ESAudioViewController.h"
#import "ESAppDelegate.h"
#import "ESJWTTokenTool.h"

@interface ESBaseTableViewController ()
@property (strong, nonatomic) ESTopTipView *topTipView;

@end

@implementation ESBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topTipView = [ESTopTipView createTopTipViewWithTipText:self.tipText];
    self.topTipView.frame = CGRectMake(0, 0, 0, 50);
    @weakify(self);
    self.topTipView.rightButtonClick = ^{
        @strongify(self);
        self.tableView.tableHeaderView = nil;
    };
    [self.view addSubview:self.topTipView];

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableHeaderView =  self.topTipView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ESDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:@"ESDownloadTableViewCell"];
    [self.view addSubview:self.tableView ];
    ESAppDelegate *appDelegate = (ESAppDelegate *)[UIApplication sharedApplication].delegate;
    self.resourceModels = appDelegate.resourceModels;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//    }];
//    return @[delAction];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ESBaseViewController *vc;
    ESDownloadResourceModel *resource = self.resourceModels[indexPath.row];
    if ([resource.type isEqualToString:@"other"]) {
        [self showMessage:@"不支持该文件预览"];
        return;
    }
    NSString *token = resource.token;
    NSURL *baseURL;
    if (!token) {
        if (![resource.processStatus isEqualToString:@"ok"]) {
            [self showMessage:@"转码中"];
            return;
        }
        token = [ESJWTTokenTool JWTTokenWithPlayload:resource.no previewTime:0 headResNo:@"" isPlayAudio:YES];
        baseURL = [NSURL URLWithString:PLAYER_HOST];
    }
    if ([resource.type isEqualToString:@"video"]) {
        vc = [[ESVideoViewController alloc]initWithBaseURL:baseURL];
    } else if ([resource.type isEqualToString:@"ppt"]) {
        vc = [[ESPPTViewController alloc]initWithBaseURL:baseURL];
    } else if ([resource.type isEqualToString:@"document"]) {
        vc = [[ESDocumetntViewController alloc]initWithBaseURL:baseURL];
    } else if ([resource.type isEqualToString:@"audio"]) {
        vc = [[ESAudioViewController alloc]initWithBaseURL:baseURL];
    }
    if (vc) {
        vc.token = token;
        vc.resNo = resource.resNo;
        vc.title = resource.fileName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
