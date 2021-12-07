//
//  XYBottomCommentView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/24.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYBottomCommentView.h"
//@interface XYBottomCommentView()
//@property(nonatomic,strong)YYTextLayout * likeLayout;
//@property(nonatomic,strong)YYTextLayout * evaluateLayout;
//@end
@implementation XYBottomCommentView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  
  [self addSubview:self.textView];
  [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(ADAPTATIONRATIO*30);
    make.top.equalTo(self).offset(ADAPTATIONRATIO*12);
    make.height.mas_equalTo(ADAPTATIONRATIO*76);
    make.bottom.equalTo(self).offset(-ADAPTATIONRATIO*12-GK_SAFEAREA_BTM);
    make.trailing.equalTo(self).offset(-ADAPTATIONRATIO*300);
  }];
  
  [self addSubview:self.evaluateBtn];
  [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.textView.mas_trailing).offset(ADAPTATIONRATIO*20);
    make.width.mas_equalTo(ADAPTATIONRATIO*120);
    make.centerY.equalTo(self.textView);
  }];
  
  [self addSubview:self.likeBtn];
  [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self).offset(-20*ADAPTATIONRATIO);
    make.width.mas_equalTo(ADAPTATIONRATIO*120);
    make.centerY.equalTo(self.textView);
  }];
  
  [self addSubview:self.sendBtn];
  [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.likeBtn);
    make.centerY.equalTo(self.textView);
    make.width.height.mas_equalTo(ADAPTATIONRATIO*76);
  }];
}

-(UITextField *)textView{
  if (!_textView) {
    _textView = [UITextField new];
//    _textView.enabled = NO;
    _textView.font = AdaptedMediumFont(XYFont_D);
    _textView.placeholder = @"写评论";
    _textView.backgroundColor =ColorHex(@"#F5F5F5");
    _textView.layer.cornerRadius = 19;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _textView.leftView = view;
    _textView.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _textView.rightView = rview;
    _textView.rightViewMode = UITextFieldViewModeAlways;
  }
  return _textView;
}
-(YYLabel *)likeBtn {
    if (!_likeBtn) {
      _likeBtn = [YYLabel new];
      @weakify(self);
      _likeBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        BOOL isFabulous = NO;
        if (self.model) {
          isFabulous = [self.model.isFabulous integerValue];
        }else if(self.dymodel){
          isFabulous = [self.dymodel.isFabulous integerValue];
        }
        
        if (self.block) {
          self.block(isFabulous?1:2, self.model?:self.dymodel);
        }
//        if (weak_self.layout.model.isFabulous.integerValue == 1) {
//          if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DidClickCancelThunmbInDynamicsCell:)]) {
//              [weak_self.delegate DidClickCancelThunmbInDynamicsCell:weak_self];
//          }
//        } else {
////          if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DidClickThunmbInDynamicsCell:)]) {
////              [weak_self.delegate DidClickThunmbInDynamicsCell:weak_self];
////          }
//        }
        };
    }
    return _likeBtn;
}

