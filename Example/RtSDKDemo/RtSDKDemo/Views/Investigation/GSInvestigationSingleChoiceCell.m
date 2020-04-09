//
//  GSInvestigationSingleChoiceCell.m
//  FASTSDK
//
//  Created by Sheng on 2017/8/11.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSInvestigationSingleChoiceCell.h"

@interface GSInvestigationSingleChoiceCell ()

/**
 比例条
 */
@property (strong, nonatomic) THProgressView *percentView;

@end
@implementation GSInvestigationSingleChoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)buildSubview{
    
    
    
    [super buildSubview];
    
    _percentView = [[THProgressView alloc]initWithFrame:CGRectMake(0, 16, 161, 10)];
    _percentView.hidden = YES;
    _percentView.borderTintColor = [UIColor redColor];
    _percentView.progressTintColor = [UIColor redColor];
    
    [self.contentView addSubview:_percentView];
    
    
    
    _percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    _percentLabel.font = [UIFont systemFontOfSize:13];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_percentLabel];
    
    
    _percentLabel.hidden = YES;
    
    [self addObserver:self forKeyPath:@"option.isSelected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"option.isSelected"]) {
        
        if (self.isShowResult || self.isSubmit) {
            if (self.option.isCorrectItem) {
                self.correctView.hidden = NO;
            }else{
                self.correctView.hidden = YES;
            }
            
            if (self.option.isSelected) {
                
                [self.choiceView setImage:[UIImage imageNamed:@"radio_unavailable"]];
                
            }else{
                [self.choiceView setImage:[UIImage imageNamed:@"radio_buttons"]];
            }
        }else{
            if (self.option.isSelected) {
                
                [self.choiceView setImage:[UIImage imageNamed:@"radio_selected"]];
                
            }else{
                [self.choiceView setImage:[UIImage imageNamed:@"radio_buttons"]];
            }
        }
        
        
        
    }
}

- (void)loadContent{
    
    CGFloat left = 10;
    
    if (self.isShowResult || self.isSubmit) {

        self.userInteractionEnabled = NO;
        
        if (self.option.isCorrectItem) {
            self.correctView.hidden = NO;
        }else{
            self.correctView.hidden = YES;
        }
        
        if (self.option.isSelected) {
            [self.choiceView setImage:[UIImage imageNamed:@"radio_unavailable"]];
        }else{
            [self.choiceView setImage:[UIImage imageNamed:@"radio_buttons"]];
        }
        
        if (self.isShowResult) {
            
            self.correctView.left = left;
            left = self.correctView.right + 5;
            
            self.choiceView.left = left;
            left = self.choiceView.right + 5;
            
            self.contentLabel.left = left;
            self.contentLabel.centerY = self.contentView.centerY;
            self.contentLabel.width = 15;
            self.contentLabel.height = 44;
            left = self.contentLabel.right + 5;
            
            _percentView.left = left;
            _percentView.centerY = self.contentView.centerY;
            _percentView.width = self.contentView.width - left - 50;
            _percentView.height = 10;
            left = _percentView.right + 5;
            
            _percentLabel.left = left;
            _percentLabel.centerY = self.contentView.centerY;
            _percentLabel.width = 40;

            self.contentLabel.text = [NSString stringWithFormat:@"%@",self.alphabet];
            
            self.choiceView.hidden = NO;
            
            _percentView.hidden = NO;
            _percentLabel.hidden = NO;
            if (self.option.users.count > 0) {
                _percentLabel.text = [NSString stringWithFormat:@"%d",(int)self.option.users.count];
            }else{
                _percentLabel.text = @"0";
            }
            
            
            [_percentView setProgress:_percentValue animated:NO];
        }else{
            self.correctView.left = left;
            left = self.correctView.right + 5;
            
            self.choiceView.left = left;
            left = self.choiceView.right + 5;
            
            self.contentLabel.left = left;
            self.contentLabel.centerY = self.contentView.centerY;
            self.contentLabel.width = self.contentView.width - left - 10;
            self.contentLabel.height = 44;
            self.contentLabel.centerY = self.contentView.centerY;
            left = self.contentLabel.right + 5;
            
            _percentView.hidden = YES;
            _percentLabel.hidden = YES;
            self.choiceView.hidden = NO;
            
        }
        
    }else{
        self.userInteractionEnabled = YES;
        
        self.choiceView.left = left;
        self.choiceView.centerY = self.contentView.centerY;
        left = self.choiceView.right + 5;
        
        self.contentLabel.left = left;
        self.contentLabel.centerY = self.contentView.centerY;
        self.contentLabel.width = self.contentView.width - 10 - left;
        left = self.contentLabel.right + 5;
        
        NSString *title = [NSString stringWithFormat:@"%@、%@",self.alphabet,self.option.content];
        
        self.contentLabel.text = title;

        if (self.option.isSelected) {
            [self.choiceView setImage:[UIImage imageNamed:@"radio_selected"]];
        }else{
            [self.choiceView setImage:[UIImage imageNamed:@"radio_buttons"]];
        }
        self.choiceView.hidden = NO;
        self.correctView.hidden = YES;
        _percentView.hidden = YES;
        _percentLabel.hidden = YES;
    }
    
    
    
    
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"option.isSelected"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
