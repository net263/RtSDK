//
//  GSInvestigationSingleChoiceCell.m
//  FASTSDK
//
//  Created by Sheng on 2017/8/11.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSInvestigationBaseCell.h"

@implementation GSInvestigationBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundColor=[UIColor whiteColor];
    
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self buildSubview];
        
        
    }
    return self;
    
}



- (void)buildSubview{
    
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _correctView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 23, 12)];
    
    _correctView.image = [UIImage imageNamed:@"correct"];
    
    [self.contentView addSubview:_correctView];
    
    _correctView.left = 10;
    _correctView.centerY = self.contentView.centerY;

    
    _choiceView = [[UIImageView alloc] initWithFrame:CGRectMake(38+2, 13.5, 30, 30)];
    
    
    [self.contentView addSubview:_choiceView];
    
    _choiceView.left = _correctView.right + 2;
    _choiceView.centerY = self.contentView.centerY;

    
    _contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(70+2, 22, Width - 72, 44)];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.numberOfLines = 0;                           //表示label可以多行显示
    _contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
    _contentLabel.font = [UIFont systemFontOfSize:13];
    
    _contentLabel.left = _choiceView.right+5;
    _contentLabel.top = self.contentView.top;
    _contentLabel.right = self.contentView.right - 10;
   
}

- (void)loadContent{
    
    
    if (_isSubmit || _isShowResult) {
        _choiceView.left = _correctView.right + 2;
        _choiceView.centerY = self.contentView.centerY;

        if (_isShowResult) {
            _contentLabel.left = self.correctView.right+5;
            _contentLabel.top = self.contentView.top;
            _contentLabel.right = self.contentView.right - 10;
       
            self.choiceView.hidden = YES;
            
        }else{
            _contentLabel.left = self.correctView.right+5;
            _contentLabel.centerY = self.contentView.centerY;
            _contentLabel.right = self.contentView.right - 10;

            self.choiceView.hidden = NO;
        }
        
        
        self.userInteractionEnabled = NO;
        
        if (_option.isCorrectItem) {
            self.correctView.hidden = NO;
        }else{
            self.correctView.hidden = YES;
        }
        
        
        //        self.choiceView.frame = CGRectMake(38 + 2, (self.frame.size.height - 30)/2, 30, 30);
        
        //        _percentLabel.text = [NSString stringWithFormat:@"%ld",_option.totalSumOfUsers];
        _contentLabel.text = [NSString stringWithFormat:@"%@、%@",_alphabet,_option.content];
        
        //        _contentLabel.frame = CGRectMake(self.choiceView.frame.origin.x + self.choiceView.frame.size.width, 0, self.frame.size.width-45, self.frame.size.height);
        
        if (_option.isSelected) {
            
            [_choiceView setImage:[UIImage imageNamed:@"radio_unavailable"]];
            
        }else{
            [_choiceView setImage:[UIImage imageNamed:@"radio_buttons"]];
        }
        
    }else{
        _choiceView.left = 10;
        _choiceView.centerY = self.contentView.centerY;
     
        _contentLabel.left = self.choiceView.right+5;
        _contentLabel.top = self.contentView.top;
        _contentLabel.right = self.contentView.right - 10;
    
        self.userInteractionEnabled = YES;
        self.choiceView.hidden = NO;
        self.correctView.hidden = YES;
        
        NSString *title = [NSString stringWithFormat:@"%@、%@",_alphabet,_option.content];
        
        _contentLabel.text = title;
        
        if (_option.isSelected) {
            
            [_choiceView setImage:[UIImage imageNamed:@"radio_selected"]];
            
        }else{
            [_choiceView setImage:[UIImage imageNamed:@"radio_buttons"]];
        }
    }
    
    
    
    
}



#pragma mark - 计算文本高度

- (CGFloat)heightWithString:(NSString *)string LabelFont:(UIFont *)font withLabelWidth:(CGFloat)width {
    CGFloat height = 0;
    
    if (string.length == 0) {
        height = 0;
    } else {
        
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13.f]};
        if (font) {
            attribute = @{NSFontAttributeName: font};
        }
        
        // 尺寸
        CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
        
        height = retSize.height;
    }
    
    return height;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

