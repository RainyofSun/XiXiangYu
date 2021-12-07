//
//  ZQSearchNormalCell.m
//  ZQSearchController
//
//  Created by zzq on 2018/9/25.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQSearchNormalCell.h"

@interface ZQSearchNormalCell()

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation ZQSearchNormalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self changeStyleWith:NO];
    }
    return self;
}

- (void)configUI {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
  label.numberOfLines = 0;
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    self.layer.cornerRadius = 4;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

- (void)changeStyleWith:(BOOL)heightLight {
  self.backgroundColor = heightLight ?  ColorHex(@"#00BC71")  :  ColorHex(@"#F7F7F7");
  self.titleLabel.textColor = heightLight ? ColorHex(@"#00BC71") : ColorHex(@"#494949");
}

- (void)setHeightLight:(BOOL)heightLight {
    _heightLight = heightLight;
    [self changeStyleWith:heightLight];
}

- (void)setTitle:(NSString *)title {
    _title = title.copy;
    self.titleLabel.text = title;
}

@end
