//
//  XYTopicTableViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/7/3.
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
#import "XYTopicTableViewCell.h"
@interface XYTopicTableViewCell ()

@end
@implementation XYTopicTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYTopicTableViewCell";
    XYTopicTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
       // cell.supertableView = tableView;
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
  self.tipLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(@"#F92B5E") text:@"#"];
  [self.contentView addSubview:self.tipLabel];
  [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(AutoSize(12));
    make.centerY.equalTo(self.contentView);
    make.width.height.mas_equalTo(AutoSize(22));
    make.bottom.equalTo(self.contentView).offset(-AutoSize(16)).priority(800);
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(@"#333333") text:@"#"];
  [self.contentView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.tipLabel.mas_trailing);
    make.centerY.equalTo(self.contentView);
    make.trailing.lessThanOrEqualTo(self.contentView).offset(-AutoSize(130));
    //make.width.height.mas_equalTo(AutoSize(22));
  }];
  
  self.hotLabel = [LSHControl createLabelFromFont:AdaptedFont(10) textColor:ColorHex(XYTextColor_FFFFFF) text:@"新"];
  self.hotLabel.textAlignment = NSTextAlignmentCenter;
  self.hotLabel.backgroundColor = ColorHex(@"#F92B5E");
  [self.hotLabel roundSize:AutoSize(8)];
  [self.contentView addSubview:self.hotLabel];
  [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.leading.equalTo(self.titleLabel.mas_trailing).offset(AutoSize(8));
    make.size.mas_equalTo(CGSizeMake(AutoSize(29), AutoSize(16)));
  }];
  
  self.descLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999) text:@""];
  [self.contentView addSubview:self.descLabel];
  [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.trailing.equalTo(self.contentView).offset(-AutoSize(16));
  }];
  
}
-(void)setModel:(XYTopicModel *)model{
  _model = model;
  self.titleLabel.text = model.title;
  self.hotLabel.hidden = [model.isNew integerValue] == 0;
  self.descLabel.text  =[NSString stringWithFormat:@"%@热度",model.fiery];
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
