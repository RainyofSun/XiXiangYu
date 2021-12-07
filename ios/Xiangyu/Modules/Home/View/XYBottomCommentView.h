//
//  XYBottomCommentView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/24.
//

#import <UIKit/UIKit.h>
#import "XYConsultDetailModel.h"
#import "XYDynamicsModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^actionBlock)(NSInteger index, id obj);
@interface XYBottomCommentView : UIView<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *textView;
@property(nonatomic,strong)YYLabel * likeBtn;
@property(nonatomic,strong)YYLabel * evaluateBtn;

@property(nonatomic,strong)UIButton *sendBtn;

@property(nonatomic,strong)XYConsultDetailModel *model;
@property(nonatomic,strong)XYDynamicsModel *dymodel;

@property(nonatomic,copy)actionBlock block;
@end

NS_ASSUME_NONNULL_END
