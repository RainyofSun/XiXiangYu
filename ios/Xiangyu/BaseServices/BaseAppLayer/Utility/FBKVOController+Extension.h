//
//  FBKVOController+Extension.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/3.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <KVOController/KVOController.h>

typedef void(^XYKVONotificationBlock)(id value);

typedef void(^XYKVONotificationsBlock)(NSString *keyPath, id value);

@interface FBKVOController (Extension)

/** 监听单个key值得变化 */
- (void)XY_observe:(id)object keyPath:(NSString *)keyPath block:(XYKVONotificationBlock)block;

/** 监听一组key值的变化 */
- (void)XY_observe:(id)object keyPaths:(NSArray *)keyPaths block:(XYKVONotificationsBlock)block;

- (void)XY_observe:(id)object keyPath:(NSString *)keyPath action:(SEL)action;

@end

