//
//  GSCustomViewController.h
//  RtSDKDemo
//
//  Created by Sheng on 2018/8/16.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSBaseViewController.h"
#import <RtSDK/RtSDK.h>
#import <GSCommonKit/GSCommonKit.h>

@interface GSCustomViewController : GSBaseViewController
@property (nonatomic, strong) GSConnectInfo *param;
@property (nonatomic, strong) GSBroadcastManager *manager;
- (void)didRtJoinSuccess;
- (void)willRtLeaveFinish;
@end
