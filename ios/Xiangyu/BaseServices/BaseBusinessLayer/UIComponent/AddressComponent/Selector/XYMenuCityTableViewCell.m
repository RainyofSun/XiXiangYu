//
//  XYMenuCityTableViewCell.m
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
#import "XYMenuCityTableViewCell.h"

@implementation XYMenuCityTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYMenuCityTableViewCell";
    XYMenuCityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYMenuCityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        //cell.supertableView = tableView;
    }
    //cell.indexPath = indexPath;
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
  self.iconView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 25)];
  self.iconView.layer.cornerRadius = 2;
  self.iconView.layer.masksToBounds = YES;
  self.iconView.hidden = YES;
  self.iconView.backgroundColor = ColorHex(XYTextColor_635FF0);
  [self.contentView addSubview:self.iconView];
  [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.leading.equalTo(self.contentView);
    make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.5);
    make.width.mas_equalTo(4);
  }];
  
  self.titleLabel = [[UILabel alloc]init];
  self.titleLabel.font = AdaptedFont(15);
  self.titleLabel.textColor = ColorHex(XYTextColor_333333);
  [self.contentView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.contentView);
    make.leading.equalTo(self.contentView).offset(ADAPTATIONRATIO*30);
  }];
}

-(void)setIsSelected:(BOOL)isSelected{
  _isSelected = isSelected;
  self.iconView.hidden = !isSelected;
  self.backgroundColor =isSelected?ColorHex(XYTextColor_FFFFFF):[UIColor clearColor];
  self.titleLabel.textColor = isSelected? ColorHex(XYTextColor_635FF0):ColorHex(XYTextColor_333333);
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
