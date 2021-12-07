//
//  XYAPIBatchAPIRequests.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAPIBatchAPIRequests.h"
#import "XYBaseAPI.h"
#import "XYAPIManager.h"

static  NSString * const hint = @"API should be kind of XYBaseAPI";

@interface XYAPIBatchAPIRequests ()

@property (nonatomic, strong, readwrite) NSMutableSet *apiRequestsSet;

@end

@implementation XYAPIBatchAPIRequests

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiRequestsSet = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Add Requests
- (void)addAPIRequest:(XYBaseAPI *)api {
    NSParameterAssert(api);
    NSAssert([api isKindOfClass:[XYBaseAPI class]],
             hint);
    if ([self.apiRequestsSet containsObject:api]) {
#ifdef DEBUG    
        NSLog(@"Add SAME API into BatchRequest set");
#endif
    }
    
    [self.apiRequestsSet addObject:api];
}

- (void)addBatchAPIRequests:(NSSet *)apis {
    NSParameterAssert(apis);
    NSAssert([apis count] > 0, @"Apis amounts should greater than ZERO");
    [apis enumerateObjectsUsingBlock:^(id  obj, BOOL * stop) {
        if ([obj isKindOfClass:[XYBaseAPI class]]) {
            [self.apiRequestsSet addObject:obj];
        } else {
            __unused NSString *hintStr = [NSString stringWithFormat:@"%@ %@",
                                          [[obj class] description],
                                          hint];
            NSAssert(NO, hintStr);
            return ;
        }
    }];
}

- (void)start {
    NSAssert([self.apiRequestsSet count] != 0, @"Batch API Amount can't be 0");
    [[XYAPIManager sharedXYAPIManager] sendBatchAPIRequests:self];
}

@end
