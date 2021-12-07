//
//  XYProfileItem.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/3.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYProfileSectionItem.h"

@implementation XYProfileItem

@end

@implementation XYProfileHeaderFooterObject

@end

@implementation XYProfileSectionItem

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"items" : [XYProfileItem class] };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSDictionary *header = dic[@"headerInfo"];
    self.headerInfo = [XYProfileHeaderFooterObject yy_modelWithJSON:header];
    return YES;
}
@end
