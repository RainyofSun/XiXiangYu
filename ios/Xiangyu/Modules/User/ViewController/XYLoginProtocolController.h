//
//  XYLoginProtocolController.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import <UIKit/UIKit.h>

@interface XYLoginProtocolController : UIViewController

@property (nonatomic, copy) void(^handler)(BOOL ret);

@end
