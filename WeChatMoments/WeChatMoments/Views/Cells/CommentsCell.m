//
//  CommentsCell.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "CommentsCell.h"
#import "TWImageView.h"
#import "AlbumView.h"
#import "CommentsView.h"
#import "Tweet.h"
#import "User.h"

static const CGFloat kAvatarSize = 64.0f;
static const CGFloat kElementGap = 8.0f;
static const CGFloat kContentPaddingLeft = 94.0f;
static const CGFloat kMinHeight = 104.f;

@interface CommentsCell (){
    
}

@property (nonatomic, strong) TWImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *separatorLineLabel;

@property (nonatomic, strong) AlbumView *alubmView;
@property (nonatomic, strong) CommentsView *commentsView;

@end

@implementation CommentsCell

- (void)drawElements {
    if (self.avatarImageView) { // Not first time
        return;
    }
    
    self.avatarImageView = [[TWImageView alloc] initWithFrame:CGRectMake(15.0f, 20.0f, kAvatarSize, kAvatarSize)];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingLeft, self.avatarImageView.frame.origin.y + 4.0f, self.frame.size.width - kContentPaddingLeft - kElementGap, 21.0f)];
    self.nameLabel.font = FONTSIZE_17;
    self.nameLabel.textColor = COMMENT_USERNAME_TEXT_COLOR;
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentPaddingLeft, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10.0f, self.frame.size.width - kContentPaddingLeft - kElementGap, 21.0f)];
    self.contentLabel.font = FONTSIZE_17;
    self.contentLabel.textColor = COMMENT_CONTENT_TEXT_COLOR;
    self.contentLabel.numberOfLines = 0;
    
    self.separatorLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + kElementGap, self.frame.size.width, 1.0f)];
    self.separatorLineLabel.text = @"";
    self.separatorLineLabel.backgroundColor = COMMENT_SEPARATOR_LINE_COLOR;
    
    [self addSubview:self.avatarImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.separatorLineLabel];
}

- (void)drawContent:(Tweet *)tweet {
    [self drawElements];
    
    self.avatarImageView.image = nil;
    [self.avatarImageView loadImageByUrl:tweet.senderUser.avatar];
    self.nameLabel.text = tweet.senderUser.username;
    self.contentLabel.text = tweet.content;
    CGSize realSize;
    if (!self.contentLabel.text) {
        realSize = CGSizeMake(self.frame.size.width - kContentPaddingLeft - kElementGap, 21.0f);
    } else {
        realSize = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, 0)];
    }
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.frame.size.width - kContentPaddingLeft - kElementGap, MAX(21.0, realSize.height));
    TWLOGINFO(@"%@", self.contentLabel);
    TWLOGINFO(@"???---?%@?---", self.contentLabel.text);
    
    CGFloat cellHeight = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + kElementGap;
    
    [self.alubmView removeFromSuperview];
    self.alubmView = nil;
    if (tweet.images.count > 0) {
        self.alubmView = [[AlbumView alloc] initWithFrame:CGRectMake(kContentPaddingLeft, cellHeight, self.frame.size.width - kContentPaddingLeft - kElementGap, 0.0f) byImages:tweet.images];
        [self addSubview:self.alubmView];
        [self.alubmView draw];
        cellHeight = self.alubmView.frame.origin.y + self.alubmView.frame.size.height + kElementGap;
    }
    
    [self.commentsView removeFromSuperview];
    self.commentsView = nil;
    if (tweet.comments.count > 0) {
        self.commentsView = [[CommentsView alloc] initWithFrame:CGRectMake(kContentPaddingLeft, cellHeight, self.frame.size.width - kContentPaddingLeft - kElementGap, 0.0f) byComments:tweet.comments];
        [self addSubview:self.commentsView];
        [self.commentsView draw];
        cellHeight = self.commentsView.frame.origin.y + self.commentsView.frame.size.height + kElementGap;
    }
    
    CGFloat minY = MAX(kMinHeight - self.separatorLineLabel.frame.size.height, cellHeight - self.separatorLineLabel.frame.size.height);
    self.separatorLineLabel.frame = CGRectMake(0.0f, minY, self.separatorLineLabel.frame.size.width, self.separatorLineLabel.frame.size.height);
    
    self.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, cellHeight);
}

+ (CGFloat)cellHeight:(id)dataModel {
    Tweet *tweet = dataModel;
    
    CommentsCell *cell = [CommentsCell loadViewFromXibNamed:NSStringFromClass([CommentsCell class]) withFileOwner:nil];
    cell.frame = CGRectMake(0.0f, 0.0f, ScreenBoundWidth, 0.0f);
    TWLOGINFO(@"1111111111%@", cell);
    [cell drawContent:tweet];
    return MAX(kMinHeight, cell.frame.size.height);
}

@end
