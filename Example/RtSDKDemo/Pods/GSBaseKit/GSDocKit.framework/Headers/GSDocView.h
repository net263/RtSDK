//
//  GSDocView.h
//  GSCommonKit
//
//  Created by Gaojin Hsu on 7/7/17.
//  Copyright © 2017 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSDocAnnoProtocol.h"
typedef NS_ENUM(NSInteger, GSDocumentType)
{
    GSDocumentTypeUnknow        =   0x00,
    GSDocumentTypePPT           =   0x01,
    GSDocumentTypeWORD          =   0x02,
    GSDocumentTypeTXT           =   0x03,
    GSDocumentTypeEXCEL         =   0x04,
    GSDocumentTypeJPEG          =   0x05,
    GSDocumentTypeEMF           =   0x06,
    GSDocumentTypePDF           =   0x07,
    GSDocumentTypeBMP           =   0x08,
    GSDocumentTypeSWF           =   0x09,
    GSDocumentTypePPTX          =   0x0a,
    GSDocumentTypeSWF_VERYDOC   =   0x10,
    GSDocumentTypeWHITEBOARD    =   0x20,
};

//标注的类型
typedef NS_ENUM(NSInteger, GSDocumentAnnoType){
    GSDocumentAnnoTypeNull = 0x00,//空标注
    GSDocumentAnnoTypePoint,//点标注
    GSDocumentAnnoTypeFreePen,//自由笔标注
    GSDocumentAnnoTypeCleaner,//橡皮擦
    GSDocumentAnnoTypeText,//文字标注
    GSDocumentAnnoTypeCircle,//圆标注
    GSDocumentAnnoTypeRect,//矩形标注
    GSDocumentAnnoTypeLine,//直线标注
    GSDocumentAnnoTypeLineEx,//加强版直线标注
    GSDocumentAnnoTypePointEx,//加强版点标注
    GSDocumentAnnoTypeFreePenEx,//加强版自由笔标注
    GSDocumentAnnoTypePointExNoSend,//加强版点标注 - 不发送仅本地显示
};

//文档类，封装了文档的数据，一份文档可以包含若干文档页
@interface GSDocument : NSObject
@property (assign, nonatomic)unsigned docID;//文档ID
@property (strong, nonatomic)NSMutableDictionary *pages;//保存所有文档页对象的数组
@property (assign, nonatomic)int currentPageIndex;//当前显示的文档页索引
@property (assign, nonatomic)BOOL savedOnServer;//布尔值表示该文档是否存放在服务器上， YES表示是
@property (copy, nonatomic)NSString *docName;//文档名称
@property (assign, nonatomic)long long ownerID;//文档所属的用户ID
@property (assign, nonatomic)int docType;
@end

// 文档页类，封装了文档页数据
@interface GSDocPage : NSObject
@property (assign, nonatomic)unsigned pageID;//文档页ID
@property (strong, nonatomic)NSData *pageData;//文档页数据
@property (strong, nonatomic)NSString *filePath;//文档页数据
@property (assign, nonatomic)short pageWidth;//文档页的宽
@property (assign, nonatomic)short pageHeight;//文档页的高
@property (strong, nonatomic)NSMutableArray *annosArray;//该文档页上的所有标注数据,替换上面的dic
@property (strong, nonatomic)NSData *aniCfg; //动画信息
@end

//文档标注的基类
@interface GSAnnoBase : NSObject
@property (assign, nonatomic)GSDocumentAnnoType type;//标注类型
@property (assign, nonatomic)long long annoID;//标注ID
@property (assign, nonatomic)unsigned pageID;//标注所在文档页的ID
@property (assign, nonatomic)unsigned docID;//标注所在文档页所在的文档的ID
@property (assign, nonatomic) long long ownerID;
@end

// 圆形标注
@interface GSAnnoCircle : GSAnnoBase
@property (assign, nonatomic)Byte lineSize;//线的粗细尺寸
@property (strong, nonatomic)UIColor *lineColor;// 线的颜色
@property (assign, nonatomic)CGRect rect;//圆标注所在的矩形区域
@end

//自由笔标注
@interface GSAnnoFreePen : GSAnnoBase
@property (strong, nonatomic)NSMutableArray *points;//自由笔所有的点数据
@property (assign, nonatomic)Byte lineSize;//线的粗细尺寸
@property (strong, nonatomic)UIColor *lineColor;//线的颜色
@property (assign, nonatomic)BOOL isHighlight; 
@end

//加强版自由笔标注
@interface GSAnnoFreePenEx : GSAnnoFreePen
@property (assign, nonatomic) Byte stepType;//表示当前的自由笔对象是开始点，过程中的点还是结束的点
@end

