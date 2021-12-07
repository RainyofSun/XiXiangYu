//
//  XYTimelineProfileInfoCell.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "XYTimelineProfileVideoCell.h"

@interface XYTimelineProfileVideoCell ()

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) YYLabel *numLable;

@property (strong, nonatomic) UIButton *editBtn;

@property (strong, nonatomic) UIButton *deleteBtn;

@end

@implementation XYTimelineProfileVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.iconView];
    [self addSubview:self.numLable];
    [self addSubview:self.editBtn];
    [self addSubview:self.deleteBtn];
    
  [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.top.equalTo(self);
    make.height.mas_equalTo(((kScreenWidth-8)/3)*167/120);
  }];
  
  [self.numLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(8);
    make.right.equalTo(self).offset(-8);
    make.bottom.equalTo(self.iconView.mas_bottom).offset(-8);
    make.height.mas_equalTo(16);
  }];
  
  CGFloat btnWidth = ((kScreenWidth-8)/3 - 12)/2;
  [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(4);
    make.top.equalTo(self.iconView.mas_bottom).offset(4);
    make.width.mas_equalTo(btnWidth);
    make.height.mas_equalTo(24);
  }];
  
  [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self).offset(-4);
    make.top.equalTo(self.iconView.mas_bottom).offset(4);
    make.width.mas_equalTo(btnWidth);
    make.height.mas_equalTo(24);
  }];
}

#pragma - action
- (void)deleteAction {
  if (self.deleteBlock) self.deleteBlock();
}

- (void)editAction {
  if (self.editBlock) self.editBlock();
}

- (void)setShouldEdit:(BOOL)shouldEdit  {
  _shouldEdit = shouldEdit;
  self.editBtn.hidden = !shouldEdit;
}

- (void)setShouldDelete:(BOOL)shouldDelete {
  _shouldDelete = shouldDelete;
  self.deleteBtn.hidden = !shouldDelete;
}

- (void)setCoverUrl:(NSString *)coverUrl {
  _coverUrl = coverUrl;
  [self.iconView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
}
-(void)setLocationUrl:(NSString *)locationUrl{
  _locationUrl = locationUrl;
  self.iconView.image =[UIImage imageWithContentsOfFile:locationUrl];
 // [self.iconView sd_setImageWithURL:[NSURL fileURLWithPath:locationUrl]];
  //self.iconView.image = [];
}

- (void)setCount:(NSString *)count {
  _count = count;
  NSMutableAttributedString *evaluate_attr = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  
  // 嵌入 UIImage
  UIImage *evaluateImage = [UIImage imageNamed:@"icon_14_bofang"];
  NSMutableAttributedString *evaluate_image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:evaluateImage contentMode:UIViewContentModeCenter attachmentSize:evaluateImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [evaluate_attr appendAttributedString:evaluate_image_attr];
  
  //创建属性字符串
  NSMutableAttributedString *evaluate_text_attr = [[NSMutableAttributedString alloc] initWithString:count ? [NSString stringWithFormat:@" %@", count] : @""];
  evaluate_text_attr.yy_font = font;
  evaluate_text_attr.yy_color = ColorHex(XYTextColor_FFFFFF);
  [evaluate_attr appendAttributedString:evaluate_text_attr];
  
   // 创建文本容器
   YYTextContainer *evaluateContainer = [YYTextContainer new];
  evaluateContainer.size = CGSizeMake(CGFLOAT_MAX, 16);
  evaluateContainer.maximumNumberOfRows = 1;
  
  self.numLable.textLayout = [YYTextLayout layoutWithContainer:evaluateContainer text:evaluate_attr];
}

#pragma mark - getter

- (UIImageView *)iconView {
    if (!_iconView) {
      _iconView = [[UIImageView alloc] init];
      _iconView.contentMode = UIViewContentModeScaleAspectFill;
      _iconView.clipsToBounds = YES;
    }
    return _iconView;
}

- (YYLabel *)numLable {
    if (!_numLable) {
      _numLable = [[YYLabel alloc] init];
    }
    return _numLable;
}

- (UIButton *)editBtn {
  if (!_editBtn) {
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setBackgroundColor:ColorHex(@"#635FF0")];
    _editBtn.titleLabel.font = AdaptedMediumFont(12);
    [_editBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    _editBtn.layer.cornerRadius = 12;
    _editBtn.layer.masksToBounds = YES;
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.hidden = YES;
  }
  return _editBtn;
}
- (UIButton *)deleteBtn {
  if (!_deleteBtn) {
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
    _deleteBtn.titleLabel.font = AdaptedMediumFont(12);
    [_deleteBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    _deleteBtn.layer.cornerRadius = 12;
    _deleteBtn.layer.masksToBounds = YES;
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.hidden = YES;
  }
  return _deleteBtn;
}
@end
