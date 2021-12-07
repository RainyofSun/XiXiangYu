//
//  XYBlindProfileHeaderCell.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "XYBlindProfileHeaderCell.h"
#import "XYAddressService.h"
#import "XYPlatformService.h"
#import "XYBlindInfoTapView.h"
@interface XYBlindProfileHeaderCell()

@property (nonatomic, strong) UILabel *nameLable;

//@property (nonatomic, strong) UIImageView *sexView;

@property (nonatomic, strong) UIImageView *statusImageView;

@property (nonatomic, strong) YYLabel *ageLable;

//@property (nonatomic, strong) UILabel *heightLable;
//
//@property (nonatomic, strong) UILabel *eduLable;
//
//@property (nonatomic, strong) UILabel *presentAddLable;
//
//@property (nonatomic, strong) UILabel *hometownLable;
//
//@property (nonatomic, strong) UILabel *slognLable;

@property(nonatomic,strong)XYBlindInfoTapView *infoView;
@end

@implementation XYBlindProfileHeaderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
      self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutUI];
    }
    return self;
}

- (void)setModel:(XYBlindProfileModel *)model {
  _model = model;
  if (!model) return;
  self.nameLable.text = model.nickName ?: @"";
  //self.sexView.image = [UIImage imageNamed:model.sex.intValue == 2 ? @"icon_12_girl" : @"icon_12_boy"];
  //model.status.intValue == 1 ||
  self.statusImageView.image = [UIImage imageNamed:( model.status.intValue == 2) ? @"authentication1" : @"authentication2"];
  //self.ageLable.text = model.age ? [NSString stringWithFormat:@"  %@岁  ", model.age] : @"";
  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  // 嵌入 UIImage
  UIImage *image = [UIImage imageNamed:model.sex.intValue == 2 ? @"icon_12_girl" : @"icon_12_boy"];
  NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [all_attr appendAttributedString:image_attr];
  
  //创建属性字符串
  NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@岁", model.age?:@""]];
  text_attr.yy_font = font;
  text_attr.yy_color = ColorHex(XYTextColor_635FF0);
  [all_attr appendAttributedString:text_attr];
  
  // 创建文本容器/
  //YYTextContainer *evaluateContainer = [YYTextContainer new];
// evaluateContainer.size = CGSizeMake(CGFLOAT_MAX, 16);
// evaluateContainer.maximumNumberOfRows = 1;
 
  self.ageLable.attributedText = all_attr;
 // self.ageLable.textLayout = [YYTextLayout layoutWithContainer:evaluateContainer text:all_attr];;
  self.ageLable.textAlignment = NSTextAlignmentCenter;
  

  
  self.infoView.dataSource = model.itemData;
  
  
//  self.heightLable.text = model.age ? [NSString stringWithFormat:@"  %@cm  ", model.height] : @"";
//  self.eduLable.text = model.educationName ? [NSString stringWithFormat:@"  %@  ", model.educationName] : @"";
  
  
 // XYPlatformService *service=[XYPlatformService shareService];
  //NSArray *arr = service.educationData_o;
  
  
  
//  self.presentAddLable.text = model.dwellArea ? [NSString stringWithFormat:@"现居地：%@", [[XYAddressService sharedService] queryCityAreaNameWithAdcode:model.dwellArea]] : @"";
//  self.hometownLable.text = model.area ? [NSString stringWithFormat:@"故乡：%@", [[XYAddressService sharedService] queryCityAreaNameWithAdcode:model.area]] : @"";
//  self.slognLable.text = model.claimStr ?: @"";
}

- (void)layoutUI {
  
  [self.contentView addSubview:self.nameLable];
  [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(16);
      make.top.mas_equalTo(self).offset(16);
  }];
  
//  [self.contentView addSubview:self.sexView];
//  [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.left.mas_equalTo(self.nameLable.mas_right).offset(8);
//    make.centerY.mas_equalTo(self.nameLable);
//    make.width.height.mas_equalTo(12);
//  }];
  

  
  [self.contentView addSubview:self.ageLable];
  [self.ageLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.nameLable.mas_right).offset(5);
      make.centerY.mas_equalTo(self.nameLable);
    make.height.mas_equalTo(AutoSize(20));
    make.width.mas_equalTo(AutoSize(58));
  }];
  
  [self.contentView addSubview:self.statusImageView];
  [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.ageLable.mas_right).offset(12);
    make.centerY.mas_equalTo(self.nameLable);
    make.width.mas_equalTo(68);
    make.height.mas_equalTo(20);
  }];
  
  
  [self.contentView addSubview:self.infoView];
  [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(0);
    make.centerX.equalTo(self.contentView);
    make.top.equalTo(self.nameLable.mas_bottom).offset(AutoSize(5));
  }];
  
  
