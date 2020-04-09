//
//  GSSingleVideoViewController.m
//  RtSDKDemo
//
//  Created by Sheng on 2018/9/10.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSSingleVideoViewController.h"

@interface GSSingleVideoViewController () <GSBroadcastVideoDelegate,GSBroadcastDesktopShareDelegate,GSBroadcastAudioDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *videoArea;
@property (nonatomic, strong) UIView *cameraArea;
@property (nonatomic, strong) UIView *docArea;
@property (nonatomic, strong) GSVideoView *videoView;
@property (nonatomic, strong) GSVideoView *previewView;
@property (nonatomic, strong) GSDocView *docView;

@property (nonatomic, strong) UIButton *display;
@property (nonatomic, strong) UIButton *speaker;
@property (nonatomic, strong) UIButton *screenShot; //截屏

@property (nonatomic, strong) UIImageView *screenShotView; //截屏

@property (nonatomic, copy) NSString *askKey;
@property (nonatomic, strong) GSUserInfo* userInfo;

@property (nonatomic, strong) UILabel *layoutShow;

@end

@implementation GSSingleVideoViewController
{
    //结构体 位域
    struct {
        unsigned int isLod : 1; //是否插播  1位
        unsigned int isAS : 1;  //是否桌面共享 1位
        unsigned int isCameraShow : 1;  //是否本地视频 1位
        unsigned int isFullScreen : 1;  //是否全屏 1位
        
        unsigned int isDisplay : 1;
        unsigned int isSpeaker : 1;
        unsigned int isRotation : 1;
        unsigned int isStartLive : 1;
        unsigned int isOrganizer : 1;
        unsigned int isCameraOpen : 1;
        unsigned int isCameraStartcapture : 1;
        unsigned int isBeauty : 1;
        unsigned int isMicphoneOpen : 1;
        
        unsigned int isDocFullScreen : 1;
        unsigned int isVideoFullScreen : 1;
        unsigned int isReceiverOrSpeaker : 1; //听筒0 扬声器1, SDK中默认扬声器
    } _state;
    long long activeUserId;
    long long recordUserId;
    
}

- (void)didRtJoinSuccess {
    GSUserInfo *userInfo = self.manager.queryMyUserInfo;
    if (userInfo.isOrganizer & GSUserRoleOrganizer) { // 组织者（教师）允许标注操作
        _screenShot.hidden = NO;
        _state.isOrganizer = 1;
    }else{
        _screenShot.hidden = YES;
        _state.isOrganizer = 0;
    }
    
    _userInfo = userInfo;
}

- (void)leave {
    [self.manager leaveAndShouldTerminateBroadcast:self.userInfo.isOrganizer?YES:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _state.isReceiverOrSpeaker = 1;
    self.title = @"单路视频";
    self.manager.videoDelegate = self;
    self.manager.audioDelegate = self;
    self.manager.desktopShareDelegate = self;
    
//    self.manager.hardwareAccelerateVideoDecodeSupport = NO;
    self.manager.videoConfiguration.previewFillMode = kGPUImageFillModePreserveAspectRatio;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - 50)];
    _scrollView.scrollEnabled = YES;
//    _scrollView.viewSize = CGSizeMake(Width, Height);
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView.alwaysBounceVertical = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self.view addSubview:_scrollView];
    
    CGFloat top = 64 + 5 + UIView.additionaliPhoneXTopSafeHeight;
    _videoArea = [[UIView alloc] initWithFrame:CGRectMake(5, top, Width - 10, (Width - 10)*3/4)];
    _videoArea.layer.borderColor          = [UIColor redColor].CGColor;
    _videoArea.layer.borderWidth          = 0.5f;
    _videoArea.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_videoArea];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapGR.numberOfTapsRequired = 2;
    [_videoArea addGestureRecognizer:tapGR];
    
    top = _videoArea.bottom + 5;
    
    _cameraArea = [[UIView alloc] initWithFrame:CGRectMake(5, top, Width/2 - 10, (Width/2 - 10)*3/4)];
