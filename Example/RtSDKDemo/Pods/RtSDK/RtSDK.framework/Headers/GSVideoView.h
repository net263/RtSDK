//
//  GSVideoView.h
//  RtSDK
//
//  Created by Gaojin Hsu on 4/7/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSVideoFrame.h"
#import "GSMovieGLView.h"
#import <AVFoundation/AVFoundation.h>
#import <GSCommonKit/GSVideoConst.h>
/**
 用于显示视频的View（一路视频一个视图)
 */
@interface GSVideoView : UIView
@property (nonatomic, assign) GSVideoViewContentMode videoViewContentMode; //视频显示模式
@property (nonatomic, strong) AVSampleBufferDisplayLayer *videoLayer;
@property (nonatomic, strong) UIImageView *defaultImageView;
@property (nonatomic, strong,readonly) GSMovieGLView *movieGLView;
@property (nonatomic, strong,readonly) UIImageView *movieASImageView;
@property (nonatomic, strong) UIView *filterView DEPRECATED_MSG_ATTRIBUTE("not use");

#pragma mark -

@property (nonatomic, assign) long long videoId; //标识当前视图

/**
 @method initWithFrame:
 @abstract 传入frame初始化视图
 @discussion 此方法默认使用 renderMode = GSVideoRenderOpenGL
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 @method initWithFrame:renderMode:
 @abstract 传入frame初始化视图,mode指定硬解渲染方式
 @discussion 可以配置硬解渲染方式
 */
- (instancetype)initWithFrame:(CGRect)frame renderMode:(GSVideoRenderMode)mode;

#pragma mark - data receive

/**
 @method renderVideoFrame:
 @abstract 软解数据从这里传入
 @discussion frame为YUY i420数据 = YCrCb,3 plane
 */
- (void)renderVideoFrame:(GSVideoFrame*)frame;

/**
 @method renderAsVideoByImage:
 @abstract 接受并渲染桌面共享数据
 @discussion 数据类型为UIImage
 */
- (void)renderAsVideoByImage:(UIImage*)imageFrame DEPRECATED_MSG_ATTRIBUTE("use -renderAsVideoByBuffer:");

- (void)renderAsVideoByBuffer:(GSGLBuffer*)buffer;
/**
 @method hardwareAccelerateRender:size:dwFrameFormat:
 @abstract 硬解数据从这里传入
 @discussion data为未解码的H264数据，dwFrameFormat为数据格式标识
 */
- (void)hardwareAccelerateRender:(void*)data size:(int)size  dwFrameFormat:(unsigned int)dwFrameFormat;

#pragma mark - other
/**
 @method flush
 @abstract 使得图层清空当前正在显示的图片
 @discussion 当停止接收数据后，视图仍会保留最后一帧图像，使用此方法可以清除最后一帧图像
 */
- (void)flush;

@end
