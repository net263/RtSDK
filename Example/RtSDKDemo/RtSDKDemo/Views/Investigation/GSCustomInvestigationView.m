//
//  GSCustomInvestigationView.m
//  FASTSDK
//
//  Created by Sheng on 2017/8/11.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSCustomInvestigationView.h"
#import "GSInvestigationHeaderView.h"
#import "GSInvestigationEssayCell.h"
#import "GSInvestigationMultiChoiceCell.h"
#import "GSInvestigationSingleChoiceCell.h"

#import "GSInvestigationTopView.h"
#import "GSInvestigationSubmitView.h"
#import "IQKeyboardManager.h"

#define MO_DISABLE_COLOR FASTSDK_COLORA(252, 209, 204, 1);
#define MO_ABLE_COLOR FASTSDK_COLORA(228, 62, 54, 1);

@interface GSCustomInvestigationView ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

#pragma mark - top

@property (nonatomic, strong) GSInvestigationTopView *topView;

#pragma mark - submit

@property (nonatomic, strong) GSInvestigationSubmitView *submitView;


@property (nonatomic, strong) NSMutableArray *submittedInvestigationArray;


@property (nonatomic, strong) NSMutableArray *showInvestigationArray;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

#pragma mark - force hint

@property (nonatomic, strong) UIView *hintView;

@end

@implementation GSCustomInvestigationView

static GSCustomInvestigationView *customView = nil;


+ (GSCustomInvestigationView*)showInvestigation:(GSInvestigation*)investigation{
    
    if (!customView) {
        customView = [[GSCustomInvestigationView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    }
    
    customView.investigation = investigation;
    
    [customView privateShow];
    
    return customView;
}

+ (GSCustomInvestigationView*)hideInvestigation:(GSInvestigation*)investigation {
    if (customView && [customView.investigation.ID isEqualToString:investigation.ID]) {
        [customView hide];
    }else if (customView.showInvestigationArray.count > 0) {
        [customView.showInvestigationArray enumerateObjectsUsingBlock:^(GSInvestigation*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj && [obj.ID isEqualToString:investigation.ID]) {
                [customView.showInvestigationArray removeObject:obj];
                *stop = YES;
            }
        }];
    }
    return customView;
}

+ (void)invalidate{
    
    if (customView.superview) {
        [customView removeFromSuperview];
    }
    
    customView = nil;
    
}

#pragma mark - 懒加载

- (NSMutableArray *)showInvestigationArray
{
    if (!_showInvestigationArray) {
        _showInvestigationArray = [NSMutableArray array];
    }
    return _showInvestigationArray;
}

- (NSMutableArray *)submittedInvestigationArray{
    if (!_submittedInvestigationArray) {
        _submittedInvestigationArray = [NSMutableArray array];
    }
    return _submittedInvestigationArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
#pragma mark tableview
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 48, frame.size.width, frame.size.height - 48) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 1.f;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_tableView];
        
#pragma mark - top
        
        _topView = [[GSInvestigationTopView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
        [_topView.exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topView];
        
#pragma mark -  submit
        
        _submitView = [[GSInvestigationSubmitView alloc]initWithFrame:CGRectMake(0, frame.size.height - 48, frame.size.width, 48)];
        [_submitView.submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitView];
        
#pragma mark - hint
        
        _hintView = [[UIView alloc]init];
        _hintView.clipsToBounds = YES;
        _hintView.backgroundColor=[UIColor colorWithRed:252/255.f green:209/255.f blue:204/255.f alpha:1];
        UILabel* forceLabel=[[UILabel alloc] init];
        forceLabel.frame=CGRectMake(20, 0, 300, 20);
        [_hintView addSubview:forceLabel];
        forceLabel.textAlignment=NSTextAlignmentLeft;
        
        forceLabel.text = @"此问卷不能跳过,请努力完成吧";

        forceLabel.font=[UIFont systemFontOfSize:13];
        forceLabel.textColor=[UIColor colorWithRed:217/255.f green:98/255.f blue:11/255.f alpha:1];

        [self addSubview:_hintView];
        
#pragma mark - noti
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHander:)];
        _tapGesture.numberOfTapsRequired = 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusFrameChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
    }
    return self;
}

- (void)statusFrameChanged:(NSNotification*)noti{
    self.frame = CGRectMake(0, 0, Width, Height);
    
    [self setNeedsLayout];
    
    [self layoutIfNeeded];
}

