//
//  WLRRouteRequest.m
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import "WLRRouteRequest.h"
#import "NSString+WLRQuery.h"
@interface WLRRouteRequest()

@end
@implementation WLRRouteRequest
-(void)setTargetCallBack:(void (^)(NSError *, id))targetCallBack{
    __weak WLRRouteRequest * weakRequest = self;
    if (targetCallBack == nil) {
        return;
    }
    self.isConsumed = NO;
    _targetCallBack = ^(NSError *error, id responseObject){
        weakRequest.isConsumed = YES;
        targetCallBack(error,responseObject);
    };
    
}
-(void)defaultFinishTargetCallBack{
    if (self.targetCallBack && self.isConsumed == NO) {
        self.targetCallBack(nil,@"正常执行回调");
    }
}
-(instancetype)initWithURL:(NSURL *)URL{
    if (!URL) {
        return nil;
    }
    self = [super init];
    if (self) {
        _URL = URL;
        _queryParameters = [[_URL query] WLRParametersFromQueryString];
    }
    return self;
}
-(instancetype)initWithURL:(NSURL *)URL routeExpression:(NSString *)routeExpression routeParameters:(NSDictionary *)routeParameters primitiveParameters:(NSDictionary *)primitiveParameters targetCallBack:(void (^)(NSError *, id))targetCallBack{
    if (!URL) {
        return nil;
    }
    self = [super init];
    if (self) {
        _URL = URL;
        _queryParameters = [[_URL query] WLRParametersFromQueryString];
        _routeExpression = routeExpression;
        _routeParameters = routeParameters;
        _primitiveParams = primitiveParameters;
        self.targetCallBack = targetCallBack;
    }
    return self;
}
-(void)setRouteParameters:(NSDictionary *)routeParameters{
    _routeParameters = routeParameters;

}
-(void)setPrimitiveParams:(NSDictionary *)primitiveParams{
    _primitiveParams = primitiveParams;
}
- (NSString *)description {
    return [NSString stringWithFormat:
            @"\n<%@ %p\n"
            @"\t URL: \"%@\"\n"
            @"\t queryParameters: \"%@\"\n"
            @"\t routeParameters: \"%@\"\n"
            @"\t PrimitiveParam: \"%@\"\n"
            @">",
            NSStringFromClass([self class]),
            self,
            [self.URL description],
            self.queryParameters,
            self.routeParameters,
            self.primitiveParams];
}
-(id)objectForKeyedSubscript:(NSString *)key{
    id value = self.routeParameters[key];
    if (!value) {
        value = self.queryParameters[key];
    }
    if (!value) {
        value = self.primitiveParams[key];
    }
    return value;
}
-(NSURL *)callbackURL{
    if (!_callbackURL) {
        for (NSString * key in self.routeParameters.allKeys) {
            if ([[key lowercaseString] rangeOfString:@"callback"].location != NSNotFound) {
                NSString * urlstring = self.routeParameters[key];
                NSURL * url = [NSURL URLWithString:urlstring];
                if (url) {
                    _callbackURL = url;
                    return _callbackURL;
                }
            }
        }
        for (NSString * key in self.queryParameters.allKeys) {
            if ([[key lowercaseString] rangeOfString:@"callback"].location != NSNotFound) {
                NSString * urlstring = self.queryParameters[key];
                NSURL * url = [NSURL URLWithString:urlstring];
                if (url) {
                    _callbackURL = url;
                    return _callbackURL;
                }
            }
        }
        for (NSString * key in self.primitiveParams.allKeys) {
            if ([[key lowercaseString] rangeOfString:@"callback"].location != NSNotFound) {
                NSString * urlstring = self.primitiveParams[key];
                NSURL * url = [NSURL URLWithString:urlstring];
                if (url) {
                    _callbackURL = url;
                    return _callbackURL;
                }
            }
        }
    }
    return _callbackURL;
}
-(id)copyWithZone:(NSZone *)zone{
    WLRRouteRequest * copyRequest = [[WLRRouteRequest alloc]initWithURL:self.URL];
    copyRequest.routeParameters = self.routeParameters;
    copyRequest.routeExpression = self.routeExpression;
    copyRequest.primitiveParams = self.primitiveParams;
    copyRequest.targetCallBack = self.targetCallBack;
    copyRequest.isConsumed = self.isConsumed;
    self.isConsumed = YES;
    return copyRequest;
}
@end
