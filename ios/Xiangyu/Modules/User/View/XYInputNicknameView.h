//
//  XYInputNicknameView.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/17.
//

#import <UIKit/UIKit.h>
#import "XYInputTextField.h"

@interface XYInputNicknameView : UIView

@property (nonatomic,strong) XYInputTextField *textField;

@property (nonatomic,copy) void(^randomNickNameBlock)();

@end

