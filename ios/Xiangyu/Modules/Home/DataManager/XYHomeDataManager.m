//
//  XYHomeDataManager.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYHomeDataManager.h"
#import "XYGetBannerListAPI.h"
#import "XYGetInterestAPI.h"
#import "XYUpdateLocationAPI.h"
#import "XYUserService.h"
#import "XYAddressService.h"
#import "XYHomePageAPI.h"
#import "XYRecommendBlindAPI.h"
#import "XYAPIBatchAPIRequests.h"
#import "XYFollowAPI.h"
#import "XYQueryTaskListAPI.h"
#import "XYReceiveTaskAPI.h"
#import "JPUSHService.h"
#import "XYGeneralAPI.h"
#import "XYHomeSearchAPI.h"

@interface XYHomeDataManager () <XYAPIBatchAPIRequestsProtocol>

@property (nonatomic,strong) XYAPIBatchAPIRequests *requests;

@property (strong, nonatomic, readwrite) NSMutableArray <XYHomeSectionInfo *>*models;

@property (nonatomic,copy) void(^pageViewRefreshBlock)(void);

@property (nonatomic,assign) BOOL addedBanner;
@property (nonatomic,assign) BOOL addedBlind;
@property (nonatomic,assign) BOOL addedTask;

@end

@implementation XYHomeDataManager

- (void)fetchViewDataWithBlock:(void(^)(BOOL ret))block {
    NSArray *data = @[
                      @{
                      @"headerClass":@"",
                      @"headerHeight":@"",
                      @"footerClass":@"",
                      @"footerHeight":@"",
                      @"title":@"",
                      @"subtitle":@"",
                      @"router":@"",
                      @"picURL":@"",
                      @"rowInfo":@{
                                  @"cellClass":@"XYHomeHeaderCell",
                                  @"minVSpacing":@"",
                                  @"minHSpacing":@"",
                                  @"cellHeight":@(114),
                                  @"data":@[
                                          @{
                                              @"router":self.target ?: @"",
                                              @"hometown":@"--",
                                              @"location":@"--",
                                              @"fellow":@"0",
                                              @"shortvideo":@"0",
                                              @"tidings":@"0",
                                              }
                                            ]
                                  },
                      },
                      @{
                          @"headerClass":@"",
                          @"headerHeight":@"",
                          @"footerClass":@"",
                          @"footerHeight":@"",
                          @"title":@"",
                          @"subtitle":@"",
                          @"router":@"",
                          @"picURL":@"",
                          @"rowInfo":@{
                                      @"cellClass":@"XYHomeOptionCell",
                                      @"minVSpacing":@"",
                                      @"minHSpacing":@"",
                                      @"cellHeight":@(120),//212
                                      @"data":@[
                                              @[@{@"title":@"去相亲",
                                                  @"router":self.target ?: @"",
                                                  @"picURL":@"icon_44_xiangqin"},
                                                @{@"title":@"行业圈",
                                                  @"router":self.target ?: @"",
                                                  @"picURL":@"icon_44_hangye"},
                                             
                                                @{@"title":@"回家拼车",
                                                  @"router":self.target ?: @"",
                                                  @"picURL":@"icon_44_pinche"},
                                                @{@"title":@"家乡资讯",
                                                @"router":self.target ?: @"",
                                                @"picURL":@"icon_44_zixun"},
//                                                @{@"title":@"找资源",
//                                                  @"router":self.target ?: @"",
//                                                  @"picURL":@"icon_44_xuqiu"},
//                                                @{@"title":@"找商家",
//                                                  @"router":self.target ?: @"",
//                                                  @"picURL":@"icon_44_shangjia"},
//                                                @{@"title":@"找工作",
//                                                  @"router":self.target ?: @"",
//                                                  @"picURL":@"icon_44_gongzuo"},
//                                                @{@"title":@"找活动",
//                                                  @"router":self.target ?: @"",
//                                                  @"picURL":@"icon_44_huodong"},
                                            ]
                                              ],
                                      }
                          }
                      ];
    
    self.models = [NSArray yy_modelArrayWithClass:[XYHomeSectionInfo class] json:data].mutableCopy;
  if (block) block(YES);
}

