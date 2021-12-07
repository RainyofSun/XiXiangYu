//
//  XYReactNativeManager.m
//  Xiangyu
//
//  Created by GQLEE on 2020/12/19.
//

#import "XYReactNativeManager.h"

@implementation XYReactNativeManager

static XYReactNativeManager *_instance = nil;
+ (instancetype)shareInstance{
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}

-(instancetype)init{
    if (self = [super init]) {
        _bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    }
    return self;
}

#pragma mark - RCTBridgeDelegate
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
# if DEBUG
 return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
 //return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
# else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
 }


@end
