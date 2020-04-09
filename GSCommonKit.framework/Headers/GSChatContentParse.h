//
//  GSEmotionEscape.h
//  GSCommonKit
//
//  Created by net263 on 2019/8/12.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSChatContentParse : NSObject
@property (nonatomic, strong) NSDictionary *key2file; //emotion\emotion.smile.gif --> 微笑

@property (nonatomic, strong) NSDictionary *text2file; // 【微笑】--> emotion\emotion.smile.gif

@property (nonatomic, strong) NSDictionary *text2key; //【微笑】--> 微笑

@property (nonatomic, strong) NSMutableDictionary *emotionsData;

+ (GSChatContentParse *)sharedInstance;

// <IMG src="emotion\emotion.qq.gif" custom="false"> --> attachment + text
- (NSAttributedString *) attributeStringFromHtml:(NSString *)html
                                        textFont:(UIFont*)font
                                       imageType:(NSString *)type;

// 【表情】--> <IMG src="emotion\emotion.qq.gif" custom="false">
- (NSString *)htmlFromEmotionText:(NSString *)emotion;


+ (BOOL)stringContainsEmoji:(NSString *)string;

//获取所有的表情，GIF图获取d第一帧，主要用于表情面板显示
-(NSArray*) allEmotions;

@end

NS_ASSUME_NONNULL_END
