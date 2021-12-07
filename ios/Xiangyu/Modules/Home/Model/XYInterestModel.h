//
//  XYInterestModel.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import <Foundation/Foundation.h>

@interface XYInterestUserModel : NSObject

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *headPortrait;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,strong) NSNumber *sex;

@property (nonatomic,copy) NSString *province;

@property (nonatomic,copy) NSString *city;

@property (nonatomic,copy) NSString *area;

@property (nonatomic,copy) NSString *oneIndustry;

@property (nonatomic,copy) NSString *twoIndustry;

@property (nonatomic,strong) NSNumber *distance;

@property (nonatomic,strong) NSNumber *isFriend;

@end

@interface XYInterestGroupModel : NSObject

@property (nonatomic,copy) NSString *faceUrl;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSNumber *memberNum;

@property (nonatomic,copy) NSString *groupId;

@end


@interface XYInterestModel : NSObject

@property (nonatomic,copy) NSArray <XYInterestUserModel *> *users;

@property (nonatomic,copy) NSArray <XYInterestGroupModel *> *groups;

@end

@interface XYInterestItem : NSObject

@property (nonatomic,copy) NSString *picURL;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSNumber*sex;
@property (nonatomic,strong) NSNumber*distance;
@property (nonatomic,copy) NSString *subTitle;

@property (nonatomic,copy) NSString *subsubTitle;

@property (nonatomic,assign, getter=isMale) BOOL male;

@property (nonatomic,assign, getter=isGroup) BOOL group;

@property (nonatomic,assign, getter=isAdded) BOOL added;

@property (nonatomic,copy) NSString *relationId;

@end
