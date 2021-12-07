//
//  XYWalletRecordTableViewCell.m
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
#import "XYWalletRecordTableViewCell.h"
@interface XYWalletRecordTableViewCell ()

@end
@implementation XYWalletRecordTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYWalletRecordTableViewCell";
    XYWalletRecordTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYWalletRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
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
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_333333) text:@"我的余额"];
  [self.contentView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView).offset(AutoSize(10));
    make.leading.equalTo(self.contentView).offset(AutoSize(24));
  }];
  
  
  self.moneyLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_FE2D63) text:@"-2000"];
  [self.contentView addSubview:self.moneyLabel];
  [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.titleLabel);
    make.trailing.equalTo(self.contentView).offset(AutoSize(-24));
  }];
  
  
  self.timeLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_999999) text:@"我的余额"];
  [self.contentView addSubview:self.timeLabel];
  [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.titleLabel.mas_bottom).offset(AutoSize(6));
    make.leading.equalTo(self.titleLabel);
    make.bottom.equalTo(self.contentView).offset(-AutoSize(10)).priority(800);
  }];
  
  self.blanceLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_999999) text:@"余额 4000.00"];
  [self.contentView addSubview:self.blanceLabel];
  [self.blanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.timeLabel);
    make.trailing.equalTo(self.contentView).offset(AutoSize(-24));
  }];
  
}
-(void)setModel:(XYWalletItemModel *)model{
  self.titleLabel.text = model.remark;
  self.timeLabel.text = model.createTime;
  self.moneyLabel.text = [NSString stringWithFormat:@"%@",model.amt];
  self.blanceLabel.text = [NSString stringWithFormat:@"余额 %@",model.balance];
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
