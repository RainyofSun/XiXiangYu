//
//  XYBaseViewModel.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/5.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYBaseViewModel : NSObject

@property (nonatomic,strong) NSNumber * executing;

@property (nonatomic,copy) NSString * exceptionCode;

@property (nonatomic,copy) NSString *exceptionMsg;

@end
