//
//  GSRtParamViewController.m
//  RtSDKDemo
//
//  Created by Sheng on 2018/8/16.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSRtParamViewController.h"
#import "GSTextFieldTitleView.h"
#import "IQKeyboardManager.h"
#import <RtSDK/RtSDK.h>

#import <GSCommonKit/GSCommonKit.h>


#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]



@interface GSRtParamViewController ()

@end

@implementation GSRtParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary*infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString*app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString*app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    //UI
    self.title = [NSString stringWithFormat:@"RtSDK(%@,%@)",app_Version,app_build];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _fieldViewsDic = [[NSMutableDictionary alloc]init];
    self.scrollView                     = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + UIView.additionaliPhoneXTopSafeHeight, Width, Height - 64 - 50 - UIView.additionaliPhoneXTopSafeHeight - UIView.additionaliPhoneXBottomSafeHeight)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    CGFloat top = 10.f;
    int index = 0;
    
    UILabel *label = [self createTagLabel:@"直播参数设置" top:top];
    [self.scrollView addSubview:label];
    top = label.bottom + 5;
    
    UIView *whiteBGView  = [self createWhiteBGViewWithTop:top itemCount:8];
    top = whiteBGView.bottom + 10;
    [self.scrollView addSubview:whiteBGView];
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"域名";
        fieldView.placeHolder               = @"请输入域名";
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_DOMAIN];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"房间号";
        fieldView.placeHolder               = @"请输入房间号";
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_ROOMID];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"昵称";
        fieldView.placeHolder               = @"请输入昵称";
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_NICKNAME];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"房间密码";
        fieldView.placeHolder               = @"请输入房间密码(可选)";
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
//        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_PWD];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"登录用户名";
        fieldView.placeHolder               = @"请输入登录用户名(可选)";
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_LOGIN_NAME];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"登录密码";
        fieldView.placeHolder               = @"请输入登录密码(可选)";
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_LOGIN_PWD];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"第三方验证码";
        fieldView.placeHolder               = @"请输入验证码(可选)";
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_THIRD_KEY];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"自定义用户ID";
        fieldView.placeHolder               = @"请输入ID(可选,且应大于十亿)";
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_USERID];
        index ++;
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"站点类型" top:top];
        [self.scrollView addSubview:label];
        UILabel *label1 = [self createTagLabel:@"网络请求类型" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label1];
        top = label.bottom + 5;
        //Webcast/Trainig
        _serviceType = [[UISegmentedControl alloc] initWithItems:@[@"Webcast",@"Training"]];
        _serviceType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _serviceType.tag = 0;
        _serviceType.selectedSegmentIndex = 0;
        [self.scrollView addSubview:_serviceType];
        //Theme
        _httpType = [[UISegmentedControl alloc] initWithItems:@[@"HTTP",@"HTTPS"]];
        _httpType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _httpType.selectedSegmentIndex = 0;
        _httpType.tag = 1;
        [self.scrollView addSubview:_httpType];
        
        top = _httpType.bottom + 10;
        
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"box用户" top:top];
        [self.scrollView addSubview:label];
        
        UILabel *label1 = [self createTagLabel:@"允许角色类型" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label1];
        top = label.bottom + 5;
        //Webcast/Trainig
        _boxType = [[UISegmentedControl alloc] initWithItems:@[@"否",@"是"]];
        _boxType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _boxType.tag = 0;
        _boxType.selectedSegmentIndex = 0;
        [self.scrollView addSubview:_boxType];
        //Theme
        _allowRoleType = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"组织者",@"观看者"]];
        _allowRoleType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _allowRoleType.selectedSegmentIndex = 0;
        _allowRoleType.tag = 1;
        [self.scrollView addSubview:_allowRoleType];
        
        top = _allowRoleType.bottom + 10;
        
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"软解/硬解" top:top];
        [self.scrollView addSubview:label];
        
        UILabel *label1 = [self createTagLabel:@"桌面共享 软解/硬解" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label1];
        top = label.bottom + 5;
        //Webcast/Trainig
        _decodeType = [[UISegmentedControl alloc] initWithItems:@[@"硬解",@"软解"]];
        _decodeType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _decodeType.tag = 0;
        _decodeType.selectedSegmentIndex = 1;
        
        [self.scrollView addSubview:_decodeType];
        //Theme
        _ASDecodeType = [[UISegmentedControl alloc] initWithItems:@[@"软解",@"硬解"]];
        _ASDecodeType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _ASDecodeType.selectedSegmentIndex = 1;
        _ASDecodeType.tag = 1;
        [self.scrollView addSubview:_ASDecodeType];
        
        top = _ASDecodeType.bottom + 10;
        
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"硬编/软编" top:top];
        [self.scrollView addSubview:label];

        top = label.bottom + 5;
        //Webcast/Trainig
        _encodeType = [[UISegmentedControl alloc] initWithItems:@[@"硬编",@"软编"]];
        _encodeType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _encodeType.tag = 2;
        _encodeType.selectedSegmentIndex = 0;
        [self.scrollView addSubview:_encodeType];
 
        top = _encodeType.bottom + 10;
        
    }
    
    //video config dpis
    {
        UILabel *label = [self createTagLabel:@"摄像头期望输出分辨率(默认640x480)" top:top];
        [self.scrollView addSubview:label];
        top = label.bottom + 5;
        
        UILabel *w = [self createTagLabel:@"宽 :" top:top + 5];
        [self.scrollView addSubview:w];
        
        _wField = [[UITextField alloc] initWithFrame:CGRectMake(w.right + 5, top, 60, 25)];
        _wField.keyboardType = UIKeyboardTypeNumberPad;
        _wField.textAlignment = NSTextAlignmentCenter;
        _wField.font          = [UIFont systemFontOfSize:14.f];
        _wField.layer.borderColor = [UIColor grayColor].CGColor;
//        _wField.layer.cornerRadius = 3.f;
        _wField.layer.borderWidth = 0.5f;
        [self.scrollView addSubview:_wField];
        
        UILabel *h = [self createTagLabel:@"高 :" top:top + 5 left:_wField.right + 10];
        [self.scrollView addSubview:h];
        
        _hField = [[UITextField alloc] initWithFrame:CGRectMake(h.right + 5, top, 60, 25)];
        _hField.keyboardType = UIKeyboardTypeNumberPad;
        _hField.textAlignment = NSTextAlignmentCenter;
        _hField.font          = [UIFont systemFontOfSize:14.f];
        _hField.layer.borderColor = [UIColor grayColor].CGColor;
//        _hField.layer.cornerRadius = 3.f;
        _hField.layer.borderWidth = 0.5f;
        [self.scrollView addSubview:_hField];
        
        top = _hField.bottom + 5;
        
        UILabel *quick = [self createTagLabel:@"快速选择分辨率" top:top];
        [self.scrollView addSubview:quick];
        top = quick.bottom + 5;
        NSArray *array = [NSArray arrayWithObjects:[NSValue valueWithCGSize:CGSizeMake(352,288)],
                          [NSValue valueWithCGSize:CGSizeMake(640,480)],
                          [NSValue valueWithCGSize:CGSizeMake(960,540)],
                          [NSValue valueWithCGSize:CGSizeMake(1280,720)],
                          [NSValue valueWithCGSize:CGSizeMake(1920,1080)],[NSValue valueWithCGSize:CGSizeMake(288,352)],
                          [NSValue valueWithCGSize:CGSizeMake(480,640)],
                          [NSValue valueWithCGSize:CGSizeMake(540,960)],
                          [NSValue valueWithCGSize:CGSizeMake(720,1280)],
                          [NSValue valueWithCGSize:CGSizeMake(1080,1920)],
                          nil];
        NSMutableArray *titles = [NSMutableArray array];
        for (int i = 0; i <array.count; i ++) {
            NSValue *value = array[i];
            [titles addObject:NSStringFromCGSize(value.CGSizeValue)];
        }
        _dpisTagView = [[GSTagsContentView alloc] initWithFrame:CGRectMake(15, top, Width - 30, 30)]
        .allowSelectSet(YES)
        .supportMultiSelectSet(NO)
        .tagTextsSet(titles);
        __weak typeof(self)wself = self;
        _dpisTagView.handler = ^(NSInteger index, NSString *text, BOOL isSelect) {
            NSValue *value = array[index];
            CGSize size = value.CGSizeValue;
            wself.wField.text = [NSString stringWithFormat:@"%.0f",size.width];
            wself.hField.text = [NSString stringWithFormat:@"%.0f",size.height];
        };
        _dpisTagView.selectIndex = 1;
        _dpisTagView.handler(1,@"",1);
        
        [self.scrollView addSubview:_dpisTagView];
        top = _dpisTagView.bottom + 10;
        
    }
    
    //video crop
    {
        UILabel *label = [self createTagLabel:@"摄像头输出比例(默认4x3)" top:top];
        [self.scrollView addSubview:label];
        top = label.bottom + 5;
        NSArray *array = @[@"4x3",@"16x9",@"9x16"];
        _cropTagView = [[GSTagsContentView alloc] initWithFrame:CGRectMake(15, top, Width - 30, 30)]
        .allowSelectSet(YES)
        .supportMultiSelectSet(NO)
        .tagTextsSet(array);
        
        _cropTagView.handler = ^(NSInteger index, NSString *text, BOOL isSelect) {
            [GSBroadcastManager sharedBroadcastManager].videoConfiguration.cropMode = (GSCropMode)index;
        };
        _cropTagView.selectIndex = 0;
        [self.scrollView addSubview:_cropTagView];
        top = _cropTagView.bottom + 10;
    }
    
    //NSUserDefault
    [self loadCache];
    
    self.scrollView.contentSize = CGSizeMake(Width, top);
    
    {
        
#if ContainVod
        UIButton *watch   = [[UIButton alloc] initWithFrame:CGRectMake(15.f, self.scrollView.y + self.scrollView.height + 5, (Width - 60.f)/2, 40.f)];
        //按钮事件 - 观看
        
#else
        UIButton *watch   = [[UIButton alloc] initWithFrame:CGRectMake(15.f, self.scrollView.y + self.scrollView.height + 5, Width - 30.f, 40.f)];
#endif
        [watch setTitle:@"下一步" forState:UIControlStateNormal];
        watch.layer.cornerRadius         = 3.f;
        watch.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        watch.layer.borderWidth          = 0.5f;
        watch.layer.masksToBounds        = YES;
        watch.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        [watch addTarget:self action:@selector(watch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:watch];
#if ContainVod
        //按钮事件 - 观看
        UIButton *vodAction   = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 + 15.f, self.scrollView.y + self.scrollView.height + 5, (Width - 60.f)/2, 40.f)];
        [vodAction setTitle:@"点播" forState:UIControlStateNormal];
        vodAction.layer.cornerRadius         = 3.f;
        vodAction.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
        vodAction.layer.borderWidth          = 0.5f;
        vodAction.layer.masksToBounds        = YES;
        vodAction.backgroundColor = FASTSDK_COLOR16(0x336699);
        [vodAction addTarget:self action:@selector(vodAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:vodAction];
#endif
    }
}

