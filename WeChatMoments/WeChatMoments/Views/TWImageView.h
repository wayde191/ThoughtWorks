//
//  TWImageView.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EImageDisplayTypeNone = 0,
    EImageDisplayTypeProportionScaling = 1,
    EImageDisplayTypeScalingAndCropping = 2,
} EImageDisplayType;

@interface TWImageView : UIImageView

- (id)initWithFrame:(CGRect)frame;
- (void)loadImageByUrl:(NSString *)imageUrl;
- (void)loadImageByUrl:(NSString *)imageUrl byDisplayType:(EImageDisplayType)displayType;

@end
