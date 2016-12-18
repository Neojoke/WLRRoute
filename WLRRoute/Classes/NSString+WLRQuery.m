//
//  NSString+WLRQuery.m
//  Pods
//
//  Created by Neo on 2016/12/16.
//
//

#import "NSString+WLRQuery.h"

@implementation NSString (WLRQuery)
+ (NSString *)WLRQueryStringWithParameters:(NSDictionary *)parameters {
    NSMutableString *query = [NSMutableString string];
    [[parameters allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *value = [parameters[key] description];
        key   = [key WLRStringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        value = [value WLRStringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [query appendFormat:@"%@%@%@%@", (idx > 0) ? @"&" : @"", key, (value.length > 0) ? @"=" : @"", value];
    }];
    return [query copy];
}


- (NSDictionary *)WLRParametersFromQueryString {
    NSArray *params = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithCapacity:[params count]];
    for (NSString *param in params) {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if (pairs.count == 2) {
            // e.g. ?key=value
            NSString *key   = [pairs[0] WLRStringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [pairs[1] WLRStringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            paramsDict[key] = value;
        }
        else if (pairs.count == 1) {
            // e.g. ?key
            NSString *key = [[pairs firstObject] WLRStringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            paramsDict[key] = @"";
        }
    }
    return [paramsDict copy];
}


#pragma mark - URL Encoding/Decoding

- (NSString *)WLRStringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet *allowedCharactersSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharactersSet];
}


- (NSString *)WLRStringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)encoding {
    return [self stringByRemovingPercentEncoding];
}

@end
