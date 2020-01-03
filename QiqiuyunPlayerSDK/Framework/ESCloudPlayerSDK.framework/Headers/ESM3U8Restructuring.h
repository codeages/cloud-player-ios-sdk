//
//  ESM3U8Restructuring.h
//  EduSoho
//
//  Created by LiweiWang on 2017/2/13.
//  Copyright © 2017年 Kuozhi Network Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESM3U8Restructuring : NSObject
- (void)restructuringM3u8WithMediaUrl:(NSURL *_Nullable)url level:(NSString *_Nullable)level encryptedHandler:(void (^_Nullable)(NSURL * _Nullable URL) )encryptedHandler;
+ (NSURL *_Nonnull)restructuringM3u8WithMediaUrl:(NSURL *_Nullable)url level:(NSString *_Nullable)level;

@end