//    _cameraArea.layer.cornerRadius         = 3.f;
    _cameraArea.layer.borderColor          = UICOLOR16(0x009BD8).CGColor;
    _cameraArea.layer.borderWidth          = 0.5f;
    _cameraArea.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_cameraArea];
    
    _docArea = [[UIView alloc] initWithFrame:CGRectMake((Width/2 - 10) + 10, top, Width/2 - 10, (Width/2 - 10)*3.0/4)];
    //    _cameraArea.layer.cornerRadius         = 3.f;
    _docArea.layer.borderColor          = UICOLOR16(0x009BD8).CGColor;
    _docArea.layer.borderWidth          = 0.5f;
    _docArea.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_docArea];
    _docView = [[GSDocView alloc]initWithFrame:_docArea.bounds];
//    [_docView setBackgroundColor:0.5 green:0.5 blue:0];
    _docView.translatesAutoresizingMaskIntoConstraints = NO;
    self.docView.showMode = GSDocViewShowModeWidthFit;
    [_docArea addSubview:_docView];
    
    [_docArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_docView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_docView)]];
    [_docArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_docView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_docView)]];
    self.docView.delegate = self;
    
    top = top + _docArea.height + 5;
    // 注意下列代码的顺序
    NSLog(@"self.docView=%@",self.docView);  //打印一下
    self.manager.documentView = self.docView;
    self.manager.documentDelegate = self;
    
    _videoView = [[GSVideoView alloc] initWithFrame:_videoArea.bounds renderMode:GSVideoRenderOpenGL];
    _videoView.videoViewContentMode = GSVideoViewContentModeRatioFit;
    _videoView.translatesAutoresizingMaskIntoConstraints = NO;
    [_videoArea addSubview:_videoView];
    
    
    //to fix autolayout case if you need
    [_videoArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)]];
    [_videoArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)]];
    
    
