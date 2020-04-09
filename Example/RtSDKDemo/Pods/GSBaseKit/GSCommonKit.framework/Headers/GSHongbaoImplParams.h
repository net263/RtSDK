//
//  GSHongbaoImplParams.h
//  GSCommonKit
//
//  Created by net263 on 2019/12/3.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSHongbaoImplParams : NSObject
@property(nonatomic, copy)NSString *strAddress;
@property(nonatomic, copy)NSString *strConfID;
@property(nonatomic, assign)NSInteger llSiteID;
@property(nonatomic, assign)NSInteger llUserID;
@property(nonatomic, assign)NSInteger nType;
@property(nonatomic, copy)NSString *strAlb;
@property(nonatomic, copy)NSString *strUserName;
@end

NS_ASSUME_NONNULL_END
