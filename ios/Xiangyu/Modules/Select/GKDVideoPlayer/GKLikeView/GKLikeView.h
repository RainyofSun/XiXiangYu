//
//  GKLikeView.h
//  GKDYVideo
//
//  Created by gaokun on 2019/5/27.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^GKLikeViewBlock)(id   obj);
@interface GKLikeView : UIView

@property (nonatomic, assign) BOOL      isLike;

@property(nonatomic,copy)GKLikeViewBlock block;
- (void)startAnimationWithIsLike:(BOOL)isLike;

- (void)setupLikeState:(BOOL)isLike;

- (void)setupLikeCount:(NSString *)count;

@end

NS_ASSUME_NONNULL_END
