//
//  GSInvestigationTopView.m
//  FASTSDK
//
//  Created by Sheng on 2017/8/15.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSInvestigationTopView.h"

@implementation GSInvestigationTopView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitBtn setImage:[UIImage imageNamed:@"shut_down"] forState:UIControlStateNormal];
        _exitBtn.frame = CGRectMake(frame.size.width - 40, 4, 40, 40);
        
        
        [self addSubview:_exitBtn];
        
        
        
        _themeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, frame.size.width - 60, 40)];
        //        _themeLabel.textAlignment = NSTextAlignmentLeft;
        _themeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _themeLabel.textColor = [UIColor colorWithRed:43/255.f green:147/255.f blue:240/255.f alpha:1];
        
        [self addSubview:_themeLabel];
        
        _linetop = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        _linetop.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self addSubview:_linetop];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _exitBtn.frame = CGRectMake(self.frame.size.width - 40, 4, 40, 40);
    _linetop.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    _themeLabel.frame = CGRectMake(10, 4, self.frame.size.width - 60, 40);
    
}

@end
