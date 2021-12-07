//
//  XYRNBaseViewController.h
//  Xiangyu
//
//  Created by GQLEE on 2020/12/19.
//

#import "GKNavigationBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYRNBaseViewController : GKNavigationBarViewController

/**
 传递到React Native的参数
 */
@property (nonatomic, strong) NSDictionary * initialProperty;

/**
 React Native界面名称
 */
@property (nonatomic, copy) NSString * pageName;

+ (instancetype)RNPageWithName:(NSString*)pageName initialProperty:(NSDictionary*)initialProperty;

- (instancetype)initWithPageName:(NSString*)pageName initialProperty:(NSDictionary*)initialProperty;


@end

NS_ASSUME_NONNULL_END
