//
//  XYInterestModel.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYHomeSearchResultModel.h"

@implementation XYHomeSearchResultModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"users" : [XYFriendItem class],
             @"shortVideo" : [XYTimelineVideoModel class],
             @"dynamic" : [XYDynamicsModel class],};
}

@end
