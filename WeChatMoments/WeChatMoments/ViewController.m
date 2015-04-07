//
//  ViewController.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "ViewController.h"
#import "VCModel.h"
#import "User.h"
#import "TWImageView.h"
#import "TWCommentsHeaderView.h"
#import "VCTableViewDataSource.h"
#import "CommentsCell.h"
#import "LoadingMoreCell.h"


@interface ViewController () {
    VCModel *_dm;
    VCTableViewDataSource *_dataSource;
    
    BOOL _loadingData;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UIImageView *refreshImageView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) TWCommentsHeaderView *headerView;;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loadingData = NO;
    
    [self drawViews];
    
    [self initModel];
    [self loadAllData];
    
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

- (TWCommentsBaseCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    } else {
        
        NSIndexPath *lastRowIndexPath = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
        LoadingMoreCell *lastCell = (LoadingMoreCell *)[self.tableView cellForRowAtIndexPath:lastRowIndexPath];
        
        if (lastCell.tag == [_dataSource getLoadingMoreCellTag]
            && scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= 100.0f) {
            
            if (![_dm hasMorePage] || _loadingData) {
                return;
            }
            
            _loadingData = YES;
            [lastCell startLoadingAnimation];
            [self performSelector:@selector(loadingMoreDidTriggered) withObject:nil afterDelay:2.0f];
        }
    }
    
}

#pragma mark - Refresh Header View
- (void)loadingMoreDidTriggered {
    [_dm loadNextPage];
    [self.tableView reloadData];
    _loadingData = NO;
}
    
- (void)refreshTableHeaderDidTriggerRefresh {
    _loadingData = YES;
    [_dm simulateRefreshing];
    [self.tableView reloadData];
    [self performSelector:@selector(doneRefresh) withObject:nil afterDelay:2.0];
    
}

- (void)doneRefresh {
    _loadingData = NO;
    [UIView animateWithDuration:.2 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        [self startRotatingView:self.refreshImageView];
    }];
    [self stopRotatingView:self.refreshImageView];
    
    [_dm restore];
    [self.tableView reloadData];
}


#pragma mark - Private Methods
- (void)reloadData {
    self.headerView.nameLabel.text = _dm.whoami.username;
    [self.headerView.bgImgView loadImageByUrl:_dm.whoami.profileImage];
    [self.headerView.avatarImgView loadImageByUrl:_dm.whoami.avatar];
    
    [self.tableView reloadData];
}

- (void)loadAllData {
    if (![_dm doCallServiceGetAllDataWithHandler:^{
        // Get All Data done, refresh the view
        TWLOGINFO(@"Get All Data done, refresh the view");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loadingView.hidden = YES;
            [self.view sendSubviewToBack:self.loadingView];
            [self reloadData];
        });
        
    }]) {
        //TODO: Network issue. Show alert and clickable refresh view
        [self showNetWorkIssue];
        [self showRetryView];
    }
    
    self.loadingView.hidden = NO;
    [self.view bringSubviewToFront:self.loadingView];
}

- (void)initModel {
    _dm = [[VCModel alloc] init];
    _dataSource.dm = _dm;
}

- (void)showNetWorkIssue {
    //TODO
}

- (void)showRetryView {
    //TODO
}

- (void)drawViews {
    [self drawTableView];
    [self drawLoadingView];
}

- (void)drawTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    _dataSource = [[VCTableViewDataSource alloc] init];
    [_dataSource registerCells:self.tableView];
    
    self.refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -60.0f, self.view.frame.size.width, 60.0f)];
    self.refreshHeaderView.backgroundColor = [UIColor clearColor];
    self.refreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 40.0f, 40.0f)];
    self.refreshImageView.image = [UIImage imageNamed:@"big_loading"];
    [self.refreshHeaderView addSubview:self.refreshImageView];
    [self.tableView addSubview:self.refreshHeaderView];
    
    self.headerView = [[TWCommentsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350)];
    self.headerView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.tableView reloadData];
}

- (void)drawLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.loadingView.backgroundColor = [UIColor whiteColor];
    UILabel *alabel = [[UILabel alloc] initWithFrame:self.loadingView.bounds];
    alabel.textAlignment = NSTextAlignmentCenter;
    alabel.text = @"数据加载中...";
    [self.loadingView addSubview:alabel];
    [self.view addSubview:self.loadingView];
    self.loadingView.hidden = YES;
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
    
//    TWImageView *aimageView = [[TWImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//    [self.view addSubview:aimageView];
//    [aimageView loadImageByUrl:@"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTlJRALAf-76JPOLohBKzBg8Ab4Q5pWeQhF5igSfBflE_UYbqu7"];
}

@end
