//
//  XYDynamicLayout.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import <Foundation/Foundation.h>
#import "XYDynamicsModel.h"

#define kDynamicsNormalPadding 16
#define kDynamicsPortraitWidthAndHeight 44
#define kDynamicsPortraitNamePadding 13
#define kDynamicsNameDetailPadding 8
#define kDynamicsNameHeight 20
#define kDynamicsMoreLessButtonHeight 30


#define kDynamicsLineSpacing 5

typedef void(^ClickUserBlock)(NSString * userID);
typedef void(^ClickUrlBlock)(NSString * url);
typedef void(^ClickPhoneNumBlock)(NSString * phoneNum);

@interface XYDynamicLayout : NSObject
@property(nonatomic,strong)XYDynamicsModel * model;

@property(nonatomic,strong)YYTextLayout * detailLayout;
@property(nonatomic,strong)YYTextLayout * locationLayout;
@property(nonatomic,strong)YYTextLayout * homeTownLayout;
@property(nonatomic,strong)YYTextLayout * likeLayout;
@property(nonatomic,strong)YYTextLayout * evaluateLayout;
@property(nonatomic,assign)CGSize photoContainerSize;
@property(nonatomic,copy)ClickUrlBlock clickUrlBlock;
@property(nonatomic,copy)ClickPhoneNumBlock clickPhoneNumBlock;

@property(nonatomic,assign)CGFloat height;

- (instancetype)initWithModel:(XYDynamicsModel *)model;
- (void)resetLayout;
@end

