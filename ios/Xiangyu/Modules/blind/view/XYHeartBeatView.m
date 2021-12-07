//
//  XYHeartBeatView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
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
#import "XYHeartBeatView.h"
#import "SVGAParser.h"
@implementation XYHeartBeatView


-(id)initWithFrame:(CGRect)frame fileName:(NSString  *)fileName{
    self = [super initWithFrame:frame];
    if (self) {
      self.animationFileName = fileName;
        [self newView];
    }
    return self;
}
-(void)newView{
//  [self addSubview:self.player];
//  [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.center.equalTo(self);
//    make.width.height.mas_equalTo(AutoSize(24));
//  }];
  
  NSString *path = [NSBundle pathForResourceName:self.animationFileName ofType:@"json"];
//CGRect rect = CGRectMake(0, 0, 30, 40);
  LOTAnimationView *animation = [LOTAnimationView animationWithFilePath:path];
// animation.bounds = rect;
 // animation.animationDuration = 12;
  [animation setLoopAnimation:YES];
animation.contentMode = UIViewContentModeScaleAspectFit;
  animation.userInteractionEnabled = NO;
 // [animation play];
  self.animation = animation;
//  [self.animation loopAnimation];
  [self addSubview:animation];
  [animation mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);
  }];
}

-(void)startAnimation{
  
  
  self.animation.loopAnimation = NO;
  self.timelenght = 0;
  [self start];


}
-(void)start{
  if (self.timelenght>10) {
    return;
  }
  self.timelenght ++;
  [self.animation playFromProgress:0 toProgress:1 withCompletion:^(BOOL animationFinished) {
    [self start];
  }];
}



- (SVGAPlayer *)player {
  if (!_player) {
    _player = [[SVGAPlayer alloc] init];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    SVGAParser *parser = [[SVGAParser alloc] init];
    @weakify(self);
    [parser parseWithNamed:@"biaobai" inBundle:resourceBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
      @strongify(self);
      self.player.videoItem = videoItem;
//      [self.player setClearsAfterStop:(BOOL)];
    } failureBlock:nil];
  }
  return _player;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
