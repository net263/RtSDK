//
//  GSEmotion.h
//  GSCommonKit
//
//  Created by net263 on 2019/8/12.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface GSBaseEmotion : NSObject
@property (nonatomic, copy) NSString *emotionTitle; //ex: 【微笑】

@property (nonatomic, copy) NSString *emotionId; //与服务器交互的id ex: emotion\emotion.angerly.gif

@property (nonatomic, copy) NSString *emotionLocal; //图片路径

//@property (nonatomic, copy) NSString *emotionRemote; //图片路径 url

- (id)initWithName:(NSString*)emotionTitle
         emotionId:(NSString*)emotionId
   emotionLocal:(NSString*)emotionLocal
emotionRemote:(NSString*)emotionRemote;

-(UIImage*)firstImage;
@end

NS_ASSUME_NONNULL_END
