//
//  XYPaymentController.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import <UIKit/UIKit.h>

@interface XYPaymentController : UIViewController

@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *buyType;
@property (nonatomic, strong) NSString *merchantOrderNo;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, copy) void(^payWithSuccess)(void);

@end
