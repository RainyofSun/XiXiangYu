//
//  XYHomeHeaderReusableView.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/31.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYHomeHeaderReusableView : UICollectionReusableView

@property (nonatomic,copy) NSString * router;

@property (nonatomic,copy) NSString * title;

@property (nonatomic,copy) NSString * imageName;

@property (nonatomic,copy) NSString * message;

@property (nonatomic,copy) void(^tipsClickBlock)(NSString *router);

@end
