//
//  TWRequestResponseFailure.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWRequestResponseFailure.h"

@implementation TWRequestResponseFailure

- (id)initWithResponse:(NSDictionary *)responseDic {
    NSAssert(responseDic != nil, @"TWRequestResponseFailure' init data Dictionary is empty");
    self = [super init];
    if (self) {
        self.serviceName = responseDic[@"serviceName"];
        self.status = responseDic[@"status"];
        self.userInfoDic = responseDic[@"userInfoDic"];
        self.errorInfo = responseDic[@"errorInfo"];
    }
    return self;
}

@end
