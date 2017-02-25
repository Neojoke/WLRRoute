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
    //将url匹配表达式转换成去掉:***的正则表达式
    NSString *transformedPattern = [WLRRegularExpression transfromFromPattern:pattern];
    if (self = [super initWithPattern:transformedPattern options:options error:error]) {
        self.routerParamNamesArr = [[self class] routeParamNamesFromPattern:pattern];
    }
    return self;
}

/**
 通过一个url生产出一个WLRMatchResult，检查是否匹配，并且将url路径中的关键字参数对应的值放入WLRMatchResult对象中

 @param string 一个需要匹配的url
 @return 匹配结果WLRMatchResult对象
 */
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
    /*
        拿出:***{} 匹配的数组
     */
    NSArray * paramPatternStrings = [self paramPatternStringsFromPattern:pattern];
    NSError * err;
    NSRegularExpression * paramNamePatternEx = [NSRegularExpression regularExpressionWithPattern:WLRRouteParamNamePattern options:NSRegularExpressionCaseInsensitive error:&err];
    /*
        将':***'取出并替换为空，保留{}部分,将原来的url匹配表达式中的':***()'替换成'()'
     */
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
    //如果替换后的表达式长度不为0且不是以/为开头，就在转换后的表达式前面加上^开头符号
    if (transfromedPattern.length && !([transfromedPattern characterAtIndex:0] == '/')) {
        transfromedPattern = [@"^" stringByAppendingString:transfromedPattern];
    }
    transfromedPattern = [transfromedPattern stringByAppendingString:@"$"];
    return transfromedPattern;
}
/**
   将表达式中的 ':***()' 部分通过正则表达式取出，存储在数组中返回

 @param pattern url匹配表达式
 @return 返回提取的 ':***()'的数组
 */
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

/**
 将原表达式中':name()'中的name全部过滤出来形成数组

 @param pattern url的匹配表达式
 @return url中匹配的路径中的关键字数组
 */
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
