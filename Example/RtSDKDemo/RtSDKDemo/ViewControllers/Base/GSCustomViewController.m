//
//  GSCustomViewController.m
//  RtSDKDemo
//
//  Created by Sheng on 2018/8/16.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSCustomViewController.h"
#import "Reachability.h"
#import "MBProgressHUD+GSMJ.h"
#define MO_LOGIN_NAME @"FAST_CONFIG_LOGIN_NAME"
@interface GSCustomViewController () <GSBroadcastRoomDelegate>
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) Reachability *internetReachability;
/**
 连接结果枚举
 */
@property (nonatomic, strong) NSDictionary *connectEnumDic;

@end

@implementation GSCustomViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.manager = [GSBroadcastManager sharedBroadcastManager];
    self.manager.broadcastRoomDelegate =self;
    GSConnectInfo *info=[self.param copy];
    [self.manager connectBroadcastWithConnectInfo:info];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

static UIAlertController *alertC = nil;

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == self.internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        
        switch (netStatus)
        {
            case NotReachable:{
                NSLog(@"updateInterfaceWithReachability NotReachable");
                UIAlertController *alertC1 = [UIAlertController alertControllerWithTitle:@"" message:@"当前无网络！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertC1 addAction:action];
                [self presentViewController:alertC1 animated:YES completion:nil];
                alertC = alertC1;
                break;
            }
                
            case ReachableViaWWAN:{
                NSLog(@"updateInterfaceWithReachability ReachableViaWWAN");
                UIAlertController *alertC1 = [UIAlertController alertControllerWithTitle:@"" message:@"当前是移动网络,是否继续?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"是" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[GSBroadcastManager sharedBroadcastManager] leaveAndShouldTerminateBroadcast:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertC1 addAction:action];
                [alertC1 addAction:action1];
                [self presentViewController:alertC1 animated:YES completion:nil];
                
                alertC = alertC1;
                
                break;
            }
            case ReachableViaWiFi:{
                NSLog(@"updateInterfaceWithReachability ReachableViaWiFi");
                if (alertC) {
                    [alertC dismissViewControllerAnimated:NO completion:nil];
                }
            }
        }
        
    }
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self updateInterfaceWithReachability:curReach];
}

- (void)popAction {
    if (_hud) [_hud hide:YES];
    _hud = [MBProgressHUD showMessage:@"正在退出..." toView:self.view];
    [self leave];
}

- (void)leave {
    [[GSBroadcastManager sharedBroadcastManager] leaveAndShouldTerminateBroadcast:NO];
}

#pragma mark - room delegate

- (NSDictionary *)connectEnumDic
{
    if (!_connectEnumDic) {
        _connectEnumDic = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[@"EnumDic" stringByAppendingPathExtension:@"plist"]]];
    }
    return _connectEnumDic;
}

- (void)broadcastManager:(GSBroadcastManager *)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)connectResult {
    if (connectResult == GSBroadcastConnectResultSuccess) {
        [[GSBroadcastManager sharedBroadcastManager] join]; //加入直播
    }else{
        NSString *message = [[self.connectEnumDic objectForKey:@"GSBroadcastConnectResult"] objectForKey:[NSString stringWithFormat:@"%d",(int)connectResult]];
        
        if (message.length == 0) {
            message = @"请导入相关Bundle文件";
        }
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[GSBroadcastManager sharedBroadcastManager] leaveAndShouldTerminateBroadcast:NO];

        }];
        [alertVC addAction:cancel];
        [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)broadcastManager:(GSBroadcastManager *)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted{
    [_hud hide:YES];
    [MBProgressHUD showHint:@"加入成功" toView:self.view];
    if (joinResult == GSBroadcastJoinResultSuccess) {
        [[GSBroadcastManager sharedBroadcastManager] setStatus:GSBroadcastStatusRunning];
        [self didRtJoinSuccess];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
    }else{
      
        NSString *message = [[self.connectEnumDic objectForKey:@"GSBroadcastJoinResult"] objectForKey:[NSString stringWithFormat:@"%d",(int)joinResult]];
        
        if (message.length > 0) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[GSBroadcastManager sharedBroadcastManager] leaveAndShouldTerminateBroadcast:NO];
            }];
            
            [alertVC addAction:cancel];
            [self.navigationController presentViewController:alertVC animated:NO completion:nil];
        }
    }
}

- (void)broadcastManager:(GSBroadcastManager *)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason{
    [_hud hide:YES];
    [self willRtLeaveFinish];
    if (leaveReason == GSBroadcastLeaveReasonNormal) {
        //正常退出需要释放资源
        [self.manager invalidate];
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }else{
        NSString *message = [[self.connectEnumDic objectForKey:@"GSBroadcastLeaveReason"] objectForKey:[NSString stringWithFormat:@"%d",(int)leaveReason]];
        
        if (message.length > 0) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.manager invalidate];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alertVC addAction:cancel];
            [self.navigationController presentViewController:alertVC animated:NO completion:nil];
        }
        
    }
}

- (BOOL)broadcastManager:(GSBroadcastManager *)manager saveSettingsInfoKey:(NSString *)key numberValue:(int)value {
    
    if ([key isEqualToString:@"client.training.type"]) {
        
    }
    
    return YES;
}

- (void)broadcastManagerWillStartReconnect:(GSBroadcastManager*)manager{
    if (_hud) [_hud hide:YES];
    _hud = [MBProgressHUD showMessage:@"正在重连..."];
}

- (void)broadcastManager:(GSBroadcastManager *)manager broadcastMessage:(NSString *)message{
    [MBProgressHUD showHint:message delay:2];
}

- (void)didRtJoinSuccess {
    NSLog(@"你应该在父类重写这个方法来实现");
}

- (void)willRtLeaveFinish {
    NSLog(@"你应该在父类重写这个方法来实现");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
        return UIInterfaceOrientationPortrait|UIInterfaceOrientationLandscapeRight;
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