- (void)tapHander:(UITapGestureRecognizer *)sender{
    [self endEditing:YES];
}

- (void)statusChanged:(NSNotification *)noti{
    
    UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
    
    if (statusOrient == UIInterfaceOrientationPortrait) {
        self.frame = CGRectMake(0, 0, Width, Height);
    }else if (statusOrient == UIInterfaceOrientationLandscapeRight){
        self.frame = CGRectMake(0, 0, Width, Height);
    }
    
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
    
    
}

- (void)setInvestigation:(GSInvestigation *)investigation
{
    //如果第一次  或者推出的是该问卷的答案
//    if ((investigation.isResultPublished && [investigation.ID isEqualToString:_investigation.ID]) || !_investigation) {
    if (!_investigation) {
    
        _investigation = investigation;
        
        _topView.themeLabel.text = _investigation.theme;
        
        _isSubmit = NO;
        
        [self updateSendButtonStatus];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];

        return;
    }else{
//        if (!self.isSubmit && _investigation ) {
//            [self.showInvestigationArray addObject:_investigation];
//            
//            GSLog(@"正在显示的问卷添加到队列中，显示新问卷");
//        }
        
        [self.showInvestigationArray addObject:investigation];
        
        NSLog(@"添加新问卷到队列中");
    }
    
    
    
    
}

- (void)exitAction:(UIButton *)sender{
    
    if (!_investigation.isForce || _isSubmit || _investigation.isResultPublished || _investigation.hasTerminated) {
        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        
        
        [self hide];
        
    }

}

- (void)removeCurrentInvestigation{
    if (self.showInvestigationArray.count > 0) {  //从显示数组中移除
        
        GSInvestigation *remove;
        
        for (GSInvestigation *tmp in self.showInvestigationArray) {
            if ([tmp.ID isEqualToString:_investigation.ID]) {
                
                if (tmp.isResultPublished == _investigation.isResultPublished) {
                    remove = tmp;
                }
                
            }
        }
        
        if (remove) {
            [self.showInvestigationArray removeObject:remove];
        }
        
    }
}

