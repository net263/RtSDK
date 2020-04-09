//
//  GSQaViewController.m
//  RtSDKDemo
//
//  Created by Sheng on 2018/8/17.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSQaViewController.h"
#import "GSQaView.h"
@interface GSQaViewController () <GSBroadcastQaDelegate>
@property (nonatomic, strong) GSQaView *qaView;
@end

@implementation GSQaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager.qaDelegate = self;
    // Do any additional setup after loading the view.
    self.qaView = [[GSQaView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height -64)];
    [self.view addSubview:self.qaView];
}

- (void)didRtJoinSuccess {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 问答设置状态改变代理
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didSetQaEnabled:(BOOL)enabled QuestionAutoDispatch:(BOOL)autoDispatch QuestionAutoPublish:(BOOL)autoPublish
{
    
}

// 问题的状态改变代理，包括收到一个新问题，问题被发布，取消发布等
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager question:(GSQuestion*)question updatesOnStatus:(GSQaStatus)status
{
    long long userId = [GSBroadcastManager sharedBroadcastManager].queryMyUserInfo.userID;
    if (question.ownerID == userId && (question.answers.count == 0 || !question.answers)) {
        NSLog(@"过滤自己的问题");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (status) {
            case GSQaStatusNewAnswer:
            {
                
            }
                
                break;
                
            case GSQaStatusQuestionPublish:
            {
                GSQaModel *model = [[GSQaModel alloc]initWithQaData:question];
                [self.qaView insert:model];
            }
                break;
                
                
            case GSQaStatusQuestionCancelPublish:
            {
                
                GSQaModel *model = [[GSQaModel alloc]initWithQaData:question];
                [self.qaView removeByQuestionID:model.qaData.questionID];
            }
                
                break;
                
            case GSQaStatusNewQuestion:
            {
                
            }
                break;
                
            default:
                break;
        }
    });
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)shouldAutorotate {
    return NO;
}
@end
