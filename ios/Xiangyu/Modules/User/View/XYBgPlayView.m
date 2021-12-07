//
//  XYBgPlayView.m
//  Xiangyu
//
//  Created by Kang on 2021/8/8.
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
#import "XYBgPlayView.h"
@interface XYBgPlayView ()
@property (nonatomic,strong) AVPlayerViewController *playerController;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVAudioSession *avaudioSession;

@property (nonatomic,assign) BOOL isLoop;
@end
@implementation XYBgPlayView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  [self stillPlayMusic];
  [self preparePlayback];
  [self getPlayerNotifications];
}
-(void)enterPage{
  [self.player play];
}
-(void)outPage{
  [self.player pause];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - allow background music still play
- (void)stillPlayMusic {
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
}
#pragma mark - Player
- (void)getPlayerNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEndNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}
- (void)playDidEndNotification:(NSNotification *)notification {
    // 自动重播
    [self.player seekToTime:CMTimeMakeWithSeconds(0, 600) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}
- (void)preparePlayback {
    if (self.player == nil) {
      
      
      NSString *path = [NSBundle pathForResourceName:@"login_bg" ofType:@"mp4"];
      NSURL *url = [NSURL fileURLWithPath:path];
      
      self.player = [[AVPlayer alloc] initWithURL:url];
      
      
      self.playerController = [[AVPlayerViewController alloc] init];
      self.playerController.showsPlaybackControls = NO;// 关闭视频视图按钮
      _playerController.view.translatesAutoresizingMaskIntoConstraints = YES;
      self.playerController.player = self.player;
        [self.playerController.view setFrame:self.frame];
      self.playerController.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self addSubview:self.playerController.view];
        [self sendSubviewToBack:self.playerController.view];
       
      [self.playerController.player play];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