- (void)submitAction:(UIButton *)sender{
    
    if (_investigation.isResultPublished || _investigation.hasTerminated) {
        return;
    }

    if (_investigation.isForce) {
       
        
        for (int i = 0; i < _investigation.questions.count; i++) {
            
            BOOL isAns = NO;
            
            GSInvestigationQuestion *que = [_investigation.questions objectAtIndex:i];
            
            if (que.questionType == GSInvestigationQuestionTypeEssay) {
                if (que.essayAnswer.length == 0||([que.essayAnswer isEqualToString:@""])) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"您还未完成所有题目，请先完成" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
            }else{
                for (int j = 0; j < que.options.count; j++) {
                    GSInvestigationOption *option = [que.options objectAtIndex:j];
                    
                    if (option.isSelected) {
                        isAns = YES;
                    }
                    
                }
                
                if (!isAns) {
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    return;
                }
            }
            
        }
    }

    //已提交 需要在上述判断后
    _isSubmit = YES;
    
    self.topView.exitBtn.hidden = NO;
    
    //show result
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < _investigation.questions.count; i++) {
        GSInvestigationQuestion* que= [_investigation.questions objectAtIndex:i];
        if (que.questionType == GSInvestigationQuestionTypeEssay) {
            GSInvestigationMyAnswer*  myAns = [GSInvestigationMyAnswer new];
            myAns.questionID = que.ID;
            myAns.essayAnswer = que.essayAnswer;
            [result addObject:myAns];
        }else{
            for (int j = 0; j < que.options.count; j++) {
                GSInvestigationOption* opt=[que.options objectAtIndex:j];
                if (opt.isSelected) {
                    GSInvestigationMyAnswer*  myAns = [GSInvestigationMyAnswer new];
                    myAns.questionID = que.ID;
                    myAns.optionID = opt.ID;
                    [result addObject:myAns];
                    if(que.questionType==GSInvestigationQuestionTypeSingleChoice){
                        break;
                    }else{
                        continue;
                    }
                }
            }
        }
        
    }
    
    if ([[GSBroadcastManager sharedBroadcastManager] submitInvestigation:_investigation.ID answers:result]) {
        
        [self.submittedInvestigationArray addObject:_investigation.ID];
        
        [self removeCurrentInvestigation];
        
        [self updateSendButtonStatus];
        
        
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"提交失败，请重试！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        
    };
    
    
    BOOL isHaveAnser=NO;
    for (int i=0; i<_investigation.questions.count; i++) {
        GSInvestigationQuestion* que=  [_investigation.questions objectAtIndex:i];
        for (int j=0; j<que.options.count; j++) {
            
            GSInvestigationOption* ans=  [que.options objectAtIndex:j];
            if (ans.isCorrectItem==true) {
                isHaveAnser=YES;
                break;
            }
        }
    }
    if (isHaveAnser) {
        CGFloat score=0;
        CGFloat rigthIndex=0;
        
        CGFloat setAnswerCount=0;
        
        
        NSString* quesID;
        for (int i=0; i<_investigation.questions.count; i++) {
            
            GSInvestigationQuestion* que= [_investigation.questions objectAtIndex:i];
            quesID=que.ID;
            if(que.questionType==GSInvestigationQuestionTypeEssay)
            {
                GSInvestigationMyAnswer*  myAns = [GSInvestigationMyAnswer new];
                myAns.questionID=quesID;
                myAns.essayAnswer=que.essayAnswer;
             
            }else{
                
                if(que.questionType==GSInvestigationQuestionTypeSingleChoice){
                    
                    for (int j=0; j<que.options.count; j++) {
                        GSInvestigationOption* opt=[que.options objectAtIndex:j];
                        if (opt.isCorrectItem&&opt.isSelected) {
                            rigthIndex++;
                        }
                        if (opt.isCorrectItem) {//纪录一下设置了答案的题目数目
                            setAnswerCount++;
                        }
                    }
                }else{
                    
                    BOOL iserror=NO;
                    for (int j=0; j<que.options.count; j++) {
                        GSInvestigationOption* opt=[que.options objectAtIndex:j];
                        if (opt.isCorrectItem&&!opt.isSelected) {
                            iserror=YES;
                            break;
                        }
                    }
                    if (!iserror) {
                        rigthIndex++;
                    }
                    setAnswerCount++;
                    
                }
                
                
                
            }
            
            if (_investigation.questions.count>0) {
                
                CGFloat tmp=  _investigation.questions.count;
                if (setAnswerCount>0) {
                    score=(CGFloat)((rigthIndex/setAnswerCount)*100);
                }else{
                    score=(CGFloat)((rigthIndex/tmp)*100);
                }
                
                [self.submitView showScore:score];
            }

        }
        
        [self.tableView reloadData];
    }else{
        [[IQKeyboardManager sharedManager] setEnable:NO];
        
        [self hide];
    }

    
}

- (void)privateShow{

    if (self.superview) {

//        [self.tableView reloadData];
        
    }else{
        
        [self updateSendButtonStatus];
        
//        [[GSContainerViewManager sharedManager].containerView addSubview:self];
  
//        [[GSWindowManager sharedManager] showInWindow:self level:GSViewLevelInvestigation];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [[IQKeyboardManager sharedManager] setEnable:YES];
        
        self.isSubmit = NO;

        [self setNeedsLayout];
        
        [self layoutIfNeeded];
    }

}

- (void)show{
    
    [self updateSendButtonStatus];
    
    if (self.superview) {
        
        //        [self.tableView reloadData];
        
    }else{
        
        
        
//        [[GSContainerViewManager sharedManager].containerView addSubview:self];
//        [[GSWindowManager sharedManager] showInWindow:self level:GSViewLevelInvestigation];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[IQKeyboardManager sharedManager] setEnable:YES];
        
        self.isSubmit = NO;
        
        
    }
    [self setNeedsLayout];
    
    [self layoutIfNeeded];
}

- (void)hide{
    
    [self removeCurrentInvestigation];
    
    if (self.showInvestigationArray.count > 0) {
        
        GSInvestigation *result = self.showInvestigationArray[0];
  
        _investigation = result;
   
        _topView.themeLabel.text = _investigation.theme;
        
        _isSubmit = NO;
        
        [self show];
    }else{
   
        _investigation = nil; //防止存储
        
        [[IQKeyboardManager sharedManager] setEnable:NO];
        
        [self.showInvestigationArray removeAllObjects];
        
        [self removeFromSuperview];
//        [[GSWindowManager sharedManager] hideInWindow:self];
        
    }
    
    
    
}

