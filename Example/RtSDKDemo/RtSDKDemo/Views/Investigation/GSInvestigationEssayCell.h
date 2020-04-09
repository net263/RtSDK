//
//  GSInvestigationEssayCell.h
//  FASTSDK
//
//  Created by Sheng on 2017/8/11.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSInvestigationEssayCell : UITableViewCell

@property (strong, nonatomic)  UITextView *textView;

@property (strong, nonatomic)  UIImageView *backImageView;

@property (strong, nonatomic)    UILabel* personLabel;

@property (nonatomic, strong) GSInvestigation* investigation;

- (void)loadContent;

@end
