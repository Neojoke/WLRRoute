//
//  NSString+WLRQuery.h
//  Pods
//
//  Created by Neo on 2016/12/16.
//
//

#import <Foundation/Foundation.h>

@interface NSString (WLRQuery)
+ (NSString *)WLRQueryStringWithParameters:(NSDictionary *)parameters ;
- (NSDictionary *)WLRParametersFromQueryString ;
- (NSString *)WLRStringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding ;
- (NSString *)WLRStringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)encoding;
@end
