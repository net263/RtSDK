//
//  GSAudioFactory.h
//  GSCommonKit
//
//  Created by gensee on 2019/11/26.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSAudioPlayProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface GSAudioFactory : NSObject

+ (id <GSAudioPlayProtocol>)audioQueuePlayer;
+ (id <GSAudioPlayProtocol>)audioQueuePlayerWithConfiguration:(AudioStreamBasicDescription)desc;

+ (id <GSAudioPlayProtocol>)openalPlayer;

@end

NS_ASSUME_NONNULL_END
