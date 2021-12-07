//
//  XYProfileItem.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/3.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseTableViewSectionObject.h"

@interface XYProfileItem : XYBaseTableViewItem

@property (nonatomic,copy) NSString *picURL;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,strong) NSNumber *withCordis;

@property (nonatomic,strong) NSNumber *withLine;

@property (nonatomic,strong) NSDictionary *info;

@end

@interface XYProfileHeaderFooterObject : XYBaseHeaderFooterObject

@property (nonatomic,copy) NSString *picURL;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *level;

@property(nonatomic,strong)NSNumber *lock;

@property (nonatomic,copy) NSString *identity;

@property (nonatomic,copy) NSString *member;

@property (nonatomic,copy) NSString *heart;

@property (nonatomic,copy) NSString *heartCount;

@property (nonatomic,copy) NSString *gift;

@property (nonatomic,copy) NSString *giftCount;

@property (nonatomic,copy) NSString *attention;

@property (nonatomic,copy) NSString *attentionCount;

@property (nonatomic,copy) NSString *fans;

@property (nonatomic,copy) NSString *fansCount;

@property (nonatomic,copy) NSString *like;

@property (nonatomic,copy) NSString *likeCount;

@property (nonatomic,copy) NSString *status;
@end

@interface XYProfileSectionItem : XYBaseTableViewSectionObject

@end
