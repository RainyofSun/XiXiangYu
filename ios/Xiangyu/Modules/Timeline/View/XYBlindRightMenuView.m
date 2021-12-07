//
//  XYBlindRightMenuView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/1.
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
#import "XYBlindRightMenuView.h"
#import "SVGAParser.h"
#import "XYPlatformService.h"
@interface XYBlindRightMenuView ()
//@property(nonatomic,strong)NSArray *btnArray;
@end
@implementation XYBlindRightMenuView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.backgroundColor = [UIColor clearColor];
  self.zhuBtn = [LSHControl createButtonWithButtonImage:[UIImage imageNamed:@"iocn_52_tuodan"]];
  [self addSubview:self.zhuBtn];
  
  [self.zhuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self);
    make.top.equalTo(self);
    make.size.mas_equalTo(CGSizeMake(AutoSize(70), AutoSize(70)));
  }];
  
  
  
  
  self.giftBtn = [LSHControl createButtonWithButtonImage:[UIImage imageNamed:@"icon_52_aiyi"]];
  
  //[[XYBlindItemBtn alloc]initWithTitle:@"表达爱意" imageName:@"icon_52_aiyi"];
  self.giftBtn.hidden = YES;
  [self addSubview:self.giftBtn];
  
  [self.giftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self);
    make.top.equalTo(self);
    make.size.mas_equalTo(CGSizeMake(AutoSize(70), AutoSize(70)));
  }];
  
  
  self.praiseBtn = [LSHControl createButtonWithButtonImage:[UIImage imageNamed:@"iocn_52_guanzhu"] selectedImage:[UIImage imageNamed:@"iocn_52_guanzhu_s"]];
  
  //[[XYBlindItemBtn alloc]initWithTitle:@"关注TA" imageName:@"iocn_52_guanzhu"];
  [self addSubview:self.praiseBtn];
  [self.praiseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self);
    make.top.equalTo(self.giftBtn.mas_bottom);
    make.size.mas_equalTo(CGSizeMake(AutoSize(70), AutoSize(70)));
  }];
  
  self.chatBtn = [LSHControl createButtonWithButtonImage:[UIImage imageNamed:@"icon_52_liaotian"]];
  
  //[[XYBlindItemBtn alloc]initWithTitle:@"聊天" imageName:@"icon_52_liaotian"];
  [self addSubview:self.chatBtn];
  [self.chatBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self);
    make.top.equalTo(self.praiseBtn.mas_bottom);
    make.size.mas_equalTo(CGSizeMake(AutoSize(70), AutoSize(70)));
  }];
  

  
  
  [self addSubview:self.player];
 
  [self.player mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.zhuBtn.mas_leading);
    make.centerY.equalTo(self.zhuBtn);
    make.size.mas_equalTo(CGSizeMake(AutoSize(40), AutoSize(40)));
  }];
  
  
  
//  [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
//    [ self layoutResult:status];
//  }];
}
-(void)layoutResult:(BOOL)hidden{
//  NSArray *array = @[self.zhuBtn,self.giftBtn, self.praiseBtn,self.chatBtn];
  if (hidden) {
    self.giftBtn.hidden = YES;
    [self.giftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.trailing.equalTo(self);
      make.top.equalTo(self.zhuBtn);
      make.size.mas_equalTo(CGSizeMake(AutoSize(70), AutoSize(70)));
    }];
  }else{
    self.giftBtn.hidden = NO;
    [self.giftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.trailing.equalTo(self);
      make.top.equalTo(self.zhuBtn.mas_bottom);
      make.size.mas_equalTo(CGSizeMake(AutoSize(70), AutoSize(70)));
    }];
  }
//
//
//  [array mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
//  [array mas_remakeConstraints:^(MASConstraintMaker *make) {
//    make.trailing.equalTo(self);
//    make.width.mas_equalTo(AutoSize(70));
//    make.height.mas_equalTo(AutoSize(70));
//  }];
  

}


- (SVGAPlayer *)player {
  if (!_player) {
    _player = [[SVGAPlayer alloc] init];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    [_player setLoops:1];
    SVGAParser *parser = [[SVGAParser alloc] init];
    @weakify(self);
    [parser parseWithNamed:@"zhuli" inBundle:resourceBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
      @strongify(self);
      self.player.videoItem = videoItem;
//      [self.player setClearsAfterStop:(BOOL)];
    } failureBlock:nil];
  }
  return _player;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
