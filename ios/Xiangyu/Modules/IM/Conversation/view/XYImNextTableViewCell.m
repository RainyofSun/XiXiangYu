//
//  XYImNextTableViewCell.m
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
#import "XYImNextTableViewCell.h"
@interface XYImNextTableViewCell ()
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIImageView *arrowImage;
@end
@implementation XYImNextTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYImNextTableViewCell";
    XYImNextTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYImNextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
       // cell.supertableView = tableView;
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
  self.nameLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_222222)];
  [self.contentView addSubview:self.nameLabel];
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(AutoSize(16));
    make.centerY.equalTo(self.contentView);
    make.bottom.equalTo(self.contentView).offset(-AutoSize(20));
  }];
  self.arrowImage = [LSHControl createImageViewWithImageName:@"ic_arrow_gray"];
  [self.contentView addSubview:self.arrowImage];
  [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.trailing.equalTo(self.contentView).offset(-AutoSize(15));
    make.width.height.mas_equalTo(AutoSize(22));
  }];
  
  self.textField = [LSHControl creatTextfieldWithFrame:CGRectZero textfieldTextFont:AdaptedFont(16) textFieldTextColor:ColorHex(XYTextColor_999999)];
  self.textField.textAlignment = NSTextAlignmentRight;
  self.textField.userInteractionEnabled = NO;
  [self.contentView addSubview:self.textField];
  [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.trailing.equalTo(self.arrowImage.mas_leading).offset(-AutoSize(4));
    make.leading.equalTo(self.contentView.mas_centerX);
  }];
  
}
-(void)setModel:(XYFirendInfoObject *)model{
  _model = model;
  self.nameLabel.text = model.title;
  self.textField.text = model.value;
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
