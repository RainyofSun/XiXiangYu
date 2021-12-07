//
//  GKDYCommentView.h
//  GKDYVideo
//
//  Created by QuintGao on 2019/5/1.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKDYVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GKDYCommentView : UIView

- (void)requestData;

@property (nonatomic, strong) GKDYVideoModel *videoModel;
@property (nonatomic, strong) UIButton              *closeBtn;

@end

NS_ASSUME_NONNULL_END
