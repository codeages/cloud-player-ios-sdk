//
//  QPVideoContollerProtocol.h
//  AFNetworking
//
//  Created by aaayi on 2019/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QPVideoContollerProtocol <NSObject>
@property (readonly) BOOL canPlay;  /// 是否可以播放
@property (readonly) BOOL canToggle;  /// 是否可以切换音视频
@property (readonly) BOOL isPlaying;  /// 是否正在播放
@property (readonly) BOOL isPreview;  /// 是否试看
@property (readonly) NSTimeInterval currentDuration; /// 获取当前播放时间点
@property (readonly) NSTimeInterval duration;/// 当前视频播放时间总长度
@property (readonly) NSTimeInterval playableDuration;/// 当前视频可播放时间长度

- (void)seekToTime:(NSTimeInterval)secs completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;    ///跳转播放
- (void)switchDefinition:(NSString *)definition; /// 设置清晰度 参数 ：shd、hd、 sd
- (void)setRate:(float)rate; /// 倍数播放
- (void)toggleWithCompletionHandler:(void (^ _Nullable)(NSDictionary * _Nullable playMetas, NSError * _Nullable error))completionHandler;/// 切换音视频
- (void)play;
- (void)pause;
- (void)stop;

///  视频指纹
/// @param fpText 指纹文字
/// @param fTime 指纹每次显示的时间
- (void)showFingerprint:(NSString *)fpText fadeTime:(NSTimeInterval)fTime;

/// 视频水印
/// @param imageURL 水印图片URL
- (void)showWatermarkWithImageURL:(NSURL *)imageURL;
@end

NS_ASSUME_NONNULL_END
