//
//  GSChatViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/8/15.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSChatViewController.h"
#import "GSChatView.h"
#import "GSChatModel.h"
@interface GSChatViewController () <GSBroadcastChatDelegate>
//test
@property (nonatomic, strong) NSTimer *testTimer;
@property (nonatomic, assign) unsigned long i;
//
@property (nonatomic, strong) GSChatView *chatView;
//
@property (nonatomic, strong) MBProgressHUD *bufferHud;
@property (nonatomic, strong) GSUserInfo *user;
@end

@implementation GSChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager.chatDelegate = self;
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"聊天性能测试" style:UIBarButtonItemStyleDone target:self action:@selector(test)];
    
    self.chatView = [[GSChatView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height -64)];
    
    [self.view addSubview:self.chatView];
    
}

- (void)didRtJoinSuccess {
    
}

- (void)test {
    if (_testTimer.isValid) {
        [_testTimer invalidate];
        _testTimer = nil;
    } else {
        _testTimer = [NSTimer timerWithTimeInterval:0.3f
                                         target:self
                                       selector:@selector(makeFakeChatMsg)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_testTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)makeFakeChatMsg {
    if (!_user) {
        _user = [GSBroadcastManager sharedBroadcastManager].queryMyUserInfo;
    }
    GSChatMessage *chatMessage = [GSChatMessage new];
    chatMessage.text = @"测试人员";
    chatMessage.richText = [NSString stringWithFormat:@"这是一条测试消息:<IMG src=\"emotion\\emotion.se.gif\" custom=\"false\"> %lu", _i++];
    chatMessage.msgID = [[NSUUID UUID] UUIDString];
    chatMessage.userInfo = _user;
    
    GSChatModel *model = [[GSChatModel alloc]initWithModel:chatMessage type:GSChatModelPublic];
    
    [self.chatView insert:model forceBottom:YES];
}




//接收聊天,聊天可能会很频繁，但是不宜刷新界面太频繁,这里没有优化

- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didReceivePrivateMessage:(GSChatMessage *)msg fromUser:(GSUserInfo *)user{
    
    msg.userInfo = user;
    GSChatModel *model = [[GSChatModel alloc]initWithModel:msg type:GSChatModelPrivate];
    
    [self.chatView insert:model];
}

- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didReceivePublicMessage:(GSChatMessage *)msg fromUser:(GSUserInfo *)user {
    msg.userInfo = user;
    GSChatModel *model = [[GSChatModel alloc]initWithModel:msg type:GSChatModelPublic];
    
    [self.chatView insert:model];
}

- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didReceivePanelistMessage:(GSChatMessage *)msg fromUser:(GSUserInfo *)user {
    msg.userInfo = user;
    GSChatModel *model = [[GSChatModel alloc]initWithModel:msg type:GSChatModelPublic];
    
    [self.chatView insert:model];
}


/**
 *  聊天审核以后，根据用户id删除聊天消息
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param userId          用户id
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didChatCensorByUserID:(long long)userId {
    [self.chatView removeByUser:[NSString stringWithFormat:@"%lld",userId]];
}
/**
 *  聊天审核以后，根据聊天的消息id删除聊天消息
 *
 *  @param broadcastManager 触发此代理的GSBroadcastManager对象
 *  @param msgID          聊天消息id
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didChatCensorByMsgID:(NSString*)msgID {
    [self.chatView removeByMessage:msgID];
}

- (BOOL)broadcastManager:(GSBroadcastManager *)manager saveSettingsInfoKey:(NSString *)key numberValue:(int)value {
    
    if ([key isEqualToString:@"chat.mode"]) {
        if (value == 0) {
            NSLog(@"禁止聊天");
        }else if (value == 1) {
            NSLog(@"允许聊天");
        }else if (value == 2) {
            NSLog(@"允许公聊");
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}


@end
