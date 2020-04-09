//  GSMutiVideoViewController.m
//  RtSDKDemo
//  Created by Sheng on 2018/8/22.
//  Copyright © 2018年 gensee. All rights reserved.

#import "GSMutiVideoViewController.h"
//这里将桌面共享当做一个用户视频处理，以便创建视图
#define AS_USER_ID 33333333333
@interface GSMutiVideoViewController () <GSBroadcastVideoDelegate,GSBroadcastDesktopShareDelegate,GSBroadcastAudioDelegate>
@property (nonatomic, assign) long long userId;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableDictionary *trainingDic;
@property (strong, nonatomic) NSMutableDictionary *videoDic;//存储video视图的字典
@property (strong, nonatomic) UIScrollView *scrollView;
@end
@implementation GSMutiVideoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
   
}
-(void)setup{
    self.title = @"多路视频(demo为10路)";
    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    hint.text = @"请打开视频";
    hint.font = [UIFont systemFontOfSize:16.f];
    hint.textAlignment = NSTextAlignmentCenter;
    [hint sizeToFit];
    hint.width += 10;
    [self.view addSubview:hint];
    hint.center = self.view.center;
    
    // Do any additional setup after loading the view.
    _videoDic = [NSMutableDictionary dictionary];
    //暂时初始化为10个视频位置
    _locations = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0,@0,@0,@0, nil];
    //training打开回调记录字典 asker表示上提问席 rostrum为上讲台
    _trainingDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"user.asker",@0,@"user.asker1",@0,@"user.asker2",@0,@"user.asker3",@0,@"user.rostrum", nil];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + UIView.additionaliPhoneXTopSafeHeight, Width, Height-64-UIView.additionaliPhoneXTopSafeHeight-UIView.additionaliPhoneXBottomSafeHeight)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_scrollView];
    
    
    self.manager.videoDelegate = self;
    self.manager.desktopShareDelegate = self;
    self.manager.audioDelegate = self;
    self.manager.hardwareAccelerateVideoDecodeSupport = NO;

}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (long long)userId {
    if (!_userId || _userId == 0) {
        _userId = [[GSBroadcastManager sharedBroadcastManager] queryMyUserInfo].userID;
    }
    return _userId;
}

- (CGRect)autoCaculateByIndex:(int)index {
    index ++;
    NSLog(@"add index : %d",index);
    CGFloat w = (Width - 30)/2;
    CGFloat h = ((Width - 30)/2)*3/4;
    CGFloat x,y;
    if (index%2 == 0) { //偶数
        x = w+20;
        y = (index/2 - 1)*(h+10) + 10;
    }else{
        x = 10;
        y = (index/2)*(h+10) + 10;
    }
    return CGRectMake(x, y, w, h);
}

- (GSVideoView*)addVideoViewByUserId:(long long)userId {
    NSNumber *key = @(userId);
    if (![self.videoDic objectForKey:key]) {
        __block int index = -1;
        [self.locations enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.longLongValue == 0) { //如果为0则未使用
                index = (int)idx;
                *stop = YES;
            }
        }];
        if (index == -1) {
            return nil;
        }
        [self.locations replaceObjectAtIndex:index withObject:@(userId)];
        GSVideoView *videoView = [[GSVideoView alloc] initWithFrame:[self autoCaculateByIndex:index]];
        videoView.videoViewContentMode =  GSVideoViewContentModeRatioFit;
        [self.videoDic setObject:videoView forKey:key];
        [self.scrollView addSubview:videoView];
        return videoView;
    }else{
        return nil;
    }
}

- (void)removeVideoByUserId:(long long)userId {
    __block int index = -1;
    [self.locations enumerateObjectsUsingBlock:^(NSNumber* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.longLongValue == userId) {
            index = (int)idx;
            *stop = YES;
        }
    }];
    
    if (index == -1) {
        return;
    }
    NSLog(@"remove index : %d",index + 1);
    [self.locations replaceObjectAtIndex:index withObject:@0];
    GSVideoView *videoView = [self.videoDic objectForKey:[NSNumber numberWithLongLong:userId]];
    [videoView removeFromSuperview];
    [self.videoDic removeObjectForKey:[NSNumber numberWithLongLong:userId]];
}

/**
 获取房间信息代理
 */
