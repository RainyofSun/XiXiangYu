//
//  XYPerfectOneStepView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/23.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYPerfectOneStepView.h"
#import "XYAddressSelector.h"
#import "XYLinkageRecycleViewController.h"
#import "BRDatePickerView.h"
@interface XYPerfectOneStepView ()

@property(nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *subTitleLable;

@property (nonatomic,strong) XYChooseItemView *hometownItemView;

//@property (nonatomic,strong) XYChooseItemView *permanentItemView;

//@property (nonatomic,strong) XYChooseItemView *birthdayItemView;
//
//@property (nonatomic,strong) XYChooseItemView *industryItemView;
//
//@property (nonatomic, strong) NSDate * selectedDate;
@end

@implementation XYPerfectOneStepView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

#pragma mark - Event
//- (void)selectBirthday {
//  @weakify(self);
//
//[BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"选择日期" selectValue:self.birthdayItemView.content
//                                 minDate:nil
//                                 maxDate:[NSDate date]
//                            isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
//      weak_self.birthdayItemView.content = [selectDate stringWithFormat:XYYTDDateFormatterName];
//      weak_self.birthdate = [selectDate stringWithFormat:XYFullDateFormatterName];
//      weak_self.selectedDate = selectDate;
//  }];
//
//
// // XYDatePickerView *picker = [[XYDatePickerView alloc] init];
////  picker.date = self.selectedDate;
////  picker.selectedBlock = ^(NSDate * _Nonnull date) {
////    weak_self.birthdayItemView.content = [date stringWithFormat:XYYTDDateFormatterName];
////    weak_self.birthdate = [date stringWithFormat:XYFullDateFormatterName];
////    weak_self.selectedDate = date;
////  };
////  [picker show];
//}

//- (void)selectIndustry {
//  @weakify(self);
//  XYLinkageRecycleViewController *vc = [[XYLinkageRecycleViewController alloc] init];
//  vc.selectedBlock = ^(NSString *name, NSNumber *firstCode, NSNumber *secondCode) {
//    weak_self.industryItemView.content = name;
//    weak_self.oneIndustry = firstCode.stringValue;
//    weak_self.twoIndustry = secondCode.stringValue;
//  };
//  [self.targetVc cyl_pushViewController:vc animated:YES];
//}

- (void)chooseAddressWithTag:(NSUInteger)tag {
  [[IQKeyboardManager sharedManager] resignFirstResponder];
  @weakify(self);
  if (tag == 1) {
    XYAddressSelector *selector = [[XYAddressSelector alloc] initWithBaseViewController:self.targetVc withTown:NO desc:@""];
    selector.adcode = self.code;
    selector.chooseFinish = ^(XYFormattedArea *area) {
      weak_self.provinceCode = area.provinceCode;
      weak_self.cityCode = area.cityCode;
      weak_self.code = area.code;
     // weak_self.townCode = area.townCode;
      weak_self.hometownItemView.content = area.formattedAddress;
    };
    [selector show];
  } else {
    XYAddressSelector *selector = [[XYAddressSelector alloc] initWithBaseViewController:self.targetVc withTown:NO];
    selector.adcode = self.dwellCode;
    selector.chooseFinish = ^(XYFormattedArea *area) {
      weak_self.dwellProvinceCode = area.provinceCode;
      weak_self.dwellCityCode = area.cityCode;
      weak_self.dwellCode = area.code;
    //  weak_self.permanentItemView.content = area.formattedAddress;
    };
    [selector show];
  }
}

- (void)addSubviews {
  [self addSubview:self.scrollView];
  [self.scrollView addSubview:self.titleLable];
  [self.scrollView addSubview:self.subTitleLable];
  [self.scrollView addSubview:self.nicknameView];
  [self.scrollView addSubview:self.selectGenderView];
  [self.scrollView addSubview:self.hometownItemView];
 // [self.scrollView addSubview:self.birthdayItemView];
  //[self.scrollView addSubview:self.industryItemView];
//  [self.scrollView addSubview:self.addressView];
//  [self.scrollView addSubview:self.permanentItemView];
  [self addSubview:self.submitButton];
}
- (void)updateConstraints {
  [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);
  }];
  
  [self.titleLable remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.top.equalTo(self.scrollView).offset(8);
  }];
  
  [self.subTitleLable remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.titleLable);
    make.right.equalTo(self.mas_right).offset(-24);
    make.top.equalTo(self.titleLable.mas_bottom).with.offset(16);
  }];
  
  [self.nicknameView remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.top.equalTo(self.subTitleLable.mas_bottom).with.offset(64);
    make.height.mas_equalTo(AdaptedHeight(52));
  }];
  
  [self.selectGenderView remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.top.equalTo(self.nicknameView.mas_bottom).with.offset(16);
    make.height.mas_equalTo(AdaptedHeight(52));
  }];
  
  [self.hometownItemView remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.top.equalTo(self.selectGenderView.mas_bottom).with.offset(16);
    make.height.mas_equalTo(AdaptedHeight(52));
  }];
