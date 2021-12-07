//
//  XYSearchCityView.h
//  Xiangyu
//
//  Created by Kang on 2021/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYSearchCityView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy) NSArray <XYAddressItem *> *searchData;
@property (nonatomic,copy) void(^selectedBlock)(XYAddressItem *item);
@end

NS_ASSUME_NONNULL_END
