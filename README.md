# ESCloudPlayerSDK

iOS SDK 支持播放视频、音频、Word/PDF文档、静态PPT、动态PPT 4种类型的资源播放。其中，视频中支持倍速播放、切换清晰度，水印、指纹等基本视频播放功能。其他资源功能，参考`ESCloudPlayerView.h`。

## 开发环境
- 支持iOS 9.0以上版本。
- XCode 10以上版本。
- 依赖库：`AVFoundation`,`Foundation`,`WebKit`, `CoreMedia`, `UIKit`, `AVKit`。

## 快速集成
通过 [CocoaPods](https://cocoapods.org/) 安装集成。
### 接入准备
请将下面代码加入到您的 Podfile 中：
```ruby
pod 'QiqiuyunPlayerSDK'
```

在项目根目录下执行下列任意命令，集成最新的 SDK：
```shell
$ pod update
```
或者

```shell
$ pod install --repo-update
```
### 使用播放器

```objc
/// 初始化
_mediaPlayerView = [[ESCloudPlayerView alloc]initWithFrame:self.bounds];
_mediaPlayerView.delegate = self;
[self.view addSubview:_mediaPlayerView];

///加载资源
[_mediaPlayerView loadResourceWithToken:self.token resNo:self.resNo specifyStartPos:30 completionHandler:^(NSDictionary *_Nullable resource, NSError *_Nullable error) {
    }];
```
> `QiqiuyunPlayerView`对象建议通过约束布局，可参考[Demo](https://github.com/codeages/cloud-player-ios-sdk)。

## Api文档
api文档包含了播放器控制接口和协议，具体参考[气球云](http://docs.qiqiuyun.com/v2/resource/play-ios-sdk.html)