- (void)fetchTaskListDataWithBlock:(void(^)(BOOL needRefresh))block {
  XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
  XYQueryTaskListAPI *api = [[XYQueryTaskListAPI alloc] initWithUserId:userInfo.userId];
  api.filterCompletionHandler = ^(NSArray * data, XYError * _Nullable error) {
    XYHomeSectionInfo *taskData = [self _buildTaskDataWithItems:data];
    if (taskData) {
      self.addedTask = YES;
      [self.models addObject:taskData];
      if (block) block(YES);
    } else {
      if (block) block(NO);
    }
  };
  [api start];
}

- (void)fetchBannerDataWithBlock:(void(^)(BOOL needRefresh))block {
  
  XYGetBannerListAPI *api = [[XYGetBannerListAPI alloc] initWithshowType:@(2)];
  api.filterCompletionHandler = ^(NSArray * data, XYError * _Nullable error) {
    XYHomeSectionInfo *bannerData = [self _buildBannerDataWithItems:data];
    if (bannerData) {
      self.addedBanner = YES;
      if (self.addedBlind) {
        if (self.addedTask) {
          [self.models insertObject:bannerData atIndex:3];
        } else {
          [self.models addObject:bannerData];
        }
      } else {
        if (self.addedTask) {
          [self.models insertObject:bannerData atIndex:2];
        } else {
          [self.models addObject:bannerData];
        }
      }
      if (block) block(YES);
    } else {
      if (block) block(NO);
    }
  };
  [api start];
}

- (void)sendLocationBatchAPIRequestsWithLocationHandler:(void(^)(NSString *cityName))locationHandler pageDataBlock:(void(^)(void))pageDataBlock  {
  self.pageViewRefreshBlock = pageDataBlock;
  
  
  
  [[XYLocationService sharedService] requestCachedLocationWithBlock:^(XYFormattedArea *model) {
    self.currentArea = model;
    if (locationHandler) {
      locationHandler(model.cityName ?: @"无定位");
    }
    XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
    if (model.latitude && model.longitude) {
      [self updateLocation:model];
    } else {
      return;
    }
    
    self.requests = [[XYAPIBatchAPIRequests alloc] init];
    self.requests.delegate = self;
    XYHomePageAPI *homePageApi = [[XYHomePageAPI alloc] initWithUserId:userInfo.userId dwellProvince:model.provinceCode dwellCity:model.cityCode];
    homePageApi.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
      if (!error) {
        NSString *hometown = [[XYAddressService sharedService] queryAreaNameWithAdcode:userInfo.city];
        NSString *location = model.cityName;

        NSDictionary *dict =
        @{
          @"hometown":hometown ?: @"",
          @"location":location ?: @"",
          @"fellow":((NSNumber *)data[@"townsMan"]).stringValue ?: @"0",
          @"shortvideo":((NSNumber *)data[@"shortVideo"]).stringValue ?: @"0",
          @"tidings":((NSNumber *)data[@"dynamic"]).stringValue ?: @"0",
          @"router":self.target ?: @"",
        };
        self.models.firstObject.rowInfo.data = @[dict].mutableCopy;
      }
    };
    [self.requests addAPIRequest:homePageApi];
    
    XYRecommendBlindAPI *api = [[XYRecommendBlindAPI alloc] initWithUserId:userInfo.userId sex:userInfo.sex latitude:@(model.latitude) longitude:@(model.longitude) dwellCity:model.cityCode];
    api.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
      NSArray *items = data[@"list"];
      XYHomeSectionInfo *blindData = [self _buildBlindViewDataWithItems:items];
      if (blindData) {
        if (self.models.count == 2) {
          [self.models addObject:blindData];
        } else {
          if (self.addedBlind) {
            [self.models replaceObjectAtIndex:2 withObject:blindData];
          } else {
            [self.models insertObject:blindData atIndex:2];
          }
        }
        self.addedBlind = YES;
      }
    };
    [self.requests addAPIRequest:api];
    [self.requests start];
    }];
  
}

