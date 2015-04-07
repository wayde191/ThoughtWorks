//
//  VCTableViewDataSource.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "VCTableViewDataSource.h"

@implementation VCTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)cellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    static NSString *identifier = @"RDRouteDaysCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
    
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath*)indexPath
{
    return 45;
}


@end