//    _videoView.isWriteToYuv = YES;
    {
        //按钮事件 - 观看
        _display   = [[UIButton alloc] initWithFrame:CGRectMake(10.f, Height - 50.f + 5,(Width - 40.f)/3, 40.f)];
        [_display setTitle:@"订阅视频(开)" forState:UIControlStateNormal];
        _display.layer.cornerRadius         = 3.f;
        _display.layer.borderColor          = UICOLOR16(0x009BD8).CGColor;
        _display.layer.borderWidth          = 0.5f;
        _display.layer.masksToBounds        = YES;
        _display.backgroundColor = UICOLOR16(0x009BD8);
        [_display addTarget:self action:@selector(display:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_display];
        
        _speaker   = [[UIButton alloc] initWithFrame:CGRectMake(_display.right + 10, Height - 50.f + 5, (Width - 40.f)/3, 40.f)];
        [_speaker setTitle:@"扬声器(开)" forState:UIControlStateNormal];
        _speaker.layer.cornerRadius         = 3.f;
        _speaker.layer.borderColor          = UICOLOR16(0x009BD8).CGColor;
        _speaker.layer.borderWidth          = 0.5f;
        _speaker.layer.masksToBounds        = YES;
        _speaker.backgroundColor = UICOLOR16(0x009BD8);
        [_speaker addTarget:self action:@selector(speaker:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_speaker];
        
        _screenShot   = [[UIButton alloc] initWithFrame:CGRectMake(_speaker.right + 10, Height - 50.f + 5, (Width - 40.f)/3, 40.f)];
        [_screenShot setTitle:@"开始直播" forState:UIControlStateNormal];
        _screenShot.layer.cornerRadius         = 3.f;
        _screenShot.layer.borderColor          = UICOLOR16(0x009BD8).CGColor;
        _screenShot.layer.borderWidth          = 0.5f;
        _screenShot.layer.masksToBounds        = YES;
        _screenShot.backgroundColor = UICOLOR16(0x009BD8);
        [_screenShot addTarget:self action:@selector(startLive:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_screenShot];
        
        __weak typeof(self) wself = self;
        /// be more attention to cycle retain, add subview will retain
        GSTagsContentView *tagContent = [[GSTagsContentView alloc] initWithFrame:CGRectMake(5, top, Width - 10, 30) tags:@[@"推出Navigation视图",@"切换先后摄像头",@"截图",@"打开/关闭[自己的视频](数据发出)",@"置为/取消[直播视频]",@"打开/关闭[自己的视频](仅本地预览)",@"开/关[美颜功能]",@"开/关[麦克风]",@"切换IDC",@"开启录制",@"切换 [听筒(蓝牙)/扬声器]"] handler:^(NSInteger index, NSString *text, BOOL isSelect) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshadow"
            @try{} @finally{} __typeof__(self) self = wself;
#pragma clang disgnostic pop
            switch (index) {
                case 0: {
                    UIViewController *test = [[UIViewController alloc] init];
                    [wself.navigationController pushViewController:test animated:YES];
                }
                    break;
                case 1: {
                    [self.manager rotateCamera];
                }
                    break;
                case 2: {
                    [wself screenShotAction:nil];
                }
                    break;
                case 3: {
                    if (self->_state.isOrganizer) {
                        if (self->_state.isCameraStartcapture) {
                            [self.manager inactivateCamera];
                        }else{
                            [self.manager activateCamera:NO landscape:NO];
                        }

                    }else{
                        [MBProgressHUD showHint:@"必须是组织者才能打开"];
                    }

                }
                    break;
                case 4: {
                    if (self->_state.isCameraStartcapture) {
                        if (self->_state.isOrganizer) {
                            if (self->activeUserId == wself.userInfo.userID) {

                                if (wself.param.serviceType == GSBroadcastServiceTypeTraining) {
                                    [self.manager setBroadcastInfo:@"user.rostrum" value:0];
                                    [self.manager inactivateMicrophone];
                                }else {
                                    [self.manager setVideo:self->_userInfo.userID active:NO];
                                }
                            }else{

                                if (self.param.serviceType == GSBroadcastServiceTypeTraining) {
                                    [self.manager setBroadcastInfo:@"user.rostrum" value:self->_userInfo.userID];
                                    [self.manager activateMicrophone];
                                }else {
                                    [self.manager setVideo:self->_userInfo.userID active:YES];
                                }
                            }
                        }else{
                            [MBProgressHUD showHint:@"必须是组织者才有权限"];
                        }
                    }else{
                        [MBProgressHUD showHint:@"需要打开自己的摄像头(数据发出模式)"];
                    }
                }
                    break;
                case 5: {
                    if (self->_state.isCameraOpen) {
                        if (self->_state.isCameraStartcapture) {
                            [MBProgressHUD showHint:@"(数据发出模式)下无法仅关闭摄像头"];
                            return ;
                        }
                        [self.manager closeCamera];
                    }else{
                        [self.manager openCamera:NO orientation:UIInterfaceOrientationPortrait];
                    }
                }
                    break;
                case 6: {
                    if (self->_state.isBeauty) {
                        [self.manager setBeautifyFace:NO];
                        self->_state.isBeauty = 0;
                    }else{
                        [self.manager setBeautifyFace:YES];
                        self->_state.isBeauty = 1;
                    }
                }
                    break;
                case 7: {
                    if (!self->_state.isMicphoneOpen) {
                        [self.manager activateMicrophone];
                        self->_state.isMicphoneOpen = 1;
                        [MBProgressHUD showHint:@"麦克风打开"];
                    }else{
                        [self.manager inactivateMicrophone];
                        self->_state.isMicphoneOpen = 0;
                        [MBProgressHUD showHint:@"麦克风关闭"];
                    }
                }
                    break;
                case 8: {
                    NSArray *idcs = [self.manager getIDCArray];
                    if (idcs.count == 0) {
                        [MBProgressHUD showHint:@"无可选的IDC"];
                        return;
                    }
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择IDC" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    for (int i = 0; i < idcs.count; i ++) {
                        GSIDCInfo *info = [idcs objectAtIndex:i];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:info.Name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self.manager setCurrentIDC:info.ID];
                        }];
                        [alertVC addAction:action];
                    }
                    [wself.navigationController presentViewController:alertVC animated:YES completion:nil];
                }
                    break;
                case 9: {
                    [self.manager setStatus:GSBroadcastStatusRunning];
                    [self.manager setRecordingStatus:GSBroadcastStatusRunning];
                    [MBProgressHUD showHint:@"开启录制并开启直播"];
                }
                    break;
                case 10: {
                    self->_state.isReceiverOrSpeaker = !self->_state.isReceiverOrSpeaker;
                    if (self->_state.isReceiverOrSpeaker) {
                        [MBProgressHUD showHint:@"切换为扬声器播放"];
                    }else {
                        [MBProgressHUD showHint:@"切换为听筒播放"];
                    }
                    self.manager.defaultAudioOutport = self->_state.isReceiverOrSpeaker;
                }
                    break;
                default:
                    break;
            }
        }];
        [_scrollView addSubview:tagContent];
        self.scrollView.contentSize = CGSizeMake(Width, tagContent.bottom + 5);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationAction) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    _layoutShow = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, 40, 20)];
    _layoutShow.layer.cornerRadius = 5;
    _layoutShow.clipsToBounds = YES;
    _layoutShow.textAlignment = NSTextAlignmentCenter;
    _layoutShow.userInteractionEnabled = NO;
    _layoutShow.backgroundColor = [UIColor whiteColor];
    _layoutShow.text = @"布局显示";
    _layoutShow.font = [UIFont systemFontOfSize:14.f];
    _layoutShow.textColor = [UIColor blackColor];
    [_layoutShow sizeToFit];
    _layoutShow.width += 5;
    _layoutShow.height += 5;
    [self.view addSubview:_layoutShow];
}


