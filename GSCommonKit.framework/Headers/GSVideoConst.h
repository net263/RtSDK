//
//  GSVideoConst.h
//  PlayerSDK
//
//  Created by gensee on 2019/1/14.
//  Copyright © 2019年 Geensee. All rights reserved.
//

#ifndef GSVideoConst_h
#define GSVideoConst_h


typedef enum : NSUInteger {
    GSVideoRenderAVSBDLayer, //AVSampleBufferDisplayLayer
    GSVideoRenderOpenGL, //openGL
} GSVideoRenderMode;

/**
 *  视频显示模式
 */
typedef NS_ENUM(NSUInteger, GSVideoViewContentMode){
    /**
     *  拉伸填充
     */
    GSVideoViewContentModeFill,
    /**
     *  保持比例， 显示全尺寸
     */
    GSVideoViewContentModeRatioFit,
    
    /**
     *  保持比例填充，会被截取
     */
    GSVideoViewContentModeRatioFill
};

#endif /* GSVideoConst_h */
