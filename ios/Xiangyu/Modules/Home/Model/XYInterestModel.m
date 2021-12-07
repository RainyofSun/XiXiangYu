//
//  XYInterestModel.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYInterestModel.h"

@implementation XYInterestUserModel

@end

@implementation XYInterestGroupModel

@end

@implementation XYInterestModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"users" : [XYInterestUserModel class], @"groups" : [XYInterestGroupModel class]};
}

@end

@implementation XYInterestItem

@end