- (void)broadcastManager:(GSBroadcastManager *)manager didReceiveBroadcastInfoKey:(NSString *)key value:(long long)value {
    if ([key containsString:@"user.asker"]) { //上提问席
        if (value == self.userId) { //自己
            [[GSBroadcastManager sharedBroadcastManager] activateUserCamera:value];
            [[GSBroadcastManager sharedBroadcastManager] activateMicrophone];
            [self.trainingDic setValue:@(value) forKey:key];
        }else if (value == 0){//下提问席
            if ([[self.trainingDic objectForKey:key] longLongValue] > 0) {
                if ([[self.trainingDic objectForKey:key] longLongValue] == self.userId) {
                    [[GSBroadcastManager sharedBroadcastManager] inactivateCamera];
                    [[GSBroadcastManager sharedBroadcastManager] inactivateMicrophone];
                }else{
                    [[GSBroadcastManager sharedBroadcastManager] undisplayVideo:[[self.trainingDic objectForKey:key] longLongValue]];
                }
            }
            [self.trainingDic setValue:@0 forKey:key];
        }else{//别人上提问席
            [[GSBroadcastManager sharedBroadcastManager] displayVideo:value];
            [self.trainingDic setValue:@0 forKey:key];
        }
    }else if ([key isEqualToString:@"user.rostrum"]) { //上讲台
        if (value == self.userId) {//自己上讲台
            [[GSBroadcastManager sharedBroadcastManager] activateCamera:NO landscape:NO];
            [[GSBroadcastManager sharedBroadcastManager] activateMicrophone];
            [self.trainingDic setValue:@(value) forKey:key];
        }else if (value == 0 ){//下讲台
            if ([[self.trainingDic objectForKey:key] longLongValue] > 0) {
                if ([[self.trainingDic objectForKey:key] longLongValue] == self.userId) {
                    [[GSBroadcastManager sharedBroadcastManager] inactivateCamera];
                    [[GSBroadcastManager sharedBroadcastManager] inactivateMicrophone];
                }else{
                    [[GSBroadcastManager sharedBroadcastManager] undisplayVideo:[[self.trainingDic objectForKey:key] longLongValue]];
                }
            }
            [self.trainingDic setValue:@(value) forKey:key];
        }else { //别人上讲台
            [self.trainingDic setValue:@(value) forKey:key];
        }
    }
}




#pragma mark GSBroadcastVideoDelegate

//视频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveVideoModuleInitResult:(BOOL)result
{
    NSLog(@"视频模块初始化成功");
}


//收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    //只要有人打开视频，就去订阅它
    [self.manager displayVideo:userInfo.userID];
    [self addVideoViewByUserId:userInfo.userID];
}

// 某个用户退出视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserQuitVideo:(long long)userID
{
    [self removeVideoByUserId:userID];
}

//某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
    [self.manager displayVideo:userInfo.userID];
}

// 硬解数据从这个代理返回
- (void)OnVideoData4Render:(long long)userId width:(int)nWidth nHeight:(int)nHeight frameFormat:(unsigned int)dwFrameFormat displayRatio:(float)fDisplayRatio data:(void *)pData len:(int)iLen
{
    [((GSVideoView*)[self.videoDic objectForKey:[NSNumber numberWithLongLong:userId]]) hardwareAccelerateRender:pData size:iLen dwFrameFormat:dwFrameFormat ];
}


//软解
- (void)broadcastManager:(GSBroadcastManager*)manager userID:(long long)userID renderVideoFrame:(GSVideoFrame*)videoFrame {
    GSVideoView *videoView = [self.videoDic objectForKey:[NSNumber numberWithLongLong:userID]];
    [videoView renderVideoFrame:videoFrame];
}

/**
 *  手机摄像头开始采集数据
 *  @param manager 触发此代理的GSBroadcastManager对象
 */
- (BOOL)broadcastManagerDidStartCaptureVideo:(GSBroadcastManager*)manager
{
    GSVideoView *videoView = [self addVideoViewByUserId:self.userId];
    NSNumber *rostrum = [self.trainingDic objectForKey:@"user.rostrum"];
    if (rostrum && rostrum.longLongValue == self.userId) {
        [self.manager setVideo:rostrum.longLongValue active:YES];
    }
    self.manager.videoView = videoView;
    
    return YES;
}





#pragma mark GSBroadcastAudioDelegate
// 音频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveAudioModuleInitResult:(BOOL)result
{
    NSLog(@"音频模块初始化成功");
}


#pragma mark - --GSBroadcastDesktopShareDelegate
/**
 *  开启桌面共享代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  桌面共享的ID
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didActivateDesktopShare:(long long)userID{
    [self addVideoViewByUserId:AS_USER_ID];
}



/**
 软解
 @param manager
 @param videoFrame
 */
- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(UIImage*)videoFrame;{
    GSVideoView *gsVideoView = [self.videoDic objectForKey:@(AS_USER_ID)];
    [gsVideoView renderAsVideoByImage:videoFrame];
}

- (void)OnAsData:(unsigned char*)data dataLen: (unsigned int)dataLen width:(unsigned int)width height:(unsigned int)height {
    GSVideoView *gsVideoView = [self.videoDic objectForKey:@(AS_USER_ID)];
    [gsVideoView hardwareAccelerateRender:data size:dataLen dwFrameFormat:0];
}


/**
 *  桌面共享关闭代理
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see GSBroadcastManager
 */
- (void)broadcastManagerDidInactivateDesktopShare:(GSBroadcastManager*)manager;{
    [self removeVideoByUserId:AS_USER_ID];
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
