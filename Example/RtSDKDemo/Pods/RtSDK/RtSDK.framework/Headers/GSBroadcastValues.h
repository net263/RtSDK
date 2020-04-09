//
//  GSBroadcastValues.h
//  RtSDK
//
//  Created by Gaojin Hsu on 3/11/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GSCommonKit/GSUserInfo.h>
#import "GSVideoFrame.h"
#import "GSChatMessage.h"
#import "GSQuestion.h"
#import "GSInvestigation.h"
#import <GSDocKit/GSDocView.h>



/**
 *  加入直播结果
 */
typedef NS_ENUM(NSInteger, GSBroadcastJoinResult) {
    /**
     *  直播加入成功
     */
    GSBroadcastJoinResultSuccess = 0,
    
    /**
     *  未知错误
     */
    GSBroadcastJoinResultUnknownError = 1,
    
    /**
     *  直播已上锁
     */
    GSBroadcastJoinResultLocked = 2,
    
    /**
     *  直播组织者已经存在
     */
    GSBroadcastJoinResultHostExist = 3,
    
    /**
     *  直播成员人数已满
     */
    GSBroadcastJoinResultMembersFull = 4,
    
    /**
     *  音频编码不匹配
     */
    GSBroadcastJoinResultAudioCodecUnmatch = 5,
    
    /**
     *  加入直播超时
     */
    GSBroadcastJoinResultTimeout = 6,
    
    /**
     *  ip被ban
     */
    GSBroadcastJoinResultIPBanned = 7,
    
    /**
     *  组织者还没有入会，加入时机太早
     */
    GSBroadcastJoinResultTooEarly = 8,
    
};

/**
 *  离开直播的原因
 */
typedef NS_ENUM(NSInteger, GSBroadcastLeaveReason) {
    
    /**
     *  自行退出房间
     */
    GSBroadcastLeaveReasonNormal,
    
    /**
     *  被踢出房间
     */
    GSBroadcastLeaveReasonEjected,
    
    /**
     *  超时
     */
    GSBroadcastLeaveReasonTimeout,
    
    /**
     *  房间关闭，直播结束
     */
    GSBroadcastLeaveReasonClosed,
    
    /**
     *  ip 被ban
     */
    GSBroadcastLeaveReasonIPBanned,
    
    /**
     *  重复登录
     */
    GSBroadcastLeaveReasonDuplicated,
};


/**
 *  直播（录制）状态
 */
typedef NS_ENUM(NSInteger, GSBroadcastStatus) {
    
    /**
     *  直播正在运行中
     */
    GSBroadcastStatusRunning = 1,
    
    /**
     *  直播已停止
     */
    GSBroadcastStatusStop,
    
    /**
     *  直播暂停
     */
    GSBroadcastStatusPause,
};


/**
 *  用户信息更新的字段
 */
typedef NS_ENUM(NSInteger, GSUserInfoUpdate) {
    
    /**
     *  除了下列情况的其他状态发生改变
     */
    GSUserInfoUpdateOthers,
    
    /**
     *  用户角色发生改变
     */
    GSUserInfoUpdateRole,
    
    /**
     *  用户权限发生改变，多数情况下用角色来替代，不同角色对应不同权限
     */
    GSUserInfoUpdatePermission,
    
    /**
     *  用户的状态发生改变，比如用户音频设备打开或关闭，视频设备打开或关闭
     */
    GSUserInfoUpdateStatus,
    
    /**
     *  用户在/Users/gaojinhsu/Documents/Projects/uniclient_win_svn/sdk/ios/RtSDK_Pro2/RtSDK/RtSDK/RtSDK用户列表里的排名次序发生改变
     */
    GSUserInfoUpdateRank,
};




/**
 *  发生改变的问答状态
 */
typedef NS_ENUM(NSInteger, GSQaStatus) {
    /**
     *  收到一个新问题
     */
    GSQaStatusNewQuestion,
    
    /**
     *  问题收到回答
     */
    GSQaStatusNewAnswer,
    
    /**
     *  问题发布
     */
    GSQaStatusQuestionPublish,
    
    /**
     *  问题取消发布
     */
    GSQaStatusQuestionCancelPublish,
    
    /**
     *  推送给嘉宾
     */
    GSQaStatusQuestionPush,
    
    /**
     *  指定组织者，主讲人或嘉宾回答问题
     */
    GSQaStatusQuestionAssgin,
    
    /**
     *  这个问题被建议用语音回复
     */
    GSQaStatusQuestionVoiceReply,
    
    /**
     *  正在使用语音回复
     */
    GSQaStatusQuestionVoiceReplying,
    
    /**
     *  正在使用文字回复
     */
    GSQaStatusQuestionTextReplying,
    
};

/**
 *  抽奖的类型
 */
typedef NS_ENUM(NSInteger, GSLotteryActionType) {
    
    /**
     *  开始抽奖
     */
    GSLotteryActionTypeBegin = 0x01,
    
    /**
     *  抽奖结束
     */
    GSLotteryActionTypeEnd = 0x02,
    
    /**
     *  抽奖取消
     */
    GSLotteryActionTypeCancel = 0x03,
};



















