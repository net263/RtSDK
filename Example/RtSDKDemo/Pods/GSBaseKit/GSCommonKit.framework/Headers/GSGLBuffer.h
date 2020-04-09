//
//  GSGLBuffer.h
//  PlayerSDK
//
//  Created by gensee on 2019/1/11.
//  Copyright © 2019年 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSGLBuffer : NSObject
{
    @public
    int w; /**< Read-only */
    int h; /**< Read-only */
    uint32_t format; /**< Read-only */
    int planes; /**< Read-only */
    uint32_t pitches[3]; /**< in bytes, Read-only */   //表示数据宽度 width,不是数据长度
    uint8_t *pixels[3]; /**< Read-write */ //数据指针
    uint32_t pixelLengths[3];
    int is_private;
    
    int sar_num;
    int sar_den;

    CVPixelBufferRef pixel_buffer;
}

- (instancetype)initWithBytes:(void*)bytes length:(NSUInteger)length;

- (void)cleanCVBuffer;

@end

NS_ASSUME_NONNULL_END
