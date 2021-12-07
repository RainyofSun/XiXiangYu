//
//  XYGetProfessModel.h
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
//

#import <Foundation/Foundation.h>
#import "XYPageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYGetProfessModel : NSObject
@property (nonatomic,strong) NSNumber *received;
@property (nonatomic,strong) NSNumber *sendOut;
@end
@interface XYQueryXdListModel : NSObject
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *headPortrait;
@property (nonatomic,strong) NSNumber *sex;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *orderNo;
@property (nonatomic,strong) NSNumber *blindDateId;
@property (nonatomic,strong) NSNumber *destUserId;
@property (nonatomic,strong) NSString *animationUrl;
@property (nonatomic,strong) NSString *content;
@end


@interface XYQueryXdListObjModel : NSObject
@property (nonatomic,strong) NSArray *list;
@property (nonatomic,strong) XYPageModel *page;
@end

NS_ASSUME_NONNULL_END
