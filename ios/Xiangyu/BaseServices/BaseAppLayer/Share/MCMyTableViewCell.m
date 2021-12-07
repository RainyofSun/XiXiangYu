//
//  MCMyTableViewCell.m
//  MeiChe
//
//  Created by GQLEE on 2019/9/29.
//  Copyright © 2019 GQLEE. All rights reserved.
//

#import "MCMyTableViewCell.h"

@implementation MCMyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // cell 的一些设置 布局
        [self setUpSubViews];
    }
    return self;
}
-(void)setUpSubViews {
  [self.contentView addSubview:self.arrowImg];
    [self.contentView addSubview:self.titleLab];
  
  [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(40);
      make.centerY.mas_equalTo(self.contentView.mas_centerY);
      make.width.mas_equalTo(16);
      make.height.mas_equalTo(16);
  }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.arrowImg.mas_right).offset(11);
        make.top.bottom.mas_equalTo(0);
    }];
    
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont systemFontOfSize:22];
    }
    return _titleLab;
}
- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
    }
    return _arrowImg;
}


@end
