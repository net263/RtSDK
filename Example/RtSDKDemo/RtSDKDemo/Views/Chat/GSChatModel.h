//
//  GSChatModel.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/14.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSBaseModel.h"
#import <RtSDK/RtSDK.h>


@interface GSChatModel : GSBaseModel

//---------- MODEL --------------

@property (nonatomic, strong) GSChatMessage *chatMessage;//消息实体

@property (nonatomic, strong) GSUserInfo *userModel;//用户信息



- (instancetype)initWithModel:(GSChatMessage*)obj type:(GSChatModelType)type;

@end