//  [self.contentView addSubview:self.heightLable];
//  [self.heightLable mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.left.mas_equalTo(self.ageLable.mas_right).offset(8);
//      make.top.mas_equalTo(self.ageLable);
//  }];
//
//  [self.contentView addSubview:self.eduLable];
//  [self.eduLable mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.left.mas_equalTo(self.heightLable.mas_right).offset(8);
//    make.top.mas_equalTo(self.ageLable);
//  }];
//
//  [self.contentView addSubview:self.presentAddLable];
//  [self.presentAddLable mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.left.mas_equalTo(16);
//    make.top.mas_equalTo(self.ageLable.mas_bottom).offset(8);
//  }];
//
//  [self.contentView addSubview:self.hometownLable];
//  [self.hometownLable mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.centerY.mas_equalTo(self.presentAddLable);
//      make.right.mas_equalTo(self.contentView).offset(-16);
//  }];
//
//  [self.contentView addSubview:self.slognLable];
//  [self.slognLable mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.top.mas_equalTo(self.presentAddLable.mas_bottom).offset(16);
//      make.right.mas_equalTo(self.contentView).offset(-16);
//    make.left.mas_equalTo(self.contentView).offset(16);
//  }];

}
#pragma mark - getter

- (UILabel *)nameLable {
    if (!_nameLable) {
      _nameLable = [[UILabel alloc] init];
      _nameLable.textColor = ColorHex(XYTextColor_222222);
      _nameLable.font = AdaptedMediumFont(20);
    }
    return _nameLable;
}

//- (UIImageView *)sexView {
//  if (!_sexView) {
//    _sexView = [[UIImageView alloc] init];
//  }
//  return _sexView;
//}

- (UIImageView *)statusImageView {
  if (!_statusImageView) {
    _statusImageView = [[UIImageView alloc] init];
  }
  return _statusImageView;
}

- (YYLabel *)ageLable {
    if (!_ageLable) {
      _ageLable = [[YYLabel alloc] init];
      _ageLable.backgroundColor = ColorHex(@"#E5E5FE");
      _ageLable.font = AdaptedFont(12);
      [_ageLable roundSize:AutoSize(10)];
      //_ageLable.layer.cornerRadius = 9;
     // _ageLable.layer.masksToBounds = YES;
     // _ageLable.layer.borderWidth = 0.5;
      //_ageLable.layer.borderColor = ColorHex(XYThemeColor_I).CGColor;
    }
    return _ageLable;
}
-(XYBlindInfoTapView *)infoView{
  if (!_infoView) {
    _infoView = [[XYBlindInfoTapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize(30))];
  }
  return _infoView;
}
//- (UILabel *)heightLable {
//    if (!_heightLable) {
//      _heightLable = [[UILabel alloc] init];
//      _heightLable.textColor = ColorHex(XYTextColor_999999);
//      _heightLable.font = AdaptedFont(12);
//      _heightLable.layer.cornerRadius = 9;
//      _heightLable.layer.masksToBounds = YES;
//      _heightLable.layer.borderWidth = 0.5;
//      _heightLable.layer.borderColor = ColorHex(XYThemeColor_I).CGColor;
//    }
//    return _heightLable;
//}
//
//- (UILabel *)eduLable {
//    if (!_eduLable) {
//      _eduLable = [[UILabel alloc] init];
//      _eduLable.textColor = ColorHex(XYTextColor_999999);
//      _eduLable.font = AdaptedFont(12);
//      _eduLable.layer.cornerRadius = 9;
//      _eduLable.layer.masksToBounds = YES;
//      _eduLable.layer.borderWidth = 0.5;
//      _eduLable.layer.borderColor = ColorHex(XYThemeColor_I).CGColor;
//    }
//    return _eduLable;
//}
//
//- (UILabel *)presentAddLable {
//    if (!_presentAddLable) {
//      _presentAddLable = [[UILabel alloc] init];
//      _presentAddLable.textColor = ColorHex(XYTextColor_635FF0);
//      _presentAddLable.font = AdaptedFont(14);
//    }
//    return _presentAddLable;
//}
//
//- (UILabel *)hometownLable {
//    if (!_hometownLable) {
//      _hometownLable = [[UILabel alloc] init];
//      _hometownLable.textColor = ColorHex(XYTextColor_666666);
//      _hometownLable.font = AdaptedFont(14);
//    }
//    return _hometownLable;
//}
//
//- (UILabel *)slognLable {
//    if (!_slognLable) {
//      _slognLable = [[UILabel alloc] init];
//      _slognLable.textColor = ColorHex(XYTextColor_222222);
//      _slognLable.font = AdaptedFont(14);
//      _slognLable.numberOfLines = 0;
//    }
//    return _slognLable;
//}

@end
