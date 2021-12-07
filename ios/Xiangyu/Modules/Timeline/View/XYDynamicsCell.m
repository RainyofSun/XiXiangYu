//
//  XYDynamicsCell.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYDynamicsCell.h"

@implementation XYDynamicsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup {
    [self.contentView addSubview:self.portrait];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.sexView];
    [self.contentView addSubview:self.attentionBtn];
  //  [self.contentView addSubview:self.ageLabel];
    [self.contentView addSubview:self.locationLabel];
    [self.contentView addSubview:self.hometownLable];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.moreLessDetailBtn];
    [self.contentView addSubview:self.picContainerView];
  [self.contentView addSubview:self.topicLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.likeBtn];
    [self.contentView addSubview:self.evaluateBtn];
    [self.contentView addSubview:self.dividingLine];
}

#pragma - action
- (void)moreLessAction {
  if (self.delegate && [self.delegate respondsToSelector:@selector(DidClickMoreLessInDynamicsCell:)]) {
      [self.delegate DidClickMoreLessInDynamicsCell:self];
  }
}

- (void)attentionAction {
  if (self.layout.model.userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DidClickDeleteInDynamicsCell:)]) {
        [self.delegate DidClickDeleteInDynamicsCell:self];
    }
  } else {
    if (self.layout.model.isFollow.integerValue == 1) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(DidClickCancelAttentionInDynamicsCell:)]) {
          [self.delegate DidClickCancelAttentionInDynamicsCell:self];
      }
    } else {
      if (self.delegate && [self.delegate respondsToSelector:@selector(DidClickAttentionInDynamicsCell:)]) {
          [self.delegate DidClickAttentionInDynamicsCell:self];
      }
    }
  }
}

