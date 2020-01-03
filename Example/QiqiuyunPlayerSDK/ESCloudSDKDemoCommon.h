//
//  ESCloudSDKDemoCommon.h
//  QiqiuyunPlayerSDK
//
//  Created by aaayi on 2020/1/3.
//  Copyright © 2020 ayia. All rights reserved.
//

#ifndef ESCloudSDKDemoCommon_h
#define ESCloudSDKDemoCommon_h

#define PLAYER_HOST @"http://play.cloud-test.edusoho.cn"

#define SIMULATOR 0
#define ESDEBUG 0

#if ESDEBUG
#define SCHOOL_HOST @"http://es3.cloud-test.edusoho.cn/"
#define SCHOOL_SECRET_KEY @"BBLj0N0A3sGKX3oxwqBJwH6tJ4WvSUD6"

#else

#define SCHOOL_HOST @"http://es3.cloud-test.edusoho.cn/"
#define SCHOOL_SECRET_KEY @"BBLj0N0A3sGKX3oxwqBJwH6tJ4WvSUD6"

#endif

#define START_UPLOAD @"api/upload/test/start"
#define FINISH_UPLOAD @"api/upload/test/finish"

#ifdef DEBUG
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DebugLog(...)
#endif

#endif /* ESCloudSDKDemoCommon_h */
