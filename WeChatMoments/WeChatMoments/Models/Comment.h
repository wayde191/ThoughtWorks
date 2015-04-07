//
//  Comment.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWBaseModel.h"

@class User;
@interface Comment : TWBaseModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) User *senderUser;

- (id)initWithDic:(NSDictionary *)userInfo;

@end
