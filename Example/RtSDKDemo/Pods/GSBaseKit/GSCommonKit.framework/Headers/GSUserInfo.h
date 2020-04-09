//
//  GSUserInfo.h
//  RtSDK
//
//  Created by Gaojin Hsu on 3/12/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UC_ROSTER_INFO_ORIG_KEY @"originfo"
#define UC_ROSTER_INFO_DBL_TEACHER_KEY @"dblteacher"
/**
 * 用户在直播中的身份
 */
typedef NS_ENUM(NSInteger, GSUserRole) {
    /**
     *  组织者
     */
    GSUserRoleOrganizer = 1 << 0,
    /**
     *  主讲人
     */
    GSUserRoleLecturer = 1 << 1,
    /**
     *  嘉宾
     */
    GSUserRolePanelist = 1 << 2,
    /**
     *  普通参加者
     */
    GSUserRoleAttendee = 1 << 3,
    /**
     *  普通参加者web用户
     */
    GSUserRoleAttendeeWeb = 1 << 4,
};


/**
 *   用户使用的平台
 */
typedef NS_ENUM(NSInteger, GSUserType){
    
    /**
     *   PC 客户端
     */
    GSUserTypePCClient = 0,
    
    /**
     *   Web 嵌入flash
     */
    GSUserTypeWebHttpFlash = 1,
    
    /**
     *   纯http
     */
    GSUserTypeWebHttp = 2,
    
    /**
     *   iPad web
     */
    GSUserTypeIPadWeb = 3,
    
    /**
     *   iPhone web
     */
    GSUserTypeIPhoneWeb = 4,
    
    /**
     *   Adroid pad web
     */
    GSUserTypeAndroidPadWeb = 5,
    
    /**
     *   Android phone web
     */
    GSUserTypeAndroidPhoneWeb = 6,
    
    /**
     *   iPad app
     */
    GSUserTypeIPadApp = 7,
    
    /**
     *   iPhone app
     */
    GSUserTypeIPhoneApp = 8,
    
    /**
     *   Android pad app
     */
    GSUserTypeAndroidPadApp = 9,
    
    /**
     *   Android phone app
     */
    GSUserTypeAndroidPhoneApp = 10,
    
    /**
     *   Mac client
     */
    GSUserTypeMacClient = 11,
    
    /**
     *   Telephone
     */
    GSUserTypeTelephone = 12,
    
    /**
     *   web flash
     */
    GSUserTypeFlash = 13,
    
    /**
     *  mobile sdk
     */
    GSUserTypeMobileSDK = 14,
    
    /**
     *  pc sdk
     */
    GSUserTypePCSDK = 15,
    
    /**
     *  ios playerSDK
     */
    GSUserTypeIOSPlayerSDK = 16,
    
    /**
     *  android playerSDK
     */
    GSUserTypeAndroidPlayerSDK = 17,
};


/**
 *  插播视频的ID，插播视频的ID是固定的，其他摄像头视频的ID是对应用户的userID
 */
#define LOD_USER_ID (0x7f00000000000000)






/**
 *  直播中的用户信息类
 */
@interface GSUserInfo : NSObject

/**
 *  用户ID
 */
@property(assign, nonatomic)long long userID;

/**
 *  用户名
 */
@property(strong, nonatomic)NSString* userName;

/**
 *  用户角色
 *  @see  GSUserRole
 */
@property(assign, nonatomic)GSUserRole role DEPRECATED_MSG_ATTRIBUTE("已经有单独的属性判断各种角色");

/**
 *  用户状态
 *  如麦克风是否打开等状态
 */
@property(assign, nonatomic)unsigned status DEPRECATED_MSG_ATTRIBUTE("已经有单独的属性判断各种状态");

/**
 *  用户使用平台类型
 *  @see GSUserType
 */
@property(assign, nonatomic)GSUserType userType;


#pragma mark - room state

/**
 *  用户是否有麦克风设备
 */
