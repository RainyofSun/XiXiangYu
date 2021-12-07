//
//  GKDYVideoControlView.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoControlView.h"
#import "GKLikeView.h"
#import "XYFollowAPI.h"
@interface GKDYVideoItemButton : UIButton

@end

@implementation GKDYVideoItemButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imgW = self.imageView.frame.size.width;
    CGFloat imgH = self.imageView.frame.size.height;
    
    self.imageView.frame = CGRectMake((width - imgH) / 2, 0, imgW, imgH);
    
    CGFloat titleW = self.titleLabel.frame.size.width;
    CGFloat titleH = self.titleLabel.frame.size.height;
    
    self.titleLabel.frame = CGRectMake((width - titleW) / 2, height - titleH, titleW, titleH);
}

@end

@interface GKDYVideoControlView()

@property (nonatomic, strong) UIImageView           *iconView;
@property(nonatomic,strong)UIButton *attendsBtn;
@property (nonatomic, strong) GKLikeView            *likeView;
@property (nonatomic, strong) GKDYVideoItemButton   *commentBtn;
@property (nonatomic, strong) GKDYVideoItemButton   *shareBtn;
@property (nonatomic, strong) GKDYVideoItemButton   *giftBtn;
@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UILabel               *contentLabel;
@property (nonatomic, strong) UIButton                  *lookDecBtn;
@property (nonatomic, strong) UILabel               *contentTypeLabel;

@property (nonatomic, strong) UIButton                  *playBtn;

@end

@implementation GKDYVideoControlView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.coverImgView];
        [self addSubview:self.iconView];
      [self addSubview:self.attendsBtn];
      [self addSubview:self.giftBtn];
        [self addSubview:self.likeView];
        [self addSubview:self.commentBtn];
        [self addSubview:self.shareBtn];
        [self addSubview:self.nameLabel];
      [self addSubview:self.lookDecBtn];
        [self addSubview:self.contentLabel];
      [self addSubview:self.contentTypeLabel];
        [self addSubview:self.sliderView];
      
        [self addSubview:self.playBtn];
        
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGFloat bottomM = TABBAR_HEIGHT;
        
        self.sliderView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT - 0.5, SCREEN_WIDTH, ADAPTATIONRATIO * 1.0f);
      
      [self.lookDecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self).offset(ADAPTATIONRATIO * 30.0f);
          make.bottom.equalTo(self).offset(-(ADAPTATIONRATIO * 30.0f + bottomM));
          make.width.mas_equalTo(ADAPTATIONRATIO * 132.0f);
        make.height.mas_equalTo(ADAPTATIONRATIO * 44.0f);
      }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ADAPTATIONRATIO * 30.0f);
            make.bottom.equalTo(self.lookDecBtn.mas_top).offset(-(ADAPTATIONRATIO * 15.0f));
            make.width.mas_lessThanOrEqualTo(ADAPTATIONRATIO * 504.0f);
        }];
      [self.contentTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.contentLabel.mas_right).offset(ADAPTATIONRATIO * 30.0f);
          make.bottom.equalTo(self.lookDecBtn.mas_top).offset(-(ADAPTATIONRATIO *15.0f));
        make.width.mas_equalTo(ADAPTATIONRATIO * 60.0f);
        make.height.mas_equalTo(ADAPTATIONRATIO * 30.0f);
        
      }];
      
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel);
            make.bottom.equalTo(self.contentLabel.mas_top).offset(-ADAPTATIONRATIO * 20.0f);
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 30.0f);
            make.bottom.equalTo(self.sliderView.mas_top).offset(-ADAPTATIONRATIO * 100.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.shareBtn.mas_top).offset(-ADAPTATIONRATIO * 45.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
        
        [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.commentBtn.mas_top).offset(-ADAPTATIONRATIO * 45.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 110.0f);
        }];
      [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.equalTo(self.shareBtn);
          make.bottom.equalTo(self.likeView.mas_top).offset(-ADAPTATIONRATIO * 70.0f);
          make.width.height.mas_equalTo(ADAPTATIONRATIO * 100.0f);
      }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shareBtn);
            make.bottom.equalTo(self.giftBtn.mas_top).offset(-ADAPTATIONRATIO * 70.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 100.0f);
        }];
      [self.attendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconView);
        make.centerY.equalTo(self.iconView.mas_bottom);
        make.width.height.mas_equalTo(ADAPTATIONRATIO * 48.0f);
      }];
      
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)setModel:(GKDYVideoModel *)model {
    _model = model;
    
    self.sliderView.value = 0;
    
    if (model.video_width > model.video_height) {
        self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;
    }else {
        self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_url] placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
  
  self.attendsBtn.selected = [model.isFollow integerValue];
    
//    self.nameLabel.text = [NSString stringWithFormat:@"@%@", model.author.name_show];
    
    if ([model.author.portrait containsString:@"http"]) {
         [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.author.portrait] placeholderImage:[UIImage imageNamed:@"placeholderimg"]];
    }else {
        self.iconView.image = [UIImage imageNamed:@"placeholderimg"];
    }
    
    self.contentLabel.text = model.title;
    
    [self.likeView setupLikeState:model.isAgree];
    [self.likeView setupLikeCount:model.agree_num];
    
    [self.commentBtn setTitle:model.comment_num forState:UIControlStateNormal];
    [self.shareBtn setTitle:model.share_num forState:UIControlStateNormal];
  
  _lookDecBtn.hidden =[model.isExt isEqualToString:@"1"] ? NO : YES;
  _contentTypeLabel.hidden = [model.isExt isEqualToString:@"1"] ? NO : YES;
}

