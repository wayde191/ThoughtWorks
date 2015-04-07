//
//  AlbumView.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "AlbumView.h"
#import "TWImageView.h"
#import "TWImageCacheCenter.h"

static const CGFloat kMaxWidth = 170.0f;
static const CGFloat kMaxHeight = 170.0f;
static const CGFloat kMarginGap = 8.0f;

@interface AlbumView (){
    
}

@property (nonatomic, strong) NSArray *imagesArr;

@end
@implementation AlbumView

- (id)initWithFrame:(CGRect)frame byImages:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.imagesArr = images;
    }
    return self;
}

- (void)restore {
    NSArray *subviews = [self subviews];
    [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

- (void)draw {
    if (1 == self.imagesArr.count) {
        [self drawOnePhoto];
    } else {
        [self drawMutiplePhotos];
    }
}

#pragma mark - Private Methods
- (void)drawOnePhoto {
    NSString *imageURL = self.imagesArr[0];
    UIImage *imageFindFor = [[TWImageCacheCenter sharedInstance] getImageByKey:[imageURL MD5]];
    if (!imageFindFor) {
        TWImageView *imageView = [[TWImageView alloc] initWithFrame:CGRectMake(0, kMarginGap, kMaxWidth, kMaxHeight)];
        [self addSubview:imageView];
        [imageView loadImageByUrl:imageURL byDisplayType:EImageDisplayTypeProportionScaling];
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kMaxHeight + 2 * kMarginGap);
        
    } else {
        UIImage *image = imageFindFor;
        image = [image imageProportionScalingForMaxSize:CGSizeMake(kMaxWidth, kMaxHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMarginGap, image.size.width, image.size.height)];
        imageView.image = image;
        [self addSubview:imageView];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, image.size.height + 2 * kMarginGap);
    }
}

- (void)drawMutiplePhotos {
    CGFloat viewHeight = 0.0f;
    CGFloat squareSize = (self.frame.size.width - 2 * kMarginGap) / 3.0f;
    
    for (int i = 0; i < self.imagesArr.count; i++) {
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        
        NSString *imageURL = self.imagesArr[i];
        UIImage *imageFindFor = [[TWImageCacheCenter sharedInstance] getImageByKey:[imageURL MD5]];
        if (!imageFindFor) {
            TWImageView *imageView = [[TWImageView alloc] initWithFrame:CGRectMake(column * (squareSize + kMarginGap), row * (squareSize + kMarginGap), squareSize, squareSize)];
            [self addSubview:imageView];
            [imageView loadImageByUrl:imageURL byDisplayType:EImageDisplayTypeScalingAndCropping];
            
        } else {
            UIImage *image = imageFindFor;
            image = [image imageByScalingAndCroppingForSize:CGSizeMake(squareSize, squareSize)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(column * (squareSize + kMarginGap), row * (squareSize + kMarginGap), squareSize, squareSize)];
            imageView.image = image;
            [self addSubview:imageView];
        }
        
        viewHeight = (row + 1) * (squareSize + kMarginGap) + kMarginGap;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, viewHeight);
}


@end
