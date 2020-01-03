//
//  ESAppDelegate.m
//  ESCloudPlayerSDK
//
//  Created by aaayia on 11/22/2019.
//  Copyright (c) 2019 aaayia. All rights reserved.
//

#import "ESAppDelegate.h"

@implementation ESAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CloudResource" ofType:@"plist"];
    NSArray *files = [[NSArray alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    self.resourceModels = [NSArray modelArrayWithClass:[ESDownloadResourceModel class] json:files].mutableCopy;
    
    ESSessionConfiguration *configuration = [[ESSessionConfiguration alloc]init];
    configuration.allowsCellularAccess = YES;
    configuration.maxConcurrentTasksLimit = 1;
    configuration.timeoutIntervalForRequest = 30;
    NSString *label = [NSString stringWithFormat:@"com.edusoho.download.manager.%@", @"M3U8"];
    dispatch_queue_t t = dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_SERIAL);
    ESM3U8DownloadManager *m3u8Mgr = [[ESM3U8DownloadManager alloc]initWithIdentifier:@"M3U8" configuration:configuration operationQueue:t];
    @weakify(self);
    [m3u8Mgr ready:YES handler:^(NSString * _Nonnull resNo, BOOL isStop) {
        NSLog(@"正在准备下载m3u8文件：%@", resNo);
    }];
    [m3u8Mgr progress:NO handler:^(ESM3U8DownloadManager *mgr) {
        @strongify(self);
    }];

    [m3u8Mgr success:NO handler:^(ESM3U8DownloadManager *mgr) {
        @strongify(self);
    }];

    [m3u8Mgr failure:NO handler:^(ESM3U8DownloadManager *mgr) {
        @strongify(self);
    }];
    self.m3u8Mgr =  m3u8Mgr;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    if ([identifier isEqualToString:self.m3u8Mgr.identifier]) {
        self.m3u8Mgr.completionHandler = completionHandler;
    }
}
@end
