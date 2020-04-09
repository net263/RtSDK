//
//  GSGrabInfo.h
//  RtSDK
//
//  Created by Gaojin Hsu on 5/30/16.
//  Copyright © 2016 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *红包类型
 */
typedef NS_ENUM(NSInteger, GSHongbaoType){
    /**
     *随机红包
     */
    GSHongbaoTypeRandom = 0,
    /**
     *固定红包
     */
    GSHongbaoTypeAverage = 1,
    /**
     *定向红包
     */
    GSHongbaoTypeDirect = 3
};

/**
 *  红包创建结果
 */
typedef NS_ENUM(NSInteger, GSHongbaoCreateResult){
    /**
     *  成功
     */
    GSHongbaoCreateResultSuccess = 0x00,
    /**
     *  系统错误
     */
    GSHongbaoCreateResultSystemError = 10001,
    /**
     *  会议不存在或者未开启红包功能
     */
    GSHongbaoCreateResultHongbaoFunctionError = 10102,
    /**
     *  会议红包余额不足
     */
    GSHongbaoCreateResultMoneyNotEnough = 10103,
    /**
     *  红包ID已存在
     */
    GSHongbaoCreateResultHongbaoIDExist = 10108,
    /**
     *  超过会议红包上限
     */
    GSHongbaoCreateResultMeetingHongbaoLimitError = 10109,
    /**
     *  红包份数超过上限
     */
    GSHongbaoCreateResultHongbaoCountLimitError = 10110,
    
    /**
     *红包创建失败-HTTP请求失败
     */
    GSHongbaoCreateResultCreateNetError = -1,
};



/**
 *  抢红包结果
 */
typedef NS_ENUM(NSInteger, GSHongbaoGrabResult){
    /**
     *  成功
     */
    GSHongbaoGrabResultSuccess = 0x00,
    /**
     *  重复争抢
     */
    GSHongbaoCreateResultGrabDuplicate = 10104,
    /**
     *  红包已空
     */
    GSHongbaoCreateResultHongbaoEmpty = 10105,
    /**
     *  红包超时
     */
    GSHongbaoCreateResultHongbaoTimedout = 10106,
    /**
     *  定向红包，不允许争抢
     */
    GSHongbaoCreateResultHongbaoNotAllowed = 10107,
    
    /**
     *红包抢失败-HTTP请求失败
     */
    GSHongbaoCreateResultGrabNetError = -1,
};

@interface GSUserGrabInfo : NSObject

@property (nonatomic, copy) NSString *hongbaoID;

@property (nonatomic, assign) long grabTime;

@property (nonatomic, assign) unsigned money;

@property (nonatomic, assign)long long userID;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, assign)BOOL bBest;

@end



@interface GSHongbaoInfo : NSObject

@property (nonatomic, copy)NSString *hongbaoID;

@property (nonatomic, assign)long long userID;

@property (nonatomic, copy)NSString *userName;

@property (nonatomic, assign) unsigned moneySum;

@property (nonatomic, assign)unsigned count;

@property (nonatomic, assign)long timeLimit;

@property (nonatomic, assign) unsigned type; //0:随机红包，1：固定红包，2：定向红包

@property (nonatomic, assign) long createTime;

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, assign) int state;

@property (nonatomic, assign) int leftCount;


@property (nonatomic, assign) unsigned leftMoney;

@property (nonatomic, assign)long long toUser;

@property (nonatomic, copy) NSString *toUserName;

@end




@interface GSGrabInfo : NSObject

@property (nonatomic, assign)long long llUserID;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, assign)long grabTime;

@property (nonatomic, assign)unsigned money;

@property (nonatomic, assign)BOOL bBest;

@end


