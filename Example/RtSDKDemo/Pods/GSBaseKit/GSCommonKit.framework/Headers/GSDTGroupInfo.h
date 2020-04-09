//
//  GSDTGroupInfo.h
//  GSCommonKit
//
//  Created by net263 on 2019/12/13.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSDTGroupInfo : NSObject
@property(nonatomic, copy)NSString *clazzName;
@property(nonatomic, copy)NSString *groupCode;
@property(nonatomic, copy)NSString *groupName;
@property(nonatomic, copy)NSString *roomId;
@property(nonatomic, assign)NSInteger siteId;

- (instancetype)initWithDictionary :(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
