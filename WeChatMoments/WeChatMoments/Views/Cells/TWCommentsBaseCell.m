//
//  TWCommentsBaseCell.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWCommentsBaseCell.h"

@implementation TWCommentsBaseCell

+ (CGFloat)cellHeight:(id)dataModel {
    return 0.0f;
}

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:fileOwner options:nil];
    if (array && [array count]) {
        return array[0];
    }else {
        return nil;
    }
}

@end
