//
//  GSBroadcastProtocol.h
//  RtSDK
//
//  Created by gensee on 2018/11/7.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GSBroadcastProtocol <NSObject>

- (void)handLoginResult:(NSDictionary *)resultDic; //处理longinfoEnhanced 
- (void)handLoginResultForGlive:(NSDictionary *)resultDic; //处理longinfoEnhanced G直播处理逻辑
@end

NS_ASSUME_NONNULL_END