//
//  [self.birthdayItemView remakeConstraints:^(MASConstraintMaker *make) {
//    make.left.equalTo(self).offset(24);
//    make.right.equalTo(self).offset(-24);
//    make.top.equalTo(self.hometownItemView.mas_bottom).with.offset(16);
//    make.height.mas_equalTo(AdaptedHeight(52));
//  }];
//
//  [self.industryItemView remakeConstraints:^(MASConstraintMaker *make) {
//    make.left.equalTo(self).offset(24);
//    make.right.equalTo(self).offset(-24);
//    make.top.equalTo(self.birthdayItemView.mas_bottom).with.offset(16);
//    make.height.mas_equalTo(AdaptedHeight(52));
//    make.bottom.equalTo(self.scrollView).offset(-120).priority(800);
//  }];
  
  [self.submitButton remakeConstraints:^(MASConstraintMaker *make) {
    
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.height.mas_equalTo(AdaptedHeight(48));
    make.bottom.equalTo(self.mas_bottom).with.offset(-60);
  }];
  [super updateConstraints];
}
#pragma mark - getter
-(UIScrollView *)scrollView{
  if (!_scrollView) {
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
      _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
    }
  }
  return _scrollView;
}
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
      NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"填写资料"];
      [attr addAttributes:@{NSFontAttributeName:AdaptedMediumFont(24),NSForegroundColorAttributeName:ColorHex(XYTextColor_222222)} range:NSMakeRange(0, 4)];
     // [attr addAttributes:@{NSFontAttributeName:AdaptedMediumFont(24),NSForegroundColorAttributeName:ColorHex(XYTextColor_635FF0)} range:NSMakeRange(4, 3)];
      _titleLable.attributedText = attr;
    }
    return _titleLable;
}

- (UILabel *)subTitleLable {
    if (!_subTitleLable) {
        _subTitleLable = [[UILabel alloc] init];
        _subTitleLable.font = AdaptedFont(14);
        _subTitleLable.textColor = ColorHex(XYTextColor_FF5672);
      _subTitleLable.numberOfLines = 0;
        _subTitleLable.text = @"*性别、家乡地注册后将不能更改， 请认真填写真实信息，系统会给您推荐老乡好友。";
    }
    return _subTitleLable;
}

- (XYSelectGenderView *)selectGenderView {
    if (!_selectGenderView) {
        _selectGenderView = [[XYSelectGenderView alloc] init];
    }
    return _selectGenderView;
}

- (XYChooseItemView *)hometownItemView {
  if (!_hometownItemView) {
    @weakify(self);
    _hometownItemView = [[XYChooseItemView alloc] init];
    _hometownItemView.title = @"家乡地";
    _hometownItemView.ChooseItemClick = ^{
      [weak_self chooseAddressWithTag:1];
    };
  }
  return _hometownItemView;
}

//- (XYInputAddressView *)addressView {
//    if (!_addressView) {
//      _addressView = [[XYInputAddressView alloc] init];
//      _addressView.title = @"家乡详细地址";
//    }
//    return _addressView;
//}
//
//- (XYChooseItemView *)permanentItemView {
//    if (!_permanentItemView) {
//      @weakify(self);
//      _permanentItemView = [[XYChooseItemView alloc] init];
//      _permanentItemView.title = @"常驻地";
//      _permanentItemView.ChooseItemClick = ^{
//        [weak_self chooseAddressWithTag:2];
//      };
//    }
//    return _permanentItemView;
//}
//- (XYChooseItemView *)birthdayItemView {
//  if (!_birthdayItemView) {
//    @weakify(self);
//    _birthdayItemView = [[XYChooseItemView alloc] init];
//    _birthdayItemView.title = @"生日";
//    _birthdayItemView.ChooseItemClick = ^{
//      [weak_self selectBirthday];
//    };
//  }
//  return _birthdayItemView;
//}

//- (XYChooseItemView *)industryItemView {
//    if (!_industryItemView) {
//      @weakify(self);
//      _industryItemView = [[XYChooseItemView alloc] init];
//      _industryItemView.title = @"行业";
//      _industryItemView.ChooseItemClick = ^{
//        [weak_self selectIndustry];
//      };
//    }
//    return _industryItemView;
//}
- (XYInputNicknameView *)nicknameView {
    if (!_nicknameView) {
        _nicknameView = [[XYInputNicknameView alloc] init];
    }
    return _nicknameView;
}
- (XYDefaultButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    return _submitButton;
}
@end
