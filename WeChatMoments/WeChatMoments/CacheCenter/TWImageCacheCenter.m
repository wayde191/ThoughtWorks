//
//  TWImageCacheCenter.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWImageCacheCenter.h"

//Singleton model
static TWImageCacheCenter *singletonInstance = nil;
static const NSInteger kMaxCachedImageNumber = 10;

@interface TWImageCacheCenter (){
    dispatch_queue_t _gcdBarrierQueue;
    
}

@property (nonatomic, strong) NSMutableArray *cacheOrderArr;
@property (nonatomic, strong) NSMutableDictionary *cachePoolDic;

@end

@implementation TWImageCacheCenter

- (id)init {
    self = [super init];
    if (self) {
        _gcdBarrierQueue = dispatch_queue_create("tw.gcd.wechatcomments.ForBarrier", DISPATCH_QUEUE_CONCURRENT);
        self.cacheOrderArr = [@[] mutableCopy];
        self.cachePoolDic = [@{} mutableCopy];
        [self createImgCacheFolder];
    }
    return self;
}

- (void)dealloc {
    _gcdBarrierQueue = nil;
}

#pragma mark - Public Methods
- (void)cacheImage:(UIImage *)image withKey:(NSString *)nameKey {
    
    TWImageCacheCenter __weak *weakSelf = self;
    dispatch_barrier_async(_gcdBarrierQueue, ^{
        [weakSelf cacheImage:image inMemoryByName:nameKey];
        [weakSelf writeImageToDisk:image withName:nameKey];
    });
}

- (UIImage *)getImageByKey:(NSString *)nameKey {
    UIImage *imgFindFor = nil;
    
    imgFindFor = self.cachePoolDic[nameKey];
    if (!imgFindFor) {
        imgFindFor = [self getImageFromFileSystem:nameKey];
    }
    
    return imgFindFor;
}

- (void)clearCache {
    [self.cacheOrderArr removeAllObjects];
    [self.cachePoolDic removeAllObjects];
}

#pragma mark - Private Methods
- (UIImage *)getImageFromFileSystem:(NSString *)imgUrl
{
    NSString *imgFilePath = [self getImgPathByFileName:imgUrl];
    UIImage *imgFindFor = [UIImage imageWithContentsOfFile:imgFilePath];
    if (imgFindFor) {
        [self cacheImage:imgFindFor inMemoryByName:imgUrl];
    }
    return imgFindFor;
}

- (void)writeImageToDisk:(UIImage *)image withName:(NSString *)nameKey {
    @autoreleasepool {
        NSData* imgData = UIImagePNGRepresentation(image);
        NSString *imgFilePath = [self getImgPathByFileName:nameKey];
        [imgData writeToFile:imgFilePath atomically:YES];
        TWLOGINFO(@"Write img to File:%@ - %@",nameKey, imgFilePath);
    }
}

- (void)cacheImage:(UIImage *)image inMemoryByName:(NSString *)nameKey {
    if (self.cacheOrderArr.count >= kMaxCachedImageNumber) {
        NSString *firstKey = self.cacheOrderArr[0];
        [self.cachePoolDic removeObjectForKey:firstKey];
        [self.cacheOrderArr removeObjectAtIndex:0];
    }
    
    [self.cachePoolDic setObject:image forKey:nameKey];
    [self.cacheOrderArr addObject:nameKey];
}

- (NSString *)getImgPathByFileName:(NSString *)fileName
{
    return [NSString stringWithFormat:@"%@/%@", [self getImgCacheFolder], fileName];
}

- (NSString *)getImgCacheFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/images",cacheFolder];
}

- (BOOL)createImgCacheFolder
{
    NSString *imgCacheFolder = [self getImgCacheFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imgCacheFolder]) {
        @synchronized(self){
            NSFileManager* manager = [NSFileManager defaultManager];
            NSError *error = nil;
            if (![manager createDirectoryAtPath:imgCacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
                TWLOGINFO(@"Create Img cache folder error with Message: %@", [error localizedDescription]);
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - Class Methods
+ (TWImageCacheCenter *)sharedInstance {
    @synchronized(self){
        if (!singletonInstance) {
            singletonInstance = [[TWImageCacheCenter alloc] init];
        }
        return singletonInstance;
    }
    
    return nil;
}
@end
