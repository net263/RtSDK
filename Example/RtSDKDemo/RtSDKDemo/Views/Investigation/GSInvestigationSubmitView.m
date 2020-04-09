//
//  GSInvestigationSubmitView.m
//  FASTSDK
//
//  Created by Sheng on 2017/8/15.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSInvestigationSubmitView.h"
#define FASTSDK_COLORA(r,g,b,a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define MO_DISABLE_COLOR FASTSDK_COLORA(252, 209, 204, 1);
#define MO_ABLE_COLOR FASTSDK_COLORA(228, 62, 54, 1);

@interface GSInvestigationSubmitView ()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIImageView *imageIcon;

@end

@implementation GSInvestigationSubmitView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        _line = line;
        [self addSubview:line];
        
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 150)/2, (self.frame.size.height - 20)/2, 150, 20)];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
        
        _imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 150)/2 - 15, (self.frame.size.height - 20)/2, 20, 20)];
        [self addSubview:_imageIcon];
        
        _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 6, self.frame.size.width - 20, self.frame.size.height - 12)];
        _submitBtn.layer.cornerRadius = (self.frame.size.height - 12)/2;
        _submitBtn.backgroundColor = MO_ABLE_COLOR;
        _submitBtn.opaque = YES;
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        
        self.userInteractionEnabled = YES;
        [self addSubview:_submitBtn];
    }
    return self;
}

- (void)showScore:(int)score{
    NSString* tipStr;
    if (score<=59) {
        
        tipStr = @"不要灰心，再接再厉";
        _tipLabel.text=tipStr;
        _imageIcon.image=[UIImage imageNamed:@"answer_sheet_is_wrong"];
    }else if ((60<=score)&&(score<=84))
    {
        
        tipStr= @"恭喜您，通过了";
        _tipLabel.text=tipStr;
        _imageIcon.image = [UIImage imageNamed:@"answer_sheet_is_right"];
    }else if((85<=score)&&(score<=100))
    {
        
        tipStr = @"您表现的棒极了";
        _tipLabel.text=tipStr;
        _imageIcon.image=[UIImage imageNamed:@"answer_sheet_is_right"];
    }
    
    _submitBtn.hidden = YES;

}

- (void)enableSubmit{
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = MO_ABLE_COLOR;
    [self.submitBtn setHidden:NO];
}

- (void)disableSubmit{
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = MO_DISABLE_COLOR;
    [self.submitBtn setHidden:NO];
}

- (void)alreadySubmit{
    
    [self.submitBtn setTitle:@"已提交" forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = MO_DISABLE_COLOR;
    [self.submitBtn setHidden:NO];
}

- (void)layoutSubviews
{
    _line.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    _submitBtn.frame = CGRectMake(10, 6, self.frame.size.width - 20, self.frame.size.height - 12);
    
    _tipLabel.frame = CGRectMake((self.frame.size.width - 150)/2, (self.frame.size.height - 20)/2, 150, 20);
    _imageIcon.frame = CGRectMake((self.frame.size.width - 150)/2 - 20, (self.frame.size.height - 20)/2, 20, 20);
    
    [super layoutSubviews];
}

@end
