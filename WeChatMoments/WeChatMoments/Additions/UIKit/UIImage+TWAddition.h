//
//  UIImage+TWAddition.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TWAddition)

- (UIImage*)imageProportionScalingForMaxSize:(CGSize)maxSize;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