- (void)updatePushToken {
  [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];
    if (!user.islogin) return;
    
    NSString *method = @"api/v1/User/BindJPush";
    NSDictionary *params = @{
      @"userId": user.userId,
      @"thirdToken": registrationID ?: @"",
    };
    XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
      api.apiRequestMethodType = XYRequestMethodTypePOST;
    api.requestParameters = params ?: @{};
    [api start];
  }];
}

- (void)switchLocationBatchAPIRequestsWithItem:(XYAddressItem *)item pageDataBlock:(void(^)(void))pageDataBlock  {
  self.pageViewRefreshBlock = pageDataBlock;
  XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
  XYFormattedArea *newArea = [[XYFormattedArea alloc] init];
  newArea.latitude = item.latitude.floatValue;
  newArea.longitude = item.longitude.floatValue;
  newArea.provinceCode = item.parentId;
  newArea.cityCode = item.code;
  newArea.cityName = item.name;
  self.currentArea = newArea;
  
  self.requests = [[XYAPIBatchAPIRequests alloc] init];
  self.requests.delegate = self;
  XYHomePageAPI *homePageApi = [[XYHomePageAPI alloc] initWithUserId:userInfo.userId dwellProvince:self.currentArea.provinceCode dwellCity:self.currentArea.cityCode];
  homePageApi.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      NSString *hometown = [[XYAddressService sharedService] queryAreaNameWithAdcode:userInfo.city];
      NSDictionary *dict =
      @{
        @"hometown":hometown ?: @"",
        @"location":self.currentArea.cityName ?: @"",
        @"fellow":((NSNumber *)data[@"townsMan"]).stringValue ?: @"0",
        @"shortvideo":((NSNumber *)data[@"shortVideo"]).stringValue ?: @"0",
        @"tidings":((NSNumber *)data[@"dynamic"]).stringValue ?: @"0",
        @"router":self.target ?: @"",
      };
      self.models.firstObject.rowInfo.data = @[dict].mutableCopy;
    }
  };
  [self.requests addAPIRequest:homePageApi];
  
  XYRecommendBlindAPI *api = [[XYRecommendBlindAPI alloc] initWithUserId:userInfo.userId sex:userInfo.sex latitude:@(self.currentArea.latitude) longitude:@(self.currentArea.longitude) dwellCity:self.currentArea.cityCode];
  api.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
    NSArray *items = data[@"list"];
    XYHomeSectionInfo *blindData = [self _buildBlindViewDataWithItems:items];
    if (blindData) {
      if (self.models.count == 2) {
        [self.models addObject:blindData];
      } else {
        if (self.addedBlind) {
          [self.models replaceObjectAtIndex:2 withObject:blindData];
        } else {
          [self.models insertObject:blindData atIndex:2];
        }
      }
      self.addedBlind = YES;
    } else {
      if (self.addedBlind) {
        [self.models removeObjectAtIndex:2];
        self.addedBlind = NO;
      }
    }
  };
  [self.requests addAPIRequest:api];
  [self.requests start];

  
}

- (XYHomeSectionInfo *)_buildBlindViewDataWithItems:(NSArray *)items {
  if (!items || items.count == 0) {
    return nil;
  }
  NSMutableArray *arr_M = @[].mutableCopy;
  for (NSDictionary *item in items) {
    NSDictionary *safeData = [item yy_modelToJSONObject];
    NSNumber *status = safeData[@"status"];
    NSNumber *sex = safeData[@"sex"];
    NSNumber *isFollow = safeData[@"isFollow"];
    NSString *area = safeData[@"area"];
    NSString *cityAreaName = [[XYAddressService sharedService] queryCityAreaNameWithAdcode:area];
    NSDictionary *dict = @{@"picURL" : safeData[@"headPortrait"],
                           @"nickname" : safeData[@"nickName"],
                           @"levelImg" : status.integerValue == 2 ? @"icon_14_renzheng" : @"icon_14_weirenzheng",
                           @"genderImg" : sex.integerValue == 2 ? @"icon_12_girl" : @"icon_12_boy",
                           @"slogan" : safeData[@"remark"],
                           @"hometown" : [NSString stringWithFormat:@"故乡：%@", cityAreaName],
                           @"attentionStatus" : isFollow.stringValue,
                           @"router":self.target ?: @"",
                           @"userId":safeData[@"userId"],
                           @"id":safeData[@"id"],
                          };
    [arr_M addObject:dict];
  }
  
  NSDictionary *info = @{
      @"headerClass":@"XYHomeHeaderReusableView",
      @"headerHeight":@"54",
      @"footerClass":@"XYHomeFooterReusableView",
      @"footerHeight":@"16",
      @"title":@"优秀如TA",
      @"subtitle":@"查看更多",
      @"router": @"blind",
      @"picURL":@"ic_arrow_gray",
      @"rowInfo":@{
                  @"cellClass":@"XYHomeFeaturedContentCell",
                  @"minVSpacing":@"",
                  @"minHSpacing":@"",
                  @"cellHeight":@(ceil(kScreenWidth*0.85)+77),
                  @"data":@[arr_M]
                  }
        };
  
  return [XYHomeSectionInfo yy_modelWithDictionary:info];
}

