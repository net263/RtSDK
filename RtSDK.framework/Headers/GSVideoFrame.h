//
//  GSVideoFrame.h
//  RtSDK
//
//  Created by Gaojin Hsu on 3/11/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//


#import <Foundation/Foundation.h>
/**
 *  视频帧数据
 *
 */
@interface GSVideoFrame : NSObject<NSCopying>
@property(nonatomic, assign)float width;
@property(nonatomic, assign)float height;
@property(nonatomic, strong) NSData *luma; //luma = Y 亮度
@property(nonatomic, strong) NSData *chromaB; //Cb = U 色彩B
@property(nonatomic, strong) NSData *chromaR; //Cr = V 色彩R

- (instancetype)initWithData:(void *)bytes
                       width:(unsigned int)w
                      height:(unsigned int)h
                      length:(unsigned int)len;

- (void)cleanObj;
@end
