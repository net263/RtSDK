//
//  GSGLRenderProtocol.h
//  PlayerSDK
//
//  Created by gensee on 2019/1/10.
//  Copyright © 2019年 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSGLBuffer.h"

NS_ASSUME_NONNULL_BEGIN

#define GS_GLES_STRINGIZE(x)   #x
#define GS_GLES_STRINGIZE2(x)  GS_GLES_STRINGIZE(x)
#define GS_GLES_STRING(x)      GS_GLES_STRINGIZE2(x)



#if SDL_BYTEORDER == SDL_LIL_ENDIAN
#   define SDL_FOURCC(a, b, c, d) \
(((uint32_t)a) | (((uint32_t)b) << 8) | (((uint32_t)c) << 16) | (((uint32_t)d) << 24))
#   define SDL_TWOCC(a, b) \
((uint16_t)(a) | ((uint16_t)(b) << 8))
#else
#   define SDL_FOURCC(a, b, c, d) \
(((uint32_t)d) | (((uint32_t)c) << 8) | (((uint32_t)b) << 16) | (((uint32_t)a) << 24))
#   define SDL_TWOCC( a, b ) \
((uint16_t)(b) | ((uint16_t)(a) << 8))
#endif

/*-
 *  http://www.webartz.com/fourcc/indexyuv.htm
 *  http://www.neuro.sfc.keio.ac.jp/~aly/polygon/info/color-space-faq.html
 *  http://www.fourcc.org/yuv.php
 */

// YUV formats
#define SDL_FCC_YV12    SDL_FOURCC('Y', 'V', '1', '2')  /**< bpp=12, Planar mode: Y + V + U  (3 planes) */
#define SDL_FCC_IYUV    SDL_FOURCC('I', 'Y', 'U', 'V')  /**< bpp=12, Planar mode: Y + U + V  (3 planes) */
#define SDL_FCC_I420    SDL_FOURCC('I', '4', '2', '0')  /**< bpp=12, Planar mode: Y + U + V  (3 planes) */
#define SDL_FCC_I444P10LE   SDL_FOURCC('I', '4', 'A', 'L')

#define SDL_FCC_YUV2    SDL_FOURCC('Y', 'U', 'V', '2')  /**< bpp=16, Packed mode: Y0+U0+Y1+V0 (1 plane) */
#define SDL_FCC_UYVY    SDL_FOURCC('U', 'Y', 'V', 'Y')  /**< bpp=16, Packed mode: U0+Y0+V0+Y1 (1 plane) */
#define SDL_FCC_YVYU    SDL_FOURCC('Y', 'V', 'Y', 'U')  /**< bpp=16, Packed mode: Y0+V0+Y1+U0 (1 plane) */

#define SDL_FCC_NV12    SDL_FOURCC('N', 'V', '1', '2')

// RGB formats
#define SDL_FCC_RV16    SDL_FOURCC('R', 'V', '1', '6')    /**< bpp=16, RGB565 */
#define SDL_FCC_RV24    SDL_FOURCC('R', 'V', '2', '4')    /**< bpp=24, RGB888 */
#define SDL_FCC_RV32    SDL_FOURCC('R', 'V', '3', '2')    /**< bpp=32, RGBX8888 */

// opaque formats
#define SDL_FCC__AMC    SDL_FOURCC('_', 'A', 'M', 'C')    /**< Android MediaCodec */
#define SDL_FCC__VTB    SDL_FOURCC('_', 'V', 'T', 'B')    /**< iOS VideoToolbox */
#define SDL_FCC__GLES2  SDL_FOURCC('_', 'E', 'S', '2')    /**< let Vout choose format */

// undefine
#define SDL_FCC_UNDF    SDL_FOURCC('U', 'N', 'D', 'F')    /**< undefined */


@protocol GSGLRenderProtocol <NSObject>

- (BOOL)renderBuffer:(GSGLBuffer*)buffer;

- (BOOL)prepareShader; // 1

- (BOOL)useShader; // 2

//3
- (BOOL)setGravity:(int)gravity width:(CGFloat)layer_width height:(CGFloat)layer_height;

- (BOOL)uploadTexture:(GSGLBuffer*)overlay;

- (void)cleanTexture;

- (void)reset;

#pragma mark - texCoords

- (void)texCoordsReset;

- (void)texCoordsCropRight:(GLfloat)cropRight;

- (void)texCoordsReload;

#pragma mark - vertice

- (void)verticesApply;

- (void)verticesReloadVertex;

- (void)verticesReset;

#pragma mark - state

- (BOOL)isvalidate;

- (BOOL)isFormat:(int)format;

#pragma mark - fragment

- (const char *)fragmentShaderSource;

#pragma mark - param

- (GLsizei)bufferWidth:(GSGLBuffer *)overlay;

@end

NS_ASSUME_NONNULL_END
