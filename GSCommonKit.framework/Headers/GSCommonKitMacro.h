//
//  GSCommonKitMacro.h
//  GSCommonKit
//
//  Created by gensee on 2019/4/19.
//  Copyright © 2019年 gensee. All rights reserved.
//

#ifndef GSCommonKitMacro_h
#define GSCommonKitMacro_h


//! Project version number for GSCommonKit.
FOUNDATION_EXPORT double GSCommonKitVersionNumber;

//! Project version string for GSCommonKit.
FOUNDATION_EXPORT const unsigned char GSCommonKitVersionString[];

#import <pthread.h>

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
static inline void gs_dispatch_async_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
static inline void gs_dispatch_sync_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}


#endif /* GSCommonKitMacro_h */
