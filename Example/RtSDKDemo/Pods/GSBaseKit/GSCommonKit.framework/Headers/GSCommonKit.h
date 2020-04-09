//
//  GSCommonKit.h
//  GSCommonKit
//
//  Created by Sheng on 2018/7/10.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

// In this header, you should import all the public headers of your framework using statements like #import <GSCommonKit/PublicHeader.h>
//视频
//opengl渲染
#import <GSCommonKit/GSSDLGLView.h>
#import <GSCommonKit/GSVideoConst.h>
//编解码
#import <GSCommonKit/GSH264Encoder.h>
#import <GSCommonKit/GSH264Decoder.h>
//视频采集
#import <GSCommonKit/GSLiveVideoConfiguration.h>
#import <GSCommonKit/GSVideoCapture.h>

//日志
#import <GSCommonKit/GSDiagnosisInfo.h>
#import <GSCommonKit/GSTrafficMonitoring.h>
#import <GSCommonKit/GSZipArchive.h>

//音频
#import <GSCommonKit/GSOpenALHelper.h>
#import <GSCommonKit/GSAudioCapture.h>
#import <GSCommonKit/GSLiveAudioConfiguration.h>

//共有实体
#import <GSCommonKit/GSConnectInfo.h>
#import <GSCommonKit/GSUserInfo.h>
#import <GSCOmmonKit/GSXMLReader.h>
#import <GSCOmmonKit/GSExtraInitParam.h>


//公用工具
#import <GSCommonKit/GSNotificationManager.h>
#import <GSCommonKit/GSThreadSafeArray.h>
#import <GSCommonKit/GSThreadSafeDictionary.h>
#import <GSCommonKit/GSFileWriter.h>
//UI 扩展
#import <GSCommonKit/GSTagsContentView.h>
#import <GSCommonKit/GSWaterMarkView.h>
#import <GSCommonKit/NSString+GSURLEncode.h>
//网络请求
#import <GSCommonKit/GSWebAccess.h>
//常量宏
#import <GSCommonKit/GSCommonConst.h>
#import <GSCommonKit/GSConstants.h>
#import <GSCommonKit/GSCommonKitMacro.h>
#import <GSCommonKit/GSAudioManager.h>

//聊天的封装，包括GIF动画的显示
#import <GSCommonKit/GSGifLabel.h>
#import <GSCommonKit/GSChatContentParse.h>
#import <GSCommonKit/GSBaseEmotion.h>

//红包的结构体
#import <GSCommonKit/GSGrabInfo.h>
#import <GSCommonKit/GSHongbaoImplDelegate.h>
#import <GSCommonKit/GSHongbaoImplParams.h>

//主课堂子课堂相关信息
#import <GSCommonKit/GSDTSubClass.h>
#import <GSCommonKit/GSDTJoinParams.h>
#import <GSCommonKit/GSDTConst.h>
#import <GSCommonKit/GSDTGroupInfo.h>

//用户管理
#import <GSCommonKit/GSUserManager.h>
