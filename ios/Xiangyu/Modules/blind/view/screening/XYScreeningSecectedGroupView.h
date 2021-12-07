//
//  XYScreeningSecectedGroupView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYScreeningSecectedGroupView : UIView
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSDictionary *currentObj;
@property (nonatomic,copy) void(^selectedBlock)(NSDictionary *item);

-(void)reshEdu;

-(void)resetData;
@end

NS_ASSUME_NONNULL_END
