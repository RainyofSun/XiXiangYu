//
//  XYConsultDetailModel.h
//  Xiangyu
//
//  Created by Kang on 2021/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYConsultDetailModel : NSObject
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSNumber *consultType;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *introduction;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSNumber *readCount;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *context;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSNumber *fabulousCount;
@property (nonatomic,strong) NSNumber *isFabulous;
//@property (nonatomic,strong) NSNumber *isFabulous;
@property (nonatomic,strong) NSNumber *isDel;
@property (nonatomic,strong) NSNumber *commentCount;
@end

NS_ASSUME_NONNULL_END
