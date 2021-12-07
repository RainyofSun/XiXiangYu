//
//  XYIMSwitchTableViewCell.m
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
#import "XYIMSwitchTableViewCell.h"
@interface XYIMSwitchTableViewCell ()
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UISwitch *switchView;
@end
@implementation XYIMSwitchTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYIMSwitchTableViewCell";
    XYIMSwitchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYIMSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
      //  cell.supertableView = tableView;
    }
    //cell.indexPath = indexPath;
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
  self.nameLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_222222)];
  [self.contentView addSubview:self.nameLabel];
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(AutoSize(16));
    make.centerY.equalTo(self.contentView);
    make.bottom.equalTo(self.contentView).offset(-AutoSize(20));
  }];
  
  self.switchView = [[UISwitch alloc]init];
  self.switchView.onTintColor = ColorHex(@"#F92B5E");
  //self.switchView.onTintColor = ColorHex(@"#F92B5E");
  [self.contentView addSubview:self.switchView];
  [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.contentView).offset(-AutoSize(16));
    make.centerY.equalTo(self.contentView);
  }];
  [self.switchView addTarget:self action:@selector(OnSwitchAction:) forControlEvents:UIControlEventValueChanged];
}
-(void)setModel:(XYFirendInfoObject *)model{
  _model = model;
  self.nameLabel.text = model.title;
  self.switchView.on = model.switchOn;
}
-(void)OnSwitchAction:(UISwitch *)sw{
  if (self.switchBlock) {
    self.switchBlock(sw.on);
  }
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
