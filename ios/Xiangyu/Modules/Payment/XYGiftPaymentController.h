//
//  XYGiftPaymentController.h
//  Xiangyu
//
//  Created by GQLEE on 2021/3/15.
//

#import <UIKit/UIKit.h>
#import "GKDYVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYGiftPaymentController : UIViewController

@property (nonatomic, strong) NSString *user_id;
@property(nonatomic,strong)NSNumber *type;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *buyType;
@property (nonatomic, strong) NSString *merchantOrderNo;
@property (nonatomic, copy) void(^payWithSuccess)(void);//
@property (nonatomic, strong) NSDictionary *dicData;

@end

NS_ASSUME_NONNULL_END
