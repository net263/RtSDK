//
//  NSString+GSUrlEncode.h
//  FASTSDK
//
//  Created by Sheng on 2017/9/22.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GSURLEncode)


/**
 URL Encode 编码（UTF-8）

 @return 编码后的字符串
 */
- (NSString *)URLEncode;

/**
 URL Encode 解码（UTF-8）
 avoid emotion
 @return 解码后的字符串
 */
- (NSString *)URLDecode;


/**
 URL Encode 编码 (自定义编码)
 @"~!*'\"();:@&=+$,/?%#[]% "
 @param encoding 编码格式:NSUTF8StringEncoding
 @return 编码后的字符串
 */
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;


/**
 过滤掉特殊字符

 @return 过滤后的字符串
 */
- (NSString *)URLTrimming;

/**
 判断是否是url
 
 @return 是否是url
 */
- (BOOL)isValidateUrlString;

@end
