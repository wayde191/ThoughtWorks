//
//  TWNetworkMonitor.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWNetworkMonitor : NSObject

- (void)startNotifer;
- (void)stopNotifier;
- (BOOL)isReachable;
- (NSString *)getReadableTrafficInfo;

// Class Methods
+ (TWNetworkMonitor *)sharedInstance;

@end
