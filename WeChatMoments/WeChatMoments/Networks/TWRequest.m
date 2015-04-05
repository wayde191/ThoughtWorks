//
//  TWRequest.m
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWRequest.h"
#import "TWRequestResponseSuccess.h"
#import "TWRequestResponseFailure.h"

static const CGFloat kTimeout = 30.0;

@interface TWRequest () {
    BOOL _canceled;
}

@end

@implementation TWRequest

- (id)init {
    self = [super init];
    if (self) {
        _canceled = NO;
        self.requestMethod = ERequestMethodGet;
        self.responseParseFormat = EResponseParseFormatJSON;
        self.requestURL = nil;
    }
    return self;
}

+ (id)requestWithName:(NSString *)name forServiceUrl:(NSString *)serviceURL {
    NSAssert((![serviceURL isEqualToString:@""] || !serviceURL), @"ServiceURL is empty!!");
    TWRequest *request = [[TWRequest alloc] init];
    request.requestURL = serviceURL;
    request.requestName = name;
    return request;
}

+ (id)requestWithName:(NSString *)name forServiceUrl:(NSString *)serviceURL withRequestBloc:(TWRequestBlockHandler)customerBlock {
    TWRequest *request = [TWRequest requestWithName:name forServiceUrl:serviceURL];
    request.requestHandler = customerBlock;
    return request;
}

+ (id)requestWithName:(NSString *)name forServiceUrl:(NSString *)serviceURL withDelegate:(id<TWRequestDelegate>) delegate {
    TWRequest *request = [TWRequest requestWithName:name forServiceUrl:serviceURL];
    request.delegate = delegate;
    return request;
}


#pragma mark - Public Methods
- (void)start {
    NSAssert(![SERVICE_ROOT_URL isEqualToString:@""], @"Service root url is empty!!");
    switch (_requestMethod) {
        case ERequestMethodPost:
        case ERequestMethodGet:
            [self startGetRequest];
            break;
        case ERequestMethodMultipartPost:
        case ERequestMethodPut:
            //TODO;
            break;
            
        default:
            break;
    }
}

- (void)cancel {
    // If we want to cancel it really, we cannot use sendSynchronousRequest
    // We need to use normal way like [NSURLConnction start], and cancel it by the way.
    
    [self requestDidCanceled];
}

#pragma mark - Private Methods

-(void)startGetRequest {
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^{
        //TODO: Parameters
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVICE_ROOT_URL, _requestURL]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setTimeoutInterval:kTimeout];
        [urlRequest setHTTPMethod:@"GET"];
        
        [self requestDidStarted];
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        if (_canceled) {
            return ;
        }
        
        if ([data length] > 0 && error == nil)
            [self receivedData:data];
        else if ([data length] == 0 && error == nil)
            [self emptyReply];
        else if (error != nil && error.code == ERequestErrorCodeTimeout)
            [self timedOut];
        else if (error != nil)
            [self downloadError:error];
    });
}

- (void)receivedData:(NSData *)data {
    id object = [self getParsedDic:data];
    NSDictionary *userInfo = @{@"data":object};
    NSDictionary *responseDic = @{@"serviceName":self.requestName,
                                  @"status":@"200",
                                  @"userInfoDic":userInfo};
    [self requestDidFinished:[[TWRequestResponseSuccess alloc] initWithResponse:responseDic]];
}

- (void)emptyReply {
    //TODO
}

- (void)timedOut {
    //TODO
}

- (void)downloadError:(NSError *)error {
    //TODO
}

- (void)requestDidStarted {
    TWLOGINFO(@"%@: requestDidStarted: %@%@", self.requestName, SERVICE_ROOT_URL, self.requestURL);
}

- (void)requestDidCanceled {
    _canceled = YES;
    if (self.delegate) {
        [self.delegate requestDidCanceled];
    }
    
    if (self.requestHandler) {
        _requestHandler(self, ERequestingCanceled, nil, nil);
    }
}

- (void)requestDidFinished:(TWRequestResponseSuccess *)response {
    if (self.delegate) {
        [self.delegate requestDidFinished:response];
    }
    
    if (self.requestHandler) {
        self.requestHandler(self, ERequestingFinished, response, nil);
    }
    
    TWLOGINFO(@"%@: requestDidFinished , %@", self.requestName, response.userInfo);
}

- (void)requestDidFailed:(TWRequestResponseFailure *)response {
}

- (id)getParsedDic:(NSData *)data {
    id obj = nil;
    switch (self.responseParseFormat) {
        case EResponseParseFormatJSON:
            obj = [self getJsonObject:data];
            break;
        case EResponseParseFormatXML:
            //TODO
            break;
            
        default:
            break;
    }
    return obj;
}

- (id)getJsonObject:(NSData *)data {
    //TODO: error Handler
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}
@end