//直线标注
@interface GSAnnoLine : GSAnnoBase
@property (assign, nonatomic)Byte lineSize;//线的粗细尺寸
@property (strong, nonatomic)UIColor *lineColor;//线的颜色
@property (assign, nonatomic)CGPoint startPoint;//起始点
@property (assign, nonatomic)CGPoint endPoint;//结束点
@end

//加强版直线标注
@interface GSAnnoLineEx : GSAnnoLine
@property (assign, nonatomic)Byte lineType;//线的类型，箭头线2，虚线1和普通线0
@end

//点标注
@interface GSAnnoPoint : GSAnnoBase
@property (assign, nonatomic)CGPoint point;//点的坐标
@end

//加强版点标注
@interface GSAnnoPointEx : GSAnnoPoint
@property (assign, nonatomic)Byte pointType;//点的类型，十字和箭头
@end

//矩形标注
@interface GSAnnoRect : GSAnnoBase
@property (assign, nonatomic)Byte lineSize;//线的粗细
@property (strong, nonatomic)UIColor *lineColor;//线的颜色
@property (assign, nonatomic)CGRect rect;//矩形信息
@end

//文字标注
@interface GSAnnoText : GSAnnoBase
@property (strong, nonatomic)UIColor *textColor;//文字颜色
@property (assign, nonatomic)Byte fontSize;//文字的字体大小
@property (copy, nonatomic)NSString *text;//文本内容
@property (assign, nonatomic)CGPoint point;//文字位置起始点
@end

//橡皮擦标注
@interface GSAnnoCleaner : GSAnnoBase
@property (assign, nonatomic)long long removedAnnoID;//删除的标注ID
@end

//文档显示模式
typedef NS_ENUM(NSUInteger, GSDocViewShowMode) {
    GSDocViewShowModeScaleAspectFit, //等比缩放显示（所有内容会全部显示在区域内）
    GSDocViewShowModeScaleToFill,    //拉伸全屏显示
    GSDocViewShowModeWidthFit,       //宽度适配屏幕，即宽度铺满，高度不够则中心显示，超出则上下拖动
    GSDocViewShowModeHeightFit,      //高度适配屏幕，即高度铺满，宽度不够则中心显示，超出则左右拖动
};

//old 文档显示模式
typedef NS_ENUM(NSInteger, GSDocShowType){
    GSDocEqualHighType = 0x01, //等高
    GSDocEqualWidthType, //等宽
    GSDocEqualFullScreenType, //全屏
};

//old 直线标注的类型
typedef NS_ENUM(NSInteger, LineExAnnoType){
    LineExSolidAnnoType = 0x00, //普通实线型
    LineExDashAnnoType, //虚线标注
    LineExArrowAnnoType, //箭头标注
};

//old 显示点的类型
typedef NS_ENUM(NSInteger, GSDocumentPointExAnnoType){
    GSDocumentAnnoPointExCross = 0x00, //十字型
    GSDocumentAnnoPointExArrow,//箭头
};

@class GSDocView;
@protocol GSDocViewDelegate <NSObject>
@optional
- (BOOL)docView:(GSDocView*)docview gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;//是否应该响应手势,小窗口不响应
- (void)docView:(GSDocView*)docview anno:(GSAnnoBase*)anno pageID:(unsigned int)pageID docID:(unsigned int)docID;//主动绘制标注时数据回调
- (void)docView:(GSDocView *)docview pageAnimationCount:(int)animationCount;//返回当前页文档包含的动画步骤
- (void)docView:(GSDocView *)docview undoCount:(int)undoCount redoCount:(int)redoCount;//返回undo redo数组中的记录数量
- (void)docViewSlideToLeft:(GSDocView*)docView;//检测到文档向左滑动
- (void)docViewSlideToRight:(GSDocView *)docView;//检车文档向右滑动
- (void)docViewSlideBorder:(GSDocView*)docView position:(float)position isEnd:(BOOL)isEnd;
- (void)docViewSlideState:(GSDocView*)docView recongnizer:(UIPanGestureRecognizer*)recongnizer;
//old
- (void)docViewOpenFinishSuccess:(GSDocPage*)page docID:(unsigned)docID;
- (void)docViewStepBackNextEnable:(int)backNum nextNum:(int)nextNum DEPRECATED_MSG_ATTRIBUTE("use 'docView:undoCount:redoCount:'"); //可以撤销的步骤数backNum，可以还原的步骤数nextNum
@end

