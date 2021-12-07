//
//  XYReleaseDynamicDataManager.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/14.
//

#import <Foundation/Foundation.h>

@interface XYReleaseDynamicDataManager : NSObject

@property (nonatomic,assign) NSUInteger type;

@property (nonatomic,copy) NSString * content;

@property (nonatomic,copy) NSNumber * subjectId;

@property (nonatomic,copy) NSString * subjectText;

@property (nonatomic,strong) NSMutableArray *selectedPhotos;

@property (nonatomic,strong) NSMutableArray *selectedAssets;

- (void)releaseDynamicWithBlock:(void(^)(XYError *error))block;


@end
