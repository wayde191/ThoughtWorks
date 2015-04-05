//
//  TWImageCacheCenter.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWImageCacheCenter : NSObject

- (void)cacheImage:(UIImage *)image withKey:(NSString *)nameKey;
- (UIImage *)getImageByKey:(NSString *)nameKey;

// Class Methods
+ (TWImageCacheCenter *)sharedInstance;

@end
