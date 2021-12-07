//
//  XYPerfectInformationPopView.h
//  Xiangyu
//
//  Created by Kang on 2021/8/8.
//

#import "FWPopupBaseView.h"
#import "XYPerfectProfileModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYPerfectInformationPopView : FWPopupBaseView
@property(nonatomic,strong)UIImageView *topImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIButton *confirmBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,copy) void(^successBlock)(id item);
@end

NS_ASSUME_NONNULL_END