- (void)display:(UIButton *)sender {
    long long userId  = 0;
    if (_state.isLod) {
        userId = LOD_USER_ID;
    }else {
        userId = activeUserId;
    }
    
    if (_state.isDisplay) {
        [_display setTitle:@"订阅视频(开)" forState:UIControlStateNormal];
        _state.isDisplay = 0;
        [self.manager displayVideo:userId];
    }else{
        [_display setTitle:@"订阅视频(关)" forState:UIControlStateNormal];
        _state.isDisplay = 1;
        [self.manager undisplayVideo:userId];
    }
}

- (void)speaker:(UIButton *)sender {
    if (_state.isSpeaker) {
        BOOL r = [self.manager activateSpeaker];
        if (r) {
            _state.isSpeaker = 0;
            [_speaker setTitle:@"扬声器(开)" forState:UIControlStateNormal];
        }
    }else{
        BOOL r = [self.manager inactivateSpeaker];
        if (r) {
            [_speaker setTitle:@"扬声器(关)" forState:UIControlStateNormal];
            _state.isSpeaker = 1;
        }
    }
    
}

- (void)startLive:(UIButton*)button {
    if (!_state.isStartLive) {
        BOOL success = [self.manager setStatus:GSBroadcastStatusRunning];
        if (success) {
            [_screenShot setTitle:@"暂停直播" forState:UIControlStateNormal];
            _state.isStartLive = 1;
            [MBProgressHUD showHint:@"直播已开始"];
        }
        
    }else{
        BOOL success = [self.manager setStatus:GSBroadcastStatusPause];
        if (success) {
            [_screenShot setTitle:@"开始直播" forState:UIControlStateNormal];
            _state.isStartLive = 0;
            [MBProgressHUD showHint:@"直播已暂停"];
        }
    }
    
}

