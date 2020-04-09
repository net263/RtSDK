//
//  GSInvestigationSingleChoiceCell.h
//  FASTSDK
//
//  Created by Sheng on 2017/8/11.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSInvestigationBaseCell.h"
#import "THProgressView.h"

@interface GSInvestigationSingleChoiceCell : GSInvestigationBaseCell

/**
 比例
 */
@property (assign, nonatomic) double percentValue;


/**
 百分比label  -  人数
 */
@property (strong, nonatomic)  UILabel *percentLabel;

@end
