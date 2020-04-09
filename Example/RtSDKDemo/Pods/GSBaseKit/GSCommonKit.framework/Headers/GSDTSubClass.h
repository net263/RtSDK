//
//  GSDTSubClass.h
//  GSCommonKit
//
//  Created by net263 on 2019/12/13.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSDTSubClass : NSObject
@property(nonatomic, copy)NSString *code;
@property(nonatomic, assign)BOOL completed;
@property(nonatomic, assign)BOOL deleted;
@property(nonatomic, copy)NSString *descriptionAsHtml;
@property(nonatomic, copy)NSString *descriptionAsMobileHtml;
@property(nonatomic, copy)NSString *genseeVs;
@property(nonatomic, assign)BOOL groupEnabled;
@property(nonatomic, copy)NSString *roomId;
@property(nonatomic, assign)BOOL invalid;
@property(nonatomic, assign)BOOL loginRequired;
@property(nonatomic, assign)BOOL notStarted;
@property(nonatomic, assign)BOOL opened;
@property(nonatomic, assign)BOOL phoningEnabled;
@property(nonatomic, assign)BOOL published;
@property(nonatomic, assign)BOOL realtime;
@property(nonatomic, assign)NSInteger runStatus;
@property(nonatomic, assign)NSInteger scene;
@property(nonatomic, copy)NSString *scheduleInfoAsHtml;
@property(nonatomic, copy)NSString *scheduleInfoAsMobileHtml;
@property(nonatomic, assign)BOOL shareUrl;
@property(nonatomic, copy)NSString *speakerInfoAsHtml;
@property(nonatomic, copy)NSString *speakerInfoAsMobileHtml;
@property(nonatomic, assign)BOOL started;
@property(nonatomic, assign)NSInteger status;
@property(nonatomic, copy)NSString *subject;
@property(nonatomic, assign)BOOL switchClient;
@property(nonatomic, assign)NSInteger webOnly;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
