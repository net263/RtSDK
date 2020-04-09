//
//  GSCustomInvestigationView.h
//  FASTSDK
//
//  Created by Sheng on 2017/8/11.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
//  此类仅为示例所用,还不完善
@interface GSCustomInvestigationView : UIView

/**
 存储GSInvestigation对象
 */
@property (nonatomic, strong) GSInvestigation* investigation;

/**
 是否提交
 */
@property (nonatomic, assign) BOOL isSubmit;

+ (instancetype)investigationView;

+ (GSCustomInvestigationView*)showInvestigation:(GSInvestigation*)investigation;
+ (GSCustomInvestigationView*)hideInvestigation:(GSInvestigation*)investigation;
- (void)show;

- (void)hide;

+ (void)invalidate;

@end
