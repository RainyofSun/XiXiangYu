//
//  ShowImageItemCollectionViewCell.h
//  TimeClock
//
//  Created by Apple on 2019/12/24.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIImage+IconFont.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShowImageItemCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UIButton *delBtn;
-(void)setCellItemWithData:(id)model;
@end

NS_ASSUME_NONNULL_END
