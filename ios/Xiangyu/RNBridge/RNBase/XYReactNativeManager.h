//
//  XYReactNativeManager.h
//  Xiangyu
//
//  Created by GQLEE on 2020/12/19.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeDelegate.h>

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
NS_ASSUME_NONNULL_BEGIN

@interface XYReactNativeManager : NSObject<RCTBridgeDelegate>

+ (instancetype)shareInstance;

// 全局唯一的bridge
@property (nonatomic, readonly, strong) RCTBridge *bridge;


@end

NS_ASSUME_NONNULL_END
