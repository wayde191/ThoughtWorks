//
//  TWRequestProtocol.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#ifndef WeChatMoments_TWRequestProtocol_h
#define WeChatMoments_TWRequestProtocol_h

#import <Foundation/Foundation.h>

@protocol TWRequestProtocol <NSObject>

@required
@property(nonatomic, strong) NSString *serviceName;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *userInfoDic;

- (id)initWithResponse:(NSDictionary *)responseDic;

@optional
@property(nonatomic, strong) NSString *errorInfo;

@end

#endif
