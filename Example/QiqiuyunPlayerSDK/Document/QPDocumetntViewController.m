//
//  QPDocumetntViewController.m
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/4.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "QPDocumetntViewController.h"

#import <ESCloudPlayerSDK/ESCloudPlayerView.h>
#import "QPJWTTokenTool.h"
#import <QMUIKit/QMUIKit.h>

#define DOC_RES_NO @"19f636fcb4f4470294e69698fe8332f1"

@interface QPDocumetntViewController ()<ESCloudPlayerProtocol>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *resNo;
@property (strong, nonatomic) QMUIModalPresentationViewController *presentVC;

@end

@implementation QPDocumetntViewController



- (QMUIModalPresentationViewController *)presentVC{
    if (!_presentVC) {
        _presentVC = [[QMUIModalPresentationViewController alloc] init];
        _presentVC.contentViewMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        _presentVC.dimmingView.backgroundColor = [UIColor blackColor];
    }
    return _presentVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor grayColor];
    [self.containerView insertSubview:self.mediaPlayerView atIndex:0];
    self.mediaPlayerView.frame = self.containerView.bounds;
        
    NSString *token = [QPJWTTokenTool JWTTokenWithPlayload:DOC_RES_NO previewTime:0 headResNo:@"" isPlayAudio:YES];
    [self showProgressInView:self.view];
        __weak typeof(self) _self = self;
    [self.mediaPlayerView loadResourceWithToken:token resNo:DOC_RES_NO specifyStartPos:3 completionHandler:^(NSDictionary * _Nullable resource, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
        if (error) {
                NSLog(@"\n\n初始化错误: %@\n\n", error);
        }

    }];
    [self addConrollItem];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)fullscreenButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.presentVC.contentView = self.mediaPlayerView;
        self.mediaPlayerView.frame = self.presentVC.view.bounds;
        [self.presentVC showWithAnimated:YES completion:^(BOOL finished) {
        }];
    }else{
        [self.presentVC hideWithAnimated:NO completion:^(BOOL finished) {
            [self.containerView addSubview:self.mediaPlayerView];
            self.mediaPlayerView.frame = self.containerView.bounds;
            self.mediaPlayerView.alpha = 1;
        }];
    }
}


- (IBAction)goToOne:(id)sender {
    [self.mediaPlayerView.docPlayerContoller  scrollToPageAtIndex:0];

}
- (void)prePage{
    [self.mediaPlayerView.docPlayerContoller  previousPage];
}

- (void)nextPage {
    [self.mediaPlayerView.docPlayerContoller  nextPage];
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView documentOnPrepared:(NSDictionary *)data{
    [self showMessage:@"加载完成"];
}

- (void)mediaPlayerDocumentOnEnd:(ESCloudPlayerView *)playerView{
    [self showMessage:@"已经到底了"];
}

- (void)mediaPlayer:(ESCloudPlayerView *)playerView documentPagechanged:(NSInteger)index{
    self.title = [NSString stringWithFormat:@"%ld/%ld", (long)index, (long)playerView.docPlayerContoller.pageCount];
}

- (void)mediaPlayerDocumentOnFullscreen:(ESCloudPlayerView *)playerView{
    
}
@end
