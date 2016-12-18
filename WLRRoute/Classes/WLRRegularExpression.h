//
//  WLRRegularExpression.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>
@class WLRMatchResult;
@interface WLRRegularExpression : NSRegularExpression
-(WLRMatchResult *)matchResultForString:(NSString *)string;
+(WLRRegularExpression *)expressionWithPattern:(NSString *)pattern;
@end
