//
//  ESBasePlayViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/11.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESBasePlayViewController.h"
#import <Masonry.h>

@interface ESBasePlayViewController ()<ESCloudPlayerProtocol>
@property (strong, nonatomic) NSURL *baseURL;

@end

@implementation ESBasePlayViewController
- (UIView *)containerView{
    if (!_containerView) {
        CGFloat width = CGRectGetWidth(self.view.frame);
        CGRect frame = CGRectMake(0, 0, width, width * (9.0/16.0));
        _containerView = [[UIView alloc]initWithFrame:frame];
        _containerView.backgroundColor = [UIColor grayColor];
    }
    return _containerView;
}

- (UIButton *)fullscreenButton {
    if (!_fullscreenButton) {
        _fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullscreenButton.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _fullscreenButton.layer.cornerRadius = 20;
        _fullscreenButton.clipsToBounds = YES;
        _fullscreenButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_fullscreenButton setImage:[UIImage imageNamed:@"VideoFullscreenIcon"] forState:UIControlStateNormal];
        [_fullscreenButton setImage:[UIImage imageNamed:@"ShrinkScreenIcon"] forState:UIControlStateSelected];
        [_fullscreenButton addTarget:self action:@selector(fullscreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullscreenButton;
}

- (UIButton *)nextPageButton {
    if (!_nextPageButton) {
        _nextPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextPageButton.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _nextPageButton.layer.cornerRadius = 5;
        _nextPageButton.clipsToBounds = YES;
        _nextPageButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_nextPageButton setTitle:@"下一页"  forState:UIControlStateNormal];
        [_nextPageButton addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextPageButton;
}

- (UIButton *)prePageButton {
    if (!_prePageButton) {
        _prePageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _prePageButton.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        _prePageButton.layer.cornerRadius = 5;
        _prePageButton.clipsToBounds = YES;
        _prePageButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_prePageButton setTitle:@"上一页"  forState:UIControlStateNormal];
        [_prePageButton addTarget:self action:@selector(prePage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prePageButton;
}

- (ESCloudPlayerView *)mediaPlayerView {
    if (!_mediaPlayerView) {
        _mediaPlayerView = [[ESCloudPlayerView alloc] initWithFrame:self.containerView.bounds baseURL:self.baseURL userId:nil userName:nil];
        _mediaPlayerView.backgroundColor = [UIColor blackColor];
        _mediaPlayerView.delegate = self;
        _mediaPlayerView.initDefinition = ESCloudPlayerVideoDefinitionSD;
    }
    return _mediaPlayerView;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL{
    self = [super init];
    if (self) {
        self.baseURL = baseURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(20 + self.navigationController.navigationBar.bounds.size.height);
        }
        make.height.equalTo(self.view.mas_width).multipliedBy(9.0/16.0);
    }];
    [self.containerView addSubview:self.mediaPlayerView];
}

- (void)addConrollItem{
    [self.mediaPlayerView addSubview:self.fullscreenButton];
    [self.fullscreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-10);
    }];
    
    [self.mediaPlayerView addSubview:self.prePageButton];
    [self.prePageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fullscreenButton);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.left.mas_equalTo(self.mediaPlayerView.mas_left).offset(20);
    }];

    [self.mediaPlayerView addSubview:self.nextPageButton];
    [self.nextPageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fullscreenButton);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.left.mas_equalTo(self.prePageButton.mas_right).offset(20);
    }];
}

- (void)fullscreenButtonClick:(UIButton *)sender {
}

- (void)prePage {

}
- (void)nextPage {
}

@end