-(YYLabel *)evaluateBtn {
    if (!_evaluateBtn) {
      _evaluateBtn = [YYLabel new];
      @weakify(self);
      _evaluateBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        if (self.block) {
          self.block(0, self.model?:self.dymodel);
        }
//        if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(DidClickCommentInDynamicsCell:)]) {
//            [weak_self.delegate DidClickCommentInDynamicsCell:weak_self];
//        }
        };
    }
    return _evaluateBtn;
}
-(UIButton *)sendBtn{
  if (!_sendBtn) {
    _sendBtn = [UIButton new];
    [_sendBtn setImage:[UIImage imageNamed:@"icon_32_send"] forState:UIControlStateNormal];
    _sendBtn.hidden = YES;
    [_sendBtn addTarget:self action:@selector(sendBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
   // [_sendBtn h]
  }
  return _sendBtn;
}
- (void)layoutLike:(NSString *)fabulousCount selected:(BOOL)selected {
  NSMutableAttributedString *like_attr = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  
  // 嵌入 UIImage
  UIImage *likeImage = [UIImage imageNamed:selected? @"icon_22_dianzan_normal" : @"icon_22_dianzan_selected"];
  NSMutableAttributedString *like_image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:likeImage contentMode:UIViewContentModeCenter attachmentSize:likeImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [like_attr appendAttributedString:like_image_attr];
  
  //创建属性字符串
  NSMutableAttributedString *like_text_attr = [[NSMutableAttributedString alloc] initWithString:fabulousCount];
  like_text_attr.yy_font = font;
  like_text_attr.yy_color = ColorHex(XYTextColor_999999);
  [like_attr appendAttributedString:like_text_attr];
  
   // 创建文本容器
   YYTextContainer *container = [YYTextContainer new];
   container.size = CGSizeMake(CGFLOAT_MAX, 22);
   container.maximumNumberOfRows = 1;
  
  self.likeBtn.textLayout = [YYTextLayout layoutWithContainer:container text:like_attr];
  

}

- (void)layoutEvaluate:(NSString *)comment_Count {
  NSMutableAttributedString *evaluate_attr = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  
  // 嵌入 UIImage
  UIImage *evaluateImage = [UIImage imageNamed:@"icon_22_pinglu"];
  NSMutableAttributedString *evaluate_image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:evaluateImage contentMode:UIViewContentModeCenter attachmentSize:evaluateImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [evaluate_attr appendAttributedString:evaluate_image_attr];
  
  //创建属性字符串
  NSMutableAttributedString *evaluate_text_attr = [[NSMutableAttributedString alloc] initWithString:comment_Count];
  evaluate_text_attr.yy_font = font;
  evaluate_text_attr.yy_color = ColorHex(XYTextColor_999999);
  [evaluate_attr appendAttributedString:evaluate_text_attr];
  
   // 创建文本容器
   YYTextContainer *evaluateContainer = [YYTextContainer new];
  evaluateContainer.size = CGSizeMake(CGFLOAT_MAX, 22);
  evaluateContainer.maximumNumberOfRows = 1;
  
  self.evaluateBtn.textLayout = [YYTextLayout layoutWithContainer:evaluateContainer text:evaluate_attr];
  
}
-(void)setModel:(XYConsultDetailModel *)model{
  _model = model;
  
  [self layoutLike:_model.fabulousCount.stringValue?:@"0" selected:model.isFabulous.integerValue == 0];
  [self layoutEvaluate:_model.commentCount.stringValue?:@"0"];
}
-(void)setDymodel:(XYDynamicsModel *)dymodel{
  _dymodel = dymodel;
  [self layoutLike:dymodel.fabulous.stringValue?:@"0" selected:dymodel.isFabulous.integerValue == 0 ];
  [self layoutEvaluate:dymodel.discuss.stringValue?:@"0"];
}
-(void)layoutChangeByEdit:(BOOL)edit{
  if (edit) {
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self).offset(ADAPTATIONRATIO*30);
      make.top.equalTo(self).offset(ADAPTATIONRATIO*12);
      make.height.mas_equalTo(ADAPTATIONRATIO*76);
      make.bottom.equalTo(self).offset(-ADAPTATIONRATIO*12-GK_SAFEAREA_BTM);
      make.trailing.equalTo(self).offset(-ADAPTATIONRATIO*120);
    }];
    self.likeBtn.hidden = YES;
    self.evaluateBtn.hidden = YES;
    self.sendBtn.hidden = NO;
  }else{
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self).offset(ADAPTATIONRATIO*30);
      make.top.equalTo(self).offset(ADAPTATIONRATIO*12);
      make.height.mas_equalTo(ADAPTATIONRATIO*76);
      make.bottom.equalTo(self).offset(-ADAPTATIONRATIO*12-GK_SAFEAREA_BTM);
      make.trailing.equalTo(self).offset(-ADAPTATIONRATIO*300);
    }];
    
    self.likeBtn.hidden = NO;
    self.evaluateBtn.hidden = NO;
    self.sendBtn.hidden = YES;
  }
}
-(void)sendBtnEvent:(id)sender{
  [self endEditing:YES];
  if (self.block) {
    self.block(5, self.textView.text);
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [self sendBtnEvent:nil];
  return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  [self layoutChangeByEdit:YES];
  return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
  [self layoutChangeByEdit:NO];
  return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
