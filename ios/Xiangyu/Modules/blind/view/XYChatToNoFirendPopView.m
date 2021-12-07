//
//  XYChatToNoFirendPopView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/6.
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
#import "XYChatToNoFirendPopView.h"
@interface XYChatToNoFirendPopView ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,strong)UIButton *leftImage;
@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UIButton *rightImage;
@property(nonatomic,strong)UILabel *rightLabel;

@property(nonatomic,strong)UILabel *descLabel;

@property(nonatomic,strong)UIButton *noBtn;

@property(nonatomic,strong)UIButton *closeBtn;
@end
@implementation XYChatToNoFirendPopView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
      self.backgroundColor = [UIColor clearColor];
    [self configProperty];
  }
  return self;
}
- (void)configProperty
{
  FWPopupBaseViewProperty *property = [FWPopupBaseViewProperty manager];
  property.popupAlignment = FWPopupAlignmentCenter;
  property.popupAnimationStyle = FWPopupAnimationStyleScale;
  property.touchWildToHide = @"0";
  property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.8];
  self.vProperty = property;
}
-(void)newView{
  self.bgView = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
  [self.bgView roundSize:AutoSize(12)];
  [self addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.size.mas_equalTo(CGSizeMake(AutoSize(320), AutoSize(430)));
    make.center.equalTo(self);
  }];

  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(18) textColor:ColorHex(@"#F92B5E") text:@"交友小贴士"];
  [self.bgView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.bgView);
    make.top.equalTo(self.bgView).offset(AutoSize(24));
  }];
  
  self.contentLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(@"#666666") text:@"陌生聊天消息排名靠后容易被忽略,发送心动表白或赠礼成为好友即可获得重点关注"];
  self.contentLabel.numberOfLines = 0;
  [self.bgView addSubview:self.contentLabel];
  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.bgView);
    make.trailing.lessThanOrEqualTo(self.bgView).offset(-AutoSize(20));
    make.top.equalTo(self.titleLabel.mas_bottom).offset(AutoSize(4));
  }];
  
  self.leftImage = [LSHControl createButtonWithFrame:CGRectZero buttonImage:@"xindong"];
  [self.bgView addSubview:self.leftImage];
  [self.leftImage handleControlEventWithBlock:^(id sender) {
    if (self.actionChatBlock) {
      self.actionChatBlock(1);
    }
    [self hide];
  }];
  [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.bgView.mas_centerX).offset(-AutoSize(4));
    make.size.mas_equalTo(CGSizeMake(AutoSize(132), AutoSize(180)));
    make.top.equalTo(self.contentLabel.mas_bottom).offset(AutoSize(8));
  }];
  
  self.leftLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_444444) text:@"立即表白"];
  [self.bgView addSubview:self.leftLabel];
  [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.leftImage);
    make.top.equalTo(self.leftImage.mas_bottom).offset(4);
  }];
  
  
  
  self.rightImage = [LSHControl createButtonWithFrame:CGRectZero buttonImage:@"zengli"];
  [self.bgView addSubview:self.rightImage];
  [self.rightImage handleControlEventWithBlock:^(id sender) {
    if (self.actionChatBlock) {
      self.actionChatBlock(2);
    }
    [self hide];
  }];
  [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.bgView.mas_centerX).offset(AutoSize(4));
    make.size.mas_equalTo(CGSizeMake(AutoSize(132), AutoSize(180)));
    make.top.equalTo(self.contentLabel.mas_bottom).offset(AutoSize(8));
  }];
  
  self.rightLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_444444) text:@"立即赠送"];
  [self.bgView addSubview:self.rightLabel];
  [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.rightImage);
    make.top.equalTo(self.rightImage.mas_bottom).offset(4);
  }];
  
  
  self.descLabel = [LSHControl createLabelFromFont:AdaptedFont(10) textColor:ColorHex(@"#FF96B0") text:@"● 表白自动成为好友             ● 赠礼自动成为好友\n● 获得专属语音提醒             ● 首次打招呼炫酷特效\n● 心动表白炫酷特效"];
  self.descLabel.numberOfLines = 0;
  [self.bgView addSubview:self.descLabel];
  [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.bgView);
    make.trailing.lessThanOrEqualTo(self.bgView).offset(-AutoSize(20));
    make.top.equalTo(self.rightImage.mas_bottom).offset(AutoSize(28));
  }];
  
  self.noBtn = [LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(14) buttonTitle:@"不了，我先试试运气~" buttonTitleColor:ColorHex(XYTextColor_999999)];
  [self.noBtn handleControlEventWithBlock:^(id sender) {
    if (self.actionChatBlock) {
      self.actionChatBlock(0);
    }
    [self hide];
  }];
  [self.bgView addSubview:self.noBtn];
  [self.noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.bgView);
    make.bottom.equalTo(self.bgView).offset(-AutoSize(16));
  }];
  
  
  self.closeBtn = [LSHControl createButtonWithFrame:CGRectZero buttonImage:@"icon_24_close"];
  [self addSubview:self.closeBtn];
  [self.closeBtn handleControlEventWithBlock:^(id sender) {
    [self hide];
  }];
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.bgView.mas_bottom).offset(AutoSize(10));
    make.size.mas_equalTo(CGSizeMake(AutoSize(24), AutoSize(24)));
  }];
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
