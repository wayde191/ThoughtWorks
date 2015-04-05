//
//  ViewController.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "ViewController.h"
#import "VCModel.h"

@interface ViewController () {
    VCModel *_dm;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initModel];
    [self loadAllData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)loadAllData {
    if (![_dm doCallServiceGetAllDataWithHandler:^{
        // Get All Data done, refresh the view
        TWLOGINFO(@"Get All Data done, refresh the view");
    }]) {
        //TODO: Network issue. Show alert and clickable refresh view
        [self showNetWorkIssue];
        [self showRetryView];
    }
}

- (void)initModel {
    _dm = [[VCModel alloc] init];
}

- (void)showNetWorkIssue {
    //TODO
}

- (void)showRetryView {
    //TODO
}

@end
