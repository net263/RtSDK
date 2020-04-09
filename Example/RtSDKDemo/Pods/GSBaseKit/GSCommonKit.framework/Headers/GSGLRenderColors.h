//
//  GSGLRenderColors.h
//  PlayerSDK
//
//  Created by gensee on 2019/1/11.
//  Copyright © 2019年 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSGLRenderColors : NSObject

+ (const GLfloat *)GLES2_getColorMatrix_bt709;

+ (const GLfloat *)GLES2_getColorMatrix_bt601;

@end

NS_ASSUME_NONNULL_END