- (void)vodAction:(UIButton *)sender {
#if ContainVod
    GSVodParamController *vodVC = [[GSVodParamController alloc] init];
    [self.navigationController pushViewController:vodVC animated:YES];
#endif
}

- (void)watch:(UIButton*)sender {
    //由于界面代码太多，将进入会议时的参数配置放在了 GSEnterViewController
    sender.userInteractionEnabled = NO;
    //存储相关参数到NSUserDefault
    [self saveCache];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
//data
#pragma mark - data

- (void)saveCache {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.serviceType.selectedSegmentIndex] forKey:MO_SERVICE];
    [self _saveField:MO_DOMAIN];
    [self _saveField:MO_ROOMID];
    [self _saveField:MO_NICKNAME];
    [self _saveField:MO_PWD];
    [self _saveField:MO_LOGIN_NAME];
    [self _saveField:MO_LOGIN_PWD];
    [self _saveField:MO_THIRD_KEY];
    [self _saveField:MO_USERID];
    
}

- (void)_saveField:(NSString *)fieldMark {
    NSString *text = [self paramInField:fieldMark];
    if (text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:fieldMark];
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:fieldMark]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:fieldMark];
        }
    }
}

- (NSString *)paramInField:(NSString *)fieldMark {
    GSTextFieldTitleView *fieldView = [_fieldViewsDic objectForKey:fieldMark];
    return fieldView.field.text;
}

- (void)loadCache {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"213.gensee.com" forKey:MO_DOMAIN];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_DOMAIN];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_SERVICE]) {
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:MO_SERVICE];
    }else{
        self.serviceType.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:MO_SERVICE] intValue];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"38738043" forKey:MO_ROOMID];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_ROOMID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_NICKNAME]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"support" forKey:MO_NICKNAME];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_NICKNAME];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_NICKNAME];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_PWD]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:MO_PWD];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_PWD];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_PWD];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_NAME]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_LOGIN_NAME];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_NAME];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_PWD]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_LOGIN_PWD];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_PWD];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_THIRD_KEY]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_THIRD_KEY];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_THIRD_KEY];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_USERID]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_USERID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_USERID];
    }
    
}

- (void)dealloc {
    [_fieldViewsDic removeAllObjects];
    NSLog(@"GSRtParamViewController dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotate {
    return NO;
}
@end
