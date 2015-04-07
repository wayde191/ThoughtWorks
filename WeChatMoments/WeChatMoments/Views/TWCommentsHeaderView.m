//
//  TWCommentsHeaderView.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWCommentsHeaderView.h"
#import "TWImageView.h"

static const CGFloat kAvatarDistance = 108.0f;
static const CGFloat kMarginDistance = 8.0f;
static const CGFloat kAvatarSquareSize = 78.0;

@implementation TWCommentsHeaderView

- (void)drawRect:(CGRect)rect {
    self.bgImgView = [[TWImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kMarginDistance - (kAvatarSquareSize / 2.0))];
    self.avatarImgView = [[TWImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - kMarginDistance - kAvatarSquareSize, self.bgImgView.frame.size.height - kAvatarSquareSize * 0.7, kAvatarSquareSize, kAvatarSquareSize)];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.avatarImgView.frame.origin.y + 30, self.frame.size.width - self.avatarImgView.frame.size.width - kMarginDistance - 10, 21.0f)];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.bgImgView];
    [self addSubview:self.avatarImgView];
    [self addSubview:self.nameLabel];
}

- (void)layoutSubviews {
    
}

@end
