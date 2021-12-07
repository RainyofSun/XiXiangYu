//
//  FBKVOController+Extension.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/3.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "FBKVOController+Extension.h"

@implementation FBKVOController (Extension)
- (void)XY_observe:(id)object keyPath:(NSString *)keyPath block:(XYKVONotificationBlock)block {
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        id value;
        if ([change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
            value = nil;
        } else {
            value = change[NSKeyValueChangeNewKey];
        }
        if (block) block(value);
    }];
}
- (void)XY_observe:(id)object keyPaths:(NSArray *)keyPaths block:(XYKVONotificationsBlock)block {
    [self observe:object keyPaths:keyPaths options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        id value;
        if ([change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
            value = nil;
        } else {
            value = change[NSKeyValueChangeNewKey];
        }
        
        if (block) block(change[FBKVONotificationKeyPathKey],value);
    }];
}
- (void)XY_observe:(id)object keyPath:(NSString *)keyPath action:(SEL)action {
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew action:action];
}
@end
