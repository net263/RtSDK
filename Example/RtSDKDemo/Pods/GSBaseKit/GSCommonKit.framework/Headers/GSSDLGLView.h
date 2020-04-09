//
//  GSSDLGLView.h
//  PlayerSDK
//
//  Created by gensee on 2019/1/11.
//  Copyright © 2019年 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGLRender.h"
#import "GSGLBuffer.h"
#import <OpenGLES/EAGL.h>

@interface GSSDLGLView : UIView

@property(nonatomic, readonly) CGFloat  fps;
@property(nonatomic)        CGFloat  scaleFactor;
@property(nonatomic)        BOOL  isThirdGLView;

- (id) initWithFrame:(CGRect)frame;
- (void) display: (GSGLBuffer *) buffer;

- (UIImage*) snapshot;
- (void)setShouldLockWhileBeingMovedToWindow:(BOOL)shouldLockWhiteBeingMovedToWindow __attribute__((deprecated("unused")));

- (void)flush;
- (void)flushWithColor:(float)red green:(float)green blue:(float)blue alpha:(float)alpha; //for custom color

@end

