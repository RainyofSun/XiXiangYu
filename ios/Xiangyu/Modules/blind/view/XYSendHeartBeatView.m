//
//  XYSendHeartBeatView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
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
#import "XYSendHeartBeatView.h"
#import <SVGAPlayer/SVGAPlayer.h>
#import "SVGAParser.h"
#import "XYBlindDateHelpMiAPI.h"
#import "ChatViewController.h"
#import "XYHeartBeatNumberBuyView.h"
#import "XYWalletQueryBillAPI.h"
@interface XYSendHeartBeatView ()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subTitleLabel;
@property(nonatomic,strong)SVGAPlayer *player;
//pic_mxp
@property(nonatomic,strong)UIImageView *bgImage;

@property(nonatomic,strong)UILabel *contentLabel;
//but_xindong
@property(nonatomic,strong)UIButton *sendBtn;

@property(nonatomic,strong)UIButton *nextBtn;

@property(nonatomic,strong)YYLabel *heartLabel;

@property(nonatomic,strong)UIButton *closeBtn;

@property(nonatomic,assign)NSInteger current;

@end
@implementation XYSendHeartBeatView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
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
    //    property.popupEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    property.animationDuration = 0.2;
    self.vProperty = property;
}
-(void)newView{
  self.backgroundColor = [UIColor clearColor];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(24) textColor:ColorHex(XYTextColor_FFFFFF) text:@"对TA超级心动"];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self).offset(AutoSize(16)+NAVBAR_HEIGHT);
  }];
  
  self.subTitleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_FFFFFF) text:@"表白自动成为好友  获得专属语音提醒 表白炫酷特效"];
  self.subTitleLabel.numberOfLines = 0;
  self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:self.subTitleLabel];
  [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.trailing.lessThanOrEqualTo(self).offset(-AutoSize(26));
    make.top.equalTo(self.titleLabel.mas_bottom).offset(AutoSize(8));
  }];
  
  [self addSubview:self.player];
  [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.subTitleLabel.mas_bottom).offset(AutoSize(8));
    make.width.height.mas_equalTo(AutoSize(100));
  }];
  
  self.bgImage = [LSHControl createImageViewWithImageName:@"pic_mxp"];
  [self addSubview:self.bgImage];
  [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.player.mas_bottom).offset(AutoSize(8));
    make.size.mas_equalTo(CGSizeMake(AutoSize(300), AutoSize(260)));
  }];
  
  self.contentLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(@"#C08392") text:@"这世间就是有如此奇妙的事，就像我们来自同一个城市，也待在同一个城市，最妙的是，茫茫人海，我一眼就看到你，只看到你。"];
  self.contentLabel.numberOfLines = 0;
  self.contentLabel.textAlignment = NSTextAlignmentCenter;
  [self.bgImage addSubview:self.contentLabel];
  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.bgImage);
    make.top.equalTo(self.bgImage).offset(AutoSize(62));
    make.leading.equalTo(self.bgImage).offset(AutoSize(50));
  }];
  
  self.sendBtn = [LSHControl createButtonWithFrame:CGRectZero buttonImage:@"but_xindong"];
  [self addSubview:self.sendBtn];
  [self.sendBtn addTarget:self action:@selector(sendHeartEvent:) forControlEvents:UIControlEventTouchUpInside];
  [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.bottom.equalTo(self.bgImage).offset(AutoSize(-20));
    make.size.mas_equalTo(CGSizeMake(AutoSize(105), AutoSize(28)));
  }];
  
  [self addSubview:self.nextBtn];
  [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.bottom.equalTo(self.sendBtn.mas_top).offset(AutoSize(-6));
    
  }];
  
  
  

  self.heartLabel = [[YYLabel alloc] init];;
  [self addSubview:self.heartLabel];
  [self.heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.bgImage.mas_bottom).offset(AutoSize(10));
  }];
  
  
  self.closeBtn = [LSHControl createButtonWithFrame:CGRectZero buttonImage:@"icon_24_close"];
  [self addSubview:self.closeBtn];
  [self.closeBtn handleControlEventWithBlock:^(id sender) {
    [self hide];
  }];
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.bottom.equalTo(self).offset(AutoSize(-44)-GK_SAFEAREA_BTM);
    make.size.mas_equalTo(CGSizeMake(AutoSize(24), AutoSize(24)));
  }];
  
}
-(void)setModel:(XYBlindDataItemModel *)model{
  _model = model;
  
  
  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
  NSMutableAttributedString *textt_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余"]];
  textt_attr.yy_font = AdaptedFont(12);
  textt_attr.yy_color = ColorHex(XYTextColor_FFFFFF);
  [all_attr appendAttributedString:textt_attr];
    UIImage *image = [UIImage imageNamed: @"icon_20_heart"];
    NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(12) alignment:YYTextVerticalAlignmentCenter];
    [all_attr appendAttributedString:image_attr];
  
  NSMutableAttributedString *textl_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@颗",self.heartNum]];
  textl_attr.yy_font = AdaptedFont(12);
  textl_attr.yy_color = ColorHex(XYTextColor_FFFFFF);
  [all_attr appendAttributedString:textl_attr];
  
  

  self.heartLabel.attributedText = all_attr;
  
  if (self.texts.count>self.current) {
    self.contentLabel.text = [[self.texts objectAtIndex:self.current] objectForKey:@"content"];
  }
  
  
  
}

