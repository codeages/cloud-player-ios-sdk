//
//  ESCloudPlayerDefines.h
//  Pods
//
//  Created by aaayi on 2019/11/18.
//

#ifndef ESCloudPlayerDefines_h
#define ESCloudPlayerDefines_h
typedef NS_ENUM(NSInteger, ESCloudPlayerResourceType) {
    ESCloudPlayerResourceTypeUnknow = 0,
    ESCloudPlayerResourceTypePPT = 1,
    ESCloudPlayerResourceTypeDoc = 2,
    ESCloudPlayerResourceTypeVideo = 3,
    ESCloudPlayerResourceTypeAudio = 4,
    ESCloudPlayerResourceTypeM3U8Audio = 5,
    ESCloudPlayerResourceTypeLocalM3U8 = 6,
};

typedef NS_ENUM(NSInteger, ESCloudSwitchDefinitionStatus) {
    ESCloudSwitchDefinitionStatusUnknown = 0,
    ESCloudSwitchDefinitionStatusSwitching,
    ESCloudSwitchDefinitionStatusFinished,
   ESCloudSwitchDefinitionStatusFailed,
};


typedef NS_ENUM(NSInteger, ESCloudPlayerVideoDefinition) {
    ESCloudPlayerVideoDefinitionSD = 0,
    ESCloudPlayerVideoDefinitionHD,
    ESCloudPlayerVideoDefinitionSHD,
    ESCloudPlayerVideoDefinitionUnknown,
};


typedef NS_ENUM(NSInteger, ESCloudPlayerStopReason) {
    ESCloudPlayerStopReasonUnknown = 0,
    ESCloudPlayerStopReasonError,
    ESCloudPlayerStopReasonEndTime,
    ESCloudPlayerStopReasonUserStop,
};

typedef NS_ENUM(NSUInteger, ESCloudPlayerWatermarkPosition) {
    /** Center position. */
    ESCloudPlayerWatermarkPositionCenter = 0,
    /** Top left position. */
    ESCloudPlayerWatermarkPositionTopLeft,
    /** Top center position. */
    ESCloudPlayerWatermarkPositionTopCenter,
    /** Top right position. */
    ESCloudPlayerWatermarkPositionTopRight,
    /** Center left position. */
    ESCloudPlayerWatermarkPositionCenterLeft,
    /** Center right position. */
    ESCloudPlayerWatermarkPositionCenterRight,
    /** Bottom left position. */
    ESCloudPlayerWatermarkPositionBottomLeft,
    /** Bottom center position. */
    ESCloudPlayerWatermarkPositionBottomCenter,
    /** Bottom right position. */
    ESCloudPlayerWatermarkPositionBottomRight
};


typedef NS_ENUM(NSUInteger, ESCloudPlayerLogLevel) {
    ESCloudPlayerLogLevelDetailed = 0,
    ESCloudPlayerLogLevelSimple,
    ESCloudPlayerLogLevelNone,

};


#endif /* ESCloudPlayerDefines_h */
