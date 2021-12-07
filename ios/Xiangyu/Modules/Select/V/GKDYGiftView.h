//
//  GKDYGiftView.h
//  Xiangyu
//
//  Created by GQLEE on 2021/3/13.
//

#import <UIKit/UIKit.h>
#import "GKDYVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKDYGiftView : UIView

- (void)requestData;

@property (nonatomic, strong) NSString *user_id;
@property(nonatomic,strong)NSNumber *type;
@property (nonatomic, strong) UIButton              *closeBtn;
@property (nonatomic, copy) void(^closePage)(void);
@property (nonatomic, copy) void(^payWithSuccessGift)(void);//


@end

NS_ASSUME_NONNULL_END
