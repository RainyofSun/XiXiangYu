//
//  XYDefaultRollingNoticeCell.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYDefaultRollingNoticeCell.h"

@interface XYDefaultRollingNoticeCell ()

@property (nonatomic,strong) UILabel *contentLable;

@property (nonatomic,strong) UILabel *indexLable;

@end

@implementation XYDefaultRollingNoticeCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.contentLable];
    [self addSubview:self.indexLable];
}

- (void)layoutSubviews {

    self.indexLable.frame = CGRectMake(self.XY_width-40 , 0, 40 , self.XY_height);
    
    self.contentLable.frame = CGRectMake(0 , 0, self.XY_width-40 , self.XY_height);
}

- (void)setIndex:(NSString *)index {
    _index = index;
    self.indexLable.text = index;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLable.text = content;
}

#pragma mark - getter

- (UILabel *)contentLable {
    if (!_contentLable) {
        _contentLable = [[UILabel alloc] init];
        _contentLable.backgroundColor = ColorHex(XYThemeColor_B);
        _contentLable.layer.masksToBounds = YES;
        _contentLable.textColor = ColorHex(XYTextColor_333333);
        _contentLable.font = AdaptedFont(XYFont_B);
        _contentLable.text = @"fadagadfasgerhsadfffa";
    }
    return _contentLable;
}

- (UILabel *)indexLable {
    if (!_indexLable) {
        _indexLable = [[UILabel alloc] init];
        _indexLable.backgroundColor = ColorHex(XYThemeColor_B);
        _indexLable.layer.masksToBounds = YES;
        _indexLable.textAlignment = NSTextAlignmentCenter;
        _indexLable.textColor = ColorHex(XYTextColor_CCCCCC);
        _indexLable.font = AdaptedFont(XYFont_B);
    }
    return _indexLable;
}
@end