- (void)screenShotAction:(UIButton *)sender {
#if 1
    //软解情况下有效 
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(Width, Height), NO, 0.0);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, Width, Height) afterScreenUpdates:YES];
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (!_screenShotView) {
        _screenShotView = [[UIImageView alloc] init];
        _screenShotView.frame = CGRectMake(0, 0, Width - 50, Height - 100);
        _screenShotView.center = self.view.center;
    }
    _screenShotView.alpha = 1.f;
    _screenShotView.image = screenShotImage;
    [self.view addSubview:_screenShotView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5f animations:^{
            _screenShotView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [_screenShotView removeFromSuperview];
        }];
    });
    
#endif
}


- (void)rotationAction {
    UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    if (statusOrient == UIInterfaceOrientationLandscapeRight){
        _scrollView.frame = CGRectMake(0, 0, Width, Height);
        _state.isFullScreen = 1;
        [self.manager setCameraLandScape:YES];
        
        _display.hidden = YES;
        _speaker.hidden = YES;
        
        self.navigationController.navigationBar.hidden = YES;
        CGRect full = CGRectMake(0, 0, Width, Height);
        CGRect lsmall = CGRectMake(5, 5, Width/3 - 10, (Width/3 - 10)*3.0/4);
        CGRect rsmall = CGRectMake(Width - (Width/3 - 10) - 5, 5, Width/3 - 10, (Width/3 - 10)*3.0/4);
        if (_state.isVideoFullScreen) {
            _videoArea.frame = full;
            _cameraArea.frame = lsmall;
            _docArea.frame = rsmall;
//            [_videoArea removeFromSuperview];
//            [[UIApplication sharedApplication].delegate.window addSubview:_videoArea];
            [self.scrollView bringSubviewToFront:_docArea];
            [self.scrollView bringSubviewToFront:_cameraArea];
        }else if (_state.isDocFullScreen){
            _docArea.frame = full;
            _cameraArea.frame = lsmall;
            _videoArea.frame = rsmall;
            [self.scrollView bringSubviewToFront:_videoArea];
            [self.scrollView bringSubviewToFront:_cameraArea];
        }
        
        if (_state.isCameraShow) {
            _previewView.frame = _videoArea.bounds;
        }else{
            _previewView.frame = _cameraArea.bounds;
        }
        _layoutShow.x = 10;
        _layoutShow.y = 30;
        
    }else if (statusOrient == UIInterfaceOrientationPortrait){
        _scrollView.frame = CGRectMake(0, 0, Width, Height - 40);
        _state.isFullScreen = 0;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.manager setCameraLandScape:NO];
        self.navigationController.navigationBar.hidden = NO;
        CGFloat top = 64 + 5 + UIView.additionaliPhoneXTopSafeHeight;
        _videoArea.frame = CGRectMake(5, top, Width - 10, (Width - 10)*3.0/4);
//        _videoView.frame = _videoArea.bounds;
//        _ASView.frame = _videoArea.bounds;
        top = _videoArea.bottom + 5;
        _cameraArea.frame = CGRectMake(5, top, Width/2 - 10, (Width/2 - 10)*3.0/4);
        if (_state.isCameraShow) {
            _previewView.frame = _videoArea.bounds;
        }else{
            _previewView.frame = _cameraArea.bounds;
        }
        _display.frame = CGRectMake(10.f, Height - 50.f + 5,(Width - 40.f)/3, 40.f);
        _speaker.frame = CGRectMake(_display.right + 10, Height - 50.f + 5, (Width - 40.f)/3, 40.f);
        _screenShot.frame = CGRectMake(_speaker.right + 10, Height - 50.f + 5, (Width - 40.f)/3, 40.f);
        _display.hidden = NO;
        _speaker.hidden = NO;
        _docArea.frame = CGRectMake((Width/2 - 10) + 10, _videoArea.bottom + 5, Width/2 - 10, (Width/2 - 10)*3.0/4);
        _layoutShow.x = 10;
        _layoutShow.y = 74;
    }
    [self.view bringSubviewToFront:_layoutShow];
}

