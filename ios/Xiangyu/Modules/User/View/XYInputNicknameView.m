//
//  XYInputNicknameView.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/17.
//

#import "XYInputNicknameView.h"
#import "XYMinorButton.h"
#import "NSString+Checker.h"
#import "XYHeartBeatView.h"
@interface XYInputNicknameView ()

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) XYHeartBeatView *randomBtn;

@end

@implementation XYInputNicknameView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      [self addSubview:self.titleLable];
      [self addSubview:self.textField];
      [self addSubview:self.randomBtn];
    }
    return self;
}
#pragma mark - event
- (void)randomNickName {
  
  [self.randomBtn.animation setLoopAnimation:NO];
  [self.randomBtn.animation playWithCompletion:^(BOOL animationFinished) {
    
  }];
  if (self.randomNickNameBlock) {
    self.randomNickNameBlock();
  }
}

- (void)layoutSubviews {
  self.titleLable.frame = CGRectMake(0, 0, 60, self.XY_height);
  self.randomBtn.frame = CGRectMake(self.XY_width-30, (self.XY_height-30)/2, 30, 30);
  self.textField.frame = CGRectMake(70, 0, self.XY_width-165, self.XY_height);
}

#pragma mark - getter

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.font = AdaptedFont(14);
      NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"昵称"];
     // [attr addAttributes:@{NSForegroundColorAttributeName:ColorHex(@"#FF4144")} range:NSMakeRange(0, 1)];
      [attr addAttributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_222222)} range:NSMakeRange(0, 2)];
      _titleLable.attributedText = attr;
    }
    return _titleLable;
}

- (XYInputTextField *)textField {
    if (!_textField) {
        _textField = [[XYInputTextField alloc] init];
        _textField.placeholder = @"请输入昵称";
        _textField.shoundBoard = NO;
      _textField.shoundSeparter = NO;
    }
    return _textField;
}

- (XYHeartBeatView *)randomBtn {
  if (!_randomBtn) {
    _randomBtn = [[XYHeartBeatView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(30), AutoSize(30)) fileName:@"yg"];
  
    [_randomBtn addTarget:self action:@selector(randomNickName) forControlEvents:UIControlEventTouchUpInside];
  }
  return _randomBtn;
}
@end
