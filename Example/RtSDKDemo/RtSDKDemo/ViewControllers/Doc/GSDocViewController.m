//
//  GSDocViewController.m
//  RtSDKDemo
//
//  Created by gensee on 2018/11/19.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "GSDocViewController.h"
#import <GSCommonKit/GSTagsContentView.h>

@interface GSDocViewController () <GSDocViewDelegate,GSBroadcastDocumentDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) GSDocView *docView;
@property (strong, nonatomic) GSTagsContentView *tagView;
@property (strong, nonatomic) GSTagsContentView *lineTypeView;
@property (strong, nonatomic) GSTagsContentView *funcView;

@property (strong, nonatomic) GSTagsContentView *unreView;

@property (strong, nonatomic) NSMutableArray *docArray;

@end
@implementation GSDocViewController
{
    struct {
        int isWhite : 1
    } _state;
    CGFloat _top;
    GSDocument *_document;
    unsigned int currentDocID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _docArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.docView = [[GSDocView alloc]initWithFrame:CGRectMake(8, 64+20,Width-16,(Width-16)*3/4)];
    [self.docView setBackgroundColor:0.5 green:0.5 blue:0];
    self.docView.showMode = GSDocViewShowModeScaleAspectFit;
    [self.view addSubview:self.docView];
    self.docView.delegate = self;

    _top = self.docView.bottom + 5;
    // 注意下列代码的顺序
    NSLog(@"self.docView=%@",self.docView);  //打印一下
    self.manager.documentView = self.docView;
    self.manager.documentDelegate = self;
}

- (void)didRtJoinSuccess {
    GSUserInfo *userInfo = self.manager.queryMyUserInfo;
    if (userInfo.isOrganizer & GSUserRoleOrganizer) { // 组织者（教师）允许标注操作
        self.docView.isRoleTeacher = YES;
        [self setup];
    }else{
        self.docView.isRoleTeacher = NO;
        self.docView.userInteractionEnabled = NO;
    }
    [self.manager setStatus:GSBroadcastStatusRunning];
}

-(void)setup
{
    GSTagsContentView *tagView = [[GSTagsContentView alloc]initWithFrame:CGRectMake(15, _top + 15, Width - 15, 44) tags:@[@"无标注",@"橡皮擦",@"圆标注",@"矩形标注",@"直线标注",@"加强版直线标注",@"加强版点标注",@"加强版自由笔标注",@"删除所有标注"] handler:^(NSInteger index, NSString *text,BOOL isSelect) {
        NSLog(@"did click tag :%ld,%@",index,text);
        if (_lineTypeView) {
            [_lineTypeView removeFromSuperview];
        }
        switch (index) {
            case 0:
                [self setUpAnnotationMode:NO];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeNull];
                break;
            case 1:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeCleaner];
                return;
                break;
            case 2:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeCircle];
                break;
            case 3:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeRect];
                break;
            case 4:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeLine];
                break;
            case 5:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeLineEx];
                [self setlineTypeView];
                break;
            case 6:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypePointEx];
                break;
            case 7:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeFreePenEx];
                break;
            case 8:
                [self setUpAnnotationMode:NO];
                [self.docView cleanAllAnnos];
                break;
            default:
                break;
        }
    }];
    tagView.supportMultiSelect = NO;
    tagView.allowSelect = YES;
    tagView.selectIndex = 0;
    [self.view addSubview:tagView];
    _tagView = tagView;
    _top = _tagView.bottom + 5;
    
    _funcView = [[GSTagsContentView alloc]initWithFrame:CGRectMake(15, _top + 15, Width - 15, 44) tags:@[@"发布白板",@"发布文档(图片)",@"关闭文档"] handler:^(NSInteger index, NSString *text,BOOL isSelect) {
        NSLog(@"did click tag :%ld,%@",index,text);
        if (_lineTypeView) {
            [_lineTypeView removeFromSuperview];
        }
        switch (index) {
            case 0: {
                _state.isWhite = 1;
                [self.manager publishDocNewWhiteboard:@"docTest" createOnce:NO];
            }
                break;
            case 1: {
                UIImagePickerController* imageController = [[UIImagePickerController alloc] init];
                imageController.delegate = self;
                imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imageController.allowsEditing = NO;
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera is unavailable on your device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                    return;
                }
                imageController.sourceType = sourceType;
                [self presentModalViewController:imageController animated:YES];
            }
                return;
                break;
            case 2: {
                [self.manager publishDocClose:currentDocID serverDocClose:YES];
            }
                break;
           
            default:
                break;
        }
    }];
    _funcView.supportMultiSelect = NO;
    _funcView.allowSelect = YES;
//    _funcView.selectIndex = 0;
    [self.view addSubview:_funcView];
    _top = _funcView.bottom + 5;
    _unreView = [[GSTagsContentView alloc]initWithFrame:CGRectMake(15, _top + 15, Width - 15, 44) tags:@[@"Undo",@"Redo"] handler:^(NSInteger index, NSString *text,BOOL isSelect) {
        NSLog(@"did click tag :%ld,%@",index,text);
        
        switch (index) {
            case 0:
            {
                [self.docView undo];
            }
                break;
            case 1:
            {
                [self.docView redo];
            }
                return;
                break;
                
            default:
                break;
        }
    }];
    _unreView.supportMultiSelect = NO;
    _unreView.allowSelect = YES;
    //    _funcView.selectIndex = 0;
    [self.view addSubview:_unreView];
    _top = _unreView.bottom + 5;
}

