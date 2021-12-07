//
//  XYHeartBeatView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import <UIKit/UIKit.h>
#import <SVGAPlayer/SVGAPlayer.h>
#import <Lottie/Lottie.h>
NS_ASSUME_NONNULL_BEGIN

@interface XYHeartBeatView : UIButton
@property(nonatomic,assign)NSInteger timelenght;

@property(nonatomic,strong)SVGAPlayer *player;
-(id)initWithFrame:(CGRect)frame fileName:(NSString  *)fileName;
@property(nonatomic,strong)NSString *animationFileName;
@property(nonatomic,strong)LOTAnimationView *animation;
-(void)startAnimation;
@end

NS_ASSUME_NONNULL_END
