//
//  GSAudioUnit.h
//  GSCommonKit
//
//  Created by gensee on 2019/9/6.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GSAudioPlayProtocol <NSObject>
/**
 音频session设置AVAudioSessionCategoryOptions 默认为  AVAudioSessionCategoryOptionDefaultToSpeaker |AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionMixWithOthers
 */
@property (nonatomic, assign) AVAudioSessionCategoryOptions sessionCategoryOption;

/**
 是否开始运行,开启服务
 */
@property (nonatomic, assign) BOOL running;


/**
 添加音频数据到队列内

 @param data 数据指针,例如void*类型
 @param size 数据大小(长度)
 */
- (void)insertPCMDataToQueue:(const unsigned char *)data size:(UInt32)size timestamp:(unsigned long)ts;

/**
 重置音频队列，防止影响接下来的音频播放 - 先pause再清空
 */
- (BOOL)reset;


/**
 暂停
 */
- (BOOL)pause;

/**
 恢复
 */
- (BOOL)resume;

/**
 debug, 打印队列内缓存区数量和已播放的缓存区数量
 */
- (void)printDebugInfo;

/**
 获取当前未处理队列长度

 @return unsigned int类型长度
 */
- (unsigned int)unprocessdNumber;

@end

NS_ASSUME_NONNULL_END
