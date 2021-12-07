//
//  XYScreeningSchoolView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import "FWPopupBaseView.h"
#import "XYFriendItem.h"
#import "XYPlatformService.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYScreeningSchoolView : FWPopupBaseView
@property(nonatomic,strong)XYFriendDataReq *reqParams;
@property(nonatomic,assign)NSInteger schoolType;// 1  初中 2 高中
@property (nonatomic,copy) void(^selectedBlock)(XYSchoolModel *proviceItem);
@end

NS_ASSUME_NONNULL_END
