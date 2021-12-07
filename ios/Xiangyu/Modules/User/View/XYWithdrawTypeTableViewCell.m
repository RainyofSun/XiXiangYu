//
//  XYWithdrawTypeTableViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
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
#import "XYWithdrawTypeTableViewCell.h"
@interface XYWithdrawTypeTableViewCell ()

@end
@implementation XYWithdrawTypeTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYWithdrawTypeTableViewCell";
    XYWithdrawTypeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYWithdrawTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
       // cell.supertableView = tableView;
    }
  //  cell.indexPath = indexPath;
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
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.headerImage = [LSHControl createImageViewWithImage:nil];
  [self.contentView addSubview:self.headerImage];
  [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(AutoSize(38));
    make.width.height.mas_offset(AutoSize(32));
    make.centerY.equalTo(self.contentView);
    make.bottom.equalTo(self.contentView).offset(-AutoSize(11)).priority(800);
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_222222)];
  [self.contentView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.headerImage.mas_trailing).offset(AutoSize(16));
    make.centerY.equalTo(self.contentView);
  }];
  
  self.selectBtn = [LSHControl createButtonWithButtonImage:[UIImage imageNamed:@"icon_22_option_def"] selectedImage:[UIImage imageNamed:@"icon_22_option_sel"]];
  self.selectBtn.userInteractionEnabled = NO;
  [self.contentView addSubview:self.selectBtn];
  [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.contentView).offset(AutoSize(-30));
    make.width.height.mas_offset(AutoSize(24));
    make.centerY.equalTo(self.contentView);
  }];
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
