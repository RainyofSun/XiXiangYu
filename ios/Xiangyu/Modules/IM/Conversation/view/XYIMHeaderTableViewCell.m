//
//  XYIMHeaderTableViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/7/13.
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
#import "XYIMHeaderTableViewCell.h"
#import "XYAddressService.h"
@interface XYIMHeaderTableViewCell ()
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *sexImage;
@property(nonatomic,strong)TapLabel *ageView;
//@property(nonatomic,strong)TapLabel *jobView;
@property(nonatomic,strong)TapLabel *homeView;

@property(nonatomic,strong)UIImageView *arrowImage;
@end
@implementation XYIMHeaderTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYIMHeaderTableViewCell";
    XYIMHeaderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYIMHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        //cell.supertableView = tableView;
    }
   // cell.indexPath = indexPath;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    
  self.headerImage = [LSHControl createImageViewWithImage:nil];
  [self.headerImage roundSize:AutoSize(30)];
  [self.contentView addSubview:self.headerImage];
  [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(AutoSize(15));
    make.centerY.equalTo(self.contentView);
    make.width.height.mas_equalTo(AutoSize(60));
    make.bottom.equalTo(self.contentView).offset(-AutoSize(20));
  }];
  
  self.nameLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_222222)];
  [self.contentView addSubview:self.nameLabel];
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.headerImage.mas_trailing).offset(AutoSize(12));
    make.top.equalTo(self.headerImage);
    make.trailing.lessThanOrEqualTo(self.contentView).offset(-AutoSize(100));
    make.bottom.equalTo(self.headerImage.mas_centerY);
  }];
  
  self.sexImage = [LSHControl createImageViewWithImage:nil];
  [self.contentView addSubview:self.sexImage];
  [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.nameLabel.mas_trailing).offset(AutoSize(4));
    make.centerY.equalTo(self.nameLabel);
    make.width.height.mas_equalTo(AutoSize(12));
  }];
  
  self.ageView = [TapLabel createViewWithTitleColor:ColorHex(@"#6160F0") font:AdaptedFont(12) backgroundColor:ColorHex(@"#E5E5FE")];
  [self.ageView roundSize:AutoSize(9)];
  [self.contentView addSubview:self.ageView];
  [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.nameLabel);
    make.bottom.equalTo(self.headerImage).offset(-AutoSize(2));
    make.height.mas_equalTo(AutoSize(18));
  }];
  
//  self.jobView = [TapLabel createViewWithTitleColor:ColorHex(@"#6160F0") font:AdaptedFont(12) backgroundColor:ColorHex(@"#E5E5FE")];
//  [self.jobView roundSize:AutoSize(9)];
//  [self.contentView addSubview:self.jobView];
//  [self.jobView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.leading.equalTo(self.ageView.mas_trailing).offset(AutoSize(8));
//    make.centerY.equalTo(self.ageView);
//    make.height.mas_equalTo(AutoSize(18));
//  }];
  
  self.homeView = [TapLabel createViewWithTitleColor:ColorHex(@"#6160F0") font:AdaptedFont(12) backgroundColor:ColorHex(@"#E5E5FE")];
  [self.homeView roundSize:AutoSize(9)];
  [self.contentView addSubview:self.homeView];
  [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.ageView.mas_trailing).offset(AutoSize(8));
    make.centerY.equalTo(self.ageView);
    make.height.mas_equalTo(AutoSize(18));
  }];
  
  self.arrowImage = [LSHControl createImageViewWithImageName:@"ic_arrow_gray"];
  [self.contentView addSubview:self.arrowImage];
  [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.trailing.equalTo(self.contentView).offset(-AutoSize(15));
    make.width.height.mas_equalTo(AutoSize(22));
  }];
}
-(void)setModel:(XYFirendInfoObject *)model{
  _model = model;
  [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[model.infoObj objectForKey:@"headPortrait"]]];
  self.nameLabel.text = [model.infoObj objectForKey:@"nickName"];;
  self.sexImage.image = [UIImage imageNamed:[[model.infoObj objectForKey:@"headPortrait"] intValue] == 2 ? @"icon_12_girl" : @"icon_12_boy"];
  
  NSDate *birthdate = [NSDate dateWithString:[model.infoObj objectForKey:@"birthdate"] format:@"yyyy-MM-dd HH-mm-ss"];
  if (!birthdate) {
    birthdate= [NSDate dateWithString:[model.infoObj objectForKey:@"birthdate"] format:@"yyyy-MM-dd'T'HH:mm:ss"];
  }
  NSDate *date = [NSDate date];
  if (!birthdate) {
    birthdate = date;
  }
  
  self.ageView.text = [NSString stringWithFormat:@"%@岁",@(date.year-birthdate.year)];
  
//  self.jobView.text = [NSString stringWithFormat:@"%@",[model.infoObj objectForKey:@"twoIndustryName"]];
  
  self.homeView.text =   [[XYAddressService sharedService] queryCityAreaNameWithAdcode:[model.infoObj objectForKey:@"area"]];
  
;
  
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
