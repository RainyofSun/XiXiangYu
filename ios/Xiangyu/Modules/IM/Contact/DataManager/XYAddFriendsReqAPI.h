//
//  XYAddFriendsReqAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYBaseAPI.h"

@interface XYAddFriendsResModel : NSObject

@property (nonatomic, strong) NSNumber * type;

@property (nonatomic, strong) NSNumber * price;

@property (nonatomic, copy) NSString * orderNo;

@property (nonatomic, copy) NSString * msg;

@end

@interface XYAddFriendsReqAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userID destUserId:(NSNumber *)destUserId;

@end