- (void)layoutSubviews{
    
    
    UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
    
    CGFloat hintH = 0;
    
    if (_investigation.isForce && !_investigation.isResultPublished) {
        hintH = 20;
    }
    
    if (_investigation.isForce && !self.isSubmit) {
        if (_investigation.isResultPublished) {
            _topView.exitBtn.hidden = NO;
        }else{
           _topView.exitBtn.hidden = YES;
        }
    }else{
        _topView.exitBtn.hidden = NO;
    }
    
    if (statusOrient == UIInterfaceOrientationPortrait) {
        
        _topView.frame = CGRectMake(0, StatusBarHeight, Width, 48);

        _hintView.frame = CGRectMake(0, StatusBarHeight + 48, Width, hintH);
        
        if (_investigation.isResultPublished) {
            _tableView.frame = CGRectMake(0, StatusBarHeight + 48 + hintH, Width, Height - 48 - StatusBarHeight - hintH);
            _submitView.hidden = YES;
            
        }else{
            _tableView.frame = CGRectMake(0, StatusBarHeight + 48 + hintH, Width, Height - 48 - StatusBarHeight - 48 - hintH);
            _submitView.hidden = NO;
            _submitView.frame = CGRectMake(0, Height - 48, Width, 48);
        }
        
        
        
    }else if (statusOrient == UIInterfaceOrientationLandscapeRight){
        
        _topView.frame = CGRectMake(0, 0, Width, 48);
        
        _hintView.frame = CGRectMake(0, StatusBarHeight + 48, Width, hintH);
        
        if (_investigation.isResultPublished) {
            _tableView.frame = CGRectMake(0, 0 + 48 + hintH, Width, Height  - 48 - hintH);
            _submitView.hidden = YES;
        }else{
            _tableView.frame = CGRectMake(0, 0 + 48 + hintH, Width, Height - 48 - 48 - hintH);
            _submitView.hidden = NO;
            _submitView.frame = CGRectMake(0, Height - 48, Width, 48);
        }
        
        
    }
    
    [self.tableView reloadData];

    [super layoutSubviews];
}

- (void)updateSendButtonStatus
{
    if (self.investigation.isResultPublished)
    {
//        [self.submitView.submitBtn setHidden:YES];
//        [self.submitView.submitBtn setTitle:@"已提交" forState:UIControlStateNormal];
//        self.submitView.submitBtn.backgroundColor = MO_DISABLE_COLOR;
//        [self.submitView.submitBtn setHidden:NO];
        [self.submitView setHidden:YES];
    }
    // 如果当前投票已经提交过了，则按钮显示“已提交”
    else if ([self.submittedInvestigationArray containsObject:self.investigation.ID]) {
        [self.submitView alreadySubmit];
    }
    else
    {
        if ([self judgeEnableSubmit]) {
            [self.submitView enableSubmit];
        }else{
            [self.submitView disableSubmit];
        }

    }
    
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _investigation.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GSInvestigationQuestion* que=  [_investigation.questions objectAtIndex:section];
    
    if (que.questionType == GSInvestigationQuestionTypeEssay) {
        return 1;
    }else{
        return que.options.count;
    }
    
    return 0;
}

static NSString *reuseHeader = @"GSInvestigationHeaderView";

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GSInvestigationHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeader];
    
    if (headerView == nil) {
        headerView = [[GSInvestigationHeaderView alloc]initWithReuseIdentifier:reuseHeader];
    }
    
    GSInvestigationQuestion* que=  [_investigation.questions objectAtIndex:section];
    
    
    headerView.title = [self headerStringByType:que.questionType section:section content:que.content];
    
    return headerView;
}

