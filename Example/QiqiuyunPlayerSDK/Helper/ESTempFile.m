//
//  ESTempFile.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/19.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESTempFile.h"

@implementation ESTempFile
+ (NSURL *)createTempfileWithSize:(int)size {
//    NSString *fileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], @"file.txt"];
    NSString *fileName = [NSString stringWithFormat:@"test_%@", @"file.txt"];
    NSURL *fileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    NSData *data = [NSMutableData dataWithLength:size];
    NSError *error = nil;
    [data writeToURL:fileUrl options:NSDataWritingAtomic error:&error];
    return fileUrl;
}

+ (void)removeTempfile:(NSURL *)fileUrl {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:fileUrl error:&error];
}

@end
