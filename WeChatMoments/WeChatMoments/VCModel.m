//
//  VCModel.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "VCModel.h"
#import "TWNetworkMonitor.h"
#import "TWRequest.h"
#import "TWRequestResponseSuccess.h"
#import "TWRequestResponseFailure.h"
#import "User.h"
#import "Tweet.h"

#define WHO_AM_I_Service    @"WhoAmI_Service"
#define GET_TWEETS_Service  @"GetTweets_Service"

static const NSInteger kTweetsNumberPerPage = 5;

@interface VCModel () {
    BOOL _getWhoAmIDone;
    BOOL _getTweetsDone;
    
    NSInteger _totalPageNum;
    NSInteger _currentPageNum;
}

@property (nonatomic, strong) GetAllDataHandler getAllDataBlockHandler;

@end

@implementation VCModel

- (id)init {
    self = [super init];
    if (self) {
        _getWhoAmIDone = NO;
        _getTweetsDone = NO;
        _currentPageNum = 0;
        _totalPageNum = 0;
        self.whoami = nil;
        self.tweetsArr = @[];
    }
    return self;
}

#pragma mark - Public Methods
- (void)simulateRefreshing {
    _currentPageNum = 0;
    _totalPageNum = 0;
}

- (void)restore {
    _totalPageNum = self.tweetsArr.count / kTweetsNumberPerPage;
    _currentPageNum = MIN(_totalPageNum, 1);
}

- (BOOL)hasMorePage {
    return _totalPageNum > _currentPageNum;
}

- (void)loadNextPage {
    if (_currentPageNum < _totalPageNum) {
        _currentPageNum++;
    }
}

- (NSInteger)numberOfRows {
    return _currentPageNum * kTweetsNumberPerPage;
}

- (void)restoreTweets {
    
}

- (BOOL)doCallServiceGetAllDataWithHandler:(GetAllDataHandler)getAllHandler {
    if ([[TWNetworkMonitor sharedInstance] isReachable]) {
        self.getAllDataBlockHandler = getAllHandler;
        [self doCallServiceGetWhoAMI];
        [self doCallServiceGetTweets];
        return YES;
    }
    return NO;
}


#pragma mark - Private Methods
- (void)doCallServiceGetWhoAMI {
    VCModel __weak *weakSelf = self;
    TWRequest *request = [TWRequest requestWithName:WHO_AM_I_Service forServiceUrl:SERVICE_WHOAMI
               withRequestBloc:^(TWRequest *request, ERequestingStatus requestingStatus, TWRequestResponseSuccess *responseSuccess, TWRequestResponseFailure *responseFailed) {
                   
       switch (requestingStatus) {
           case ERequestingStarted:
               //TODO
               break;
           case ERequestingFinished:
           {
               [weakSelf parseWhoAmI:responseSuccess];
               _getWhoAmIDone = YES;
               [weakSelf serviceDone];
           }
               
               break;
           case ERequestingFailed:
               //TODO
               break;
           case ERequestingCanceled:
               //TODO
               break;
               
           default:
               break;
       }
    }];
    [request start];
}

- (void)parseWhoAmI:(TWRequestResponseSuccess *)response {
    self.whoami = [[User alloc] initWithDic:response.userInfo[@"data"]];
}

- (void)doCallServiceGetTweets {
    VCModel __weak *weakSelf = self;
    TWRequest *request = [TWRequest requestWithName:GET_TWEETS_Service forServiceUrl:SERVICE_GET_MY_TWEETS
                                    withRequestBloc:^(TWRequest *request, ERequestingStatus requestingStatus, TWRequestResponseSuccess *responseSuccess, TWRequestResponseFailure *responseFailed) {
        switch (requestingStatus) {
            case ERequestingStarted:
                //TODO
                break;
            case ERequestingFinished:
            {
                [weakSelf parseTweets:responseSuccess];
                _getTweetsDone = YES;
                [weakSelf serviceDone];
            }
                
                break;
            case ERequestingFailed:
                //TODO
                break;
            case ERequestingCanceled:
                //TODO
                break;
                
            default:
                break;
        }
    }];
    [request start];
}

- (void)parseTweets:(TWRequestResponseSuccess *)response {
    NSMutableArray *mutTweets = [@[] mutableCopy];
    NSArray *tweets = response.userInfo[@"data"];
    for (int i = 0; i < tweets.count; i++) {
        NSDictionary *tweet = tweets[i];
        if (tweet.count > 1) {
            [mutTweets addObject:[[Tweet alloc] initWithDic:tweet]];
        } else {
            continue;
        }
    }
    self.tweetsArr = [NSArray arrayWithArray:mutTweets];
}

- (void)serviceDone {
    if (_getWhoAmIDone && _getTweetsDone && self.getAllDataBlockHandler) {
        [self restore];
        self.getAllDataBlockHandler();
    }
}

@end
