//
//  XYDynamicsListDataManager.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYDynamicsListDataManager.h"
#import "XYDynamicsAPI.h"
#import "XYLocationService.h"
#import "XYDynamicsFabulousAPI.h"
#import "XYFollowAPI.h"
#import "XYDeleteDynamicsAPI.h"
#import "XYGetBannerListAPI.h"

@interface XYDynamicsListDataManager ()



@property (nonatomic, assign) BOOL requested;

@property (nonatomic, assign) NSUInteger page;

@end

@implementation XYDynamicsListDataManager

- (void)fetchNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page = 1;
  
  switch (self.dataType) {
    case XYDynamicsViewType_Recommend:
    case XYDynamicsViewType_Attention:
    {
      if (self.area && self.requested) {
        XYRecommendDynamicsAPI *api = [[XYRecommendDynamicsAPI alloc] initWithType:self.dataType provice:self.area.provinceCode city:self.area.cityCode page:self.page subjectId:nil];
        [self startNewReqWithAPI:api block:block];
      } else {
        [self fetchLocationWithBlock:^(BOOL ret) {
          XYRecommendDynamicsAPI *api = [[XYRecommendDynamicsAPI alloc] initWithType:self.dataType provice:self.area.provinceCode city:self.area.cityCode page:self.page subjectId:nil];
          [self startNewReqWithAPI:api block:block];
        }];
      }
    }
      break;
    case XYDynamicsViewType_Mine:
    {
      XYMyDynamicsAPI *api = [[XYMyDynamicsAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId page:self.page];
      [self startNewReqWithAPI:api block:block];
    }
      break;
    case XYDynamicsViewType_Others:
    {
      XYOthersDynamicsAPI *api = [[XYOthersDynamicsAPI alloc] initWithUserId:self.hisUserId page:self.page];
      [self startNewReqWithAPI:api block:block];
    }
      break;
    default:
      break;
  }
}

- (void)fetchNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page ++;
  
  switch (self.dataType) {
    case XYDynamicsViewType_Recommend:
    case XYDynamicsViewType_Attention:
    {
      if (self.area && self.requested) {
        XYRecommendDynamicsAPI *api = [[XYRecommendDynamicsAPI alloc] initWithType:self.dataType provice:self.area.provinceCode city:self.area.cityCode page:self.page subjectId:nil];
        [self startNextReqWithAPI:api block:block];
      } else {
        [self fetchLocationWithBlock:^(BOOL ret) {
          XYRecommendDynamicsAPI *api = [[XYRecommendDynamicsAPI alloc] initWithType:self.dataType provice:self.area.provinceCode city:self.area.cityCode page:self.page subjectId:nil];
          [self startNextReqWithAPI:api block:block];
        }];
      }
    }
      break;
    case XYDynamicsViewType_Mine:
    {
      XYMyDynamicsAPI *api = [[XYMyDynamicsAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId page:self.page];
      [self startNextReqWithAPI:api block:block];
    }
      break;
    case XYDynamicsViewType_Others:
    {
      XYOthersDynamicsAPI *api = [[XYOthersDynamicsAPI alloc] initWithUserId:self.hisUserId page:self.page];
      [self startNextReqWithAPI:api block:block];
    }
      break;
    default:
      break;
  }
}

- (void)startNewReqWithAPI:(XYBaseAPI *)api block:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  api.filterCompletionHandler = ^(id data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      [self.layoutsArr removeAllObjects];
      
      NSArray *arr = nil;
      if ([data isKindOfClass:[NSArray class]]) {
        arr = data;
      }
      if ([data isKindOfClass:[NSDictionary class]]) {
        arr = data[@"dynamics"];
      }
      
      if (arr.count > 0) {
        NSArray <XYDynamicsModel *> *dynamics = [NSArray yy_modelArrayWithClass:[XYDynamicsModel class] json:arr];
        for (XYDynamicsModel * model in dynamics) {
          XYDynamicLayout * layout = [[XYDynamicLayout alloc] initWithModel:model];
          [self.layoutsArr addObject:layout];
        }
      } else {
        self.page --;
      }
      if (block) block(YES, nil);
    }
  };
  [api start];

}

- (void)insertDynamics:(NSArray <XYDynamicsModel *> *)dynamics {
  [self.layoutsArr removeAllObjects];
  for (XYDynamicsModel * model in dynamics) {
    XYDynamicLayout * layout = [[XYDynamicLayout alloc] initWithModel:model];
    [self.layoutsArr addObject:layout];
  }
}

