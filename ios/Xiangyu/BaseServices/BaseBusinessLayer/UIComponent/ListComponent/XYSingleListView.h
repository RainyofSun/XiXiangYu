//
//  XYSingleListView.h
//  Xiangyu
//
//  Created by dimon on 02/02/2021.
//

#import <UIKit/UIKit.h>

@interface XYSingleListView : UIView

@property (nonatomic, copy) void(^selectedBlock)(NSNumber *selectedIndex);

@property (nonatomic,strong) NSArray <NSString *> *dataSource;

@property (nonatomic, strong) NSNumber * selectedIndex;

@end

