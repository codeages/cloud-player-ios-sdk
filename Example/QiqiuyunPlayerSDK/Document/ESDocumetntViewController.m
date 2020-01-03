//
//  ESDocumetntViewController.m
//  ESESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/10/31.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESDocumetntViewController.h"
#import "ESJWTTokenTool.h"
#import <Masonry.h>
#import <QMUIKit/QMUIKit.h>

@interface ESDocumetntViewController ()<ESCloudPlayerProtocol>
@property (strong, nonatomic) QMUIModalPresentationViewController *presentVC;

@end

@implementation ESDocumetntViewController
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
//    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    [self.containerView removeFromSuperview];
    [self.view addSubview:self.mediaPlayerView];
    self.mediaPlayerView.frame = self.view.bounds;
        
    
    if (!self.token) {
         self.token = [ESJWTTokenTool JWTTokenWithPlayload:self.resNo previewTime:0 headResNo:@"" isPlayAudio:YES];
    }
    [self showProgressInView:self.view];
        __weak typeof(self) _self = self;
    [self.mediaPlayerView loadResourceWithToken:self.token  resNo:self.resNo specifyStartPos:3 completionHandler:^(NSDictionary * _Nullable resource, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
        NSLog(@"%@", resource);
        if (error) {
                NSLog(@"\n\n初始化错误: %@\n\n", error);
        }
    }];
    [self addConrollItem];
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
            [self.view addSubview:self.mediaPlayerView];
            self.mediaPlayerView.frame = self.view.bounds;
            self.mediaPlayerView.alpha = 1;
        }];
    }
}

- (void)prePage {
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
//    self.title = [NSString stringWithFormat:@"%ld/%ld", (long)index, (long)playerView.docPlayerContoller.pageCount];
}

- (void)mediaPlayerDocumentOnFullscreen:(ESCloudPlayerView *)playerView{
    
}

@end
