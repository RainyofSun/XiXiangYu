//
//  XYFabulousTableViewCell.m
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
#import "XYFabulousTableViewCell.h"
@interface XYFabulousTableViewCell ()

@end
@implementation XYFabulousTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYFabulousTableViewCell";
    XYFabulousTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYFabulousTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        //cell.supertableView = tableView;
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
  [self.headerImage roundSize:AutoSize(22)];
  self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
  [self.contentView addSubview:self.headerImage];
  [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(AutoSize(24));
    make.width.height.mas_equalTo(AutoSize(44));
    make.centerY.equalTo(self.contentView);
    make.bottom.equalTo(self.contentView).offset(-AutoSize(13)).priority(800);
  }];
  
  self.nameLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_222222) text:@""];
  [self.contentView addSubview:self.nameLabel];
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.headerImage.mas_trailing).offset(AutoSize(14));
    make.top.equalTo(self.headerImage);
    make.trailing.lessThanOrEqualTo(self.contentView).offset(-AutoSize(100));
  }];
  self.sexImage = [LSHControl createImageViewWithImage:nil];
  [self.contentView addSubview:self.sexImage];
  [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.nameLabel.mas_trailing).offset(AutoSize(4));
    make.centerY.equalTo(self.nameLabel);
    make.width.height.mas_equalTo(12);
  }];
  
  self.homeLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_999999) text:@""];
  [self.contentView addSubview:self.homeLabel];
  [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.nameLabel);
    make.bottom.equalTo(self.headerImage);
    make.trailing.lessThanOrEqualTo(self.contentView).offset(-AutoSize(60));
  }];
  
  
  self.chatBtn = [LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(12) buttonTitle:@"聊天" buttonTitleColor:ColorHex(XYTextColor_FFFFFF)];
  self.chatBtn.backgroundColor = ColorHex(@"#F92B5E");
  [self.chatBtn roundSize:AutoSize(12)];
  [self.contentView addSubview:self.chatBtn];
  [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
  
    make.centerY.equalTo(self.headerImage);
    make.trailing.equalTo(self.contentView).offset(-AutoSize(16));
    
    make.size.equalTo(CGSizeMake(AutoSize(56), AutoSize(24)));
  }];
}
-(void)setModel:(XYLikesUserModel *)model{
  _model = model;
  [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.headPortrait]];
  self.nameLabel.text = model.nickName;
  self.sexImage.image = [UIImage imageNamed:model.sex.intValue == 2 ? @"icon_12_girl" : @"icon_12_boy"];
  self.homeLabel.text = [NSString stringWithFormat:@"故乡 %@",model.addressDec];
  
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
