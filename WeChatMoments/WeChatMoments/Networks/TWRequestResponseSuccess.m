//
//  TWRequestResponseSuccess.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWRequestResponseSuccess.h"

@implementation TWRequestResponseSuccess

- (id)initWithResponse:(NSDictionary *)responseDic {
    NSAssert(responseDic != nil, @"TWRequestResponseSuccess' init data Dictionary is empty");
    self = [super init];
    if (self) {
        self.serviceName = responseDic[@"serviceName"];
        self.status = responseDic[@"status"];
        self.userInfo = responseDic[@"userInfoDic"];
    }
    return self;
}

@end