- (NSString *)headerStringByType:(GSInvestigationQuestionType)type section:(NSInteger)section content:(NSString *)content{
    
    NSString *queTitle = content;
    
    NSString* titleName;
    
    if (type==GSInvestigationQuestionTypeSingleChoice) {
        titleName=[NSString stringWithFormat:@"%ld.【%@】%@", section+1,@"单选", queTitle];
    }else if (type==GSInvestigationQuestionTypeMultiChoice)
    {
        titleName=[NSString stringWithFormat:@"%ld.【%@】%@", section+1,@"多选", queTitle];
    }else{
        titleName=[NSString stringWithFormat:@"%ld.【%@】%@", section+1,@"问答", queTitle];
    }
    
    return titleName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    GSInvestigationQuestion* que=  [_investigation.questions objectAtIndex:section];

    NSString *tmpStr = [self headerStringByType:que.questionType section:section content:que.content];

    return [self heightWithString:tmpStr LabelFont:[UIFont systemFontOfSize:13] withLabelWidth:Width - 20] + 8;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSInvestigationQuestion* que=  [_investigation.questions objectAtIndex:indexPath.section];
    if (que.questionType == GSInvestigationQuestionTypeEssay)
    {
        if (_investigation.isResultPublished || _investigation.hasTerminated) {
            return 30;
        }else{
            return 93;
        }
        
    }else{
        
        GSInvestigationQuestion* que=  [_investigation.questions objectAtIndex:indexPath.section];
        GSInvestigationOption* ans=  [que.options objectAtIndex:indexPath.row];
        
        
        NSString *ansTitle = ans.content;
        NSString *ansAll = [NSString stringWithFormat:@"%c、%@", 65+indexPath.row, ansTitle];
        
        CGSize labelSize = {0, 0};
        labelSize = [ansAll sizeWithFont:[UIFont systemFontOfSize:13]
                       constrainedToSize:CGSizeMake(175, 5000)];
        
        
        if (_investigation.isResultPublished||_investigation.hasTerminated) {  //处理发布后的cell
            return 44;
        }
        
        float height;
        
        if (_isSubmit==NO) {
            
            height = [self heightWithString:ansAll LabelFont:[UIFont systemFontOfSize:13] withLabelWidth:Width - 45] + 8;

        }else{
     
            height = [self heightWithString:ansAll LabelFont:[UIFont systemFontOfSize:13] withLabelWidth:Width - 65] + 8 ;
  
        }
        int H =  ceil(height) + 1;
        
        if (H > 44) {
            return H;
        }else{
            return 44;
        }
  
    }
  
    return 44;
    
}

static NSString *reuseCell_essay = @"GSInvestigationEssayCell";
static NSString *reuseCell_single = @"GSInvestigationSingleChoiceCell";
static NSString *reuseCell_multi = @"GSInvestigationMultiChoiceCell";


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSInvestigationQuestion* que = [_investigation.questions objectAtIndex:indexPath.section];
    
    if (que.questionType == GSInvestigationQuestionTypeEssay) {
        GSInvestigationEssayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell_essay];
        
        if (cell == nil) {
            cell = [[GSInvestigationEssayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell_essay];
        }
        
        if (_investigation.isResultPublished || _investigation.hasTerminated ) {
            cell.textView.editable = NO;
            cell.textView.text = que.essayAnswer;
            cell.investigation = self.investigation;
            
            
        }else{
            cell.textView.editable = YES;
            cell.textView.text = que.essayAnswer;
            cell.textView.delegate = self;
            cell.investigation = nil;
        }
        
        cell.textView.tag = indexPath.section + 10000;
        
        [cell loadContent];
        
        return cell;
    }else if (que.questionType == GSInvestigationQuestionTypeSingleChoice){
        
        GSInvestigationSingleChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell_single];
        
        if (cell == nil) {
            cell = [[GSInvestigationSingleChoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell_single];
        }
        
        GSInvestigationOption *option = [que.options objectAtIndex:indexPath.row];
        
        cell.option = option;
        cell.alphabet = [NSString stringWithFormat:@"%c", 65+indexPath.row];
        
        if (_investigation.isResultPublished || _investigation.hasTerminated) { //处理发布后的cell
            cell.isShowResult = YES;
            
            double count = que.users.count;
//            double count = que.totalSumOfUsers;
            double num = option.users.count;
            if (count > 0) {
                double percent = num*(1.00) / count;
                cell.percentValue = percent;
                
            }else{
                cell.percentValue = 0;
            }
        }else{
            cell.isShowResult = NO;
        }
        
        cell.isSubmit = _isSubmit;
        
        [cell loadContent];
        
        return cell;
        
    }else{
        
        GSInvestigationMultiChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell_multi];
        
        if (cell == nil) {
            cell = [[GSInvestigationMultiChoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell_multi];
        }
        
        GSInvestigationOption *option = [que.options objectAtIndex:indexPath.row];
        
        cell.option = option;
        cell.alphabet = [NSString stringWithFormat:@"%c", 65+indexPath.row];
        
        if (_investigation.isResultPublished || _investigation.hasTerminated) { //处理发布后的cell
            cell.isShowResult = YES;
            
            double count = que.users.count;
            //            double count = que.totalSumOfUsers;
            double num = option.users.count;
            if (count > 0) {
                double percent = num*(1.00) / count;
                cell.percentValue = percent;

            }else{
                cell.percentValue = 0;
            }
            
        }else{
            cell.isShowResult = NO;
        }
        
        cell.isSubmit = _isSubmit;
        
        [cell loadContent];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSInvestigationQuestion* que = [_investigation.questions objectAtIndex:indexPath.section];
    
    if (que.questionType == GSInvestigationQuestionTypeSingleChoice) {
        
        for (GSInvestigationOption *tmp in que.options) {
            tmp.isSelected = NO;
        }
        GSInvestigationOption *option = [que.options objectAtIndex:indexPath.row];
        
        option.isSelected = YES;
        
//        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (que.questionType == GSInvestigationQuestionTypeMultiChoice){
        
        GSInvestigationOption *option = [que.options objectAtIndex:indexPath.row];
        
        option.isSelected = !option.isSelected;
        
//        [tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];

    }

    if ([self judgeEnableSubmit]) {
        [self.submitView enableSubmit];
    }else{
        [self.submitView disableSubmit];
    }
    
}


