//
//  GSInvestigationEssayCell.m
//  FASTSDK
//
//  Created by Sheng on 2017/8/11.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSInvestigationEssayCell.h"

@implementation GSInvestigationEssayCell
{
    UIView *footView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor=[UIColor whiteColor];
        
        _backImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, Width - 20, self.frame.size.height)];
        [self.contentView addSubview:_backImageView];
        _backImageView.image = [UIImage imageNamed:@"vote_text"];
        
        
        
        _textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 15, self.frame.size.width - 20, self.frame.size.height)];
        [self.contentView addSubview:_textView];
        
        
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.layer.cornerRadius = 2.f;
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.borderColor = [[UIColor grayColor] CGColor];
        _textView.font = [UIFont systemFontOfSize:13];
        
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 23)];
        footView.backgroundColor=[UIColor whiteColor];
        
        UILabel* personLabel=[[UILabel alloc] init];
        
        personLabel.frame=CGRectInset(footView.frame,25,0);
        [footView addSubview:personLabel];
        personLabel.textAlignment=NSTextAlignmentLeft;
        personLabel.textColor=[UIColor colorWithRed:250/255.f green:178/255.f blue:160/255.f alpha:1];
        personLabel.font=[UIFont systemFontOfSize:13];
        
        _personLabel = personLabel;
        
        [self addSubview:footView];
        
        footView.hidden = YES;
        
    }
    return self;
    
}

- (void)setInvestigation:(GSInvestigation *)investigation
{
    _investigation = investigation;
    if (_investigation) {
        if (_investigation.isResultPublished || _investigation.hasTerminated ) {
            
//            _personLabel.text=[NSString stringWithFormat:@"%@:%lu",GNSLocalizedString(@"number_of_entries", @"参加人数"),(unsigned long)_investigation.toto];
            _personLabel.text=[NSString stringWithFormat:@"%@:%lu",@"参加人数",(unsigned long)_investigation.users.count];
            footView.hidden = NO;
            _textView.hidden = YES;
        }else{
            footView.hidden = YES;
            _textView.hidden = NO;
        }
    }else{
        footView.hidden = YES;
        _textView.hidden = NO;
    }
    
    
}



- (void)loadContent{
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_backImageView) {
        _backImageView.frame = CGRectMake(10, 5, self.frame.size.width - 20, self.frame.size.height - 10);
    }
    
    if (_textView) {
        _textView.frame = CGRectMake(10, 5, self.frame.size.width - 20, self.frame.size.height - 10);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
