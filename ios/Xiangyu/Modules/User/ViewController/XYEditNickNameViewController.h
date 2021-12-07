//
//  XYEditNickNameViewController.h
//  Xiangyu
//
//  Created by Kang on 2021/6/27.
//

#import "GKNavigationBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYEditNickNameViewController : GKNavigationBarViewController
@property(nonatomic,copy)NSDictionary *pram;
@property (nonatomic,copy)void(^saveBlock)(NSString *text);
@end

NS_ASSUME_NONNULL_END
