//
//  XYSearchFriendsDataManager.m
//  Xiangyu
//
//  Created by dimon on 04/02/2021.
//

#import "XYSearchFriendsDataManager.h"
#import "XYQueryFriendsAPI.h"
#import "XYUserService.h"
@interface XYSearchFriendsDataManager ()

@property (nonatomic, strong, readwrite) XYFriendDataReq *reqParams;

@property (nonatomic,assign) NSUInteger page;

@end

@implementation XYSearchFriendsDataManager

- (void)fetchIndustryDataWithBlock:(void(^)(BOOL ret))block {
  if (self.industryDatas && self.industryDatas.count > 0) {
    if (block) block(YES);
    return;
  }
  [[XYPlatformService shareService] fetchIndustryDataWithBlock:^(NSArray<XYIndustryModel *> *data, XYError *error) {
    if (error) {
      if (block) block(NO);
    } else {
      self.industryDatas = data;
      if (block) block(YES);
    }
  }];
}

- (void)fetchJuniorSchoolDataWithBlock:(void(^)(BOOL ret))block {
  if (self.juniorSchoolDatas.count > 0 && self.juniorSchoolNameDatas.count > 0) {
    if (block) block(YES);
    return;
  }
  
  [[XYPlatformService shareService] fetchSchoolDataWithProvice:self.reqParams.province
                                                          city:self.reqParams.city
                                                          area:self.reqParams.area
                                                          type:1
                                                         block:^(NSArray<XYSchoolModel *> *data, XYError *error) {
    if (error) {
      if (block) block(NO);
    } else {
      [self.juniorSchoolDatas removeAllObjects];
      [self.juniorSchoolNameDatas removeAllObjects];
      for (XYSchoolModel *item in data) {
        [self.juniorSchoolDatas addObject:item];
        [self.juniorSchoolNameDatas addObject:item.schoolName];
      }
      if (block) block(YES);
    }
  }];
}

- (void)fetchSeniorSchoolDataWithBlock:(void(^)(BOOL ret))block {
  if (self.seniorSchoolDatas.count > 0 && self.seniorSchoolNameDatas.count > 0) {
    if (block) block(YES);
    return;
  }
  
  [[XYPlatformService shareService] fetchSchoolDataWithProvice:self.reqParams.province
                                                          city:self.reqParams.city
                                                          area:self.reqParams.area
                                                          type:2
                                                         block:^(NSArray<XYSchoolModel *> *data, XYError *error) {
    if (error) {
      if (block) block(NO);
    } else {
      [self.seniorSchoolDatas removeAllObjects];
      [self.seniorSchoolNameDatas removeAllObjects];
      for (XYSchoolModel *item in data) {
        [self.seniorSchoolDatas addObject:item];
        [self.seniorSchoolNameDatas addObject:item.schoolName];
      }
      if (block) block(YES);
    }
  }];
}

- (void)switchHomeTownWithProvice:(NSString *)provice city:(NSString *)city area:(NSString *)area WithBlock:(void(^)(BOOL needRefresh, XYError * error))block {
  [self.juniorSchoolDatas removeAllObjects];
  [self.juniorSchoolNameDatas removeAllObjects];
  
  [self.seniorSchoolDatas removeAllObjects];
  [self.seniorSchoolNameDatas removeAllObjects];
  
  //self.reqParams.province = provice;//
 // self.reqParams.city = city;
 //self.reqParams.area = area;
  
  self.reqParams.middleSchool = nil;
  self.reqParams.highSchool = nil;
  
  [self fetchJuniorSchoolDataWithBlock:^(BOOL ret) {
      [self fetchSeniorSchoolDataWithBlock:^(BOOL ret) {
        [self fetchNewDataWithBlock:block];
      }];
  }];
}

- (void)switchJuniorSchoolWithIndex:(NSUInteger)index block:(void(^)(BOOL needRefresh, XYError * error))block {
  if (index > self.juniorSchoolDatas.count - 1) {
    return;
  }
  
  self.reqParams.middleSchool = self.juniorSchoolDatas[index].id.stringValue;
  
  [self fetchNewDataWithBlock:block];
}

- (void)switchSeniorSchoolWithIndex:(NSUInteger)index block:(void(^)(BOOL needRefresh, XYError * error))block {
  if (index > self.seniorSchoolDatas.count - 1) {
    return;
  }
  
  self.reqParams.highSchool = self.seniorSchoolDatas[index].id.stringValue;
  
  [self fetchNewDataWithBlock:block];
}