@property (assign, nonatomic)BOOL hasMicrophone;

/**
 *  用户是否有摄像头设备
 */
@property (assign, nonatomic)BOOL hasCamera;
/**
 *  用户麦克风是否打开
 */
@property (assign, nonatomic)BOOL isMicrophoneOpen;
/**
 *  麦克风是否静音
 */
@property (assign, nonatomic)BOOL isMicrophoneMute;
/**
 *  摄像头是否打开
 */
@property (assign, nonatomic)BOOL isCameraOpen;
/**
 *  此用户的视频是否为直播视频
 */
@property (assign, nonatomic)BOOL isVideoActivated;
/**
 *  该用户是否举手
 */
@property (assign, nonatomic)BOOL isHandup;
/**
 *  该用户是否被禁止聊天或提问
 */
@property (assign, nonatomic)BOOL isChatForbidden;
/**
 *
 */
@property(assign, nonatomic)long long Order;
#pragma mark - role 角色相关
@property (assign, nonatomic) BOOL isOrganizer; //判断是否为组织者
@property (assign, nonatomic) BOOL isPresentor;//判断是否为主讲人
@property (assign, nonatomic) BOOL isPanelist; //是否为嘉宾
@property (assign, nonatomic) BOOL isAttendee; //是否为参加者
@property (assign, nonatomic) BOOL isAttendeeWeb; //是否为web参加者
@property (assign, nonatomic) BOOL isLodUser; //是否为插播用户

/**
 *用户权限相关
 */
@property (assign, nonatomic) BOOL isCanDocCreate;
@property (assign, nonatomic) BOOL isCanDocAnno;
@property (assign, nonatomic) BOOL isCanDocSyncPage;
@property (assign, nonatomic) BOOL isCanVideoOpenSelf;
@property (assign, nonatomic) BOOL isCanVideoSetMain;
@property (assign, nonatomic) BOOL isCanAudioOpenSelf;
@property (assign, nonatomic) BOOL isCanASOpen;
@property (assign, nonatomic) BOOL isCanChatPublic;
@property (assign, nonatomic) BOOL isCanChatPrivate;
@property (assign, nonatomic) BOOL isCanVoteCreateDel;
@property (assign, nonatomic) BOOL isCanVotePublish;
@property (assign, nonatomic) BOOL isCanVotePublishResult;
@property (assign, nonatomic) BOOL isCanVoteVote;
@property (assign, nonatomic) BOOL isCanVotePublishPopup;
@property (assign, nonatomic) BOOL isCanQAReply;
@property (assign, nonatomic) BOOL isCanQAPublish;
@property (assign, nonatomic) BOOL isCanLvodBeginEnd;
@property (assign, nonatomic) BOOL isCanUserShowOverview;
@property (assign, nonatomic) BOOL isCanUserCtrlOtherMedia;
@property (assign, nonatomic) BOOL isCanUserGrantRole;
@property (assign, nonatomic) BOOL isCanUserAllowUpgradeFromWeb;
@property (assign, nonatomic) BOOL isCanUserKickout;
@property (assign, nonatomic) BOOL isCanGlobalCtrlBroadcast;
@property (assign, nonatomic) BOOL isCanGlobalCtrlRecord;;
@property (assign, nonatomic) BOOL isCanGlobalSwitchLayoutOnWeb;
@property (assign, nonatomic) BOOL isCanGlobalLiveText;
@property (assign, nonatomic) BOOL isCanGlobalMessage;
@property (assign, nonatomic) BOOL isCanGlobalLottery;
@property (assign, nonatomic) BOOL isCanVideoWatchWall;
@property (assign, nonatomic) BOOL isCanQADispatchQuestion;
@property (assign, nonatomic) BOOL isCanDocChangePage;
@property (assign, nonatomic) BOOL isCanVoiceChat;














#pragma mark - other
@property (copy, nonatomic) NSString *userData;

@property(copy, nonatomic) NSString *groupCode;

@end
