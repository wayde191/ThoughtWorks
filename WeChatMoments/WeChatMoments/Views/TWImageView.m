//
//  TWImageView.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWImageView.h"
#import "TWImageCacheCenter.h"

@interface TWImageView (){
    
}

typedef void(^CompletionHandlerBlock)(UIImage *image, BOOL succeed);
@property (nonatomic, strong) CompletionHandlerBlock completionHandler;

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) EImageDisplayType displayType;

@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation TWImageView

- (void)awakeFromNib {
    self.displayType = EImageDisplayTypeNone;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self drawRefreshLoadingViews];
    }
    return self;
}

#pragma mark - Public Methods
- (void)loadImageByUrl:(NSString *)imageUrl {
    self.imageUrl = imageUrl;
    
    UIImage *imageFindFor = [[TWImageCacheCenter sharedInstance] getImageByKey:[imageUrl MD5]];
    if (!imageFindFor) {
        [self startLoadingAnimation];
        [self requestImageFromInternet];
    } else {
        self.image = imageFindFor;
        [self drawImageByDisplayType];
    }
}

- (void)loadImageByUrl:(NSString *)imageUrl byDisplayType:(EImageDisplayType)displayType {
    self.displayType = displayType;
    [self loadImageByUrl:imageUrl];
}

#pragma mark - Private Methods
- (void)requestImageFromInternet {
    
    TWImageView __weak *weakSelf = self;
    if (!self.completionHandler) {
        self.completionHandler = ^(UIImage *image, BOOL succeed){
            if (succeed) {
                [weakSelf imageLoadedSucceed:image];
            } else {
                [weakSelf imageLoadedFailed];
            }
        };
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *imgUrl = [NSURL URLWithString:weakSelf.imageUrl];
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
        
        if( imgData ){
            UIImage *image = [UIImage imageWithData:imgData];
            if (weakSelf && weakSelf.completionHandler) {
                weakSelf.completionHandler(image, TRUE);
            }
        } else {
            if (weakSelf && weakSelf.completionHandler) {
                weakSelf.completionHandler(nil, FALSE);
            }
        }
    });
}

- (void)imageLoadedSucceed:(UIImage *)image {
    TWImageView __weak *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.image = image;
        [weakSelf drawImageByDisplayType];
        [weakSelf hideLoadingAnimation];
    });
    [[TWImageCacheCenter sharedInstance] cacheImage:image withKey:[self.imageUrl MD5]];
}

- (void)imageLoadedFailed {
    TWImageView __weak *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showRefreshBtn];
    });

}

- (void)drawImageByDisplayType {
    if (self.displayType == EImageDisplayTypeNone) {
        return; // Do nothing
    }
    
    UIImage *image = self.image;
    switch (self.displayType) {
        case EImageDisplayTypeProportionScaling:
            image = [image imageProportionScalingForMaxSize:self.frame.size];
            break;
        case EImageDisplayTypeScalingAndCropping:
            image = [image imageByScalingAndCroppingForSize:self.frame.size];
            
        default:
            break;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height);
    self.image = image;
}

- (void)drawRefreshLoadingViews {
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.activityView.hidden = YES;
    [self addSubview:self.activityView];
    
    [self setUserInteractionEnabled:YES];
    self.refreshBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self.refreshBtn setTitle:@"Refresh" forState:UIControlStateNormal];
    [self.refreshBtn addTarget:self action:@selector(onRefreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn setBackgroundColor:[UIColor greenColor]];
    [self addSubview:self.refreshBtn];
    self.refreshBtn.hidden = YES;
}

- (void)onRefreshBtnClicked {
    [self startLoadingAnimation];
    [self requestImageFromInternet];
}

- (void)startLoadingAnimation {
    self.refreshBtn.hidden = YES;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

- (void)hideLoadingAnimation {
    self.refreshBtn.hidden = YES;
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}

- (void)showRefreshBtn {
    self.refreshBtn.hidden = NO;
    [self.activityView stopAnimating];
    self.activityView.hidden = YES;
}

@end
