//
//  WLRMatchResult.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
/**
 The WLRMatchResult object is a result of whether a request url is matching for a handler or handleBlock.
 该对象是一个url是否匹配的结果对象，paramProperties字典包含了url上的匹配参数。
 */

@interface WLRMatchResult : NSObject
/**
 If matched,value is YES.
 */
@property (nonatomic, assign, getter=isMatch) BOOL match;
/**
 If matched,the paramProperties dictionary  will store url's path keyword paramaters away.
 如果匹配成功，url路径中的关键字对应的值将存储在该字典中.
 */
@property (nonatomic, strong) NSDictionary *paramProperties;
@end
