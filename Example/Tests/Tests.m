//
//  WLRRouteTests.m
//  WLRRouteTests
//
//  Created by Neo on 12/18/2016.
//  Copyright (c) 2016 Neo. All rights reserved.
//

@import XCTest;
#import <WLRRoute/WLRRoute.h>
#import "HBXCALLBACKHandler.h"
@interface Tests : XCTestCase
@property(nonatomic,strong)WLRRouter * router;

@end

@implementation Tests

- (void)setUp
{
    self.router = [[WLRRouter alloc]init];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    self.router = [[WLRRouter alloc]init];
    [self.router registerHandler:[[HBXCALLBACKHandler alloc]init] forRoute:@"x-call-back/:path(.*)"];
    NSURL * url = [NSURL URLWithString:@"WLRDemo://x-call-back/user/register?x-success=WLRDemo%3a%2f%2fx-call-back%2fuser%2fregister_success&x-error=WLRDemo%3a%2f%2fx-call-back%2falert%26message%3dregister+fail&phone=15890077643"];
    [self.router handleURL:url primitiveParameters:nil targetCallBack:^(NSError *error, id responseObject) {
        
    } withCompletionBlock:^(BOOL handled, NSError *error) {
        
    }];
}

@end

