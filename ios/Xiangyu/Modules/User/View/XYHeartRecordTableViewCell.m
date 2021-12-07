//
//  XYHeartRecordTableViewCell.m
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
#import "XYHeartRecordTableViewCell.h"
@interface XYHeartRecordTableViewCell ()

@end
@implementation XYHeartRecordTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYHeartRecordTableViewCell";
    XYHeartRecordTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYHeartRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        //cell.supertableView = tableView;
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
  self.headerImage = [LSHControl createImageViewWithImage:nil];
  [self.headerImage roundSize:AutoSize(22)];
  self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
  [self.contentView addSubview:self.headerImage];
  [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(AutoSize(24));
    make.centerY.equalTo(self.contentView);
    make.width.height.mas_equalTo(AutoSize(44));
    make.bottom.equalTo(self.contentView).offset(-AutoSize(13)).priority(800);
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_222222) text:@"--"];
  [self.contentView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.headerImage.mas_trailing).offset(AutoSize(16));
    make.top.equalTo(self.headerImage);
    make.trailing.lessThanOrEqualTo(self.contentView).offset(AutoSize(70));
  }];
  [self.contentView addSubview:self.sexView];
  [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.titleLabel.mas_right).offset(8);
    make.centerY.mas_equalTo(self.titleLabel);
    make.width.height.mas_equalTo(12);
  }];
  
  self.timeLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_CCCCCC) text:@"--"];
  [self.contentView addSubview:self.timeLabel];
  [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.headerImage.mas_trailing).offset(AutoSize(16));
    make.bottom.equalTo(self.headerImage);
    make.trailing.lessThanOrEqualTo(self.contentView).offset(AutoSize(70));
  }];
  
  self.iconHeart = [LSHControl createImageViewWithImageName:@"icon_20_heart"];
  [self.contentView addSubview:self.iconHeart];
  [self.iconHeart mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.trailing.equalTo(self.contentView).offset(-AutoSize(16));
    make.width.height.mas_equalTo(AutoSize(28));
  }];
  
  
}
-(void)setModel:(XYQueryXdListModel *)model{
  [self.headerImage sd_setImageWithURL: [NSURL URLWithString:model.headPortrait]];
  self.timeLabel.text  = model.createTime;
  self.sexView.image = [UIImage imageNamed:model.sex.intValue == 2 ? @"icon_12_girl" : @"icon_12_boy"];
  self.titleLabel.text = model.nickName;
}
- (UIImageView *)sexView {
  if (!_sexView) {
    _sexView = [[UIImageView alloc] init];
  }
  return _sexView;
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
