//
//  ESAppDelegate.h
//  ESCloudPlayerSDK
//
//  Created by aaayia on 11/22/2019.
//  Copyright (c) 2019 aaayia. All rights reserved.
//

@import UIKit;
#import "ESDownloadResourceModel.h"

@interface ESAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray<ESDownloadResourceModel *> *resourceModels;
@property (strong, nonatomic)ESM3U8DownloadManager *m3u8Mgr;

@end