//文档view
@interface GSDocView : UIView <GSDocAnnoProtocol>
@property (nonatomic, assign) GSDocViewShowMode showMode;//显示模式
@property (nonatomic, weak) id<GSDocViewDelegate> delegate;
@property (nonatomic, strong) GSDocPage* currentPage;
@property (nonatomic, assign) NSUInteger limitTextureCount; //TextureCount 如果超过的话，OpenFile返回false, TextureCount =0，不限制
@property (nonatomic, assign) BOOL touchEventEnabled; //是否向下传递touchEvent事件，默认为YES
@property (nonatomic, assign) BOOL isAnnomationMode;//自己能否画标注
@property (nonatomic, assign) GSDocumentAnnoType docAnnoType;//要画的标注类型
@property (nonatomic, assign) Byte lineExType;//当docAnnoType设置为GSDocumentAnnoTypeLineEx时，用这个来设置线的样式，箭头线2，虚线1和普通线0
@property (nonatomic, assign) Byte pointExType;//当docAnnoType设置为GSDocumentAnnoTypePointEx时，用这个来设置点的样式，0十字 1箭头
@property (nonatomic, assign) NSUInteger lineSize;//线的粗细
@property (nonatomic, strong) UIColor *lineColor;//线的颜色
@property (assign, nonatomic) BOOL isRoleTeacher; //老师角色可删除其他人的标注，否则只能删除自己的标注
@property (assign, nonatomic) long long myUserID;
@property (assign, nonatomic) BOOL isSlideToPosition;//针对网络会议特殊处理，与UIScrollView嵌套使用，存在事件冲突的问题

- (void)setBackgroundColor:(int)red
                     green:(int)green
                      blue:(int)blue; //设置背景色(r,g,b : 0-255)

//playersdk & vodsdk
- (void)receiveAnnos:(NSString*)xmlAnno;
- (void)goToAnimationStep:(int)step;


- (void)drawPage:(GSDocPage*)page; //new logic for page


//rtsdk
- (void)receiveAnno:(GSAnnoBase*)annoBase
              docID:(unsigned)docID
             pageID:(unsigned)pageID;
- (void)removeAnno:(long long)annoID
             docID:(unsigned)docID
            pageID:(unsigned)pageID;


//清除视图上的所有的标注(内部方法即清楚上面的所有的layer)
-(void)docCleanAllAnnos;
- (void)docOpen:(GSDocument*)doc;
- (void)docClose:(unsigned)docID;
- (void)docCloseAnyway;
- (void)goToPage:(unsigned)pageID
           docID:(unsigned)docID
            step:(int)step;
- (void)pageReady:(unsigned)docID page:(GSDocPage*)page;  //for doc
- (void)redo;//恢复
- (void)undo;//撤销
- (void)cleanAllAnnos; //清除所有标注（如果是老师角色，删除所有标注；如果是非老师角色，删除自己的标注), 橡皮擦（清除单笔标注）使用docAnnoType


//old
- (int)getCurrentDocAnnoStepCount;
- (int)getNextAnimation;



@property (nonatomic, assign) BOOL isNeedShowPen DEPRECATED_MSG_ATTRIBUTE("弃用");
@property (nonatomic, assign) NSUInteger  gSDocShowType DEPRECATED_MSG_ATTRIBUTE("建议使用showMode"); //文档的显示类型
@property (nonatomic, assign) BOOL zoomEnabled DEPRECATED_MSG_ATTRIBUTE("弃用,use delegate");
@property (nonatomic, assign) BOOL fullMode DEPRECATED_MSG_ATTRIBUTE("弃用");
@property (assign, nonatomic) BOOL isVectorScale DEPRECATED_MSG_ATTRIBUTE("弃用");
@property (nonatomic, weak) id<GSDocViewDelegate> docDelegate DEPRECATED_MSG_ATTRIBUTE("弃用");
- (void)setGlkBackgroundColor:(int)red green:(int)green blue:(int)blue DEPRECATED_MSG_ATTRIBUTE("use 'setBackgroundColor:green:blue:'");
- (void)enablePanGes:(BOOL)enable DEPRECATED_MSG_ATTRIBUTE("弃用");
- (void)clearPageAndAnno DEPRECATED_MSG_ATTRIBUTE("弃用");
//设置线的颜色
- (void)setupDocAnnoColor:(UIColor*)annoColor DEPRECATED_MSG_ATTRIBUTE("use 'lineColor'");
//设置线的粗细
- (void)setupDocAnnoLineSize:(Byte)LineSize DEPRECATED_MSG_ATTRIBUTE("use 'lineSize'");
//设置需要绘制那种标注线型
- (void)setupDocAnnoType:(GSDocumentAnnoType)annoType DEPRECATED_MSG_ATTRIBUTE("use 'docAnnoType'");
//设置线的类型
- (void)setupLineExAnnoType:(LineExAnnoType)lineType DEPRECATED_MSG_ATTRIBUTE("use 'lineExType'");
//设置PointEx的显示类型
- (void)setupPointExType:(GSDocumentPointExAnnoType)pointExType DEPRECATED_MSG_ATTRIBUTE("use 'pointExType'");
//绘制文档页
- (void)drawPage:(GSDocPage*)page docID:(unsigned)docID DEPRECATED_MSG_ATTRIBUTE("use 'pageReady:page:'");

//释放SWF的渲染
- (void)releaseSwfRender;
@end
