//
//  GSTagsContentView.h
//  RtSDKDemo
//
//  Created by Sheng on 2018/7/24.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GSTagHandler)(NSInteger index, NSString *text,BOOL isSelect);

@interface GSTagsContentView : UIView

@property (nonatomic, assign) BOOL defaultSelected; //所有tag初始化为选中状态
- (GSTagsContentView * (^) (BOOL defaultSelected))defaultSelectedSet;

@property (nonatomic, assign) BOOL allowSelect; //允许选择 default NO -  YES :默认为灰色底色，选择后变颜色
- (GSTagsContentView * (^) (BOOL allowSelect))allowSelectSet;

@property (nonatomic, assign) BOOL supportMultiSelect; //是否支持多选
- (GSTagsContentView * (^) (BOOL supportMultiSelect))supportMultiSelectSet;

@property (nonatomic, strong) NSArray <NSString *>*tagTexts;
- (GSTagsContentView * (^) (NSArray <NSString *>*tagTexts))tagTextsSet;

@property (nonatomic, copy) GSTagHandler handler;
- (GSTagsContentView * (^) (GSTagHandler handler))handlerSet;

///< 选中index,默认为-1
@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)initWithFrame:(CGRect)frame tags:(NSArray <NSString *>*)tagTexts handler:(void (^)(NSInteger index, NSString *text,BOOL isSelect))handler;

@end
