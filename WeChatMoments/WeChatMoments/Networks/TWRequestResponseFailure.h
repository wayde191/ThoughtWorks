//
//  TWRequestResponseFailure.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWRequestProtocol.h"

@interface TWRequestResponseFailure : NSObject <TWRequestProtocol>

@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *userInfoDic;
@property(nonatomic, strong) NSString *errorInfo;

- (id)initWithResponse:(NSDictionary *)responseDic;

@end