-(void)setLayout:(XYDynamicLayout *)layout {
    UIView * lastView;
    _layout = layout;
    XYDynamicsModel * model = layout.model;
    
    //头像
    _portrait.left = kDynamicsNormalPadding;
    _portrait.top = kDynamicsNormalPadding;
    _portrait.size = CGSizeMake(kDynamicsPortraitWidthAndHeight, kDynamicsPortraitWidthAndHeight);
    _portrait.layer.cornerRadius = kDynamicsPortraitWidthAndHeight/2;
    _portrait.layer.masksToBounds = YES;
    [_portrait sd_setImageWithURL:[NSURL URLWithString:model.headPortrait]];
    
    //昵称
    _nameLabel.text = model.nickName;
    _nameLabel.top = kDynamicsNormalPadding;
    _nameLabel.left = _portrait.XY_right + kDynamicsPortraitNamePadding;
    _nameLabel.size = [_nameLabel sizeThatFits:CGSizeZero];
    
    //性别
    _sexView.image = model.sex.integerValue == 2 ? [UIImage imageNamed:@"icon_12_girl"] : [UIImage imageNamed:@"icon_12_boy"];
    _sexView.size = model.isExt.integerValue == 1 ? CGSizeZero : CGSizeMake(12, 12);
    _sexView.XY_centerY = _nameLabel.XY_centerY;
    _sexView.left = _nameLabel.XY_right + 4;
  
    //关注按钮
    _attentionBtn.XY_size = model.isExt.integerValue == 1 ? CGSizeZero : CGSizeMake(56, 24);
    _attentionBtn.XY_centerY = _portrait.XY_centerY;
    _attentionBtn.XY_right = kScreenWidth - kDynamicsNormalPadding;
  if (self.layout.model.userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue) {
      _attentionBtn.enabled = YES;
      [_attentionBtn setTitle:@"删除" forState:UIControlStateNormal];
      _attentionBtn.layer.borderColor = ColorHex(XYThemeColor_A).CGColor;
      _attentionBtn.layer.borderWidth = 0.5;
      [_attentionBtn setBackgroundColor:ColorHex(XYThemeColor_B)];
      [_attentionBtn setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
      [_attentionBtn setTitleColor:ColorHex(XYTextColor_CCCCCC) forState:UIControlStateDisabled];
    } else {
      if (layout.model.isFollow.integerValue == 1) {
        _attentionBtn.enabled = NO;
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        _attentionBtn.layer.borderWidth = 0.0;
        [_attentionBtn setBackgroundColor:ColorHex(XYThemeColor_I)];
        [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
      } else {
        _attentionBtn.enabled = YES;
        _attentionBtn.layer.borderWidth = 0.0;
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
        [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
      }
    }
  
    //年龄
//    _ageLabel.text = [NSString stringWithFormat:@"  %@岁  ", model.age];
//    _ageLabel.XY_left = _nameLabel.XY_left;
//    _ageLabel.XY_top = _nameLabel.XY_bottom + 4;
//    _ageLabel.size = model.isExt.integerValue == 1 ? CGSizeZero : [_ageLabel sizeThatFits:CGSizeZero];
  
  //时间
  _dateLabel.left = _nameLabel.XY_left;
  _dateLabel.top = _nameLabel.XY_bottom  + 4;
  NSString * newTime = [model.createTime formateDateWithFormate:XYFullDateFormatterName];
  _dateLabel.text = newTime;
  CGSize dateSize = [_dateLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, kDynamicsNameHeight)];
  _dateLabel.width = dateSize.width;
  _dateLabel.height = model.isExt.integerValue == 1 ? 0 : kDynamicsNameHeight;
  
  
    //定位
    _locationLabel.textLayout = layout.locationLayout;
    _locationLabel.XY_left = _nameLabel.XY_left;
    _locationLabel.XY_top = _dateLabel.XY_bottom + 4;
    _locationLabel.size = model.isExt.integerValue == 1 ? CGSizeZero : layout.locationLayout.textBoundingSize;

    //家乡
    _hometownLable.textLayout = layout.homeTownLayout;
    _hometownLable.XY_size = model.isExt.integerValue == 1 ? CGSizeZero : layout.homeTownLayout.textBoundingSize;
    _hometownLable.XY_right = _attentionBtn.XY_right;
    _hometownLable.XY_top = _dateLabel.XY_bottom + 4;
    
    //描述
    _detailLabel.left = _nameLabel.XY_left;
  _detailLabel.top = model.isExt.integerValue == 1 ? _nameLabel.XY_bottom + kDynamicsNameDetailPadding : _hometownLable.XY_bottom + kDynamicsNameDetailPadding;
    _detailLabel.width = kScreenWidth - kDynamicsNormalPadding * 2 - kDynamicsPortraitNamePadding - kDynamicsPortraitWidthAndHeight;
    _detailLabel.height = layout.detailLayout.textBoundingSize.height;
    _detailLabel.textLayout = layout.detailLayout;
    lastView = _detailLabel;
    
    //展开/收起按钮
    _moreLessDetailBtn.left = _nameLabel.XY_left;
    _moreLessDetailBtn.top = _detailLabel.XY_bottom + kDynamicsNameDetailPadding;
    _moreLessDetailBtn.height = kDynamicsMoreLessButtonHeight;
    [_moreLessDetailBtn sizeToFit];
    
    if (model.shouldShowMoreButton) {
      _moreLessDetailBtn.hidden = NO;
      [_moreLessDetailBtn setTitle:@"全文" forState:UIControlStateNormal];
      lastView = _moreLessDetailBtn;
    }else{
        _moreLessDetailBtn.hidden = YES;
    }
    //图片集
    if (model.images.count != 0) {
        _picContainerView.hidden = NO;
        _picContainerView.left = _nameLabel.XY_left;
        _picContainerView.top = lastView.XY_bottom + kDynamicsNameDetailPadding;
        _picContainerView.width = layout.photoContainerSize.width;
        _picContainerView.height = layout.photoContainerSize.height;
      @weakify(self);
      _picContainerView.clickBlock = ^{
        if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DidClickImageOrVideoInDynamicsCell:)]) {
            [weak_self.delegate DidClickImageOrVideoInDynamicsCell:weak_self];
        }
      };
      if (model.type.integerValue == 3) {
        _picContainerView.videoImage = YES;
        _picContainerView.picPathStringsArray = @[model.coverUrl];
      } else {
        _picContainerView.videoImage = NO;
        _picContainerView.picPathStringsArray = model.images;
      }
        lastView = _picContainerView;
    }else{
        _picContainerView.hidden = YES;
    }
  
  
  if ([model.subjectId integerValue]>0) {
    NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
    NSMutableAttributedString *textt_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"# "]];
    textt_attr.yy_font = AdaptedFont(14);
    textt_attr.yy_color = ColorHex(@"#F92B5E");
    [all_attr appendAttributedString:textt_attr];