- (void)tapAction:(UIGestureRecognizer *)sender {
    if (_state.isFullScreen) {
        _state.isVideoFullScreen = 0;
        [self updateScreenOriention:UIDeviceOrientationPortrait];
    }else{
        _state.isVideoFullScreen = 1;
        [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
    }
}

- (void)updateScreenOriention:(UIDeviceOrientation)oriention{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = oriention;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//小班课上
- (void)broadcastManager:(GSBroadcastManager *)manager didReceiveBroadcastInfoKey:(NSString *)key value:(long long)value {
    if ([key containsString:@"user.asker"]) { //上提问席
        if (value == self.userInfo.userID) {
            self.askKey = key;
            [self.manager activateCamera:NO landscape:_state.isFullScreen?YES:NO];
            [self.manager activateMicrophone];
        }else if (value == 0 && [self.askKey isEqualToString:key]){
            self.askKey = nil;
            [self.manager inactivateCamera];
            [self.manager inactivateMicrophone];
        }
    }else if ([key isEqualToString:@"user.rostrum"]) { //上讲台
        if (value == self.userInfo.userID) {
            self.askKey = key;
            if (_state.isCameraStartcapture) {
                [self.manager setVideo:self.userInfo.userID active:YES];
            }else{
                [self.manager activateCamera:NO landscape:_state.isFullScreen?YES:NO];
                [self.manager activateMicrophone];
            }
            
        }else if (value == 0 ){
            if ([self.askKey isEqualToString:key]) {
                self.askKey = nil;
                [self.manager inactivateCamera];
                [self.manager inactivateMicrophone];
            }else{
                if (activeUserId > 0) {
                    [self.manager undisplayVideo:activeUserId];
                }
//                _isCameraVideoDisplaying = NO;
                activeUserId = 0;
            }
            
        }else { //别人上讲台
//            typeof(self) wself = self;
//            self.trainingBlock = ^{
//                typeof(self) sself = wself;
//                // 桌面共享和插播的优先级比摄像头视频大
//                if (!sself->_state.isAS && !sself->_state.isLod) {//直播
//                    // 订阅当前激活的视频
//                    if (sself->_state.isCameraShow) {
//                        sself->_state.isCameraShow = 0;
//                        sself.previewView.frame = sself.cameraArea.bounds;
//                        [sself.cameraArea addSubview:sself.previewView];
//                    }
//                    [sself.manager displayVideo:value];
//                    sself.videoView.frame = sself.videoArea.bounds;
//                }
//                sself->activeUserId = value;
//            };
            
        }
    }
}


// 收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    // 判断是否是插播，插播优先级比摄像头视频大
    if (userInfo.userID == LOD_USER_ID) {
        _state.isLod = 1;
        [self.manager undisplayVideo:activeUserId];
        recordUserId = activeUserId;
        activeUserId = 0;
        [self.manager displayVideo:LOD_USER_ID];
    }
}

// 某个用户退出视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserQuitVideo:(long long)userID
{
    // 判断是否是插播结束
    if (userID == LOD_USER_ID) {
        _state.isLod = 0;
        [self.manager undisplayVideo:LOD_USER_ID];
        if (recordUserId) {
            [self.manager displayVideo:recordUserId];
        }
    }
}

// 某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
//    if (activeUserId == userInfo.userID && active) {
//        NSLog(@"didSetVideo会重复回调2次，这里过滤掉第二次");
//        return;
//    }
    if (active) {
        // 桌面共享和插播的优先级比摄像头视频大
        if (!_state.isAS && !_state.isLod) {//直播
            // 订阅当前激活的视频
            if (userInfo.userID == self.userInfo.userID) {
                _state.isCameraShow = 1;
                self.previewView.frame = self.videoArea.bounds;
                [self.videoArea addSubview:self.previewView];
            }else {
                if (_state.isCameraShow) {
                    _state.isCameraShow = 0;
                    self.previewView.frame = self.cameraArea.bounds;
                    [self.cameraArea addSubview:self.previewView];
                }
                [self.manager displayVideo:userInfo.userID];
            }
        }
        activeUserId = userInfo.userID;
    } else {
        if (_state.isCameraShow) {
            _state.isCameraShow = 0;
            self.previewView.frame = self.cameraArea.bounds;
            [self.cameraArea addSubview:self.previewView];
        }
        
        if (activeUserId == userInfo.userID) {
            activeUserId = 0;
//            [self.videoView flush];
        }
        [self.manager undisplayVideo:userInfo.userID];
    }
}