- (void)switchStartAge:(NSUInteger)startAge endAge:(NSUInteger)endAge block:(void(^)(BOOL needRefresh, XYError * error))block {
  
  self.reqParams.startAge = @(startAge);
  
  self.reqParams.endAge = @(endAge);
  
  [self fetchNewDataWithBlock:block];
}

- (void)switchIndustryWithOneIndex:(NSUInteger)oneIndex
                       secondIndex:(NSUInteger)secondIndex
                             block:(void(^)(BOOL needRefresh, XYError * error))block {
  if (oneIndex > self.industryDatas.count - 1 || secondIndex > self.industryDatas[oneIndex].list.count - 1) {
    return;
  }
  
  self.reqParams.oneIndustry = self.industryDatas[oneIndex].id;
  self.reqParams.twoIndustry = self.industryDatas[oneIndex].list[secondIndex].id;
  
  [self fetchNewDataWithBlock:block];
}

- (void)fetchNewDataWithBlock:(void(^)(BOOL needRefresh, XYError * error))block {
  
  self.page = 1;
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  XYQueryFriendsAPI *api = [[XYQueryFriendsAPI alloc] initWithUserId:user.userId reqData:self.reqParams page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      NSArray *list = data[@"list"];
      [self.friendsData removeAllObjects];
      
      NSArray *arr = [NSArray yy_modelArrayWithClass:[XYFriendItem class] json:list];
      [self.friendsData addObjectsFromArray:arr];
      
      if (arr.count == 0) self.page --;
      
      if (block) block(YES, nil);
    }
  };
  [api start];

}

- (void)fetchNextDataWithBlock:(void(^)(BOOL needRefresh, XYError * error))block {
    self.page ++;
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];
    XYQueryFriendsAPI *api = [[XYQueryFriendsAPI alloc] initWithUserId:user.userId reqData:self.reqParams page:self.page];
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      if (error) {
        self.page --;
        if (block) block(NO, error);
      } else {
        NSArray *list = data[@"list"];
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XYFriendItem class] json:list];
        if (arr && arr.count > 0) {
          [self.friendsData addObjectsFromArray:arr];
          if (block) block(YES, nil);
        } else {
          if (block) block(NO, nil);
        }
      }
    };
    [api start];
}

#pragma - getter
- (NSMutableArray *)juniorSchoolDatas {
  if (!_juniorSchoolDatas) {
    _juniorSchoolDatas = @[].mutableCopy;
  }
  return _juniorSchoolDatas;
}

- (NSMutableArray *)seniorSchoolDatas {
  if (!_seniorSchoolDatas) {
    _seniorSchoolDatas = @[].mutableCopy;
  }
  return _seniorSchoolDatas;
}

- (NSMutableArray *)juniorSchoolNameDatas {
  if (!_juniorSchoolNameDatas) {
    _juniorSchoolNameDatas = @[].mutableCopy;
  }
  return _juniorSchoolNameDatas;
}

- (NSMutableArray *)seniorSchoolNameDatas {
  if (!_seniorSchoolNameDatas) {
    _seniorSchoolNameDatas = @[].mutableCopy;
  }
  return _seniorSchoolNameDatas;
}

- (NSMutableArray<XYFriendItem *> *)friendsData {
  if (!_friendsData) {
    _friendsData = @[].mutableCopy;
  }
  return _friendsData;
}

- (NSArray *)sexDatas {
  return @[@{@"name":@"不限", @"id":@(-10)}, @{@"name":@"男", @"id":@(1)}, @{@"name":@"女", @"id":@(2)}];
}

- (NSArray *)sexNameDatas {
  return @[@"不限", @"男", @"女"];
}

- (NSArray<NSString *> *)titleArray {
  return @[@"故乡地址", @"年龄", @"行业", @"初中学校", @"高中学校"];
}

- (XYFriendDataReq *)reqParams {
  if (!_reqParams) {
    _reqParams = [[XYFriendDataReq alloc] init];
    
    
    
    _reqParams.province = [[XYUserService service] fetchLoginUser].province;
    _reqParams.city = [[XYUserService service] fetchLoginUser].city;
    _reqParams.area = [[XYUserService service] fetchLoginUser].area;
  }
  return _reqParams;
}
@end

