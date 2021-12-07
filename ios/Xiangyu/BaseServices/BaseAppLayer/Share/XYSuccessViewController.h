//
//  XYSuccessViewController.h
//  Xiangyu
//
//  Created by GQLEE on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYSuccessViewController : UIViewController

@property (nonatomic, copy) void(^payWithSuccess)(void);

@property (nonatomic, strong) NSString *titleL;
@property (nonatomic, strong) NSString *decL;

@end

NS_ASSUME_NONNULL_END