//
//    //创建属性字符串
    NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.subjectText]];
    text_attr.yy_font = AdaptedFont(14);
    text_attr.yy_color = ColorHex(XYTextColor_333333);
    [all_attr appendAttributedString:text_attr];
    self.topicLabel.attributedText = all_attr;
//    [self.topicLabel sizeToFit];
//
   CGSize size =  [[NSString stringWithFormat:@"# %@",model.subjectText] sizeForFont:AdaptedFont(14) size:CGSizeMake(AutoSize(240), AutoSize(20)) mode:NSLineBreakByWordWrapping];
    self.topicLabel.textAlignment = NSTextAlignmentCenter;
    self.topicLabel.left = _detailLabel.XY_left;
    self.topicLabel.top = lastView.XY_bottom + kDynamicsPortraitNamePadding;
    self.topicLabel.width = size.width + AutoSize(20);
   self.topicLabel.height = AutoSize(20);
   // self.topicLabel.titleLabel.text =model.subjectText;
    self.topicLabel.hidden = NO;
    lastView = self.topicLabel;
  }else{
    self.topicLabel.hidden = YES;
  }
    
 
    
    //评价
    _evaluateBtn.size = model.isExt.integerValue == 1 ? CGSizeZero : layout.evaluateLayout.textBoundingSize;
    _evaluateBtn.right = _detailLabel.XY_right;
  //  _evaluateBtn.centerY = _dateLabel.XY_centerY;
  
  _evaluateBtn.top = lastView.XY_bottom + 4;
  
    _evaluateBtn.textLayout = layout.evaluateLayout;
    
    //点赞
    _likeBtn.size = model.isExt.integerValue == 1 ? CGSizeZero : layout.likeLayout.textBoundingSize;
    _likeBtn.right = _evaluateBtn.XY_left - 16;
    _likeBtn.centerY = _evaluateBtn.XY_centerY;
    _likeBtn.textLayout = layout.likeLayout;
    
    //分割线
    _dividingLine.left = _detailLabel.XY_left;
    _dividingLine.height = .5;
    _dividingLine.right = _detailLabel.XY_right;
    _dividingLine.bottom = layout.height - .5;
    
  @weakify(self);
    layout.clickUrlBlock = ^(NSString *url) {
        if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DynamicsCell:didClickUrl:PhoneNum:)]) {
            [weak_self.delegate DynamicsCell:weak_self didClickUrl:url PhoneNum:nil];
        }
    };

    layout.clickPhoneNumBlock = ^(NSString *phoneNum) {
        if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DynamicsCell:didClickUrl:PhoneNum:)]) {
            [weak_self.delegate DynamicsCell:weak_self didClickUrl:nil PhoneNum:phoneNum];
        }
    };
}

#pragma mark - getter
- (UIImageView *)portrait {
    if(!_portrait){
        _portrait = [UIImageView new];
        _portrait.userInteractionEnabled = YES;
        _portrait.backgroundColor = [UIColor grayColor];
        @weakify(self);
      UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
          if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
              [weak_self.delegate DynamicsCell:weak_self didClickUser:weak_self.layout.model.userId.stringValue];
          }
        }];
        [_portrait addGestureRecognizer:tapGR];
    }
    return _portrait;
}

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [YYLabel new];
      _nameLabel.font = AdaptedMediumFont(16);
      _nameLabel.textColor = ColorHex(XYTextColor_333333);
    }
    return _nameLabel;
}

- (UIImageView *)sexView {
    if(!_sexView){
      _sexView = [UIImageView new];
    }
    return _sexView;
}


-(YYLabel *)locationLabel {
    if (!_locationLabel) {
      _locationLabel = [YYLabel new];
    }
    return _locationLabel;
}


