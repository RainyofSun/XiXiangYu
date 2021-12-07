//
//  XYCommentListCell.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "XYCommentListCell.h"

@interface XYCommentListCell()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UILabel *timeLab;



@end

@implementation XYCommentListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutUI];
    }
    return self;
}

#pragma mark - action
- (void)delete {
  if (self.deleteBlock) {
    self.deleteBlock();
  }
}

- (void)setIsFirstCell:(BOOL)isFirstCell {
  _isFirstCell = isFirstCell;
  self.iconView.hidden = !isFirstCell;
}

- (void)setModel:(XYCommentModel *)model {
  _model = model;
  self.titleLab.text = model.nickName ?: @"";
  self.timeLab.text = model.commentTimeDesc ?: @"";
  self.contentLab.text = model.commentBody ?: @"";
  self.deleteBtn.hidden = (model.userId.integerValue != [[XYUserService service] fetchLoginUser].userId.integerValue);
  [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headPortrait]];
  CGFloat titleWidth = [self.titleLab sizeThatFits:CGSizeMake(CGFLOAT_MAX, 20)].width;
  if (titleWidth>100) {
      titleWidth = 100;
  }
  
  [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
      make.width.mas_offset(titleWidth);
  }];
}
-(void)setIshiddenCell:(BOOL)ishiddenCell{
  _ishiddenCell = ishiddenCell;
  if (ishiddenCell) {
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
  }else{
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(46);
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
  }
}
- (void)layoutUI{

  if (!_iconView) {
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"icon_22_pinglu"];
      [self.contentView addSubview:_iconView];
      [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(16);
          make.top.mas_equalTo(16);
          make.size.mas_equalTo(CGSizeMake(22, 22));
      }];
  }
  
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
      _headImageView.layer.cornerRadius = 16;
      _headImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(46);
            make.top.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    }
  
//    if (!_timeLab) {
//        _timeLab = [[UILabel alloc] init];
//        _timeLab.textColor = ColorHex(XYTextColor_999999);
//        _timeLab.font = [UIFont systemFontOfSize:10];
//        _timeLab.textAlignment = NSTextAlignmentRight;
//        _timeLab.numberOfLines = 1;
//        [_timeLab sizeToFit];
//        [self.contentView addSubview:_timeLab];
//        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-14);
//            make.centerY.mas_equalTo(_headImageView);
//        }];
//    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
      _titleLab.textColor = ColorHex(@"#58569F");
        _titleLab.font = AdaptedFont(12);
        _titleLab.numberOfLines = 1;
        [_titleLab sizeToFit];
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).mas_offset(8);
            make.top.mas_equalTo(_headImageView);
        }];
    }
  
  if (!_deleteBtn) {
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:ColorHex(@"#58569F") forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = AdaptedFont(13);
    [self.contentView addSubview:_deleteBtn];
    _deleteBtn.hidden = YES;
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.centerY.mas_equalTo(_titleLab);
    }];
  }
    
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
      _contentLab.textColor = ColorHex(XYTextColor_222222);
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
        _contentLab.backgroundColor = [UIColor clearColor];
        [_contentLab sizeToFit];
        [self.contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab);
            make.top.mas_equalTo(_titleLab.mas_bottom).mas_offset(4);
            make.right.mas_equalTo(-16);
            make.bottom.mas_equalTo(-16);
            
        }];
    }
    
}

@end
