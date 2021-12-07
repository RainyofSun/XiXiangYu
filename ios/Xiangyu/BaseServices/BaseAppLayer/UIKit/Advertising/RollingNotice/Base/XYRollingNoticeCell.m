//
//  XYRollingNoticeCell.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYRollingNoticeCell.h"

@implementation XYRollingNoticeCell
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self setupInitialUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:@""];
}

- (void)setupInitialUI {
    self.backgroundColor = [UIColor whiteColor];
    
    _textLabel = [[UILabel alloc] init];
    [self addSubview:_textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
}

@end
