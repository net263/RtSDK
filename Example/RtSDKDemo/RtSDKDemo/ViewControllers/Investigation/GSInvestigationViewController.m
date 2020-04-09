//
//  GSInvestigationViewController.m
//  RtSDKDemo
//
//  Created by Sheng on 2018/8/17.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSInvestigationViewController.h"
#import "GSCustomInvestigationView.h"
@interface GSInvestigationViewController () <GSBroadcastInvestigationDelegate>

@end

@implementation GSInvestigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问卷调查";
    // Do any additional setup after loading the view.
    self.manager.investigationDelegate = self;
    
    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    hint.text = @"请在PC或MAC端发起投票";
    hint.font = [UIFont systemFontOfSize:16.f];
    hint.textAlignment = NSTextAlignmentCenter;
    [hint sizeToFit];
    hint.width += 10;
    [self.view addSubview:hint];
    hint.center = self.view.center;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRtLeaveFinish {
    [GSCustomInvestigationView invalidate];
}

#pragma mark - investigation

- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didPublishInvestigation:(GSInvestigation*)investigation {
    [GSCustomInvestigationView showInvestigation:investigation];
}

- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didPublishInvestigationResult:(GSInvestigation*)investigation {
    [GSCustomInvestigationView showInvestigation:investigation];
}

- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didTerminateInvestigation:(GSInvestigation *)investigation {
    [GSCustomInvestigationView hideInvestigation:investigation];
}


- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didOnCardPublish:(NSDictionary *)options type:(GSCardQuestionType)questionType {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