- (XYHomeSectionInfo *)_buildBannerDataWithItems:(NSArray *)items {
  if (!items || items.count == 0) {
    return nil;
  }
  NSMutableArray *arr_M = @[].mutableCopy;
  for (NSDictionary *item in items) {
    NSDictionary *safeData = [item yy_modelToJSONObject];
    NSString *imageUrl = safeData[@"imageUrl"];
    NSString *jumpLink = safeData[@"jumpLink"];
    NSNumber *skipType = safeData[@"skipType"];
    NSDictionary *dict = @{@"imageUrl" : imageUrl ?: @"",
                           @"router":self.target ?: @"",
                           @"skipType":skipType ?: @(0),
                           @"jumpLink":jumpLink ?: @""};
    [arr_M addObject:dict];
  }
  NSDictionary *info = @{
      @"headerClass":@"",
      @"headerHeight":@"",
      @"footerClass":@"",
      @"footerHeight":@"",
      @"title":@"",
      @"subtitle":@"",
      @"router": @"",
      @"picURL":@"",
      @"rowInfo":@{
                  @"cellClass":@"XYHomeSlideshowCell",
                  @"minVSpacing":@"",
                  @"minHSpacing":@"",
                  @"cellHeight":@(ceil((kScreenWidth-32)*0.32)),
                  @"data":@[arr_M]
                  }
        };
  
  return [XYHomeSectionInfo yy_modelWithDictionary:info];
}

- (XYHomeSectionInfo *)_buildTaskDataWithItems:(NSArray *)items {
  if (!items || items.count == 0) {
    return nil;
  }
  NSMutableArray *arr_M = @[].mutableCopy;
  NSUInteger index = 0;
  for (NSDictionary *item in items) {
    NSDictionary *safeData = [item yy_modelToJSONObject];
    NSString *taskName = [safeData[@"taskName"] toSafeValue];
    NSString *icon = [safeData[@"icon"] toSafeValue];
    NSNumber *rewardsGold = [safeData[@"rewardsGold"] toSafeValue];
    NSNumber *taskType = [safeData[@"taskType"] toSafeValue];
    NSString *remark = [safeData[@"remark"] toSafeValue];
    NSNumber *status = [safeData[@"receiveStatus"] toSafeValue];
    NSNumber *taskId = [safeData[@"id"] toSafeValue];
    NSNumber *expand = @(NO);
    
    NSDictionary *dict = @{@"title" : taskName ?: @"",
                           @"picURL": icon ?: @"",
                           @"taskId": taskId ?: @"",
                           @"detail": rewardsGold ? [NSString stringWithFormat:@"奖励%@乡币", rewardsGold] : @"",
                           @"actionType": taskType.stringValue ?: @"",
                           @"content": remark ?: @"",
                           @"expand": expand ?: @(NO),
                           @"expandHeight": @(0),
                           @"status": status,
                           @"index": @(index),
                           @"router":self.target ?: @""
    };
    [arr_M addObject:dict];
    index ++;
  }
  
  NSDictionary *info = @{
    @"headerClass":@"XYHomeHeaderReusableView",
    @"headerHeight":@"54",
    @"footerClass":@"",
    @"footerHeight":@"",
    @"title":@"做任务得乡币",
    @"subtitle":@"完成任务拿奖励",
    @"router":@"task",
    @"picURL":@"icon_22_yiweng",
    @"rowInfo":@{
            @"cellClass":@"XYHomeTaskCell",
            @"minVSpacing":@"",
            @"minHSpacing":@"",
            @"cellHeight":@(88),
            @"data":arr_M ?: @[]
            }
  };
  
  return [XYHomeSectionInfo yy_modelWithDictionary:info];
}

