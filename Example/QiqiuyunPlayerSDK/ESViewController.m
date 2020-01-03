//
//  ESViewController.m
//  ESqiqiuyunPlayerSDK
//
//  Created by ayia on 10/11/2019.
//  Copyright (c) 2019 ayia. All rights reserved.
//

#import "ESViewController.h"

@interface ESViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

@end

@implementation ESViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"EduSoho教育云demo";
    [self.bannerImageView setImageWithURL:[NSURL URLWithString:@"http://devtest.edusoho.cn/themes/jianmo/img/banner_net.jpg"] options:YYWebImageOptionShowNetworkActivity];
}
@end
