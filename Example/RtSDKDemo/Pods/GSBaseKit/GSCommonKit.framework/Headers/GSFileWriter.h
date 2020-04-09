//
//  GSFileWriter.h
//  GSCommonKit
//
//  Created by gensee on 2019/7/1.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSFileWriter : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (void)write:(void*)pdata length:(long long)len;

@end

NS_ASSUME_NONNULL_END
