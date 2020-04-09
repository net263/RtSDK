//
//  GSRtParamViewController.h
//  RtSDKDemo
//
//  Created by Sheng on 2018/8/16.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSBaseViewController.h"

#define MO_DOMAIN @"FAST_CONFIG_DOMAIN"
#define MO_SERVICE @"FAST_CONFIG_SERVICE_TYPE"
#define MO_ROOMID @"FAST_CONFIG_ROOMID"
#define MO_NICKNAME @"FAST_CONFIG_NICKNAME"
#define MO_PWD @"FAST_CONFIG_PWD"
#define MO_LOGIN_NAME @"FAST_CONFIG_LOGIN_NAME"
#define MO_LOGIN_PWD @"FAST_CONFIG_LOGIN_PWD"
#define MO_THIRD_KEY @"FAST_CONFIG_THIRD_KEY"
#define MO_REWARD @"FAST_CONFIG_REWARD"
#define MO_USERID @"FAST_CONFIG_USERID"

@interface GSRtParamViewController : GSBaseViewController


//UI
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSMutableDictionary  *fieldViewsDic;
//config
@property (strong, nonatomic) UISegmentedControl *serviceType;
@property (strong, nonatomic) UISegmentedControl *httpType;
@property (strong, nonatomic) UISegmentedControl *boxType;
@property (strong, nonatomic) UISegmentedControl *allowRoleType;

//编解码
@property (strong, nonatomic) UISegmentedControl *encodeType;
@property (strong, nonatomic) UISegmentedControl *decodeType;
@property (strong, nonatomic) UISegmentedControl *ASDecodeType;


//视频采集
@property (strong, nonatomic) GSTagsContentView *dpisTagView;
@property (strong, nonatomic) UITextField *wField;
@property (strong, nonatomic) UITextField *hField;
@property (strong, nonatomic) GSTagsContentView *cropTagView;


- (void)watch:(UIButton*)sender;

- (void)saveCache;

- (NSString *)paramInField:(NSString *)fieldMark;

@end
