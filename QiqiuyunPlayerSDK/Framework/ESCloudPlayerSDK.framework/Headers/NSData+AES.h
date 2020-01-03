//
//  NSData+AES.h
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/28.
//  Copyright © 2019 ayia. All rights reserved.
//


#import <Foundation/Foundation.h>

enum {
    /* AES */
    kCCBlockSizeAES128        = 16,
    /* DES */
    kCCBlockSizeDES           = 8,
    /* 3DES */
    kCCBlockSize3DES          = 8,
    /* CAST */
    kCCBlockSizeCAST          = 8,
    kCCBlockSizeRC2           = 8,
    kCCBlockSizeBlowfish      = 8,
};

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES)
- (NSData *)aes256EncryptWithKey:(NSData *)key iv:(NSData *)iv;
- (NSData *)aes256DecryptWithkey:(NSData *)key iv:(NSData *)iv;

@end

NS_ASSUME_NONNULL_END
