//
//  ShareView.h
//  JShareDemo
//
//  Created by ys on 11/01/2017.
//  Copyright © 2017 ys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSHAREService.h"

typedef void(^ShareBlock)(JSHAREPlatform platform, JSHAREMediaType type);

@interface ShareView : UIView

- (ShareView *)getFactoryShareViewWithCallBack:(ShareBlock)block;

- (void)showWithContentType:(JSHAREMediaType)type shareType:(NSDictionary *)shareType;

- (void)showWithSupportedLoginPlatform;
- (void)requestData:(NSDictionary *)dicDic;//1.落地页 2.邀请页 3.注册页 4.活动页 5.相亲详情页 6.咨询详情页 7.短视频
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *textStr;
@property (nonatomic, strong) NSString *imageURL;


@end
