//
//  XYDynamicsDetailHeaderView.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/25.
//

#import <UIKit/UIKit.h>
#import "XYDynamicsModel.h"

typedef NS_ENUM(NSInteger, XYDynamicsDetailType) {
  XYDynamicsDetailType_Text      = 1,
  XYDynamicsDetailType_Image    = 2,
  XYDynamicsDetailType_Video     = 3
};

@interface XYDynamicsDetailHeaderView : UIView

@property(nonatomic,strong)YYLabel *fabulousLabel;
- (instancetype)initWithType:(XYDynamicsDetailType)type contentLayout:(YYTextLayout *)layout;

@property (nonatomic, copy) NSString *creatTime;
@property (nonatomic,strong) XYDynamicsModel *dynamicsModel;
@property (nonatomic, copy) NSString *coverImageUrl;

@property (nonatomic, copy) NSArray <NSString *> *resources;
@property(nonatomic,strong)YYLabel *topicLabel;
- (void)releasePlayer;

@end
