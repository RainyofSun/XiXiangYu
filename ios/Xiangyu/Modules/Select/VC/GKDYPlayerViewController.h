//
//  GKDYPlayerViewController.h
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import <GKNavigationBarViewController/GKNavigationBarViewController.h>
#import "GKDYVideoView.h"

NS_ASSUME_NONNULL_BEGIN

@class GKDYPlayerViewController;

@protocol GKDYPlayerViewControllerDelegate <NSObject>

- (void)playerVCDidClickShoot:(GKDYPlayerViewController *)playerVC;

- (void)playerVC:(GKDYPlayerViewController *)playerVC controlView:(GKDYVideoControlView *)controlView isCritical:(BOOL)isCritical;

@end

@interface GKDYPlayerViewController : GKNavigationBarViewController

@property (nonatomic, strong) GKDYVideoView *videoView;

@property (nonatomic, weak) id<GKDYPlayerViewControllerDelegate> delegate;

// 播放单个视频
- (instancetype)initWithVideoModel:(GKDYVideoModel *)model;
// 关闭刷新
@property (nonatomic, assign) BOOL                  isRefreshing;

// 播放一组视频，并指定播放位置
- (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
