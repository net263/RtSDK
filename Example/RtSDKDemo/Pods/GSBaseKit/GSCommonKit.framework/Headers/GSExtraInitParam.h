//  GSExtraInitParam.h
//  EMNetMeeting_IOS
//  Created by XuGuangwei on 15/12/14.
//  Copyright © 2015年 yiyimama. All rights reserved.
#import <Foundation/Foundation.h>
@interface GSExtraInitParam : NSObject
@property (nonatomic, assign) BOOL  enablePhoneSupport;
@property (nonatomic, assign) BOOL  autoRecordOnServer;
@property (nonatomic, assign) int   videoMaxWidth;
@property (nonatomic, assign) int   videoMaxHeight;
@property (nonatomic, assign) int	videoMaxFps;
@property (nonatomic, assign) BOOL  videoAutoFps;
@property (nonatomic, assign) int   fileshareMaxFileQuantity;
@property (nonatomic, assign) int   fileshareMaxSizePerFile;
@end
