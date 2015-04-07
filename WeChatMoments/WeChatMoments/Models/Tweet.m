//
//  Tweet.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "Comment.h"

@implementation Tweet

- (id)initWithDic:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        //TODO: validation data
        self.content = userInfo[@"content"];
        self.senderUser = [[User alloc] initWithDic:userInfo[@"sender"]];
        
        NSMutableArray *mutComments = [@[] mutableCopy];
        NSArray *comments = userInfo[@"comments"];
        for (int i = 0; i < comments.count; i++) {
            [mutComments addObject:[[Comment alloc] initWithDic:comments[i]]];
        }
        self.comments = [NSArray arrayWithArray:mutComments];
        
        NSMutableArray *mutImages = [@[] mutableCopy];
        NSArray *imgs = userInfo[@"images"];
        for (int j = 0; j < imgs.count; j++) {
            [mutImages addObject:imgs[j][@"url"]];
        }
        self.images = [NSArray arrayWithArray:mutImages];
    }
    return self;
}

@end
