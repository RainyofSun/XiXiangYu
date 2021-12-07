//
//  XYBlindRightMenuView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/1.
//

#import <UIKit/UIKit.h>
#import "XYBlindItemBtn.h"
#import <SVGAPlayer/SVGAPlayer.h>
NS_ASSUME_NONNULL_BEGIN

@interface XYBlindRightMenuView : UIView
@property(nonatomic,strong)SVGAPlayer *player;
@property(nonatomic,strong)UIButton *zhuBtn;
@property(nonatomic,strong)UIButton *giftBtn;
@property(nonatomic,strong)UIButton *praiseBtn;
@property(nonatomic,strong)UIButton *chatBtn;

-(void)layoutResult:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
