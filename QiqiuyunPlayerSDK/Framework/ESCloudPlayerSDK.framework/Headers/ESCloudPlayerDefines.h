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
    ESCloudPlayerResourceTypePPT,
    ESCloudPlayerResourceTypeDoc,
    ESCloudPlayerResourceTypeVideo,
    ESCloudPlayerResourceTypeAudio,
    ESCloudPlayerResourceTypeAnimationPPT,
};

typedef NS_ENUM(NSInteger, ESCloudSwitchDefinitionStatus) {
    ESCloudSwitchDefinitionStatusUnknown = 0,
    ESCloudSwitchDefinitionStatusSwitching,
    ESCloudSwitchDefinitionStatusFinished,
   ESCloudSwitchDefinitionStatusFailed,
};


typedef NS_ENUM(NSInteger, ESCloudPlayerVideoDefinition) {
    ESCloudPlayerVideoDefinitionUnknown = 0,
    ESCloudPlayerVideoDefinitionSHD,
    ESCloudPlayerVideoDefinitionHD,
    ESCloudPlayerVideoDefinitionSD,
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



#endif /* ESCloudPlayerDefines_h */
