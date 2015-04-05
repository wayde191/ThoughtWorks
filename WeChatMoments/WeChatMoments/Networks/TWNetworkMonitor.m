//
//  TWNetworkMonitor.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWNetworkMonitor.h"
#import "Reachability.h"

//Singleton model
static TWNetworkMonitor *singletonInstance = nil;

@interface TWNetworkMonitor () {
    Reachability *_reachAbility;
    BOOL _networkReachable;
    NSString *_networkType;
}

@end

@implementation TWNetworkMonitor

- (id)init {
    self = [super init];
    if (self) {
        _networkReachable = YES;
        _networkType = nil;
    }
    return self;
}

#pragma mark - Public Methods
- (void)dealloc {
    [self removeObserver];
}

- (void)startNotifer {
    [self addObserver];
    _reachAbility = [Reachability reachabilityForInternetConnection];
    [self updateNetwordStatus:_reachAbility.currentReachabilityStatus];
    [_reachAbility startNotifier];
}

- (void)stopNotifier {
    [self removeObserver];
    if (_reachAbility) {
        [_reachAbility stopNotifier];
    }
}

- (BOOL)isReachable {
    return _networkReachable;
}

- (NSString *)getReadableTrafficInfo {
    return _networkType;
}

#pragma mark - Private Methods
- (void)networkStateDidChanged:(NSNotification*)n
{
    Reachability* curReach = [n object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateNetwordStatus:curReach.currentReachabilityStatus];
}

- (void)updateNetwordStatus:(NetworkStatus)status
{
    _networkReachable = YES;
    switch (status) {
        case ReachableViaWiFi:
        {
            _networkType = @"wifi";
        }
            break;
        case ReachableViaWWAN:
        {
            _networkType = @"wwan";
        }
            break;
        case NotReachable:
        {
            _networkType = @"unavailable";
            _networkReachable = NO;
        }
            break;
        default:
        {
            _networkReachable = NO;
            _networkType = @"unknown";
        }
            break;
    }
    
    TWLOGINFO(@"%@", _networkType);
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateDidChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - Class Methods
+ (TWNetworkMonitor *)sharedInstance {
    @synchronized(self){
        if (!singletonInstance) {
            singletonInstance = [[TWNetworkMonitor alloc] init];
        }
        return singletonInstance;
    }
    
    return nil;
}

@end
