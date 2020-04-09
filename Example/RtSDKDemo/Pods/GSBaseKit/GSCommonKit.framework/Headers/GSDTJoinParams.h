//
//  GSDTJoinParams.h
//  GSCommonKit
//
//  Created by net263 on 2019/12/13.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSDTGroupInfo.h"
#import "GSDTConst.h"
NS_ASSUME_NONNULL_BEGIN

@interface GSDTJoinParams : NSObject
@property(nonatomic, strong)GSDTGroupInfo *dtGroupInfo;
/*
 名师课堂分课id
 */
@property(nonatomic, copy)NSString *subClassId;
/*
 名师课堂主课id
 */
@property(nonatomic, copy)NSString *masterRoomId;

/*
 名师课堂主课的主题
 */
@property(nonatomic, copy)NSString *masterSubject;

/*
 用户加入分课的组编号
 */
@property(nonatomic, copy)NSString *groupCode;

/*
 分课是否有分组信息
 */
@property(nonatomic, assign)BOOL isGroups;

/*
 名师课堂模式：
 GSSubClassStatus,//分课堂
 GSMainClassStatus,//主课堂
 */
@property(nonatomic, assign)GSDTStatus dtStatus;

/*
 课堂类型
 3:名师课堂主课类型
 4：名师课堂分课类型
 */
@property(nonatomic, assign)NSInteger scene;

-(BOOL) isDoubleTeacher;
@end

NS_ASSUME_NONNULL_END
