//
//  GSUserManager.h
//  GSCommonKit
//
//  Created by net263 on 2019/12/13.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSUserManager : NSObject
+ (instancetype) sharedInstance;

-(void)addUser:(GSUserInfo *)userInfo;
-(void)removeUser:(GSUserInfo *)userInfo;
-(void)updateUser:(GSUserInfo *)userInfo;
-(NSString *)userGroupCode:(long long)userId;
-(void)clear;
@end

NS_ASSUME_NONNULL_END