- (void)setlineTypeView {
    if (!_lineTypeView) {
        _lineTypeView = [[GSTagsContentView alloc]initWithFrame:CGRectMake(15, _top + 15, Width - 15, 44) tags:@[@"普通",@"虚线",@"箭头"] handler:^(NSInteger index, NSString *text,BOOL isSelect) {
            NSLog(@"did click tag :%ld,%@",index,text);
            switch (index) {
                case 0:
                    self.docView.lineExType = 0;
                    break;
                case 1:
                    self.docView.lineExType = 1;
                    return;
                    break;
                case 2:
                    self.docView.lineExType = 2;
                    break;
                default:
                    break;
            }
        }];
        _lineTypeView.supportMultiSelect = NO;
        _lineTypeView.allowSelect = YES;
        _lineTypeView.selectIndex = 0;
    }
    
    [self.view addSubview:_lineTypeView];
}

-(void)setUpAnnotationMode:(BOOL)isAnnotation
{
    self.docView.isAnnomationMode = isAnnotation;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    UIImage* imageItem;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        imageItem= [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(imageItem == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择图片失败,请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    imageItem = [self scaleAndRotateImage:imageItem];
    
    [[GSBroadcastManager sharedBroadcastManager] docPublishImage:imageItem name:@"Demo_test"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

#pragma mark - GSBroadcastDocDelegate

// 文档模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDocModuleInitResult:(BOOL)result
{}

// 文档打开代理
- (void)broadcastManager:(GSBroadcastManager *)manager didOpenDocument:(GSDocument *)doc
{
    
    if (_state.isWhite) {
        [self.manager publishDocGotoPage:doc.docID pageId:0 sync2other:YES];
        _state.isWhite = 0;
    }
    currentDocID = doc.docID;
    NSLog(@"didOpenDocument name %@, id %d",doc.docName,doc.docID);
    if (doc && _docArray) {
        [_docArray addObject:doc];
    }
}

// 文档关闭代理
- (void)broadcastManager:(GSBroadcastManager *)manager didCloseDocument:(unsigned int)docID
{
    
}

// 文档切换代理
- (void)broadcastManager:(GSBroadcastManager *)manager didSlideToPage:(unsigned int)pageID ofDoc:(unsigned int)docID step:(int)step
{
    NSLog(@"didSlideToPage pageID %d docID %d",pageID,docID);
    if (_docArray.count == 0) {
        return;
    }
    for (int i = 0; i < _docArray.count; i++) { //从众多文档中选择需要显示的那个文档
        GSDocument *doc = _docArray[i];
        if (docID == doc.docID) {
            _document = doc;
            break;
        }
    }
}

#pragma mark - docView delegate

- (void)docView:(GSDocView*)docview anno:(GSAnnoBase*)anno pageID:(unsigned int)pageID docID:(unsigned int)docID {//主动绘制标注时数据回调
    NSLog(@"docView handle anno %@",anno.description);
    if ([anno isKindOfClass:[GSAnnoCleaner class]]) {
        GSAnnoCleaner *cleaner = anno;
        if (cleaner.removedAnnoID == 0) { //删除全部标注
            [[GSBroadcastManager sharedBroadcastManager] publishDocRemoveAllAnnotation:docID pageId:pageID];
        }else{ //删除单条
            [[GSBroadcastManager sharedBroadcastManager] publishDocRemoveAnnotation:docID pageId:pageID GSAnnoBase:cleaner];
        }
    }
    [[GSBroadcastManager sharedBroadcastManager] publishDocAddAnnotation:docID pageId:pageID GSAnnoBase:anno];
}

- (void)docViewOpenFinishSuccess:(GSDocPage*)page   docID:(unsigned)docID
{
    if ( self.docView.hidden) {
        self.docView.hidden=NO;
    }
}

- (void)docViewSlideToLeft:(GSDocView*)docView {  //<--- 左滑  文档向前翻页 + 1
    if (_document.pages.count > 1) {
        if (_document.currentPageIndex + 1 <  _document.pages.count) {
            BOOL success = [self.manager publishDocGotoPage:_document.docID pageId:(_document.currentPageIndex + 1) sync2other:YES];
            if (success) {
                _document.currentPageIndex ++;
            }
        }else{
            NSInteger index = [_docArray indexOfObject:_document];
            index ++;
            if (index > _docArray.count - 1) {
                index = _docArray.count - 1;
            }else{
                _document = [_docArray objectAtIndex:index];
                [self.manager publishDocGotoPage:_document.docID pageId:(_document.currentPageIndex) sync2other:YES];
            }
        }
    }else {
        NSInteger index = [_docArray indexOfObject:_document];
        index ++;
        if (index > _docArray.count - 1) {
            index = _docArray.count - 1;
        }else{
            _document = [_docArray objectAtIndex:index];
            [self.manager publishDocGotoPage:_document.docID pageId:(_document.currentPageIndex) sync2other:YES];
        }
    }
}

- (void)docViewSlideToRight:(GSDocView *)docView { //--> 右滑  文档向后翻页 - 1
    if (_document.pages.count > 1) {
        if (_document.currentPageIndex - 1 >= 0) {
            BOOL success = [self.manager publishDocGotoPage:_document.docID pageId:(_document.currentPageIndex - 1) sync2other:YES];
            if (success) {
                _document.currentPageIndex --;
            }
        }else {
            NSInteger index = [_docArray indexOfObject:_document];
            index --;
            if (index < 0) {
                index = 0;
            }else {
                _document = [_docArray objectAtIndex:index];
                [self.manager publishDocGotoPage:_document.docID pageId:(_document.currentPageIndex) sync2other:YES];
            }
        }
    }else {
        NSInteger index = [_docArray indexOfObject:_document];
        index --;
        if (index < 0) {
            index = 0;
        }else {
            _document = [_docArray objectAtIndex:index];
            [self.manager publishDocGotoPage:_document.docID pageId:(_document.currentPageIndex) sync2other:YES];
        }
    }
}

#pragma mark - rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
