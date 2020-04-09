//
//  GSInvestigationHeaderView.h
//  FASTSDK
//
//  Created by Sheng on 2017/8/14.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSInvestigationHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign) NSUInteger section;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, weak) UITableView *tableView;

@end
