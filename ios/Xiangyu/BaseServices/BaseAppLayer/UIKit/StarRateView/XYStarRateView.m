//
//  XYStarRateView.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/6/1.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYStarRateView.h"

@interface XYStarRateView ()

@property (nonatomic, strong) UIView *foregroundView;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign) NSInteger numberOfStars;

@end

@implementation XYStarRateView

#pragma mark - Init Methods

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars {
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubViews {
    _score = 5;
    _shouldRadix = NO;
    _shouldGrade = NO;
    
    self.foregroundView = [self buildRateViewWithImageName:@"icon_star_red"];
    self.backgroundView = [self buildRateViewWithImageName:@"icon_star_gray"];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.foregroundView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateRatePercent:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (void)updateRatePercent:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width)*self.numberOfStars;
    
    self.score = self.shouldRadix ? realStarScore : ceilf(realStarScore);
}

- (UIView *)buildRateViewWithImageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.foregroundView.frame = CGRectMake(0, 0, (self.bounds.size.width * self.score)/self.numberOfStars, self.bounds.size.height);
    }];
}

#pragma mark - Get and Set Methods

- (void)setShouldGrade:(BOOL)shouldGrade {
    _shouldGrade = shouldGrade;
    self.gestureRecognizers.firstObject.enabled = shouldGrade;
}

- (void)setScore:(CGFloat)score {
    if (_score == score) {
        return;
    }
    
    if (score < 0) {
        _score = 0;
    } else if (score >= _numberOfStars) {
        _score = 5;
    } else {
        _score = score;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:percentDidChange:)]) {
        [self.delegate starRateView:self percentDidChange:score];
    }
    
    [self setNeedsLayout];
}


@end
