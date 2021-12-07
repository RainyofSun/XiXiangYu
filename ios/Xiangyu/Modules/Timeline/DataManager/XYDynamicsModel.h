//
//  XYDynamicsModel.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import <Foundation/Foundation.h>
#import "XYPageModel.h"
@interface XYDynamicsModel : NSObject

@property (nonatomic, strong) NSNumber * area;
@property (nonatomic, strong) NSNumber * city;
@property (nonatomic, strong) NSNumber * province;
@property (nonatomic, strong) NSNumber * dwellProvince;
@property (nonatomic, strong) NSNumber * dwellCity;
@property (nonatomic, strong) NSNumber * dwellArea;
@property (nonatomic, strong) NSNumber * auditStatus;
@property (nonatomic, strong) NSNumber * discuss;
@property (nonatomic, strong) NSNumber * fabulous;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSNumber * isFabulous;
@property (nonatomic, strong) NSNumber * isFollow;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, strong) NSNumber * age;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * coverUrl;
@property (nonatomic, copy) NSString * headPortrait;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * resources;
@property (nonatomic, copy) NSArray <NSString *> * images;

@property (nonatomic, strong) NSNumber * isExt;
@property (nonatomic, copy) NSString * extUrl;
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;//应该显示"全文"
@property (nonatomic, strong) NSNumber * subjectId;
@property (nonatomic, copy) NSString * subjectText;
@end

@interface XYLikesUserListModel : NSObject
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)XYPageModel *page;
@end
@interface XYLikesUserModel : NSObject

@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * headPortrait;

@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * area;
@property (nonatomic, strong) NSNumber * isFriend;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, copy) NSString *addressDec;
@end

@interface XYCommentModel : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * headPortrait;
@property (nonatomic, copy) NSString * commentBody;
@property (nonatomic, copy) NSString * commentDate;
@property (nonatomic, copy) NSString * replyCount;
@property (nonatomic, copy) NSString * fabulousCount;
@property (nonatomic, copy) NSString * isLike;
@property (nonatomic, copy) NSString * commentTimeDesc;

@end