#pragma mark - Public Methods
- (void)setProgress:(float)progress {
    self.sliderView.value = progress;
}

- (void)startLoading {
    [self.sliderView showLineLoading];
}

- (void)stopLoading {
    [self.sliderView hideLineLoading];
}

- (void)showPlayBtn {
    self.playBtn.hidden = NO;
}

- (void)hidePlayBtn {
    self.playBtn.hidden = YES;
}

- (void)showLikeAnimation {
    [self.likeView startAnimationWithIsLike:YES];
}

- (void)showUnLikeAnimation {
    [self.likeView startAnimationWithIsLike:NO];
}

#pragma mark - Action
- (void)controlViewDidClick {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:self];
    }
}

- (void)iconDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickIcon:)]) {
        [self.delegate controlViewDidClickIcon:self];
    }
}

- (void)praiseBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickPriase:)]) {
        [self.delegate controlViewDidClickPriase:self];
    }
}

- (void)commentBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickComment:)]) {
        [self.delegate controlViewDidClickComment:self];
    }
}
- (void)giftBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickGift:)]) {
        [self.delegate controlViewDidClickGift:self];
    }
}


- (void)shareBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickShare:)]) {
        [self.delegate controlViewDidClickShare:self];
    }
}
- (void)click_lookDecBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickLookDec:)]) {
        [self.delegate controlViewDidClickLookDec:self];
    }
}
-(void)attendBtnClick:(id)sender{
  if ( [self.delegate respondsToSelector:@selector(controlViewDidClickFollow:button:)]) {
    [self.delegate controlViewDidClickFollow:self button:sender];
  }
  [self follow];
}

-(void)follow{
  
  XYFollowAPI *api = [[XYFollowAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId destUserId:self.model.userId operation:self.model.isFollow.integerValue == 1 ? @(2) : @(1) source:@(2) dyId:self.model.post_id.numberValue];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      BOOL isFollow = self.model.isFollow.integerValue == 1;
      self.model.isFollow = isFollow ? @(0) : @(1);
      
      self.attendsBtn.selected = [self.model.isFollow integerValue];
     // if (block) block(nil);
    } else {
     // if (block) block(error);
    }
  };
  [api start];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    NSTimeInterval delayTime = 0.3f;
    
    if (touch.tapCount <= 1) {
        [self performSelector:@selector(controlViewDidClick) withObject:nil afterDelay:delayTime];
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlViewDidClick) object:nil];
        
        if ([self.delegate respondsToSelector:@selector(controlView:touchesBegan:withEvent:)]) {
            [self.delegate controlView:self touchesBegan:touches withEvent:event];
        }
    }
}

