//
//  ESClouldSDKDefines.h
//  Pods
//
//  Created by aaayi on 2019/12/25.
//

#import "ESCloudSDKLog.h"

#ifndef ESClouldSDKDefines_h
#define ESClouldSDKDefines_h

#define ESLogError(...)         ESCloudLog(@"Error",__FUNCTION__ , __VA_ARGS__)
#define ESLogPlayer(...)         ESCloudLog(@"Player",__FUNCTION__ , __VA_ARGS__)
#define ESLogCanche(...)         ESCloudLog(@"Canche",__FUNCTION__ , __VA_ARGS__)
#define ESLogDownload(...)         ESCloudLog(@"Donwload",__FUNCTION__ , __VA_ARGS__)
#define ESLogM3U8Download(...)     ESCloudLog(@"M3U8Donwload",__FUNCTION__ , __VA_ARGS__)
#define ESLogUpload(...)         ESCloudLog(@"Upload",__FUNCTION__ , __VA_ARGS__)

#endif /* ESClouldSDKDefines_h */