- (void)startNextReqWithAPI:(XYBaseAPI *)api block:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  api.filterCompletionHandler = ^(id data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      NSArray *arr = nil;
      if ([data isKindOfClass:[NSArray class]]) {
        arr = data;
      }
      if ([data isKindOfClass:[NSDictionary class]]) {
        arr = data[@"dynamics"];
      }
      
      if (arr.count > 0) {
        NSArray <XYDynamicsModel *> *dynamics = [NSArray yy_modelArrayWithClass:[XYDynamicsModel class] json:arr];
        for (XYDynamicsModel * model in dynamics) {
          XYDynamicLayout * layout = [[XYDynamicLayout alloc] initWithModel:model];
          [self.layoutsArr addObject:layout];
        }
        if (block) block(YES, nil);
      } else {
        self.page --;
        if (block) block(NO, nil);
      }
    }
  };
  [api start];

}

- (void)thunmbDynamicsWithIndex:(NSUInteger)index block:(void(^)(XYDynamicLayout *layout, XYError * error))block {
  if (index > self.layoutsArr.count - 1) {
    if (block) {
      block(nil, ClientExceptionNULL());
    }
    return;
  }
  XYDynamicsModel *model = self.layoutsArr[index].model;
  XYDynamicsFabulousAPI *api = [[XYDynamicsFabulousAPI alloc] initWithDynamicId:model.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      BOOL isFabulous = model.isFabulous.integerValue == 1;
      model.isFabulous = isFabulous ? @(0) : @(1);
      model.fabulous = isFabulous ? @(model.fabulous.integerValue-1) : @(model.fabulous.integerValue+1);
      XYDynamicLayout *layout = [[XYDynamicLayout alloc] initWithModel:model];
      [self.layoutsArr replaceObjectAtIndex:index withObject:layout];
      if (block) block(layout, error);
    } else {
      if (block) block(nil, error);
    }
  };
  [api start];
}

- (void)followUserWithIndex:(NSUInteger)index block:(void(^)(XYDynamicLayout *layout, XYError * error))block {
  if (index > self.layoutsArr.count - 1) {
    if (block) {
      block(nil, ClientExceptionNULL());
    }
    return;
  }
  XYDynamicsModel *model = self.layoutsArr[index].model;
  XYFollowAPI *api = [[XYFollowAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId destUserId:model.userId operation:model.isFollow.integerValue == 1 ? @(2) : @(1) source:@(2) dyId:model.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      BOOL isFollow = model.isFollow.integerValue == 1;
      model.isFollow = isFollow ? @(0) : @(1);
      XYDynamicLayout *layout = [[XYDynamicLayout alloc] initWithModel:model];
      [self.layoutsArr replaceObjectAtIndex:index withObject:layout];
      if (block) block(layout, error);
    } else {
      if (block) block(nil, error);
    }
  };
  [api start];
}

- (void)deleteDynamicWithIndex:(NSUInteger)index block:(void(^)(XYError * error))block {
  if (index > self.layoutsArr.count - 1) {
    if (block) {
      block(ClientExceptionNULL());
    }
    return;
  }
  XYDynamicsModel *model = self.layoutsArr[index].model;
  XYDeleteDynamicsAPI *api = [[XYDeleteDynamicsAPI alloc] initWithDynamicId:model.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      [self.layoutsArr removeObjectAtIndex:index];
      if (block) block(nil);
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (void)fetchBannerDataWithBlock:(void(^)(NSArray *imageUrls))block {
  
  XYGetBannerListAPI *api = [[XYGetBannerListAPI alloc] initWithshowType:@(9)];
  api.filterCompletionHandler = ^(NSArray * data, XYError * _Nullable error) {
    if (data && data.count > 0) {
      NSMutableArray *arr_M = @[].mutableCopy;
      for (NSDictionary *info in data) {
        NSString *imageUrl = info[@"imageUrl"];
        [arr_M addObject:imageUrl];
      }
      self.bannerData=data;
      if (block) block(arr_M);
    } else {
      if (block) block(nil);
    }
  };
  [api start];
}

- (void)fetchLocationWithBlock:(void(^)(BOOL ret))block {
  self.requested = YES;
  [[XYLocationService sharedService] requestCachedLocationWithBlock:^(XYFormattedArea *model) {
    self.area = model;
    if (block) block(model ? YES : NO);
  }];
}

-(NSMutableArray *)layoutsArr {
    if (!_layoutsArr) {
        _layoutsArr = [NSMutableArray array];
    }
    return _layoutsArr;
}

@end
