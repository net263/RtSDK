//  GSRtSelectViewController.m
//  RtSDKDemo
//  Created by Sheng on 2018/8/16.
//  Copyright © 2018年 gensee. All rights reserved.
#import "GSRtSelectViewController.h"
#import "GSChatViewController.h"
#import "GSQaViewController.h"
#import "GSInvestigationViewController.h"
#import "GSMutiVideoViewController.h"
#import "GSDiagnosisViewController.h"
#import "GSMoreInfoViewController.h"
#import "GSSingleVideoViewController.h"
#import "GSDocViewController.h"
#import "BaseItemViewController.h"
@interface GSRtSelectViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *controllerIdentifiers;
@end
@implementation GSRtSelectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) {  // >= 11
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    [self _setExtraCellLineHidden:tableView];
    _tableView = tableView;
    [self.view addSubview:tableView];
    self.controllerIdentifiers = [NSArray arrayWithObjects:@"SingleVideo", @"MultiVideo",@"Doc", @"Chat", @"Qa", @"Investigation", @"DemoBoard",@"Lottery", @"Checkin",@"viesAnswer",@"Praise", nil];
}

- (NSArray *)datas {
    if (!_datas) {
        _datas = [NSArray arrayWithObjects:
                  NSLocalizedString(@"SingleVideo", @"单路视频"),
                  NSLocalizedString(@"MultiVideo", @"多路视频(观看端)"),
                  NSLocalizedString(@"Doc", @"文档"),
                  NSLocalizedString(@"Chat", @"聊天"),
                  NSLocalizedString(@"Qa", @"问答"),
                  NSLocalizedString(@"Investigation", @"问卷调查"),
                  NSLocalizedString(@"Robot", @"罗伯特笔服务"),
                  NSLocalizedString(@"Lottery", @"抽奖"),
                  NSLocalizedString(@"CheckIn", @"点名"),
                  NSLocalizedString(@"Vies", @"抢答"),
                  NSLocalizedString(@"Praise", @"点赞/勋章"),
                  NSLocalizedString(@"Diagnosis", @"日志收集"),
                  NSLocalizedString(@"MoreInfo", @"更多信息"),
                  nil];
    }
    return _datas;
}

- (void)_setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

static NSString *reuseIdentifier = @"GSSelectReuseCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GSSingleVideoViewController *tmp = [[GSSingleVideoViewController alloc]init];
        tmp.param = self.param;
        [self.navigationController pushViewController:tmp animated:YES];
        return;
    }else if (indexPath.row == 1) {
        GSMutiVideoViewController *tmp = [[GSMutiVideoViewController alloc]init];
        tmp.param = self.param;
        [self.navigationController pushViewController:tmp animated:YES];
        return;
    }else if (indexPath.row == 2) {
        GSDocViewController *tmp = [[GSDocViewController alloc]init];
        tmp.param = self.param;
        [self.navigationController pushViewController:tmp animated:YES];
        return;
    }else if (indexPath.row == 3) {
        GSChatViewController *tmp = [[GSChatViewController alloc]init];
        tmp.param = self.param;
        [self.navigationController pushViewController:tmp animated:YES];
        return;
    }else if (indexPath.row == 4) {
        GSQaViewController *tmp = [[GSQaViewController alloc]init];
        tmp.param = self.param;
        [self.navigationController pushViewController:tmp animated:YES];
        return;
    }else if (indexPath.row == 5) {
        GSInvestigationViewController *tmp = [[GSInvestigationViewController alloc]init];
        tmp.param = self.param;
        [self.navigationController pushViewController:tmp animated:YES];
        return;
    }else if (indexPath.row==6){
        NSLog(@"该界面已移除");
        return;
    }
    else if (indexPath.row == self.datas.count - 2) {
        GSDiagnosisViewController *tmp = [[GSDiagnosisViewController alloc]init];
        tmp.param = self.param;
        [self.navigationController pushViewController:tmp animated:YES];
        return;
    }else if (indexPath.row == self.datas.count - 1) {
        GSMoreInfoViewController *tmp = [[GSMoreInfoViewController alloc]init];
        tmp.param = self.param;
        [self.navigationController pushViewController:tmp animated:YES];
        return;
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BaseItemViewController *controller = [board instantiateViewControllerWithIdentifier:self.controllerIdentifiers[indexPath.row]];
    controller.title = self.datas[indexPath.row];
    controller.connectInfo = [self.param copy];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotate {
    return NO;
}

@end
