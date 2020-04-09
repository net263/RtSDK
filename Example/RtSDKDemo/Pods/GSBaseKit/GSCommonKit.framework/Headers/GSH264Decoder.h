//
//  GSH264Decoder.h
//  GSCommonKit
//
//  Created by Gaojin Hsu on 7/10/17.
//  Copyright © 2017 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import <CoreVideo/CoreVideo.h>
#import <UIKit/UIKit.h>

@class GSH264Decoder;
@protocol GSH264DataDelegate <NSObject>
@optional
- (void)h264Decoder:(GSH264Decoder* _Nullable)decoder onAVSampleBuffer:(CMSampleBufferRef _Nullable)pixels;
- (void)h264Decoder:(GSH264Decoder* _Nullable)decoder onCVImageBufferRef:(CVImageBufferRef)pixels width:(unsigned long)width height:(unsigned long)height;

@end



typedef enum : NSUInteger {
    GSDECODER_NO_ERROR = 0,
    GSDECODER_NALU_SPS_INVALIDATE,       //no sps
    GSDECODER_NALU_PPS_INVALIDATE,       //no pps
    GSDECODER_NALU_TYPE_INVALIDATE,      //nalu type invalide eg:31
    GSDECODER_NALU_IDR_INVALIDATE,       //idr not found
    GSDECODER_QUEUE_BACKGROUND_ERROR,    //decode in background
    GSDECODER_QUEUE_CALLBACK_ERROR,      //callback error
    GSDECODER_NO_MEMORY,                 //no memory
    GSDECODER_DATA_INVALIDATE,           //data invalidate
} GSDecoderError;

//H264(baseline)格式视频解码器
@interface GSH264Decoder : NSObject
- (void)decodeRawVideoFrame:(uint8_t *_Nonnull)frame withSize:(uint32_t)frameSize timestamp:(unsigned long)ts;//接受h264数据进行解码
//@property (nonatomic, copy) VideoDecodeCompletionBlock  _Nullable completion;//每一帧解码完成回调
//@property (nonatomic, assign) BOOL moreInfo; //开启返回视频宽高信息，CPU消耗增加%3（iPhone7Plus）,默认关闭
@property (nonatomic, assign) BOOL isVideoToolBox; //使用videoToolBox 而不直接使用AVSampleDisplayBuffer解码渲染一条龙
@property (nonatomic, assign) OSType outputPixelType;
@property (nonatomic, weak) id<GSH264DataDelegate> _Nullable  delegate;

- (BOOL)createDecompSession;
- (void)recreateDecompSession;
@end
