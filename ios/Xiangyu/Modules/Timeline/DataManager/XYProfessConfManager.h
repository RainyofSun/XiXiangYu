//
//  XYProfessConfManager.h
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYProfessConfManager : NSObject
@property(nonatomic,strong)NSArray *texts;
@property(nonatomic,strong)NSArray *conf;
@property(nonatomic,strong)NSNumber *superHeartCount;

- (void)releaseProfessConfWithBlock:(void(^)(XYError *error))block;


@end


NS_ASSUME_NONNULL_END
