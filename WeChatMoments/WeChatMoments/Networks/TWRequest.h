//
//  TWRequest.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SERVICE_ROOT_URL
#define SERVICE_ROOT_URL    @""
#endif

typedef enum {
    ERequestStatusFail = 0,
    ERequestStatusSucc = 1,
} ERequestResponseStatus;

typedef enum {
    ERequestErrorCodeTimeout = 256,
    ERequestErrorCodeNotFound = 404,
    ERequestErrorCodeServerError = 500,
} ERequestErrorCode;

typedef enum{
    ERequestMethodGet = 1,
    ERequestMethodPost = 2,
    ERequestMethodMultipartPost = 3,
    ERequestMethodPut = 4
} ERequestMethod;

typedef enum{
    EResponseParseFormatJSON = 0,
    EResponseParseFormatXML = 1,
} EResponseParseFormat;

typedef enum {
    ERequestingStarted = 0,
    ERequestingCanceled,
    ERequestingFinished,
    ERequestingFailed,
}ERequestingStatus;

#pragma mark - TWRequestDelegate
@class TWRequestResponseFailure, TWRequestResponseSuccess;
@protocol TWRequestDelegate <NSObject>
@required
- (void)requestDidStarted;
- (void)requestDidCanceled;
- (void)requestDidFinished:(TWRequestResponseSuccess *)response;
- (void)requestDidFailed:(TWRequestResponseFailure *)response;
@end

@interface TWRequest : NSObject

typedef void(^TWRequestBlockHandler)(TWRequest *request, ERequestingStatus requestingStatus, TWRequestResponseSuccess *responseSuccess, TWRequestResponseFailure *responseFailed);

@property (nonatomic, weak) id<TWRequestDelegate> delegate;
@property (nonatomic, strong) TWRequestBlockHandler requestHandler;
@property (nonatomic, strong) NSString *requestName;
@property (nonatomic, strong) NSString *requestURL;
@property (nonatomic, assign) EResponseParseFormat responseParseFormat;
@property (nonatomic, assign) ERequestMethod requestMethod;

- (void)start;
- (void)cancel;

+ (id)requestWithName:(NSString *)name forServiceUrl:(NSString *)serviceURL;
+ (id)requestWithName:(NSString *)name forServiceUrl:(NSString *)serviceURL withRequestBloc:(TWRequestBlockHandler)customerBlock;
+ (id)requestWithName:(NSString *)name forServiceUrl:(NSString *)serviceURL withDelegate:(id<TWRequestDelegate>) delegate;




@end
