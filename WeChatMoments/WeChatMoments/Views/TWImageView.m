//
//  TWImageView.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWImageView.h"
#import "TWImageCacheCenter.h"

@interface TWImageView (){
    
}

typedef void(^CompletionHandlerBlock)(UIImage *image, BOOL succeed);
@property (nonatomic, strong) CompletionHandlerBlock completionHandler;

@property (nonatomic, strong) NSString *imageUrl;

@end

@implementation TWImageView

#pragma mark - Public Methods
- (void)loadImageByUrl:(NSString *)imageUrl {
    self.imageUrl = imageUrl;
    
    UIImage *imageFindFor = [[TWImageCacheCenter sharedInstance] getImageByKey:[imageUrl MD5]];
    if (!imageFindFor) {
        [self requestImageFromInternet];
    } else {
        self.image = imageFindFor;
    }
}


#pragma mark - Private Methods
- (void)requestImageFromInternet {
    TWImageView __weak *weakSelf = self;
    if (!self.completionHandler) {
        self.completionHandler = ^(UIImage *image, BOOL succeed){
            if (succeed) {
                [weakSelf imageLoadedSucceed:image];
            } else {
                [weakSelf imageLoadedFailed];
            }
        };
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *imgUrl = [NSURL URLWithString:weakSelf.imageUrl];
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
        
        if( imgData ){
            UIImage *image = [UIImage imageWithData:imgData];
            weakSelf.completionHandler(image, TRUE);
        } else {
            weakSelf.completionHandler(nil, FALSE);
        }
    });
}

- (void)imageLoadedSucceed:(UIImage *)image {
    TWImageView __weak *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.image = image;
    });
    [[TWImageCacheCenter sharedInstance] cacheImage:image withKey:[self.imageUrl MD5]];
}

- (void)imageLoadedFailed {
    //TODO
}

@end
