//
//  XYDropDownMenu.h
//  XYDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - data source protocol
@class XYDropDownMenu;

@protocol XYDropDownMenuDataSource <NSObject>
@required
- (NSString *)menu:(XYDropDownMenu *)menu titleForColumn:(NSInteger)column;
- (UIView *)menu:(XYDropDownMenu *)menu viewForColumn:(NSInteger)column;
- (CGFloat)menu:(XYDropDownMenu *)menu viewHeightForColumn:(NSInteger)column;
- (NSInteger)numberOfColumnsInMenu:(XYDropDownMenu *)menu;

@end

#pragma mark - delegate
@protocol XYDropDownMenuDelegate <NSObject>
@optional
- (BOOL)menu:(XYDropDownMenu *)menu shouldSelectMenuAtIndex:(NSUInteger)index;

@end

#pragma mark - interface
@interface XYDropDownMenu : UIView

@property (nonatomic, weak) id <XYDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <XYDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

- (void)packupMenu;

- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index;

@end
