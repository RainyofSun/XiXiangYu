//
//  XYImageUploadManager.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/25.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYImageUploadManager : NSObject

+ (instancetype)uploadManager;

/**
 *    PUT方式上传资源
 *    @params object ：可以为NSData UIImage和NSString类型的文件名
 *    block 成功返回YES
 */
- (void)uploadObject:(id)object
               block:(void(^)(BOOL success, NSString *url))block;

@end
