//
//  QPDocumetntViewController.m
//  QiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/11/4.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "QPDocumetntViewController.h"

#import <QiqiuyunPlayerSDK/QiqiuyunPlayerView.h>
#import "QPJWTTokenTool.h"
#import <Masonry.h>

#define DOC_RES_NO @"afbf964a4a434924a2a85e71704ac6b0"
#define DOC_TOKEN_NO @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJubyI6ImFmYmY5NjRhNGE0MzQ5MjRhMmE4NWU3MTcwNGFjNmIwIiwianRpIjoiYTJhNWI5MGMtNzdmMy00NyIsImV4cCI6MTYwNDYzNDQ1MSwidGltZXMiOjEwMDAwMDB9.LhRPgZc4z_YKNHRNAbZGL4uSgQV3lAJiaPdMtaZ2tIQ"

@interface QPDocumetntViewController ()<QiqiuyunPlayerProtocol>
@property (strong, nonatomic) QiqiuyunPlayerView *qiqiuyunPlayerView;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *resNo;

@end

@implementation QPDocumetntViewController
- (QiqiuyunPlayerView *)qiqiuyunPlayerView {
    if (!_qiqiuyunPlayerView) {
        _qiqiuyunPlayerView = [[QiqiuyunPlayerView alloc]initWithFrame:self.view.bounds];
        _qiqiuyunPlayerView.backgroundColor = [UIColor blackColor];
        _qiqiuyunPlayerView.delegate = self;
    }
    return _qiqiuyunPlayerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.qiqiuyunPlayerView];
    [self.qiqiuyunPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
        
    [self showProgressInView:self.view];
        __weak typeof(self) _self = self;
    [self.qiqiuyunPlayerView loadResourceWithToken:DOC_TOKEN_NO resNo:DOC_RES_NO completionHandler:^(NSDictionary * _Nullable resource, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        [self dissMissProgressInView:self.view];
        if (error) {
                NSLog(@"\n\n初始化错误: %@\n\n", error);

        }

    }];
}

- (IBAction)prePage:(id)sender {
    [self.qiqiuyunPlayerView.docPlayerContoller  previousPage];
}
- (IBAction)nextPage:(id)sender {
    [self.qiqiuyunPlayerView.docPlayerContoller  nextPage];
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView documentOnPrepared:(NSDictionary *)data{
    [self showMessage:@"加载完成"];
}

- (void)mediaPlayerDocumentOnEnd:(QiqiuyunPlayerView *)playerView{
    [self showMessage:@"已经到底了"];
}

- (void)mediaPlayer:(QiqiuyunPlayerView *)playerView documentPagechanged:(NSInteger)index{
    self.title = [NSString stringWithFormat:@"%ld/%ld", (long)index, (long)playerView.docPlayerContoller.pageCount];
}

- (void)mediaPlayerDocumentOnFullscreen:(QiqiuyunPlayerView *)playerView{
    
}
@end
