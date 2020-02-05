#
# Be sure to run `pod lib lint QiqiuyunPlayerSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ESCloudPlayerSDK'
  s.version          = '2.0.2'
  s.summary          = '气球云资源播放器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
气球云资源播放器，支持视频、音频、PPT、文档资源文件
                       DESC

  s.homepage         = 'https://github.com/codeages/qiqiuyun-player-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ayia' => 'twilightzzy@126.com' }
   s.source           = { :git => 'https://github.com/codeages/cloud-player-ios-sdk.git', :tag => s.version.to_s }
#  s.source           = { :git => '/Users/tony/Documents/work/code/qiqiuyun-player-ios-sdk', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.vendored_frameworks = 'QiqiuyunPlayerSDK/Framework/ESCloudPlayerSDK.framework'
  # s.source_files = ['QiqiuyunPlayerSDK/Classes/*', 'QiqiuyunPlayerSDK/Classes/*/*']
  # s.resource_bundles = {
  #   'QiqiuyunPlayerSDK' => ['QiqiuyunPlayerSDK/Assets/*.png']
  # }

  s.pod_target_xcconfig = {
      "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES" # requies both `user_target_xcconfig` and `pod_target_xcconfig`
  }
  s.user_target_xcconfig = {
      "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES" # requies both `user_target_xcconfig` and `pod_target_xcconfig`
  }

  s.public_header_files = 'ESMediaPlayerSDK/Classes/Public/*.h'
#  s.prefix_header_contents = '#import <YYKit/YYKit.h>', '#import "ESClouldSDKDefines.h"'
  s.static_framework  =  true
  s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}
  s.frameworks = 'AVFoundation','Foundation','WebKit', 'CoreMedia', 'UIKit', 'AVKit'
  s.libraries = 'objc'

  s.dependency 'GCDWebServer'
  s.dependency 'AFNetworking'
  s.dependency 'Masonry'
  s.dependency 'YYKit', '~> 1.0.9'
  s.dependency 'Qiniu', '~> 7.3'


end
