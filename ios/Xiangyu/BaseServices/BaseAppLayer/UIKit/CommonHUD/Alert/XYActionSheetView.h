//
//  XYActionSheetView.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/21.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYActionSheetView;
@protocol XYActionSheetViewDelegate
@optional
- (void)didClickActionSheet:(XYActionSheetView *)actionSheet atIndex:(NSInteger)index;

@end


@interface XYActionSheetView : UIView

@property (nonatomic,copy) NSString *detail;

@property (nonatomic,strong) NSArray<NSString *> *dataSource;

@property (nonatomic,strong) NSNumber * preIndex;

@property (nonatomic,weak) id delegate;

@property(nonatomic,assign)NSInteger defaultRow;

@property (nonatomic,copy) void(^dismissBlock)(void);

@property (nonatomic,copy) void(^selectedBlock)(NSInteger index, NSString *text);

- (void)show;

- (void)dismiss;

@end
