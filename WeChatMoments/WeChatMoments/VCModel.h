//
//  VCModel.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface VCModel : NSObject

typedef void(^GetAllDataHandler)();
- (BOOL)doCallServiceGetAllDataWithHandler:(GetAllDataHandler)getAllHandler;

@property (nonatomic, strong) User *whoami;
@property (nonatomic, strong) NSArray *tweetsArr;

- (void)simulateRefreshing;
- (void)restore;
- (BOOL)hasMorePage;
- (void)loadNextPage;
- (NSInteger)numberOfRows;

@end
