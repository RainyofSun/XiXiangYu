//
//  XYFirendPrefileViewController.h
//  Xiangyu
//
//  Created by Kang on 2021/7/15.
//

#import "GKNavigationBarViewController.h"
#import "TUIFriendProfileControllerServiceProtocol.h"
#import <ImSDK/ImSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface XYFirendPrefileViewController : GKNavigationBarViewController<TUIFriendProfileControllerServiceProtocol>
@property(nonatomic,strong)V2TIMUserFullInfo *userFullInfo;
@end

NS_ASSUME_NONNULL_END
