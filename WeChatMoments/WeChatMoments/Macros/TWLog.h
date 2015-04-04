//
//  TWLog.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#ifndef WeChatMoments_TWLog_h
#define WeChatMoments_TWLog_h

#define TWLOGPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#if APP_PRODUCTION_ENVIRONMENT == 1
#define TWLOGINFO(xx, ...)  TWLOGPRINT(xx, ##__VA_ARGS__)
#else
#define TWLOGINFO(xx, ...)  ((void)0)
#endif

#endif
