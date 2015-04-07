//
//  CommentsView.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsView : UIView

- (id)initWithFrame:(CGRect)frame byComments:(NSArray *)comments;
- (void)draw;

@end
