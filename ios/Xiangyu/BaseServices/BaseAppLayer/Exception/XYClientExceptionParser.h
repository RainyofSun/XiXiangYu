//
//  XYClientExceptionParser.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/16.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYClientExceptionParser : NSObject

XYError * ClientExceptionNULL(void);

XYError * ClientExceptionUndefined(void);

XYError * ClientExceptionParser(void);

XYError * ClientExceptionSave(void);

XYError * ClientExceptionNotLogin(void);

XYError * ClientExceptionSystem(NSError *error);

XYError * ClientExceptionNetworking(NSDictionary *info);

@end
