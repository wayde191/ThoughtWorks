//
//  NetwoksTests.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TWRequest.h"

@interface NetwoksTests : XCTestCase

@end

@implementation NetwoksTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializeRequest {
    TWRequest *one = [TWRequest requestWithName:@"name" forServiceUrl:@"url"];
    XCTAssertTrue([one isMemberOfClass:[TWRequest class]], @"init one succeed");
    
    TWRequest *two = [TWRequest requestWithName:@"name" forServiceUrl:@"url" withDelegate:nil];
    XCTAssertTrue([two isMemberOfClass:[TWRequest class]], @"init two succeed");
    
    TWRequest *three = [TWRequest requestWithName:@"name" forServiceUrl:@"url" withRequestBloc:^(TWRequest *request, ERequestingStatus requestingStatus, TWRequestResponseSuccess *responseSuccess, TWRequestResponseFailure *responseFailed) {
        ;
    }];
    XCTAssertTrue([three isMemberOfClass:[TWRequest class]], @"init three succeed");
}

@end
