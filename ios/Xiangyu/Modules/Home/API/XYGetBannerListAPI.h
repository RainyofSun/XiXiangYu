//
//  XYGetBannerListAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYBaseAPI.h"

@interface XYGetBannerListAPI : XYBaseAPI

//2.首页 3.相亲区 4.拼车区 5.美食区 6.找工作区 7.活动区 8.找需求区 9.老乡圈
- (instancetype)initWithshowType:(NSNumber *)showType;

@end
