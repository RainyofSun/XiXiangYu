//
//  XYMainCityTableViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/5/26.
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
#import "XYMainCityTableViewCell.h"

@implementation XYMainCityTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYMainCityTableViewCell";
    XYMainCityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYMainCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        //cell.supertableView = tableView;
    }
   // cell.indexPath = indexPath;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
      self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)newView{
  self.titleLabel = [[UILabel alloc]init];
  self.titleLabel.font = AdaptedFont(15);
  self.titleLabel.textColor = ColorHex(XYTextColor_333333);
  [self.contentView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.leading.equalTo(self.contentView).offset(ADAPTATIONRATIO*30);
    make.trailing.lessThanOrEqualTo(self.contentView).offset(-30*ADAPTATIONRATIO);
  }];
  
  self.iconImage = [UIImageView new];
  self.iconImage.image = [UIImage imageNamed:@"icon_12_dingwe"];
  [self.contentView addSubview:self.iconImage];
  [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.leading.equalTo(self.titleLabel.mas_trailing).offset(ADAPTATIONRATIO*10);
  }];
  
//  self.descLabel = [[UILabel alloc]init];
//  self.descLabel.font = AdaptedFont(12);
//  self.descLabel.text = @"当前定位";
//  self.descLabel.textColor = ColorHex(XYTextColor_999999);
//  [self.contentView addSubview:self.descLabel];
//  [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerY.equalTo(self.contentView);
//    make.leading.equalTo(self.iconImage.mas_trailing).offset(ADAPTATIONRATIO*16);
//    make.trailing.lessThanOrEqualTo(self.contentView).offset(-30*ADAPTATIONRATIO);
//  }];
  
}
-(void)setIsSelected:(BOOL)isSelected{
  _isSelected = isSelected;
  //self.iconView.hidden = !isSelected;
  //self.backgroundColor =isSelected?ColorHex(XYTextColor_FFFFFF):[UIColor clearColor];
  self.titleLabel.textColor = isSelected? ColorHex(XYTextColor_635FF0):ColorHex(XYTextColor_333333);
}
-(void)setIsCut:(BOOL)isCut{
  _isCut = isCut;
  self.iconImage.hidden = !isCut;
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