- (BOOL)judgeEnableSubmit{
    BOOL isCanUse=NO;
    
    BOOL isEssayCanUse=NO;
    
    
    for (int j=0; j<_investigation.questions.count; j++) {
        
        GSInvestigationQuestion* que=  [_investigation.questions objectAtIndex:j];
        
        if(que.questionType==GSInvestigationQuestionTypeEssay)
        {
            if((que.essayAnswer.length>0)||(![que.essayAnswer isEqualToString:@""]))
            {
                isEssayCanUse = YES;
            }else{
                isEssayCanUse = NO;
            }
            
            
        }else{
            for (int k=0; k<que.options.count; k++) {
                
                GSInvestigationOption* ans=  [que.options objectAtIndex:k];
                if(que.questionType==GSInvestigationQuestionTypeSingleChoice)
                {
                    if (ans.isSelected) {
                        isCanUse=YES;
                        break;
                    }
                }
                
                else if(que.questionType==GSInvestigationQuestionTypeMultiChoice)
                {
                    if (ans.isSelected) {
                        isCanUse=YES;
                        break;
                    }
                    
                }
                
            }
        }
        
    }
    
    
    return isCanUse || isEssayCanUse;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section== (_investigation.questions.count-1)) {
//        if (_investigation.isResultPublished||_investigation.hasTerminated) {
//            return 20;
//        }
//        return 0;
//    }
//    return 0;
//}



//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//
//
//    if (section== (_investigation.questions.count-1)) {
//
//
//
//        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 23)];
//        footView.backgroundColor=[UIColor whiteColor];
//
//        UILabel* personLabel=[[UILabel alloc] init];
//
//        personLabel.frame=CGRectInset(footView.frame,25,0);
//        [footView addSubview:personLabel];
//        personLabel.textAlignment=NSTextAlignmentLeft;
//        personLabel.textColor=[UIColor colorWithRed:250/255.f green:178/255.f blue:160/255.f alpha:1];
//        personLabel.font=[UIFont systemFontOfSize:13];
//
//
//
//        if (_investigation.isResultPublished||_investigation.hasTerminated) {
//
//            personLabel.text=[NSString stringWithFormat:@"%@:%lu",GNSLocalizedString(@"number_of_entries", @"参加人数"),(unsigned long)_investigation.total];
//
//            return footView;
//        }else{
//
//            return nil;
//        }
//
//    }
//    return nil;
//
//
//}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_tableView addGestureRecognizer:_tapGesture];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    
    [_tableView removeGestureRecognizer:_tapGesture];
    
    
    if (textView.text.length>0) {
        [self.submitView enableSubmit];
    }else{
        [self.submitView disableSubmit];
    }
    
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    GSInvestigationQuestion* que = [_investigation.questions objectAtIndex:(textView.tag - 10000)];
    
    
    que.essayAnswer = textView.text;
    
    
    
}

#pragma mark - 计算文本高度

- (CGFloat)heightWithString:(NSString *)string LabelFont:(UIFont *)font withLabelWidth:(CGFloat)width {
    CGFloat height = 0;
    
    if (string.length == 0) {
        height = 0;
    } else {
        
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13.f]};
        if (font) {
            attribute = @{NSFontAttributeName: font};
        }
        
        // 尺寸
        CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
        
        height = retSize.height;
    }
    
    return ceil(height) + 1;
}

@end
