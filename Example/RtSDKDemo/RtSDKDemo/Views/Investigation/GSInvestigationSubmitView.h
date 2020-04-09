//
//  GSInvestigationSubmitView.h
//  FASTSDK
//
//  Created by Sheng on 2017/8/15.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSInvestigationSubmitView : UIView

@property (nonatomic, strong) UIButton *submitBtn;


- (void)showScore:(int)score;

- (void)enableSubmit;

- (void)disableSubmit;

- (void)alreadySubmit;

@end
