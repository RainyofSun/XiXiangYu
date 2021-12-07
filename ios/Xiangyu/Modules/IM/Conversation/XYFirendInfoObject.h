//
//  XYFirendInfoObject.h
//  Xiangyu
//
//  Created by Kang on 2021/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYFirendInfoObject : NSObject
@property(nonatomic,assign)NSInteger type;// 0-个人资料 2-昵称 3-举报 4-置顶 5-屏蔽
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *value;
@property(nonatomic,strong)NSDictionary *infoObj;
@property(nonatomic,assign)BOOL switchOn;

- (instancetype)initWithType:(NSInteger)type
                       title:(NSString *)title
                       value:(NSString *)value;
- (instancetype)initWithType:(NSInteger)type
                     infoObj:(NSDictionary *)infoObj;
- (instancetype)initWithType:(NSInteger)type
                       title:(NSString *)title
                    switchOn:(BOOL)switchOn;
@end

NS_ASSUME_NONNULL_END
