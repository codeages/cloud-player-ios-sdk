//
//  ESSubtitleItem.h
//  AFNetworking
//
//  Created by aaayi on 2019/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct {
    NSInteger hours;
    NSInteger minutes;
    NSInteger seconds;
    NSInteger milliseconds;
} ESSubtitleTime;

static const ESSubtitleTime ESSubtitleTimeZero = {0, 0, 0, 0};
NSTimeInterval ESSubtitleTimeGetSeconds(ESSubtitleTime time);

@interface ESSubtitleItem : NSObject
@property (nonatomic, assign) ESSubtitleTime startTime;
@property (nonatomic, assign) ESSubtitleTime endTime;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSString *identifier;
@property (nonatomic, assign) NSInteger index;
- (instancetype)initWithText:(NSString *)text start:(ESSubtitleTime)startTime end:(ESSubtitleTime)endTime;

@end

NS_ASSUME_NONNULL_END
