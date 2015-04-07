//
//  TWCommentsBaseCell.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWCommentsBaseCell : UITableViewCell

+ (CGFloat)cellHeight:(id)dataModel;
+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner;
@end
