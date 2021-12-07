//
//  XYLoginCheckCodeViewController.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/6.
//

#import "GKNavigationBarViewController.h"
#import "XYLoginViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBindPhoneCheckcodeController : GKNavigationBarViewController

@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *thirdToken;
@property (nonatomic,copy) NSString *thirdId;

@property (nonatomic,assign) NSUInteger type;

@end

NS_ASSUME_NONNULL_END
