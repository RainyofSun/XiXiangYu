//
//  XYGuideCollectionViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
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
#import "XYGuideCollectionViewCell.h"

@interface XYGuideCollectionViewCell ()

@end
@implementation XYGuideCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
#pragma mark - 界面布局
-(void)newView{
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(24) textColor:ColorHex(XYTextColor_222222)];
  [self.contentView addSubview:self.titleLabel];

  
  self.subTitleLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_222222)];
  [self.contentView addSubview:self.subTitleLabel];

  self.player = [[SVGAPlayer alloc] init];
  self.player.loops = 1;
  self.player.delegate = self;
  self.player.clearsAfterStop = NO;
  [self.contentView addSubview:self.player];
  [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.contentView);
    make.width.height.mas_equalTo(AutoSize(300));
  }];
  
  [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.contentView);
    make.bottom.equalTo(self.player.mas_top).offset(-AutoSize(36));
  }];
  
  
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.contentView);
    make.bottom.equalTo(self.subTitleLabel.mas_top).offset(-AutoSize(36));
  }];
  
  
  self.actionBtn = [LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(16) buttonTitle:@"立即体验" buttonTitleColor:ColorHex(@"#F92B5E")];
  [self.actionBtn roundSize:AutoSize(18) color:ColorHex(@"#F92B5E")];
  [self.contentView addSubview:self.actionBtn];
  [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.contentView);
    make.size.mas_equalTo(CGSizeMake(AutoSize(120), AutoSize(36)));
    make.bottom.equalTo(self.contentView).offset(-AutoSize(80)-GK_SAFEAREA_BTM);
  }];
}
-(void)setModel:(NSDictionary *)model{
  _model = model;
  self.titleLabel.text = model[@"title"];
  self.subTitleLabel.text = model[@"subtitle"];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        SVGAParser *parser = [[SVGAParser alloc] init];
        [parser parseWithNamed:model[@"page"] inBundle:resourceBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
          self.player.videoItem = videoItem;
          [self.player startAnimation];
        } failureBlock:nil];
}
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
  
}
@end
