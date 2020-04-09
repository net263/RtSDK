//
//  GSGLRender.h
//  PlayerSDK
//
//  Created by gensee on 2019/1/10.
//  Copyright © 2019年 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSGLRenderProtocol.h"
#import "GSGLRenderColors.h"


NS_ASSUME_NONNULL_BEGIN




@interface GSGLRender : NSObject <GSGLRenderProtocol>
{
    @public
    GLuint program;
    
    GLuint vertex_shader;
    GLuint fragment_shader;
    GLuint plane_textures[3];
    
    GLuint av4_position;
    GLuint av2_texcoord;
    GLuint um4_mvp;
    
    GLuint us2_sampler[3];
    GLuint um3_color_conversion;
    
    GLsizei buffer_width;
    GLsizei visible_width;
    
    GLfloat texcoords[8];
    
    GLfloat vertices[8];
    int     vertices_changed;
    
    int     format;
    int     gravity;
    GLsizei layer_width;
    GLsizei layer_height;
    int     frame_width;
    int     frame_height;
    int     frame_sar_num;
    int     frame_sar_den;
    
    GLsizei last_buffer_width;
}

@end

NS_ASSUME_NONNULL_END
