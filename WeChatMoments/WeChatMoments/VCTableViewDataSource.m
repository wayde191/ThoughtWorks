//
//  VCTableViewDataSource.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "VCTableViewDataSource.h"
#import "VCModel.h"
#import "Tweet.h"
#import "TWCommentsBaseCell.h"
#import "CommentsCell.h"
#import "LoadingMoreCell.h"

static const NSInteger kLoadingMoreCellTag = 99999;

@implementation VCTableViewDataSource

- (void)registerCells:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CommentsCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoadingMoreCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LoadingMoreCell class])];
}

- (NSInteger)getLoadingMoreCellTag {
    return kLoadingMoreCellTag;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dm hasMorePage] ? ([self.dm numberOfRows] + 1) : [self.dm numberOfRows];
}

- (TWCommentsBaseCell*)cellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    TWCommentsBaseCell *theCell = nil;
    if (indexPath.row == [self.dm numberOfRows]) {
        NSString *identifier = NSStringFromClass([LoadingMoreCell class]);
        LoadingMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[LoadingMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.frame = CGRectMake(0.0f, 0.0f, ScreenBoundWidth, 0.0f);
        cell.tag = kLoadingMoreCellTag;
        [cell stopLoadingAnimation];
        TWLOGINFO(@"33333333%@", cell);
        theCell = cell;
        
    } else {
        NSString *identifier = NSStringFromClass([CommentsCell class]);
        CommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CommentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.frame = CGRectMake(0.0f, 0.0f, ScreenBoundWidth, 0.0f);
        TWLOGINFO(@"2222222%@", cell);
        Tweet *tweet = self.dm.tweetsArr[indexPath.row];
        [cell drawContent:tweet];
        theCell = cell;
    }
    
    theCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return theCell;
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == [self.dm numberOfRows]) {
        return [LoadingMoreCell cellHeight:nil];
    } else {
        Tweet *tweet = self.dm.tweetsArr[indexPath.row];
        return [CommentsCell cellHeight:tweet];
    }
}


@end
