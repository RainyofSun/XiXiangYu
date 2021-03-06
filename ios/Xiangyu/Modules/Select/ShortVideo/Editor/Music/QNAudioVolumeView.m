//
//  QNAudioVolumeView.m
//  ExhibitionShortVideo
//
//  Created by hxiongan on 2019/5/7.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNAudioVolumeView.h"

@interface QNAudioVolumeView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UISlider *originSlider;
//@property (nonatomic, strong) UILabel *originValueLabel;

@property (nonatomic, strong) UISlider *musicSlider;
//@property (nonatomic, strong) UILabel *musicValueLabel;

@end

@implementation QNAudioVolumeView

- (CGFloat)minViewHeight {
    return 200;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = QN_COMMON_BACKGROUND_COLOR;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        self.titleLabel.textColor = [UIColor lightTextColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"音量";
        [self.titleLabel sizeToFit];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(13);
        }];
        
        self.originSlider = [[UISlider alloc] init];
        [self.originSlider addTarget:self action:@selector(originSliderValueChange:) forControlEvents:(UIControlEventValueChanged)];
        self.originSlider.maximumValue = 1;
        self.originSlider.minimumValue = 0;
        self.originSlider.continuous = NO;
        self.originSlider.value = 1.0;
        self.originSlider.minimumTrackTintColor = ColorHex(@"#F92B5E");
        self.originSlider.maximumTrackTintColor = UIColor.whiteColor;
      [self.originSlider setThumbImage:[UIImage imageNamed:@"SliderBar"] forState:UIControlStateNormal];
        
        [self addSubview:self.originSlider];
        
        self.musicSlider = [[UISlider alloc] init];
        [self.musicSlider addTarget:self action:@selector(musicSliderValueChange:) forControlEvents:(UIControlEventValueChanged)];
        self.musicSlider.continuous = NO;
        self.musicSlider.maximumValue = 1;
        self.musicSlider.minimumValue = 0;
        self.musicSlider.value = 1.0;
        self.musicSlider.minimumTrackTintColor = ColorHex(@"#F92B5E");
        self.musicSlider.maximumTrackTintColor = UIColor.whiteColor;
      [self.musicSlider setThumbImage:[UIImage imageNamed:@"SliderBar"] forState:UIControlStateNormal];
      
        [self addSubview:self.musicSlider];

        UILabel *originLabel = [[UILabel alloc] init];
        originLabel.font = [UIFont systemFontOfSize:14];
        originLabel.textColor = UIColor.lightTextColor;
        originLabel.text = @"视频原声";
        [originLabel sizeToFit];
        
        UILabel *musicLabel = [[UILabel alloc] init];
        musicLabel.font = [UIFont systemFontOfSize:14];
        musicLabel.textColor = UIColor.lightTextColor;
        musicLabel.text = @"背景音乐";
        [musicLabel sizeToFit];
        
        
//        self.originValueLabel = [[UILabel alloc] init];
//        self.originValueLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
//        self.originValueLabel.textColor = UIColor.lightTextColor;
//        self.originValueLabel.text = @"100%";
//        [self.originValueLabel sizeToFit];
//
//        self.musicValueLabel = [[UILabel alloc] init];
//        self.musicValueLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
//        self.musicValueLabel.textColor = UIColor.lightTextColor;
//        self.musicValueLabel.text = @"100%";
//        [self.musicValueLabel sizeToFit];
        
        [self addSubview:self.originSlider];
      [self addSubview:originLabel];
        [self addSubview:self.musicSlider];
      [self addSubview:musicLabel];
//        [self addSubview:self.originValueLabel];
//        [self addSubview:self.musicValueLabel];
//
        
//        [self.originValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(originLabel);
//          make.size.equalTo(self.originValueLabel.bounds.size);
//            make.right.equalTo(self).offset(-30);
//        }];
//
//        [self.musicValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(musicLabel);
//            make.size.equalTo(self.musicValueLabel.bounds.size);
//            make.right.equalTo(self).offset(-30);
//        }];
        
        [self.originSlider mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.titleLabel.mas_bottom).offset(20);

            make.left.equalTo(30);
            make.right.equalTo(-30);
        }];
      [originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originSlider.mas_bottom).offset(10);
          make.centerX.equalTo(self.mas_centerX);
          make.size.equalTo(originLabel.bounds.size);
      }];
      
        
        [self.musicSlider mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(30);
          make.right.equalTo(-30);
          make.top.equalTo(originLabel.mas_bottom).offset(20);
        }];
      [musicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
          make.size.equalTo(originLabel);
          make.top.equalTo(self.musicSlider.mas_bottom).offset(10);
      }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:self.bounds];
}

- (void)setMusicSliderEnable:(BOOL)enable {
    self.musicSlider.enabled = enable;
}

- (void)originSliderValueChange:(UISlider *)slider {
    [self.delegate audioVolumeView:self videoVolumeChange:slider.value];
//    self.originValueLabel.text = [NSString stringWithFormat:@"%d%%", (int)(slider.value * 100)];
}

- (void)musicSliderValueChange:(UISlider *)slider {
    [self.delegate audioVolumeView:self musicVolumeChange:slider.value];
//    self.musicValueLabel.text = [NSString stringWithFormat:@"%d%%", (int)(slider.value * 100)];
}

@end
