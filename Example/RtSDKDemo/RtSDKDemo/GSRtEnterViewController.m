//
//  GSRtEnterViewController.m
//  RtSDKDemo
//
//  Created by gensee on 2020/4/9.
//  Copyright © 2020年 CaicaiNo. All rights reserved.
//

#import "GSRtEnterViewController.h"
#import "GSRtSelectViewController.h"

@interface GSRtEnterViewController ()

@end

@implementation GSRtEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)watch:(UIButton*)sender {
    [super watch:sender];
    //param
    GSConnectInfo *params = [GSConnectInfo new];
#if 1
    params.domain = [self paramInField:MO_DOMAIN];
    params.roomNumber = [self paramInField:MO_ROOMID];
    params.loginName = [self paramInField:MO_LOGIN_NAME];
    params.watchPassword = [self paramInField:MO_PWD];
    params.loginPassword = [self paramInField:MO_LOGIN_PWD];
    params.nickName = [self paramInField:MO_NICKNAME];
    
#else
    //allgf.gensee.com/training/site/s/04738047
    //192.168.1.40/webcast/site/entry/join-3c9508b05cbe4085aca3e21d106b6eed
    //213.gensee.com/training/site/r/59271145
    params.domain = @"allgf.gensee.com";
    params.roomNumber = @"04738047";
    params.nickName = @"Paul@EM3";
    params.watchPassword = @"908424";
#endif
    params.serviceType = self.serviceType.selectedSegmentIndex==0?GSBroadcastServiceTypeWebcast:GSBroadcastServiceTypeTraining;
    params.thirdToken = [self paramInField:MO_THIRD_KEY];
    if ([self paramInField:MO_USERID].length > 0) {
        params.customUserID = [[self paramInField:MO_USERID] longLongValue];
    }
    [GSBroadcastManager sharedBroadcastManager].httpAPIEnabled = (self.httpType.selectedSegmentIndex==0)?YES:NO;
    [GSBroadcastManager sharedBroadcastManager].hardwareAccelerateVideoDecodeSupport = (self.decodeType.selectedSegmentIndex==0)?YES:NO;
    [GSBroadcastManager sharedBroadcastManager].hardwareAccelerateASDecodeSupport = (self.ASDecodeType.selectedSegmentIndex==0)?NO:YES;
    [GSBroadcastManager sharedBroadcastManager].hardwareAccelerateEncodeSupport = (self.encodeType.selectedSegmentIndex==0)?YES:NO;
    
    if (self.wField.text.length > 0 && self.hField.text.length > 0) {
        [GSBroadcastManager sharedBroadcastManager].videoConfiguration.videoSize = CGSizeMake(self.wField.text.intValue, self.hField.text.intValue);
    }
    
    switch (self.allowRoleType.selectedSegmentIndex) {
        case 0:
            params.joinPermission = GSBroadcastPermissionAllRoles;
            break;
        case 1:
            params.joinPermission = GSBroadcastPermissionOnlyOrgnizer;
            break;
        case 2:
            params.joinPermission = GSBroadcastPermissionOnlyAttendee;
            break;
        default:
            break;
    }
    params.oldVersion = self.boxType.selectedSegmentIndex;
    GSRtSelectViewController *selectVC = [[GSRtSelectViewController alloc] init];
    selectVC.param = params;
    [self.navigationController pushViewController:selectVC animated:YES];
    
    //设置间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
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

@end
