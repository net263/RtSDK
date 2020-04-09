//
//  GSInvestigationHeaderView.m
//  FASTSDK
//
//  Created by Sheng on 2017/8/14.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSInvestigationHeaderView.h"


@interface GSInvestigationHeaderView ()


@property (nonatomic, strong) UILabel *questionLabel;

@end

@implementation GSInvestigationHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.questionLabel = [[UILabel alloc]init];
        
        self.questionLabel.font = [UIFont systemFontOfSize:13];
        
        self.questionLabel.textAlignment = NSTextAlignmentLeft;
        
        self.questionLabel.numberOfLines = 0;
        
        self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
//        self.questionLabel.textColor = [UIColor grayColor];
        
        [self addSubview:self.questionLabel];
        
    }
    return  self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.questionLabel.frame = CGRectMake(10, 4, self.frame.size.width - 20, self.frame.size.height-8);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.questionLabel.text = _title;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
