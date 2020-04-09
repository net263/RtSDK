//
//  GSAudioManager.h
//  GSCommonKit
//
//  Created by gensee on 2019/11/5.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface GSAudioManager : NSObject

/**
 音频session设置AVAudioSessionCategoryOptions 默认为  AVAudioSessionCategoryOptionDefaultToSpeaker |AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionMixWithOthers
 */
@property (nonatomic, assign) AVAudioSessionCategoryOptions sessionCategoryOption;
/**
 音频路由改变时，默认选择的输出端口
 0表示听筒和蓝牙设备  1表示外放扬声器
 */
@property (nonatomic, assign) int defaultAudioOutport;

/**
 是否为蓝牙
 */
@property (nonatomic, assign) BOOL isBlueTooth;
+ (instancetype)sharedManager;
//notifications
- (void)startRtNotification;
- (void)stopRtNotification;

@end

NS_ASSUME_NONNULL_END