- (void)setIsAudit:(BOOL)isAudit {
  _isAudit = isAudit;
  self.shareBtn.hidden = isAudit;
  self.giftBtn.hidden = isAudit;
  
  if (isAudit) {
    [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shareBtn);
        make.bottom.equalTo(self.likeView.mas_top).offset(-ADAPTATIONRATIO * 70.0f);
        make.width.height.mas_equalTo(ADAPTATIONRATIO * 100.0f);
    }];
  }
}

#pragma mark - 懒加载
-(UIButton *)attendsBtn{
  if (!_attendsBtn) {
    _attendsBtn = [UIButton new];
    [_attendsBtn setImage:[UIImage imageNamed:@"home_follow"] forState:UIControlStateNormal];
    [_attendsBtn setImage:[UIImage imageNamed:@"home_follow_sel"] forState:UIControlStateSelected];
    [_attendsBtn addTarget:self action:@selector(attendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _attendsBtn;
}
- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [UIImageView new];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImgView.clipsToBounds = YES;
    }
    return _coverImgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.layer.cornerRadius = ADAPTATIONRATIO * 50.0f;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconView.layer.borderWidth = 1.0f;
        _iconView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_iconView addGestureRecognizer:iconTap];
    }
    return _iconView;
}

- (GKDYVideoItemButton *)giftBtn {
    if (!_giftBtn) {
      _giftBtn = [GKDYVideoItemButton new];
      _giftBtn.hidden = YES;
        [_giftBtn setImage:[UIImage imageNamed:@"icon_40_gift"] forState:UIControlStateNormal];
      _giftBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_giftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_giftBtn addTarget:self action:@selector(giftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftBtn;
}
- (GKLikeView *)likeView {
    if (!_likeView) {
        _likeView = [GKLikeView new];
      @weakify(self);
      _likeView.block = ^(id  _Nonnull obj) {
        @strongify(self);
        [self praiseBtnClick:self.likeView];
      };
    }
    return _likeView;
}

- (GKDYVideoItemButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [GKDYVideoItemButton new];
        [_commentBtn setImage:[UIImage imageNamed:@"icon_home_comment"] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (GKDYVideoItemButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [GKDYVideoItemButton new];
      _shareBtn.hidden = YES;
        [_shareBtn setImage:[UIImage imageNamed:@"icon_home_share"] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick:)];
        [_nameLabel addGestureRecognizer:nameTap];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _contentLabel;
}
- (UILabel *)contentTypeLabel {
    if (!_contentTypeLabel) {
      _contentTypeLabel = [UILabel new];
      _contentTypeLabel.textColor = ColorHex(@"999999");
      _contentTypeLabel.font = [UIFont systemFontOfSize:12.0f];
      _contentTypeLabel.backgroundColor = [UIColor whiteColor];
      _contentTypeLabel.layer.masksToBounds = YES;
      _contentTypeLabel.layer.cornerRadius = 4;
      _contentTypeLabel.text = @"广告";
      _contentTypeLabel.hidden = YES;
      _contentTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTypeLabel;
}
- (UIButton *)lookDecBtn {
    if (!_lookDecBtn) {
      _lookDecBtn = [UIButton new];
      _lookDecBtn.hidden = YES;
      [_lookDecBtn setTitle:@"查看详情" forState:UIControlStateNormal];
      [_lookDecBtn setBackgroundColor:ColorHex(@"#FFA516")];
      [_lookDecBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
      _lookDecBtn.layer.masksToBounds = YES;
      _lookDecBtn.layer.cornerRadius = ADAPTATIONRATIO * 22.0f;
      [_lookDecBtn addTarget:self action:@selector(click_lookDecBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookDecBtn;
}


- (GKSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [GKSliderView new];
        _sliderView.isHideSliderBlock = YES;
        _sliderView.sliderHeight = ADAPTATIONRATIO * 1.0f;
        _sliderView.maximumTrackTintColor = [UIColor clearColor];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
    }
    return _sliderView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"ss_icon_pause"] forState:UIControlStateNormal];
      _playBtn.userInteractionEnabled = NO;
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

@end
