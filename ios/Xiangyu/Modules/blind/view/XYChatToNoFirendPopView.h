//
//  XYChatToNoFirendPopView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/6.
//

#import "FWPopupBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYChatToNoFirendPopView : FWPopupBaseView

@property(nonatomic,copy)void(^actionChatBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
