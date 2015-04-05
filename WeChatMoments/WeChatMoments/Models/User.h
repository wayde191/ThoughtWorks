//
//  User.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/5/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#import "TWBaseModel.h"

@interface User : TWBaseModel

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *profileImage;

- (id)initWithDic:(NSDictionary *)userInfo;

@end