- (void)broadcastManager:(GSBroadcastManager *)manager didDisplayVideo:(GSUserInfo *)userInfo {
    if (!_state.isAS) {
        if (!_videoView.superview) {
            [self.videoArea addSubview:self.videoView];
        }
    }
}

- (void)broadcastManager:(GSBroadcastManager *)manager didUndisplayVideo:(long long)userID {
    if (userID == activeUserId && activeUserId != 0) {
        if (!_state.isLod && !_state.isAS) {
            [self.videoView flush];
//            [_videoView.videoLayer removeFromSuperlayer];
        }
    }
 
}

// 摄像头或插播视频每一帧的数据代理，软解
- (void)broadcastManager:(GSBroadcastManager*)manager userID:(long long)userID renderVideoFrame:(GSVideoFrame*)videoFrame
{
    if (_state.isLod && userID == LOD_USER_ID) {
        
    }else if (userID == activeUserId) {
        
    }else{
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 指定Videoview渲染每一帧数据
        [_videoView renderVideoFrame:videoFrame];
    });
    
}


// 硬解数据从这个代理返回
- (void)OnVideoData4Render:(long long)userId width:(int)nWidth nHeight:(int)nHeight frameFormat:(unsigned int)dwFrameFormat displayRatio:(float)fDisplayRatio data:(void *)pData len:(int)iLen
{
    if ( userId == LOD_USER_ID) {
        
    }else if (userId == activeUserId) {
        
    }else{
        return;
    }
    
    [_videoView hardwareAccelerateRender:pData size:iLen dwFrameFormat:dwFrameFormat];
    
}

/**
 *  手机摄像头开始采集数据
 *  @param manager 触发此代理的GSBroadcastManager对象
 */
- (void)broadcastManagerDidActivateCamera:(GSBroadcastManager*)manager
{
    if (!_previewView) {
        _previewView = [[GSVideoView alloc]initWithFrame:self.cameraArea.bounds];
    }
    [self.cameraArea addSubview:_previewView];
    self.manager.videoView = _previewView;
    
    _state.isCameraOpen = 1;
}

- (BOOL)broadcastManagerDidStartCaptureVideo:(GSBroadcastManager *)manager {
    _state.isCameraStartcapture = 1;
    
    if ([self.askKey isEqualToString:@"user.rostrum"]) {
        [self.manager setVideo:self.userInfo.userID active:YES];
    }
    return YES;
}

- (void)broadcastManagerDidStopCaptureVideo:(GSBroadcastManager *)manager {
    _state.isCameraStartcapture = 0;
}

/**
 手机摄像头停止采集数据
 */
- (void)broadcastManagerDidInactivateCamera:(GSBroadcastManager*)manager {
    //    [_previewView removeFromSuperview];
    //    _previewView.filterView.hidden = YES;
    _state.isCameraOpen = 0;
}

/**
 索取直播设置信息代理
 */
- (BOOL) broadcastManager:(GSBroadcastManager *)manager querySettingsInfoKey:(NSString *)key numberValue:(int *)value
{
    return YES;
}


- (BOOL)broadcastManager:(GSBroadcastManager*)manager saveSettingsInfoKey:(NSString*)key strValue:(NSString*)value {
    if ([key isEqualToString:@"video.logo.data.png"]) {
        
        if (value.length>0) {
            
            NSData* pngData=[self hexToBytes:value];
            UIImage *waterImage = [UIImage imageWithData: pngData];
            NSLog(@"%f--%f",waterImage.size.width,waterImage.size.height);

            UIImageView *waterUIImage =[[UIImageView alloc] initWithImage:waterImage];
            waterUIImage.contentMode = UIViewContentModeScaleAspectFit;
            waterUIImage.frame = CGRectMake(self.manager.videoConfiguration.videoSize.width - 100,10 , 90, 60);
            [self.manager setWatermarkImage:waterUIImage];
        }else{
            
        }
    }
    return  YES;
}