-(YYLabel *)hometownLable {
    if (!_hometownLable) {
      _hometownLable = [YYLabel new];
      _hometownLable.font = AdaptedFont(12);
      _hometownLable.textColor = ColorHex(XYTextColor_999999);
    }
    return _hometownLable;
}

-(YYLabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [YYLabel new];
      @weakify(self);
      _detailLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DidClickTextInDynamicsCell:)]) {
            [weak_self.delegate DidClickTextInDynamicsCell:weak_self];
        }
      };
      _detailLabel.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        XYToastText(@"文字复制成功!");
          UIPasteboard * board = [UIPasteboard generalPasteboard];
          board.string = text.string;
      };
    }
    return _detailLabel;
}

- (XYDefaultButton *)attentionBtn {
    if (!_attentionBtn) {
      _attentionBtn = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
      _attentionBtn.titleLabel.font = AdaptedFont(12);
      [_attentionBtn addTarget:self action:@selector(attentionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

//- (YYLabel *)ageLabel {
//    if (!_ageLabel) {
//      _ageLabel = [YYLabel new];
//      _ageLabel.font = AdaptedFont(12);
//      _ageLabel.textColor = ColorHex(XYTextColor_999999);
//      _ageLabel.layer.borderColor = ColorHex(XYThemeColor_I).CGColor;
//      _ageLabel.layer.borderWidth = 0.5;
//      _ageLabel.layer.cornerRadius = 9;
//    }
//    return _ageLabel;
//}

-(UIButton *)moreLessDetailBtn {
    if (!_moreLessDetailBtn) {
        _moreLessDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreLessDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreLessDetailBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:90/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
        _moreLessDetailBtn.hidden = YES;
      [_moreLessDetailBtn addTarget:self action:@selector(moreLessAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreLessDetailBtn;
}

- (XYPhotoContainerView *)picContainerView {
    if (!_picContainerView) {
        _picContainerView = [XYPhotoContainerView new];
        _picContainerView.hidden = YES;
    }
    return _picContainerView;
}

-(YYLabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [YYLabel new];
        _dateLabel.textColor = [UIColor lightGrayColor];
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateLabel;
}
-(YYLabel *)topicLabel{
  if (!_topicLabel) {
    _topicLabel =  [[YYLabel alloc]initWithFrame:CGRectZero];
    _topicLabel.textAlignment = NSTextAlignmentCenter;
    _topicLabel.backgroundColor = ColorHex(@"#EEEEEE");
   _topicLabel.font = AdaptedFont(14);
   [_topicLabel roundSize:AutoSize(10)];
    @weakify(self);
   _topicLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
  //  [_topicLabel handleTapGestureRecognizerEventWithBlock:^(id sender) {
      @strongify(self);
      
      if (self.delegate && [self.delegate respondsToSelector:@selector(DidClickTopicInDynamicsCell:)]) {
        [self.delegate DidClickTopicInDynamicsCell:self];
      }
   // }];
    
     
    };
  }
  return _topicLabel;
}

-(YYLabel *)likeBtn {
    if (!_likeBtn) {
      _likeBtn = [YYLabel new];
      @weakify(self);
      _likeBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (weak_self.layout.model.isFabulous.integerValue == 1) {
          if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DidClickCancelThunmbInDynamicsCell:)]) {
              [weak_self.delegate DidClickCancelThunmbInDynamicsCell:weak_self];
          }
        } else {
          if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DidClickThunmbInDynamicsCell:)]) {
              [weak_self.delegate DidClickThunmbInDynamicsCell:weak_self];
          }
        }
        };
    }
    return _likeBtn;
}

-(YYLabel *)evaluateBtn {
    if (!_evaluateBtn) {
      _evaluateBtn = [YYLabel new];
      @weakify(self);
      _evaluateBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DidClickCommentInDynamicsCell:)]) {
            [weak_self.delegate DidClickCommentInDynamicsCell:weak_self];
        }
        };
    }
    return _evaluateBtn;
}

- (UIView *)dividingLine {
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = [UIColor lightGrayColor];
        _dividingLine.alpha = .3;
    }
    return _dividingLine;
}

@end
