//
//  SimpleModel.h
//  CollectionView
//
//  Created by ad on 12/12/2017.
//

#import <Foundation/Foundation.h>


@interface XYHomeRowInfo : NSObject

@property (nonatomic,copy) NSString * cellClass;

@property (nonatomic,copy) NSString * minVSpacing;

@property (nonatomic,copy) NSString * minHSpacing;

@property (nonatomic,strong) NSNumber * cellHeight;

@property (nonatomic,strong) NSMutableArray * data;

@end

@interface XYHomeSectionInfo : NSObject

@property (nonatomic,copy) NSString * headerClass;

@property (nonatomic,copy) NSString * headerHeight;

@property (nonatomic,copy) NSString * footerClass;

@property (nonatomic,copy) NSString * footerHeight;

@property (nonatomic,copy) NSString * title;

@property (nonatomic,copy) NSString * subtitle;

@property (nonatomic,copy) NSString * router;

@property (nonatomic,copy) NSString * picURL;

@property (nonatomic,strong) XYHomeRowInfo * rowInfo;

@end