- (void)broadcastManager:(GSBroadcastManager*)manager didSetStatus:(GSBroadcastStatus)status {
    
    if (status == GSBroadcastStatusRunning) {
        _state.isStartLive = 1;
        [_screenShot setTitle:@"暂停直播" forState:UIControlStateNormal];
    }else{
        _state.isStartLive = 0;
        [_screenShot setTitle:@"开始直播" forState:UIControlStateNormal];
    }
    
}

- (NSData*) hexToBytes:(NSString*)pngStr {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= pngStr.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [pngStr substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}



#pragma mark - AS

// 开启桌面共享代理
- (void)broadcastManager:(GSBroadcastManager*)manager didActivateDesktopShare:(long long)userID
{
    _state.isAS = 1;
    if (!_videoView.superview) {
        [self.videoArea addSubview:_videoView];
    }
    // 桌面共享时，需要主动取消订阅当前直播的摄像头视频
    if (activeUserId != 0) {
        [self.manager undisplayVideo:activeUserId];
    }
}
#if 1
//新版
- (void)broadcastManager:(GSBroadcastManager *)manager receiveSoftBuffer:(GSGLBuffer *)buffer {
    // 指定Videoview渲染每一帧数据
    if (_state.isAS) {
        [_videoView renderAsVideoByBuffer:buffer];
    }
}
#else
// 桌面共享视频每一帧的数据代理, 软解数据
- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(UIImage*)videoFrame {
    // 指定Videoview渲染每一帧数据
    if (_state.isAS) {
        [_videoView renderAsVideoByImage:videoFrame];
    }
}
#endif

- (void)OnAsData:(unsigned char*)data dataLen: (unsigned int)dataLen width:(unsigned int)width height:(unsigned int)height {
    
    if (_state.isAS) {
        [_videoView hardwareAccelerateRender:data size:dataLen dwFrameFormat:0];
    }
}

// 桌面共享关闭代理
- (void)broadcastManagerDidInactivateDesktopShare:(GSBroadcastManager*)manager
{
    // 如果桌面共享前，有摄像头视频在直播，需要在结束桌面共享后恢复
    if (activeUserId != 0) {
        [self.manager displayVideo:activeUserId];
    }
    _state.isAS = 0;
    [_videoView flush];
}

#pragma mark - layout changed

- (void)broadcastManager:(GSBroadcastManager *)manager webLayoutChanged:(NSInteger)value {
    if (value == 2) {
        _state.isDocFullScreen = 1;
        _state.isVideoFullScreen = 0;
        UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
        if (statusOrient == UIInterfaceOrientationLandscapeRight) {
            [self rotationAction];
        }else {
            [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
        }
    }else if (value == 1) {
        _state.isVideoFullScreen = 1;
        _state.isDocFullScreen = 0;
        UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
        
        if (statusOrient == UIInterfaceOrientationLandscapeRight) {
            [self rotationAction];
        }else {
            [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
        }
        
        
    }else if (value == 3) {
        _state.isVideoFullScreen = 0;
        _state.isDocFullScreen = 0;
        [self updateScreenOriention:UIDeviceOrientationPortrait];
        
    }
    NSString *hint;
    switch (value) {
        case 0:
            hint = @"文档为主(0)[暂未适配]";
            break;
        case 1:
            hint = @"视频最大化(1)";
            break;
        case 2:
            hint = @"文档最大化(2)";
            break;
        case 3:
            hint = @"视频为主(3)";
            break;
        default:
            break;
    }
    
    [_layoutShow setText:hint];
    [_layoutShow sizeToFit];
    _layoutShow.width += 5;
    _layoutShow.height += 5;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if DEBUG
    NSLog(@"GSSingleVideoViewController dealloc %p",self);
#endif
}

@end
