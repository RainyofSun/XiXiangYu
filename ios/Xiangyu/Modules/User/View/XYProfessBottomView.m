//
//  XYProfessBottomView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/28.
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
#import "XYProfessBottomView.h"
#import "XYHeartRecordViewController.h"
@interface XYProfessBottomItemView ()

@end
@implementation XYProfessBottomItemView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  [self addSubview:self.titleLabel];
  [self addSubview:self.arrowView];
  
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self).offset(AutoSize(16));
      make.centerY.equalTo(self);
  }];

  [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.trailing.equalTo(self).offset(-AutoSize(16));
      make.centerY.equalTo(self);
  }];
}
- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_gray"]];
    }
    return _arrowView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ColorHex(XYTextColor_222222);
        _titleLabel.font = AdaptedFont(XYFont_D);
    }
    return _titleLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface XYProfessBottomView ()

@end
@implementation XYProfessBottomView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.bgView = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
  [self.bgView roundSize:AutoSize(12)];
  [self addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(AutoSize(15));
    make.center.equalTo(self);
    make.bottom.equalTo(self);
  }];
  
  self.myHeartView = [[XYProfessBottomItemView alloc]initWithFrame:CGRectZero];
  self.myHeartView.titleLabel.text = @"我的心动记录";
  [self.bgView addSubview:self.myHeartView];
  [self.myHeartView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.bgView);
    make.top.equalTo(self.bgView).offset(AutoSize(12));
    make.height.mas_equalTo(AutoSize(38));
  }];
  
  self.toMyHeartView = [[XYProfessBottomItemView alloc]initWithFrame:CGRectZero];
  self.toMyHeartView.titleLabel.text = @"对我心动记录";
  [self.bgView addSubview:self.toMyHeartView];
  [self.toMyHeartView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.bgView);
    make.top.equalTo(self.myHeartView.mas_bottom);
    make.bottom.equalTo(self.bgView).offset(-AutoSize(12)).priority(AutoSize(800));
    make.height.mas_equalTo(AutoSize(38));
  }];
  @weakify(self);
  [self.myHeartView handleTapGestureRecognizerEventWithBlock:^(id sender) {
    @strongify(self);
    [self nextVC:2];
  }];
  [self.toMyHeartView handleTapGestureRecognizerEventWithBlock:^(id sender) {
    @strongify(self);
    [self nextVC:1];
  }];
  
}
-(void)nextVC:(NSInteger)type{
  XYHeartRecordViewController *recordVC=[[XYHeartRecordViewController alloc]init];
  recordVC.heartType = type;
  //[self ];
  [[self getCurrentVC] cyl_pushViewController:recordVC animated:YES];
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
