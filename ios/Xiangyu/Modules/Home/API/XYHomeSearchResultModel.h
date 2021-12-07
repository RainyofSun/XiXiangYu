//
//  XYHomeSearchResultModel.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import <Foundation/Foundation.h>
#import "XYFriendItem.h"
#import "XYTimelineVideoModel.h"
#import "XYDynamicsModel.h"

@interface XYHomeSearchResultModel : NSObject

@property (nonatomic,copy) NSArray <XYFriendItem *> *users;

@property (nonatomic,copy) NSArray <XYTimelineVideoModel *> *shortVideo;

@property (nonatomic,copy) NSArray <XYDynamicsModel *> *dynamic;

@end
