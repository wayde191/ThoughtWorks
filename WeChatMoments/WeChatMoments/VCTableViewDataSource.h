//
//  VCTableViewDataSource.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/7/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCTableViewDataSource : NSObject

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (UITableViewCell*)cellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
- (CGFloat)cellHeightForIndexPath:(NSIndexPath*)indexPath;

@end
