//
//  WLRRegularExpression.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
@class WLRMatchResult;
/**
    This object is a regularExpression,it can match a url and return the result with WLRMatchResult object.
 */
@interface WLRRegularExpression : NSRegularExpression

/**
 This method can return a WLRMatchResult object to check a url string is matched.

 @param string a url string
 @return matching result
 */
-(WLRMatchResult *)matchResultForString:(NSString *)string;
+(WLRRegularExpression *)expressionWithPattern:(NSString *)pattern;
@end
