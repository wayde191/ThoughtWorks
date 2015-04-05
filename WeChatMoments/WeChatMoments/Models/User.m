//
//  User.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDic:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        //TODO: validation data
        self.username = userInfo[@"username"];
        self.nickname = userInfo[@"nick"];
        self.avatar = userInfo[@"avatar"];
        self.profileImage = userInfo[@"profile-image"];
    }
    return self;
}

@end
