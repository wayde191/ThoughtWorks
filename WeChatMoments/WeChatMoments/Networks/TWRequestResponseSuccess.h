//
//  TWRequestResponseSuccess.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWRequestResponseSuccess : NSObject

@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) id userInfo;

- (id)initWithResponse:(NSDictionary *)responseDic;

@end
