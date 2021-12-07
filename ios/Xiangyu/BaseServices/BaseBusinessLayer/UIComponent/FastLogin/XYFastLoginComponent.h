//
//  XYFastLoginComponent.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/13.
//

#import <Foundation/Foundation.h>

@interface XYFastLoginComponent : NSObject

@property (nonatomic,assign) BOOL needthirdLogin;

- (void)fastLoginFromVc:(UIViewController *)fromVc block:(void(^)(NSString *token))block;

- (void)dismissLoginControllerAnimated:(BOOL)flag completion: (void (^)(void))completion;

@property (nonatomic,copy) void(^wechatBlock)(NSString *name, NSString *token, NSString *errorMsg);

@property (nonatomic,copy) void(^qqBlock)(NSString *name, NSString *token, NSString *errorMsg);

@end
