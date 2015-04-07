//
//  ViewController.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "ViewController.h"
#import "VCModel.h"
#import "TWImageView.h"
#import "VCTableViewDataSource.h"

@interface ViewController () {
    VCModel *_dm;
    VCTableViewDataSource *_dataSource;
    
    BOOL _loadingData;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UIImageView *refreshImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loadingData = NO;
    
    [self initModel];
    [self loadAllData];
    [self setupViews];
    
    // Testing
    [self testImageCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource cellForTableView:tableView indexPath:indexPath];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource cellHeightForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentOffset.y <= (0 - self.refreshHeaderView.frame.size.height - 20.0f)
        && !_loadingData) {
        [self refreshTableHeaderDidTriggerRefresh];
        [UIView animateWithDuration:.2 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(self.refreshHeaderView.frame.size.height + 20.0f, 0.0f, 0.0f, 0.0f);
            [self startRotatingView:self.refreshImageView];
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0) { // Scroll down
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, self.refreshHeaderView.frame.size.height);
        
        self.refreshImageView.transform = CGAffineTransformMakeRotation((offset / self.refreshHeaderView.frame.size.height) * 100 * (M_PI / 180.0f));
    }
    
}

#pragma mark - Refresh Header View
- (void)refreshTableHeaderDidTriggerRefresh {
    _loadingData = YES;
    
    [self performSelector:@selector(doneRefresh) withObject:nil afterDelay:2.0];
    
}

- (void)doneRefresh {
    _loadingData = NO;
    [UIView animateWithDuration:.2 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        [self startRotatingView:self.refreshImageView];
    }];
    [self stopRotatingView:self.refreshImageView];
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

- (void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    _dataSource = [[VCTableViewDataSource alloc] init];
    
    self.refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -60.0f, self.view.frame.size.width, 60.0f)];
    self.refreshHeaderView.backgroundColor = [UIColor clearColor];
    self.refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 40.0f, 40.0f)];
    self.refreshImageView.image = [UIImage imageNamed:@"big_loading"];
    [self.refreshHeaderView addSubview:self.refreshImageView];
    [self.tableView addSubview:self.refreshHeaderView];
    
    [self.tableView reloadData];
}

- (void)startRotatingView:(UIImageView *)refreshView {
    [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [refreshView setTransform:CGAffineTransformRotate(refreshView.transform, M_PI_4)];
    }completion:^(BOOL finished){
        if (finished) {
            [self startRotatingView:refreshView];
        }
    }];
}

- (void)stopRotatingView:(UIImageView *)refreshView {
    [refreshView.layer removeAllAnimations];
}

#pragma mark - Testing
- (void)testImageCache {
    return;
    
    TWImageView *aimageView = [[TWImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:aimageView];
    [aimageView loadImageByUrl:@"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTlJRALAf-76JPOLohBKzBg8Ab4Q5pWeQhF5igSfBflE_UYbqu7"];
}

@end
