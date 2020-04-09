//
//  GSOpenALHelper.h

// 这里需要独立后台模式和非后台模式的处理单元 分两套逻辑，不然写在一起太不清晰了


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>


@interface GSOpenALHelper : NSObject

@property (nonatomic, assign) int queueLength;

@property (nonatomic, assign) BOOL running; //

/**
 音频session设置AVAudioSessionCategoryOptions 默认为  AVAudioSessionCategoryOptionDefaultToSpeaker |AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionMixWithOthers
 */
@property (nonatomic, assign) AVAudioSessionCategoryOptions sessionCategoryOption;

+ (instancetype)sharedOpenAL;

//初始化openAL
- (void)initOpenal;
//不用时先调用清除, 再销毁对象
- (void)cleanOpenal;
//添加音频数据到队列内
- (void)insertPCMDataToQueue:(const unsigned char *)data size:(UInt32)size;
//播放声音
- (void)play;
//停止播放
- (void)stop;
//debug, 打印队列内缓存区数量和已播放的缓存区数量
- (void)getInfo;
//清除已播放完成的缓存区
- (void)cleanBuffers;
//清除未播放完成的缓存区
- (void)cleanQueuedBuffers;
/**
 @method prepare
 @abstract 重置清空所有缓存状态以便于播放
 @discussion 当进入播放界面时调用，清空上次的状态
 */
- (void)prepare;

@end
