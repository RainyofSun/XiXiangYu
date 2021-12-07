//
//  XYPerfectTwoStepView.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/17.
//

#import "XYPerfectTwoStepView.h"
#import "XYChooseItemView.h"
#import "XYPlatformService.h"
#import "XYDatePickerView.h"
#import "XYLinkageRecycleViewController.h"
#import "BRDatePickerView.h"
@interface XYPerfectTwoStepView ()

@property(nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *subTitleLable;

@property (nonatomic,strong) XYChooseItemView *birthdayItemView;

@property (nonatomic,strong) XYChooseItemView *industryItemView;

@property (nonatomic,strong) XYChooseItemView *heightItemView;

@property (nonatomic,strong) XYChooseItemView *educationItemView;

@property (nonatomic,strong) XYChooseItemView *monthlypayItemView;

@property (nonatomic, strong) NSDate * selectedDate;

@end

@implementation XYPerfectTwoStepView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}
#pragma mark - event
- (void)selectMonthlypay {
  [[XYPlatformService shareService] displaySalarySheetViewWithBlock:^(NSString *text, NSNumber *start, NSNumber *end) {
    self.monthlypayItemView.content = text;
    self.salaryStart = start;
    self.salaryEnd = end;
  }];
}

- (void)selectEducation {
  [[XYPlatformService shareService] displayEduSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    self.educationItemView.content = text;
    self.education = ID;
  }];
}

- (void)selectHeight {
  [[XYPlatformService shareService] displayHeightSheetViewWithBlock:^(NSString *text, NSNumber *size) {
    self.heightItemView.content = text;
    self.height = size;
  }];
}

- (void)selectBirthday {
  @weakify(self);
  
[BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"选择日期" selectValue:self.birthdayItemView.content
                                 minDate:nil
                                 maxDate:[NSDate date]
                            isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
      weak_self.birthdayItemView.content = [selectDate stringWithFormat:XYYTDDateFormatterName];
      weak_self.birthdate = [selectDate stringWithFormat:XYFullDateFormatterName];
      weak_self.selectedDate = selectDate;
  }];
  
  
 // XYDatePickerView *picker = [[XYDatePickerView alloc] init];
//  picker.date = self.selectedDate;
//  picker.selectedBlock = ^(NSDate * _Nonnull date) {
//    weak_self.birthdayItemView.content = [date stringWithFormat:XYYTDDateFormatterName];
//    weak_self.birthdate = [date stringWithFormat:XYFullDateFormatterName];
//    weak_self.selectedDate = date;
//  };
//  [picker show];
}

- (void)selectIndustry {
  @weakify(self);
  XYLinkageRecycleViewController *vc = [[XYLinkageRecycleViewController alloc] init];
  vc.selectedBlock = ^(NSString *name, NSNumber *firstCode, NSNumber *secondCode) {
    weak_self.industryItemView.content = name;
    weak_self.oneIndustry = firstCode.stringValue;
    weak_self.twoIndustry = secondCode.stringValue;
  };
  [self.targetVc cyl_pushViewController:vc animated:YES];
}

- (void)addSubviews {
  [self addSubview:self.scrollView];
  
  [self.scrollView addSubview:self.titleLable];
  [self.scrollView addSubview:self.subTitleLable];
  [self.scrollView addSubview:self.birthdayItemView];
  [self.scrollView addSubview:self.industryItemView];
  [self.scrollView addSubview:self.heightItemView];
  [self.scrollView addSubview:self.educationItemView];
  [self.scrollView addSubview:self.monthlypayItemView];
  [self addSubview:self.submitButton];
}
- (void)updateConstraints {
  [self.scrollView remakeConstraints:^(MASConstraintMaker *make) {
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
  
  [self.birthdayItemView remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.top.equalTo(self.subTitleLable.mas_bottom).with.offset(64);
    make.height.mas_equalTo(AdaptedHeight(52));
  }];
  
  [self.industryItemView remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.top.equalTo(self.birthdayItemView.mas_bottom).with.offset(16);
    make.height.mas_equalTo(AdaptedHeight(52));
  }];
  
  [self.heightItemView remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.top.equalTo(self.industryItemView.mas_bottom).with.offset(16);
    make.height.mas_equalTo(AdaptedHeight(52));
  }];
  
  [self.educationItemView remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.top.equalTo(self.heightItemView.mas_bottom).with.offset(16);
    make.height.mas_equalTo(AdaptedHeight(52));
  }];
  
  [self.monthlypayItemView remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(24);
    make.right.equalTo(self).offset(-24);
    make.top.equalTo(self.educationItemView.mas_bottom).with.offset(16);
    make.height.mas_equalTo(AdaptedHeight(52));
    make.bottom.equalTo(self.scrollView).offset(-120).priority(800);
  }];
  
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
      NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"填写资料2/2"];
      [attr addAttributes:@{NSFontAttributeName:AdaptedMediumFont(24),NSForegroundColorAttributeName:ColorHex(XYTextColor_222222)} range:NSMakeRange(0, 4)];
      [attr addAttributes:@{NSFontAttributeName:AdaptedMediumFont(24),NSForegroundColorAttributeName:ColorHex(XYTextColor_635FF0)} range:NSMakeRange(4, 3)];
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
        _subTitleLable.text = @"*生日、行业为必填项，生日填写后不允许更改";
    }
    return _subTitleLable;
}

- (XYChooseItemView *)birthdayItemView {
  if (!_birthdayItemView) {
    @weakify(self);
    _birthdayItemView = [[XYChooseItemView alloc] init];
    _birthdayItemView.title = @"*生日";
    _birthdayItemView.ChooseItemClick = ^{
      [weak_self selectBirthday];
    };
  }
  return _birthdayItemView;
}

- (XYChooseItemView *)industryItemView {
    if (!_industryItemView) {
      @weakify(self);
      _industryItemView = [[XYChooseItemView alloc] init];
      _industryItemView.title = @"*行业";
      _industryItemView.ChooseItemClick = ^{
        [weak_self selectIndustry];
      };
    }
    return _industryItemView;
}

- (XYChooseItemView *)heightItemView {
    if (!_heightItemView) {
      @weakify(self);
      _heightItemView = [[XYChooseItemView alloc] init];
      _heightItemView.title = @"身高";
      _heightItemView.ChooseItemClick = ^{
        [weak_self selectHeight];
      };
    }
    return _heightItemView;
}

- (XYChooseItemView *)educationItemView {
    if (!_educationItemView) {
      @weakify(self);
        _educationItemView = [[XYChooseItemView alloc] init];
      _educationItemView.title = @"学历";
      _educationItemView.ChooseItemClick = ^{
        [weak_self selectEducation];
      };
    }
    return _educationItemView;
}

- (XYChooseItemView *)monthlypayItemView {
    if (!_monthlypayItemView) {
      @weakify(self);
      _monthlypayItemView = [[XYChooseItemView alloc] init];
      _monthlypayItemView.title = @"月薪";
      _monthlypayItemView.ChooseItemClick = ^{
        [weak_self selectMonthlypay];
      };
    }
    return _monthlypayItemView;
}

- (XYDefaultButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"完成注册" forState:UIControlStateNormal];
    }
    return _submitButton;
}
@end
