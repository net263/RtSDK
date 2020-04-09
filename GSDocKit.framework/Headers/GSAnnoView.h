//
//  GSAnnoView.h
//  RtSDK
//
//  Created by Gaojin Hsu on 9/8/17.
//  Copyright © 2017 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSDocView.h"


@interface GSAnnoView : UIView <GSDocAnnoProtocol>
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, copy) void(^annoCallback)(GSAnnoBase* anno);
@property (nonatomic, copy) void(^didUndoRedo)(int undoCount,int redoCount);
@property (nonatomic, assign) NSUInteger lineSize;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) BOOL isAnnomationMode;
@property (nonatomic, assign) GSDocumentAnnoType docAnnoType;
@property (nonatomic, assign) Byte lineExType;
@property (nonatomic, assign) Byte pointExType;//当docAnnoType设置为GSDocumentAnnoTypePointEx时，用这个来设置点的样式，0十字 1箭头
@property (nonatomic, assign) BOOL isTeacherRole;
@property (nonatomic, assign) float offX;
@property (nonatomic, assign) float offY;
@property (nonatomic, assign) float scaleX;
@property (nonatomic, assign) float scaleY;
@property (nonatomic, strong) GSDocPage *currentPage;
@property (nonatomic, assign) unsigned int pageID;
@property (nonatomic, assign) unsigned int docID;
@property (nonatomic, assign) long long myUserID;
@property (nonatomic, strong) NSMutableArray *canceledAnnosArray;
@property (nonatomic, strong) NSMutableArray *myAnnosArray;
@property (nonatomic, weak) CALayer *arrowImageLayer;
@property (nonatomic, weak) CALayer *crossImageLayer;
- (void)redo;//恢复
- (void)undo;//撤销
- (void)cleanMyAnnoRecords;//删除undo/redo记录
- (void)removeAllMyAnnosOnCurrentPage;
- (void)removeAllAnnosOnCurrentPage;



@end
