//
//  NSBundle+Extension.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/13.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

- (id)toSafeValue;

- (instancetype)toSafeValueOfClass:(Class)cls;

@end
