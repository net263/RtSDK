//
//  GSLiveVideoConfiguration.h
//  GSCommonKit
//
//  Created by gensee on 2018/11/28.
//  Copyright © 2018年 gensee. All rights reserved.
//
#if __has_include(<GPUImage/GPUImageFramework.h>)
#import <GPUImage/GPUImageFramework.h>
#else
#import "GPUImage.h"
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GSConstants.h"

/// 视频分辨率(当此设备不支持当前分辨率，自动降低一级)
typedef NS_ENUM (NSUInteger, GSLiveVideoSessionPreset){
    GSCaptureSessionPreset352x288 = 0,
    GSCaptureSessionPreset640x480 = 1,
    GSCaptureSessionPreset960x540 = 2,
    GSCaptureSessionPreset1280x720 = 3,
    GSCaptureSessionPreset1920x1080 = 4
};

NS_ASSUME_NONNULL_BEGIN

@interface GSLiveVideoConfiguration : NSObject

/// 视频的分辨率，宽高务必设定为 2 的倍数，否则解码播放时可能出现绿边(这个videoSizeRespectingAspectRatio设置为YES则可能会改变)
@property (nonatomic, assign) CGSize videoSize;
/// 视频裁剪的rect
@property (nonatomic, assign, readonly) CGRect cropRect;
/// 输出图像是否等比例,默认为YES
@property (nonatomic, assign) BOOL videoSizeRespectingAspectRatio;
/// 视频的帧率，即 fps
@property (nonatomic, assign) NSUInteger videoFrameRate;

/// 最大关键帧间隔，可设定为 fps 的2倍，影响一个 gop 的大小
@property (nonatomic, assign) NSUInteger videoMaxKeyframeInterval;

/// 视频的裁剪比例
@property (nonatomic, assign) GSCropMode cropMode;
/// 摄像头前后
@property (nonatomic, assign) AVCaptureDevicePosition cameraPostion;

/// 视频输出方向
@property (nonatomic, assign) UIInterfaceOrientation outputImageOrientation;


/** The beautyFace control capture shader filter empty or beautiy */
@property (nonatomic, assign) BOOL beautyFace;

/*** The warterMarkView control whether the watermark is displayed or not ,if set ni,will remove watermark,otherwise add *.*/
@property (nonatomic, strong, nullable) UIView *warterMarkView;

/// 预览视图的默认显示模式
@property (nonatomic, assign) GPUImageFillModeType previewFillMode;


/// 视频的最大分辨率 默认取后台值 - 请勿自行设置
@property (nonatomic, assign) CGSize videoSizeMax;
/// 视频的最大分辨率 fps 默认取后台值 - 请勿自行设置
@property (nonatomic, assign) CGFloat videoFpsMax;
///< 分辨率数组 CGSize类型存储NSValue
@property (nonatomic, strong) NSArray <NSValue*>*dpis;
/// 视频的码率，单位是 bps
@property (nonatomic, assign,readonly) NSUInteger videoBitRate;
///< 是否是横屏
@property (nonatomic, assign, readonly) BOOL landscape;
///< ≈sde3分辨率
@property (nonatomic, assign, readonly) NSString *avSessionPreset;

@end

NS_ASSUME_NONNULL_END
