//
//  ESm3u8KeyDecrypt.h
//  EduSoho
//
//  Created by LiweiWang on 2017/2/9.
//  Copyright © 2017年 Kuozhi Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESm3u8KeyDecrypt : NSObject
+ (NSString *)m3u8KeyDecrypt:(NSString *)key;
+ (NSString *)m3u8SeventeenKeyDecrypt:(NSString *)key;

@end
