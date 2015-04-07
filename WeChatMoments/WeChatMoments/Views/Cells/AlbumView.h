//
//  AlbumView.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumView : UIView

- (id)initWithFrame:(CGRect)frame byImages:(NSArray *)images;
- (void)draw;
- (void)restore;

@end
