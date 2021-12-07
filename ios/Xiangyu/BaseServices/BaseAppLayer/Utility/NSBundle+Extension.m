//
//  NSBundle+Extension.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/13.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

+ (NSString *)pathForPictureName:(NSString *)name ofType:(NSString *)type {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Picture" ofType:@"bundle"];
    NSBundle *pictureBundle = [NSBundle bundleWithPath:bundlePath];
    return [pictureBundle pathForResource:name ofType:type];
}

+ (NSString *)pathForResourceName:(NSString *)name ofType:(NSString *)type {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    return [resourceBundle pathForResource:name ofType:type];
}
@end
