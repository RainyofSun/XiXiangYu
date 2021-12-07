//
//  XYAddTopicViewController.h
//  Xiangyu
//
//  Created by Kang on 2021/7/3.
//

#import "GKNavigationBarViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^topicBlock)(id obj);
@interface XYAddTopicViewController : GKNavigationBarViewController
@property(nonatomic,copy)topicBlock block;
@end

NS_ASSUME_NONNULL_END
