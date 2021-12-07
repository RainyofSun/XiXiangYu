//
//  XYAddFriendsResponeAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYBaseAPI.h"

@interface XYAddFriendsResponeAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userID destUserId:(NSNumber *)destUserId;

@end

@interface XYBlindDateReachObjAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userID destUserId:(NSNumber *)destUserId;

@end
