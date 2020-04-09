//
//  GSConstants.h
//  GSCommonKit
//
//  Created by Gaojin Hsu on 9/29/17.
//  Copyright © 2017 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 采集视频按比例裁剪
 */
typedef NS_ENUM(NSInteger, GSCropMode) {
    GSCropMode4x3 = 0, //GSCropMode4x3: 在竖屏采集是，将采集的视频按 w:h = 4:3 的比例裁剪
    GSCropMode16x9, //GSCropMode16x9:  在竖屏采集是，将采集的视频按 w:h = 16:9 的比例裁剪
    GSCropMode9x16, //GSCropMode9x16:  在竖屏采集是，将采集的视频按 w:h = 9:16 的比例裁剪
};