-(UIButton *)nextBtn{
  if (!_nextBtn) {
    _nextBtn = [LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(12) buttonTitle:@"换一个" buttonTitleColor:ColorHex(XYTextColor_999999)];
    [_nextBtn handleControlEventWithBlock:^(id sender) {
      self.current ++;
      if (self.texts.count>self.current) {
        self.contentLabel.text = [[self.texts objectAtIndex:self.current] objectForKey:@"content"];
      }else{
        self.current = 0;
        if (self.texts.count>self.current) {
          self.contentLabel.text = [[self.texts objectAtIndex:self.current] objectForKey:@"content"];
        }
      }
    }];
  }
  return _nextBtn;
}
- (SVGAPlayer *)player {
  if (!_player) {
    _player = [[SVGAPlayer alloc] init];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    SVGAParser *parser = [[SVGAParser alloc] init];
    @weakify(self);
    [parser parseWithNamed:@"biaobai" inBundle:resourceBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
      @strongify(self);
      self.player.videoItem = videoItem;
      [self.player startAnimation];
//      [self.player setClearsAfterStop:(BOOL)];
    } failureBlock:nil];
  }
  return _player;
}
-(void)sendHeartEvent:(id)sender{
  
  
  if (self.heartNum && [self.heartNum integerValue]>0) {
    [self sendHeartBeat];
  }else{
    XYHeartBeatNumberBuyView *VC = [[XYHeartBeatNumberBuyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    VC.conf = self.conf;
    @weakify(self);
    VC.successBlock = ^(id  _Nonnull item) {
      @strongify(self);
      [self getHeartCount];
    };
    [VC show];
  }

  
  
  
  

}
-(void)getHeartCount{
   XYWalletSuperHeartCountAPI *api = [[XYWalletSuperHeartCountAPI alloc]init];
   api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
     if (!error) {
       
       NSNumber *heart = [data objectForKey:@"data"];
       
       NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
       NSMutableAttributedString *textt_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余"]];
       textt_attr.yy_font = AdaptedFont(12);
       textt_attr.yy_color = ColorHex(XYTextColor_FFFFFF);
       [all_attr appendAttributedString:textt_attr];
         UIImage *image = [UIImage imageNamed: @"icon_20_heart"];
         NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(12) alignment:YYTextVerticalAlignmentCenter];
         [all_attr appendAttributedString:image_attr];
       
       NSMutableAttributedString *textl_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@颗",heart]];
       textl_attr.yy_font = AdaptedFont(12);
       textl_attr.yy_color = ColorHex(XYTextColor_FFFFFF);
       [all_attr appendAttributedString:textl_attr];
       
       self.heartLabel.attributedText = all_attr;
       
       self.heartNum = heart;
       
     }else{
       
     }
     
     
     
   };
  [api start];
}
-(void)sendHeartBeat{
  XYBlindDateCreateProfessAPI *api = [[XYBlindDateCreateProfessAPI alloc]initWithId:self.model.id destUserId:self.model.userId content:self.contentLabel.text];
  @weakify(self);
  XYShowLoading;
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    @strongify(self);
    XYHiddenLoading;
    if (self.block) {
      self.block(error);
    }
    [self hide];
    if (!error) {
      // 发送表白成功并添加好友
      [self onAdd];
    }
  };
  [api start];
}


- (void)onAdd {
  XYShowLoading;
  V2TIMFriendAddApplication *application = [[V2TIMFriendAddApplication alloc] init];
  application.addWording = self.contentLabel.text;
  application.friendRemark = @"";
  application.userID = self.model.userId.stringValue;
  application.addSource = @"iOS";
  application.addType = V2TIM_FRIEND_TYPE_BOTH;
  [[V2TIMManager sharedInstance] addFriend:application succ:^(V2TIMFriendOperationResult *result) {
      NSString *msg = [NSString stringWithFormat:@"%ld", (long)result.resultCode];
      //根据回调类型向用户展示添加结果
      if (result.resultCode == ERR_SVR_FRIENDSHIP_ALLOW_TYPE_NEED_CONFIRM) {
          msg = NSLocalizedString(@"发送成功,等待对方验证", nil);
       // [self.navigationController popViewControllerAnimated:YES];
      }
      if (result.resultCode == ERR_SVR_FRIENDSHIP_ALLOW_TYPE_DENY_ANY) {
          msg = NSLocalizedString(@"对方禁止添加", nil);
      }
      if (result.resultCode == 0) {
          msg = NSLocalizedString(@"已添加到好友列表", nil);
//        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
//        data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.model.userId];
//        data.userID = self.model.userId.stringValue;
//        data.title = self.model.nickName;
//        ChatViewController *chat = [[ChatViewController alloc] init];
//        chat.conversationData = data;
//        [[ self getCurrentVC].navigationController pushViewController:chat animated:YES];
       // [self cyl_pushViewController:chat animated:YES];
      }
      if (result.resultCode == ERR_SVR_FRIENDSHIP_INVALID_PARAMETERS) {
          msg = NSLocalizedString(@"好友已存在", nil);
        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
        data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.model.userId];
        data.userID = self.model.userId.stringValue;
        data.title = self.model.nickName;
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.conversationData = data;
        [[ self getCurrentVC].navigationController pushViewController:chat animated:YES];
        //[self cyl_pushViewController:chat animated:YES];
      }

    XYHiddenLoading;
    XYToastText(msg);
  } fail:^(int code, NSString *desc) {
    XYHiddenLoading;
    XYToastText(desc);
  }];
}
-(UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

-(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
      
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {

        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
     
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
       
     
        currentVC = rootVC;
    }
    
    return currentVC;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
