//
//  XYDynamicsModel.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import <Foundation/Foundation.h>

@interface XYTimelineVideoModel : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, copy) NSString * videoUrl;
@property (nonatomic, copy) NSString * auditTime;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * coverUrl;
@property (nonatomic, copy) NSString * content;

@property (nonatomic, strong) NSNumber * videoType;
@property (nonatomic, strong) NSNumber * isDel;
@property (nonatomic, strong) NSNumber * userId;

@property (nonatomic, strong) NSNumber * discuss;
@property (nonatomic, strong) NSNumber * auditStatus;
@property (nonatomic, strong) NSNumber * forward;
@property (nonatomic, strong) NSNumber * fabulous;

@property (nonatomic, copy) NSString * authorPortrait;
@property (nonatomic, strong) NSNumber * isLike;

@end
