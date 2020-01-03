//
//  ESDownloadResourceModel.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/10.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESDownloadResourceModel.h"

@implementation ESDownloadResourceModel
- (NSString *)fileName{
    if (!_fileName) {
        return self.name;
    }
    return _fileName;
}
- (NSString *)resNo{
    if (!_resNo) {
        return self.no;
    }
    return _resNo;
}
@end
