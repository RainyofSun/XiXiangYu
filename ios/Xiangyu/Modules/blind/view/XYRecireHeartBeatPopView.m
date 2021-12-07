//
//  XYRecireHeartBeatPopView.m
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
#import "XYRecireHeartBeatPopView.h"
#import <SVGAPlayer/SVGAPlayer.h>
#import "SVGAParser.h"
#import "ChatViewController.h"
#import "XYBlindGetGiftListAPI.h"

#import "XYGetProfessModel.h"
#import "ChatViewController.h"
@interface XYRecireHeartBeatPopView ()
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)SVGAPlayer *player;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIButton *chatButton;

@property(nonatomic,strong)XYQueryXdListModel *itemModel;

@end
@implementation XYRecireHeartBeatPopView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
      self.backgroundColor = [UIColor clearColor];
    [self configProperty];
      
   // [self getGift];
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
    // property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.3];
  //    property.popupEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  //    property.animationDuration = 0.2;
  self.vProperty = property;
}

-(void)setOrderId:(NSString *)orderId{
  _orderId = orderId;
  if (orderId) {
    [self getMyGift];
  }
}
-(void)getMyGift{
  
  XYProfessGetMesAPI *api = [[XYProfessGetMesAPI alloc] initWithOrderId:self.orderId];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (!error) {
      
      self.itemModel = [XYQueryXdListModel yy_modelWithJSON:data];

      
      [self show];
    }
  };
  [api start];
  
}

-(void)setItemModel:(XYQueryXdListModel *)itemModel{
  _itemModel = itemModel;
  [self.headerImage sd_setImageWithURL:[NSURL URLWithString:itemModel.headPortrait]];
  self.contentLabel.text = itemModel.content;
  
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

//  SVGAParser *parser = [[SVGAParser alloc] init];
//      @weakify(self);
//  [parser parseWithURL:[NSURL URLWithString:itemModel.animationUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
//    @strongify(self);
//    self.player.videoItem = videoItem;
//    [self.player startAnimation];
//  } failureBlock:nil];
}


-(void)newView{
  self.headerImage = [LSHControl createImageViewWithImage:nil];
  [self.headerImage roundSize:AutoSize(44)];
  [self addSubview:self.headerImage];
  [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self).offset(AutoSize(100));
    make.width.height.mas_equalTo(AutoSize(88));
    
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(20) textColor:ColorHex(@"#CFCFCF") text:@"你收到了一个超级心动"];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.trailing.lessThanOrEqualTo(self).offset(-AutoSize(16));
    make.top.equalTo(self.headerImage.mas_bottom).offset(AutoSize(12));
  }];
  
  self.contentLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(@"#CFCFCF") text:@"你收到了一个超级心动"];
  self.contentLabel.numberOfLines = 0;
  [self addSubview:self.contentLabel];
  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.trailing.lessThanOrEqualTo(self).offset(-AutoSize(16));
    make.top.equalTo(self.titleLabel.mas_bottom).offset(AutoSize(10));
  }];

  [self addSubview:self.player];
  [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.contentLabel.mas_bottom).offset(AutoSize(12));
    make.size.mas_equalTo(CGSizeMake(AutoSize(343), AutoSize(230)));
  }];
  self.descLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(@"#CFCFCF") text:@"和TA互动超过3句即可获得现金奖励哦~"];
  [self addSubview:self.descLabel];
  [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.trailing.lessThanOrEqualTo(self).offset(-AutoSize(16));
    make.top.equalTo(self.player.mas_bottom).offset(AutoSize(4));
  }];
  
  [self addSubview:self.chatButton];
  [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.descLabel.mas_bottom).offset(AutoSize(12));
    make.size.mas_equalTo(CGSizeMake(AutoSize(120), AutoSize(36)));
  }];
  
  self.closeBtn = [LSHControl createButtonWithFrame:CGRectZero buttonImage:@"icon_24_close"];
  [self addSubview:self.closeBtn];
  [self.closeBtn handleControlEventWithBlock:^(id sender) {
    [self hide];
  }];
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.bottom.equalTo(self).offset(-AutoSize(40)-GK_SAFEAREA_BTM);
    make.size.mas_equalTo(CGSizeMake(AutoSize(24), AutoSize(24)));
  }];
  
}
- (UIButton *)chatButton {
  if (!_chatButton) {
    _chatButton = [[UIButton alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30, SCREEN_HEIGHT-ADAPTATIONRATIO * 140-SafeAreaBottom(), SCREEN_WIDTH - ADAPTATIONRATIO * 60, ADAPTATIONRATIO * 88)];
    [_chatButton setBackgroundColor:ColorHex(@"#F92B5E")];
    [_chatButton setTitle:@"去聊天" forState:UIControlStateNormal];
    [_chatButton.titleLabel setFont:AdaptedFont(14)];
    _chatButton.layer.cornerRadius = AutoSize(18);
    _chatButton.layer.masksToBounds = YES;
    [_chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_chatButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
  }
  return _chatButton;
}
-(void)submit{
  [self hide];
  // 首先判断是否是好友
  // 然后判断申请列表，同意申请请求，直接聊天
  [[V2TIMManager sharedInstance] checkFriend:self.itemModel.userId.stringValue succ:^(V2TIMFriendCheckResult *result) {
    
    if (result.relationType == V2TIM_FRIEND_RELATION_TYPE_BOTH_WAY) {
      [self toChat];
    }else   if (result.relationType == V2TIM_FRIEND_RELATION_TYPE_NONE){
      [[V2TIMManager sharedInstance] getFriendApplicationList:^(V2TIMFriendApplicationResult *result) {
        if (result.unreadCount<1) {
          return;
        }
        for (V2TIMFriendApplication *application in result.applicationList) {
          if ([application.userID isEqual:self.itemModel.userId.stringValue]) {
            [[V2TIMManager sharedInstance] acceptFriendApplication:application type:V2TIM_FRIEND_ACCEPT_AGREE_AND_ADD succ:^(V2TIMFriendOperationResult *result) {
              [self toChat];
            } fail:nil];
          }
        }
      } fail:nil];
    }
  } fail:nil];
  
}

-(void)toChat{
  TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
  data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.itemModel.userId];
  data.userID = self.itemModel.userId.stringValue;
  data.title = self.itemModel.nickName;
  ChatViewController *chat = [[ChatViewController alloc] init];
  chat.conversationData = data;
  [[ self getCurrentVC].navigationController pushViewController:chat animated:YES];
}
- (SVGAPlayer *)player {
  if (!_player) {
    _player = [[SVGAPlayer alloc] init];
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    SVGAParser *parser = [[SVGAParser alloc] init];
//    @weakify(self);
//    [parser parseWithNamed:@"biaobai" inBundle:resourceBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
//      @strongify(self);
//      self.player.videoItem = videoItem;
//      [self.player startAnimation];
////      [self.player setClearsAfterStop:(BOOL)];
//    } failureBlock:nil];
  }
  return _player;
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
