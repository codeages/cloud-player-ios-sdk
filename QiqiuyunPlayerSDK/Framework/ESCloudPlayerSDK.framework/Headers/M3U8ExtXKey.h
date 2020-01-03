//
//  M3U8ExtXKey.h
//  M3U8Kit
//
//  Created by Pierre Perrin on 01/02/2019.
//  Copyright © 2019 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface M3U8ExtXKey : NSObject
@property (copy) NSString *key;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)method;
- (NSString *)url;
- (NSString *)keyFormat;
- (NSString *)iV;

@end
