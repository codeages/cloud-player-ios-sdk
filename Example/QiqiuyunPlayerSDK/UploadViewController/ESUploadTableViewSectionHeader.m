//
//  ESUploadTableViewSectionHeader.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/12.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESUploadTableViewSectionHeader.h"

@implementation ESUploadTableViewSectionHeader
+ (instancetype)createUploadTableViewSectionHeader{
   return [[[NSBundle mainBundle] loadNibNamed:@"ESUploadTableViewSectionHeader" owner:nil options:nil]lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
