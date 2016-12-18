//
//  WLRRegularExpression.m
//  Pods
//
//  Created by Neo on 2016/12/15.
//
//

#import "WLRRegularExpression.h"
#import "WLRMatchResult.h"
static NSString * const WLRRouteParamPattern=@":[a-zA-Z0-9-_][^/]+";
static NSString * const WLRRouteParamNamePattern=@":[a-zA-Z0-9-_]+";
static NSString * const WLPRouteParamMatchPattern=@"([^/]+)";
@interface WLRRegularExpression ()
@property(nonatomic,strong)NSArray * routerParamNamesArr;
@end
@implementation WLRRegularExpression
+(WLRRegularExpression *)expressionWithPattern:(NSString *)pattern{
    NSError *error;
    WLRRegularExpression * exp =[[WLRRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return exp;
}
-(instancetype)initWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError * _Nullable __autoreleasing *)error{
    NSString *transformedPattern = [WLRRegularExpression transfromFromPattern:pattern];
    if (self = [super initWithPattern:transformedPattern options:options error:error]) {
        self.routerParamNamesArr = [[self class] routeParamNamesFromPattern:pattern];
    }
    return self;
}
-(WLRMatchResult *)matchResultForString:(NSString *)string{
    NSArray * array = [self matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    WLRMatchResult * result = [[WLRMatchResult alloc]init];
    if (array.count == 0) {
        return result;
    }
    result.match = YES;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    for (NSTextCheckingResult * paramResult in array) {
        for (int i = 1; i<paramResult.numberOfRanges&&i <= self.routerParamNamesArr.count;i++ ) {
            NSString * paramName = self.routerParamNamesArr[i-1];
            NSString * paramValue = [string substringWithRange:[paramResult rangeAtIndex:i]];
            [paramDict setObject:paramValue forKey:paramName];
        }
    }
    result.paramProperties = paramDict;
    return result;
}
+(NSString*)transfromFromPattern:(NSString *)pattern{
    NSString * transfromedPattern = [NSString stringWithString:pattern];
    NSArray * paramPatternStrings = [self paramPatternStringsFromPattern:pattern];
    NSError * err;
    NSRegularExpression * paramNamePatternEx = [NSRegularExpression regularExpressionWithPattern:WLRRouteParamNamePattern options:NSRegularExpressionCaseInsensitive error:&err];
    for (NSString * paramPatternString in paramPatternStrings) {
        NSString * replaceParamPatternString = [paramPatternString copy];
        NSTextCheckingResult * foundParamNamePatternResult =[paramNamePatternEx matchesInString:paramPatternString options:NSMatchingReportProgress range:NSMakeRange(0, paramPatternString.length)].firstObject;
        if (foundParamNamePatternResult) {
            NSString *paramNamePatternString =[paramPatternString substringWithRange: foundParamNamePatternResult.range];
            replaceParamPatternString = [replaceParamPatternString stringByReplacingOccurrencesOfString:paramNamePatternString withString:@""];
        }
        if (replaceParamPatternString.length == 0) {
            replaceParamPatternString = WLPRouteParamMatchPattern;
        }
        transfromedPattern = [transfromedPattern stringByReplacingOccurrencesOfString:paramPatternString withString:replaceParamPatternString];
    }
    if (transfromedPattern.length && !([transfromedPattern characterAtIndex:0] == '/')) {
        transfromedPattern = [@"^" stringByAppendingString:transfromedPattern];
    }
    transfromedPattern = [transfromedPattern stringByAppendingString:@"$"];
    return transfromedPattern;
}
+(NSArray<NSString *> * )paramPatternStringsFromPattern:(NSString *)pattern{
    NSError *err;
    NSRegularExpression * paramPatternEx = [NSRegularExpression regularExpressionWithPattern:WLRRouteParamPattern options:NSRegularExpressionCaseInsensitive error:&err];
    NSArray * paramPatternResults = [paramPatternEx matchesInString:pattern options:NSMatchingReportProgress range:NSMakeRange(0, pattern.length)];
    NSMutableArray * array = [NSMutableArray array];
    for (NSTextCheckingResult * paramPattern in paramPatternResults) {
        NSString * paramPatternString  = [pattern substringWithRange:paramPattern.range];
        [array addObject:paramPatternString];
    }
    return array;
}
+(NSArray *)routeParamNamesFromPattern:(NSString *)pattern{
    NSRegularExpression *paramNameEx = [NSRegularExpression regularExpressionWithPattern:WLRRouteParamNamePattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * routeParamStrings = [self paramPatternStringsFromPattern:pattern];
    NSMutableArray *routeParamNames = [[NSMutableArray alloc]init];
    for (NSString *routeParamSting  in routeParamStrings) {
        NSTextCheckingResult * foundRouteParamNameResult = [[paramNameEx matchesInString:routeParamSting options:NSMatchingReportProgress range:NSMakeRange(0, routeParamSting.length)] firstObject];
        if (foundRouteParamNameResult) {
            NSString *routeParamNameSting = [routeParamSting substringWithRange:foundRouteParamNameResult.range];
            routeParamNameSting = [routeParamNameSting stringByReplacingOccurrencesOfString:@":" withString:@""];
            [routeParamNames addObject:routeParamNameSting];
        }
    }
    return routeParamNames;
}
@end
