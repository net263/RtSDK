//
//  GSInvestigationBaseCell.h
//  FASTSDK
//
//  Created by Sheng on 2017/10/24.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSInvestigationBaseCell : UITableViewCell

@property (nonatomic, strong) GSInvestigationOption* option;


/**
 答案 选择图片
 */
@property (strong, nonatomic)  UIImageView *choiceView;

/**
 内容label
 */
@property (strong, nonatomic)  UILabel *contentLabel;

/**
 显示正确答案的视图
 */
@property (strong, nonatomic)  UIImageView *correctView;




///**
// 百分比label  -  人数
// */
//@property (strong, nonatomic)  UILabel *percentLabel;

/**
 *  此调查结果是否已经公布 或者 已经结束  显示结果
 */
@property (nonatomic, assign) BOOL isShowResult;


/**
 A  B  C  D
 */
@property (strong, nonatomic) NSString *alphabet;


/**
 是否提交了
 */
@property (assign,nonatomic) BOOL isSubmit;


- (void)loadContent;

#pragma mark - private

- (void)buildSubview;
@end
