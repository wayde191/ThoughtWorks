//
//  Comment.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "Comment.h"
#import "User.h"

@implementation Comment

- (id)initWithDic:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        //TODO: validation data
        self.content = userInfo[@"content"];
        self.senderUser = [[User alloc] initWithDic:userInfo[@"sender"]];
    }
    return self;
}

@end
