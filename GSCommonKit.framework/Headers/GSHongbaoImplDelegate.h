//
//  GSHongbaoImplDelegate.h
//  GSCommonKit
//
//  Created by net263 on 2019/12/3.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GSHongbaoImplDelegate <NSObject>
/**
 *红包功能是否开启
 */
-(void)onHongbaoEnable:(bool)bEnable;

/**
 *红包创建成功的回调
 */
-(void)onHongbaoCreate:(GSHongbaoCreateResult)result strId:(NSString*)strid;

/**
 *  出现红包回调
 *  @param hongbaoInfo      红包信息
 */
- (void)onHongbaoComingNotify:(GSHongbaoInfo*)hongbaoInfo;

/**
 *  红包被抢回调
 *  @param strid            红包ID
 *  @param grabInfo         抢红包信息
 *  @param hongbaoType      红包类型：//0:随机红包，1：固定红包，2：定向红包
 */
- (void)onHongbaoGrabbedNotify:(NSString*)strid grabInfo:(GSGrabInfo*)grabInfo type:(int)hongbaoType;

/**
 *  抢红包结果回调
 *  @param result           抢红包结果
 *  @param strid            红包ID
 *  @param money            抢到的货币
 */
- (void)onHongbaoGrabHongbao:(GSHongbaoGrabResult)result strId:(NSString*)strid money:(unsigned)money;

/**
 *  查询抢了这个红包的所有人
 *
 *  @param grabs            抢了这个红包的所有人的信息
 *  @param strid            红包ID
 */
- (void)onHongbaoQueryHongbaoGrabList:(NSArray<GSGrabInfo*>*)grabs strId:(NSString*)strid;

/**
 *  查询自己抢的所有红包
 *  @param grabs            自己抢的红包列表
 */
- (void)onHongbaoQuerySelfGrabList:(NSArray<GSUserGrabInfo *> *)grabs;

@end

NS_ASSUME_NONNULL_END
