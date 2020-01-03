//
//  NSString+extno.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/23.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "NSString+extno.h"

@implementation NSString (extno)
+ (NSString *)extno{
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [NSString stringWithFormat:@"%.8f",random];
    NSString *randompassword = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    return randompassword;
}

@end
