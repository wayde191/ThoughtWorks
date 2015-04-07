//
//  CommentsCell.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWCommentsBaseCell.h"

@class Tweet;
@interface CommentsCell : TWCommentsBaseCell

- (void)drawContent:(Tweet *)tweet;

@end
