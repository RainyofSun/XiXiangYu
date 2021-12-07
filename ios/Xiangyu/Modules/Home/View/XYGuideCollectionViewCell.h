//
//  XYGuideCollectionViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
//

#import "XYHomeBaseCell.h"
#import <SVGAPlayer/SVGAPlayer.h>
#import "SVGAParser.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYGuideCollectionViewCell : XYHomeBaseCell<SVGAPlayerDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subTitleLabel;
@property(nonatomic,strong)SVGAPlayer *player;
@property(nonatomic,strong)UIButton *actionBtn;

@property(nonatomic,strong)NSDictionary *model;
@end

NS_ASSUME_NONNULL_END