- (void)followUserId:(NSNumber *)userId block:(void(^)(NSUInteger index, NSDictionary *info, XYError *error))block {
  XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
  XYHomeSectionInfo *sectionInfo = self.models.count > 2 ? self.models[2] : nil;
  if (!sectionInfo) {
    if (block) {
      block(0, nil, ClientExceptionUndefined());
    }
    return;
  }
  
  NSString *followStatus;
  NSNumber *Id;
  NSUInteger index = 0;
  for (NSDictionary *info in sectionInfo.rowInfo.data.firstObject) {
    NSNumber *toUserId = info[@"userId"];
    if (userId.integerValue == toUserId.integerValue) {
      followStatus = info[@"attentionStatus"];
      Id = info[@"id"];
      break;
    }
    index ++;
  }
  
  if (!followStatus.isNotBlank) {
    if (block) {
      block(index, nil, ClientExceptionUndefined());
    }
    return;
  }
  
  XYFollowAPI *api = [[XYFollowAPI alloc] initWithUserId:userInfo.userId destUserId:userId operation:@(followStatus.integerValue+1) source:@(1) dyId:Id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    NSMutableDictionary *dict = [self.models[2].rowInfo.data.firstObject[index] mutableCopy];
    dict[@"attentionStatus"] = followStatus.integerValue == 0 ? @"1" : @"0";
    self.models[2].rowInfo.data.firstObject[index] = dict;
    if (block) {
      block(index, dict, error);
    }
  };
  [api start];
}

- (void)receiveTaskWithIndex:(NSUInteger)index block:(void(^)(XYError *error))block {
  XYHomeSectionInfo *sectionInfo = self.models.count > 2 ? self.models.lastObject : nil;
  
  if (!sectionInfo) {
    if (block) {
      block(ClientExceptionUndefined());
    }
    return;
  }
  
  NSNumber *status = sectionInfo.rowInfo.data[index][@"status"];
  if (status.integerValue == 0) {
    NSNumber *taskId = sectionInfo.rowInfo.data[index][@"taskId"];
    XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
    
    XYReceiveTaskAPI *api = [[XYReceiveTaskAPI alloc] initWithUserId:userInfo.userId taskId:taskId];
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      if (!error) {
        NSMutableDictionary *dict = [self.models.lastObject.rowInfo.data[index] mutableCopy];
        NSNumber *currentExpand = dict[@"expand"];
        [dict setValue:@(!currentExpand.boolValue) forKey:@"expand"];
        
        NSString *remark = dict[@"content"];
        UILabel *tempLable = [UILabel new];
        tempLable.font = AdaptedFont(12);
        tempLable.text = remark;
        tempLable.numberOfLines = 0;
        CGFloat height = [tempLable sizeThatFits:CGSizeMake(kScreenWidth-64, CGFLOAT_MAX)].height;
        [dict setValue:currentExpand.boolValue || !remark.isNotBlank ? @(0) : @(height + 32) forKey:@"expandHeight"];
        dict[@"status"] = @(1);
        self.models.lastObject.rowInfo.data[index] = dict;
      }
      if (block) {
        block(error);
      }
    };
    [api start];
  } else if (status.integerValue == 1) {
    NSMutableDictionary *dict = [self.models.lastObject.rowInfo.data[index] mutableCopy];
    NSNumber *currentExpand = dict[@"expand"];
    [dict setValue:@(!currentExpand.boolValue) forKey:@"expand"];
    
    NSString *remark = dict[@"content"];
    UILabel *tempLable = [UILabel new];
    tempLable.font = AdaptedFont(12);
    tempLable.text = remark;
    tempLable.numberOfLines = 0;
    CGFloat height = [tempLable sizeThatFits:CGSizeMake(kScreenWidth-64, CGFLOAT_MAX)].height;
    [dict setValue:currentExpand.boolValue || !remark.isNotBlank ? @(0) : @(height + 32) forKey:@"expandHeight"];
    self.models.lastObject.rowInfo.data[index] = dict;
    if (block) {
      block(nil);
    }
  } else if (status.integerValue == 2) {
    if (block) {
      block([XYError clientErrorWithCode:@"-10009" msg:@"您已完成此任务，明天再来尝试下"]);
    }
  }
}

