//
//  ZQSearchConst.h
//  ZQSearchController
//
//  Created by zzq on 2018/9/26.
//  Copyright © 2018年 zzq. All rights reserved.
//

#ifndef ZQSearchConst_h
#define ZQSearchConst_h

#import <UIKit/UIKit.h>

static NSString *ZQSearchHistorys = @"ZQSearchHistorys";

typedef NS_ENUM(NSUInteger, SearchEditType) {
    SearchEditTypeFuzzy = 1,
    SearchEditTypeConfirm = 2,
};

@protocol ZQSearchData<NSObject>
@required
@property (nonatomic, copy) NSString *title;

@optional
@property (nonatomic, assign) SearchEditType editType;
@property (nonatomic, strong) UIImage *image;//优先加载image图片
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *desc;

@end

@protocol ZQSearchChildViewDelegate<NSObject>

- (void)searchChildViewDidScroll;

- (void)searchChildViewDidSelectItem:(id)value;
- (void)searchChildViewDidSelectRow:(id)value;

@end


#define ZQ_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ZQSearchhistories.plist"]

#endif /* ZQSearchConst_h */
