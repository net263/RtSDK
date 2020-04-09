//
//  GSCameraManager.h
//  GSCommonKit
//
//  Created by Gaojin Hsu on 9/29/17.
//  Copyright © 2017 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "GSLiveVideoConfiguration.h"

@class GSVideoCapture;
/** LFVideoCapture callback videoData */
@protocol GSVideoCaptureDelegate <NSObject>
- (void)captureOutput:(nullable GSVideoCapture *)capture data:(void*)data size:(int)size width:(int)width height:(int)height bytesPerRow:(NSUInteger)bytesPerRow pixelBuffer:(nullable CVPixelBufferRef)pixelBuffer;
@end

@interface GSVideoCapture : NSObject

/** The delegate of the capture. captureData callback */
@property (nullable, nonatomic, weak) id<GSVideoCaptureDelegate> delegate;

/** The running control start capture or stop capture*/
@property (nonatomic, assign) BOOL running;

/** The preView will show OpenGL ES view*/
@property (null_resettable, nonatomic, strong) UIView *preView;

/** The captureDevicePosition control camraPosition ,default front*/
@property (nonatomic, assign) AVCaptureDevicePosition captureDevicePosition;

/** The beautyFace control capture shader filter empty or beautiy */
@property (nonatomic, assign) BOOL beautyFace;

/** The torch control capture flash is on or off */
@property (nonatomic, assign) BOOL torch;

/** The mirror control mirror of front camera is on or off */
@property (nonatomic, assign) BOOL mirror;

/** The beautyLevel control beautyFace Level, default 0.5, between 0.0 ~ 1.0 */
@property (nonatomic, assign) CGFloat beautyLevel;

/** The brightLevel control brightness Level, default 0.5, between 0.0 ~ 1.0 */
@property (nonatomic, assign) CGFloat brightLevel;

/** The torch control camera zoom scale default 1.0, between 1.0 ~ 3.0 */
@property (nonatomic, assign) CGFloat zoomScale;

/** The videoFrameRate control videoCapture output data count */
@property (nonatomic, assign) NSInteger videoFrameRate;

/*** The warterMarkView control whether the watermark is displayed or not ,if set ni,will remove watermark,otherwise add *.*/
@property (nonatomic, strong, nullable) UIView *warterMarkView;

/* The currentImage is videoCapture shot */
@property (nonatomic, strong, nullable) UIImage *currentImage;

/* The orientation of gpuimage view */
@property (nonatomic, assign) UIInterfaceOrientation outputImageOrientation;


///=============================================================================
/// @name Initializer
///=============================================================================
- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 The designated initializer. Multiple instances with the same configuration will make the
 capture unstable.
 */
- (nullable instancetype)initWithVideoConfiguration:(nullable GSLiveVideoConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

@end