- (void)updateLocation:(XYFormattedArea *)model {
  XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
  NSString *hometownTag = [NSString stringWithFormat:@"hometown_%@", userInfo.area];
  NSString *locationTag = [NSString stringWithFormat:@"location_%@", model.code];
  [JPUSHService setTags:[NSSet setWithArray:@[hometownTag, locationTag]] completion:nil seq:1000];
  XYUpdateLocationAPI *api = [[XYUpdateLocationAPI alloc] initWithUserId:userInfo.userId latitude:@(model.latitude) longitude:@(model.longitude)];
  [api start];
}

- (void)fetchInterestDataWithBlock:(void(^)(NSArray <XYInterestItem *>* data))block {
  XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
  if (userInfo.islogin) {
    XYGetInterestAPI *api = [[XYGetInterestAPI alloc] initWithUserId:userInfo.userId];
    api.filterCompletionHandler = ^(NSDictionary *_Nullable data, XYError * _Nullable error) {
      if (error || !data) {
        if (block) block(nil);
        return;
      }
      XYInterestModel *model = [XYInterestModel yy_modelWithDictionary:data];
      if (model) {
        NSMutableArray *viewData = @[].mutableCopy;
        for (XYInterestUserModel *user in model.users) {
          XYInterestItem *item = [[XYInterestItem alloc] init];
          item.picURL = user.headPortrait;
          item.name = user.nickName;
          item.subTitle = user.oneIndustry;
          item.subsubTitle = [[XYAddressService sharedService] queryCityAreaNameWithAdcode:user.area];
          item.male = (user.sex.integerValue == 0);
          item.group = NO;
          item.relationId = user.userId.stringValue;
          item.added = user.isFriend.integerValue == 1 ? YES : NO;
          [viewData addObject:item];
        }
        for (XYInterestGroupModel *group in model.groups) {
          XYInterestItem *item = [[XYInterestItem alloc] init];
          item.picURL = group.faceUrl;
          item.name = group.name;
          item.subTitle = [NSString stringWithFormat:@"人数：%@",group.memberNum];
          item.group = YES;
          item.relationId = group.groupId;
          item.added = YES;
          [viewData addObject:item];
        }
        if (block) block(viewData);
      } else {
        if (block) block(nil);
      }
    };
    [api start];
  }
}

- (void)searchWithWords:(NSString *)words block:(void(^)(XYHomeSearchResultModel* data))block {
  XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
  if (userInfo.islogin) {
    XYHomeSearchAPI *api = [[XYHomeSearchAPI alloc] initWithUserId:userInfo.userId words:words];
    api.filterCompletionHandler = ^(NSDictionary *_Nullable data, XYError * _Nullable error) {
      if (error || !data) {
        if (block) block(nil);
        return;
      }
      XYHomeSearchResultModel *model = [XYHomeSearchResultModel yy_modelWithDictionary:data];
      if (model) {
        if (block) block(model);
      } else {
        if (block) block(nil);
      }
    };
    [api start];
  }
}

- (void)batchAPIRequestsDidFinished:(nonnull XYAPIBatchAPIRequests *)batchApis {
  [batchApis.apiRequestsSet removeAllObjects];
  if (self.pageViewRefreshBlock) {
    self.pageViewRefreshBlock();
  }
}

- (XYFormattedArea *)currentArea {
  if (!_currentArea) {
    _currentArea = [[XYFormattedArea alloc] init];
  }
  return _currentArea;
}
@end
