//
//  XYBlindDateCollectionViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
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
#import "XYBlindDateCollectionViewCell.h"
#import "TapLabel.h"
@interface XYBlindDateCollectionViewCell()
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UIView *bottomBGView;
@property(nonatomic,strong)UILabel *markLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property (strong, nonatomic) UIImageView * certificateStatusVew;
@property(nonatomic,strong)UIImageView *sexView;
@property(nonatomic,strong)UILabel *distanceLable;
@property(nonatomic,strong)UILabel  *addressLabel;

@property (nonatomic, strong) TapLabel *ageLable;
@property (nonatomic, strong) TapLabel *heightLable;
@property (nonatomic, strong) TapLabel *eduLable;



@end
@implementation XYBlindDateCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
#pragma mark - 界面布局
-(void)newView{
    
  self.headerImage = [LSHControl createImageViewWithImage:nil];
  [self.headerImage roundSize:8];
  self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
  //self.headerImage.backgroundColor = [UIColor redColor];
  [self.contentView addSubview:self.headerImage];
  [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.top.equalTo(self.contentView);
    make.height.mas_equalTo(self.headerImage.mas_width).multipliedBy(50/41.0);
  }];
  
  self.bottomBGView = [LSHControl viewWithFrame:CGRectMake(0, 0, AutoSize(164), AutoSize(40))];
  [self.bottomBGView setViewColors:@[(id)[UIColor clearColor].CGColor,(id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor] withDirection:1];
  [self.headerImage addSubview:self.bottomBGView];
  [self.bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.bottom.equalTo(self.headerImage);
    make.height.mas_equalTo(AutoSize(40));
  }];
  
  self.markLabel = [LSHControl createLabelFromFont:AdaptedFont(10) textColor:ColorHex(XYTextColor_FFFFFF) numberOfLines:2];
  
  [self.bottomBGView addSubview:self.markLabel];
  [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(AutoSize(8));
    make.center.equalTo(self.bottomBGView);
  }];
  
  self.nameLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_222222)];
  [self.contentView addSubview:self.nameLabel];
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.headerImage);
    make.top.equalTo(self.headerImage.mas_bottom).offset(AutoSize(4));
    make.trailing.lessThanOrEqualTo(self.headerImage).offset(-AutoSize(70));
  }];
  [self.contentView addSubview:self.certificateStatusVew];
  [self.certificateStatusVew mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.nameLabel.mas_trailing).offset(AutoSize(5));
    make.centerY.equalTo(self.nameLabel);
  }];
  [self.contentView addSubview:self.sexView];
  [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.certificateStatusVew.mas_trailing).offset(AutoSize(5));
    make.centerY.equalTo(self.nameLabel);
    make.width.height.mas_equalTo(12);
//    make.trailing.lessThanOrEqualTo(self.headerImage).offset(-AutoSize(70));
  }];
  
  
  self.distanceLable = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(@"#6160F0")];
  [self.contentView addSubview:self.distanceLable];
  [self.distanceLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.headerImage);
    make.centerY.equalTo(self.nameLabel);
  }];
  
  self.addressLabel = [LSHControl createLabelFromFont:AdaptedFont(10) textColor:ColorHex(XYTextColor_666666)];
  [self.contentView addSubview:self.addressLabel];
  [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.headerImage);
    make.top.equalTo(self.nameLabel.mas_bottom).offset(AutoSize(3));
    
  }];
  
  self.ageLable = [TapLabel createViewWithTitleColor:ColorHex(XYTextColor_999999) font:AdaptedFont(10)];
  [self.ageLable roundSize:AutoSize(7) color:ColorHex(XYTextColor_999999)];
  [self.contentView addSubview:self.ageLable];
  [self.ageLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.addressLabel);
    make.top.equalTo(self.addressLabel.mas_bottom).offset(AutoSize(4));
    make.height.mas_equalTo(AutoSize(14));
  }];
  
  self.heightLable = [TapLabel createViewWithTitleColor:ColorHex(XYTextColor_999999) font:AdaptedFont(10)];
  [self.heightLable roundSize:AutoSize(7) color:ColorHex(XYTextColor_999999)];
  [self.contentView addSubview:self.heightLable];
  [self.heightLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.ageLable.mas_trailing).offset(AutoSize(4));
    make.top.equalTo(self.addressLabel.mas_bottom).offset(AutoSize(4));
    make.height.mas_equalTo(AutoSize(14));
  }];
  
  self.eduLable = [TapLabel createViewWithTitleColor:ColorHex(XYTextColor_999999) font:AdaptedFont(10)];
  [self.eduLable roundSize:AutoSize(7) color:ColorHex(XYTextColor_999999)];
  [self.contentView addSubview:self.eduLable];
  [self.eduLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.heightLable.mas_trailing).offset(AutoSize(4));
    make.top.equalTo(self.addressLabel.mas_bottom).offset(AutoSize(4));
    make.height.mas_equalTo(AutoSize(14));
  }];
  
  [self.contentView addSubview:self.beatView];
  [self.beatView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.contentView);
    make.centerY.equalTo(self.ageLable);
    make.width.height.mas_equalTo(AutoSize(24));
  }];
  
  
}
-(XYHeartBeatView *)beatView{
  if (!_beatView) {
    //
    _beatView = [[XYHeartBeatView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(24), AutoSize(24)) fileName:@"xd"];
    [_beatView.animation setLoopAnimation:NO];
//    [_beatView.animation playWithCompletion:^(BOOL animationFinished) {
//    }];
  }
  return _beatView;
}
- (UIImageView *)sexView {
    if(!_sexView){
      _sexView = [UIImageView new];
    }
    return _sexView;
}
- (UIImageView *)certificateStatusVew {
    if (!_certificateStatusVew) {
        _certificateStatusVew = [[UIImageView alloc] init];
      _certificateStatusVew.image = [UIImage imageNamed:@"icon_14_renzheng"];
    }
    return _certificateStatusVew;
}
-(void)setModel:(XYBlindDataItemModel *)model{
  _model = model;
  [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.headPortrait]];
  self.markLabel.text = model.remark;
  self.nameLabel.text = model.nickName;
  self.certificateStatusVew.image =  model.status.intValue==2? [UIImage imageNamed:@"icon_14_renzheng"]:[UIImage imageNamed:@"icon_14_weirenzheng"];//: @""
  self.sexView.image = [UIImage imageNamed:model.sex.intValue == 2 ? @"icon_12_girl" : @"icon_12_boy"];
  
  NSDecimalNumberHandler *hea = [[NSDecimalNumberHandler alloc]initWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
  
  self.distanceLable.text = [NSString stringWithFormat:@"%@km",[[[NSDecimalNumber alloc] initWithString:model.distance?model.distance.stringValue:@"0"] decimalNumberByRoundingAccordingToBehavior:hea]];
  self.addressLabel.text = [NSString stringWithFormat:@"%@",model.addressDec?:@""];
  self.ageLable.text = [NSString stringWithFormat:@"%@岁",model.age];
  self.heightLable.text = [NSString stringWithFormat:@"%@cm",model.height];
  self.eduLable.text = [NSString stringWithFormat:@"%@kg",model.weight];
  
  [self.beatView startAnimation];
}
@end
