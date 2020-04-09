//
//  GSH264Encoder.h
//  GSCommonKit
//
//  Created by Gaojin Hsu on 7/17/17.
//  Copyright © 2017 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import "GSLiveVideoConfiguration.h"
@protocol GSH264EncoderDelegate <NSObject>
- (void)gotSpsPps:(NSData*)sps pps:(NSData*)pps spslen:(int)spslen ppslen:(int)ppslen;
- (void)gotEncodedData:(NSData*)data isKeyFrame:(BOOL)isKeyFrame len:(int)len;
@end

@interface GSH264Encoder : NSObject
@property (nonatomic, assign) BOOL AVCSent;
@property (nonatomic, weak) id<GSH264EncoderDelegate> delegate;
@property (nonatomic, assign) NSInteger videoBitRate;
@property (nonatomic, strong) GSLiveVideoConfiguration *configuration;


- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithVideoStreamConfiguration:(nullable GSLiveVideoConfiguration *)configuration;
- (void)encodeImageBuffer:(CVImageBufferRef) imageBuffer;
- (BOOL)createSession;


@end
