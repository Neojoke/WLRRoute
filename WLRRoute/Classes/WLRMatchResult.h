//
//  WLRMatchResult.h
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import <Foundation/Foundation.h>

@interface WLRMatchResult : NSObject
@property (nonatomic, assign, getter=isMatch) BOOL match;
@property (nonatomic, strong) NSDictionary *paramProperties;
@end
