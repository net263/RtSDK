//
//  GSDocAnnoProtocol.h
//  GSDocKit
//
//  Created by gensee on 2018/11/21.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GSDocAnnoProtocol <NSObject>

@property (nonatomic, assign) CGRect annoRect;

- (void)annoTouchBegin:(CGPoint)startP;
- (void)annoTouchMoved:(CGPoint)moveP;
- (void)annoTouchEnded:(CGPoint)endP;
- (void)annoTouchCancelled:(CGPoint)cancelP;

@end

NS_ASSUME_NONNULL_END
