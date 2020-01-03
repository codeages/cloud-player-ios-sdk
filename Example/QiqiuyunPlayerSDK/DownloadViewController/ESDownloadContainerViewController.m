//
//  ESDownloadContainerViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/6.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESDownloadContainerViewController.h"
#import "TYTabPagerController.h"
#import <YYKit/YYKit.h>
#import "ESDownloadedViewController.h"
#import "ESDownloadingViewController.h"

@interface ESDownloadContainerViewController ()<TYTabPagerControllerDataSource, TYTabPagerControllerDelegate>
@property (strong, nonatomic) TYTabPagerController *detailViewController;
@property (strong, nonatomic) ESDownloadedViewController *downloadedVC;
@property (strong, nonatomic) ESDownloadingViewController *downloadingdVC;
@end

@implementation ESDownloadContainerViewController
- (TYTabPagerController *)detailViewController {
    if (!_detailViewController) {
        _detailViewController = [[TYTabPagerController alloc] init];
        @weakify(self)
//        _detailViewController.didScrollToTabPageIndexHandle = ^(NSInteger index) {
//        };
        _detailViewController.tabBarOrignY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _detailViewController.dataSource = self;
        _detailViewController.delegate = self;
        _detailViewController.tabBarHeight = 50;
        _detailViewController.layout.scrollView.scrollEnabled = NO;
        _detailViewController.view.frame = self.view.bounds;
        _detailViewController.tabBar.layout.barStyle = TYPagerBarStyleProgressView;
        _detailViewController.tabBar.layout.adjustContentCellsCenter = YES;
        _detailViewController.tabBar.layout.cellWidth = 80;
        _detailViewController.tabBar.layout.cellEdging = 0;
        _detailViewController.tabBar.layout.cellSpacing = 100;
        _detailViewController.tabBar.layout.progressHeight = 3;
        _detailViewController.tabBar.layout.progressWidth = 80;
        _detailViewController.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
        _detailViewController.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:15];
        _detailViewController.tabBar.layout.progressColor = [UIColor colorWithRGB:GREEN_COLOR_RGB];
        _detailViewController.tabBar.layout.normalTextColor = [UIColor colorWithRGB:GRAY_COLOR_RGB];
        _detailViewController.tabBar.layout.selectedTextColor = [UIColor colorWithRGB:GREEN_COLOR_RGB];
        _detailViewController.tabBar.backgroundView.backgroundColor = [UIColor grayColor];
        [_detailViewController reloadData];
        
    }
    return _detailViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已下载资源";
    [self addChildViewController:self.detailViewController];
    [self.view insertSubview:self.detailViewController.view atIndex:0];
    
    self.downloadedVC = [[ESDownloadedViewController alloc]init];
    self.downloadingdVC = [[ESDownloadingViewController alloc]init];
    

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    CGRect frame = self.view.bounds;
//    frame.origin.y = 64;
//    self.detailViewController.view.frame = frame;
}

- (NSInteger)numberOfControllersInTabPagerController {
    return 2;
}

- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    if (index == 0) {
        return @"已下载";
    }else{
        return @"下载中";
    }
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index == 0) {
        self.navigationItem.rightBarButtonItem = [self.downloadedVC rightBarButtonItem];
        return self.downloadedVC;
    }else{
        self.navigationItem.rightBarButtonItem = [self.downloadingdVC rightBarButtonItem];
        return self.downloadingdVC;
    }
}

- (void)tabPagerControllerDidEndScrolling:(TYTabPagerController *)tabPagerController animate:(BOOL)animate{
    if (self.detailViewController.layout.curIndex == 0) {
        self.navigationItem.rightBarButtonItem = [self.downloadedVC rightBarButtonItem];
    }else{
        self.navigationItem.rightBarButtonItem = [self.downloadingdVC rightBarButtonItem];
    }
}

- (void)tabPagerController:(TYTabPagerController *)tabPagerController didSelectTabBarItemAtIndex:(NSInteger)index{
    if (index == 0) {
        self.navigationItem.rightBarButtonItem = [self.downloadedVC rightBarButtonItem];
    }else{
        self.navigationItem.rightBarButtonItem = [self.downloadingdVC rightBarButtonItem];
    }
}

@end
