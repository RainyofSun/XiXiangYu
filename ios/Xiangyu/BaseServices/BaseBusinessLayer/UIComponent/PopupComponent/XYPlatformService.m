//
//  XYPlatformService.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/18.
//

#import "XYPlatformService.h"
#import "XYPlatformDataAPI.h"
#import "XYActionSheetView.h"
#import "XYRangeSliderPopView.h"


@implementation XYRatesConfigModel

@end

@implementation XYIndustryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"list" : [XYIndustryModel class] };
}

@end

@implementation XYSchoolModel

@end

@interface XYPlatformService ()



@property (nonatomic,strong) NSNumber *onlineSwitchStatus;

@end

static XYPlatformService *instance = nil;
@implementation XYPlatformService

+ (instancetype)shareService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XYPlatformService alloc] init];
    });
    return instance;
}

- (void)fetchOnlineSwitchWithBlock:(void(^)(BOOL status))block {
  if (self.onlineSwitchStatus) {
    if (block) block(self.onlineSwitchStatus.boolValue);
    return;
  }

  XYSwitchAPI *api = [[XYSwitchAPI alloc] init];
  api.filterCompletionHandler = ^(id data, XYError * _Nullable error) {
    if (![data isKindOfClass:[NSNumber class]] || error) {
      self.onlineSwitchStatus = @(NO);
    } else {
      self.onlineSwitchStatus = ((NSNumber *)data).integerValue == 1 ? @(YES) : @(NO);
    }
    if (block) block(self.onlineSwitchStatus.boolValue);
  };
  [api start];
}

- (void)displayRatesConfigSheetViewWithType:(NSNumber *)type block:(void(^)(NSDictionary *item))block {
  XYShowLoading;
  [self fetchRatesConfigDataWithType:type block:^(NSArray<XYRatesConfigModel *> *data, XYError *error) {
    XYHiddenLoading;
    if (data && data.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in self.ratesConfigData_o) {
        [data_m addObject:info[@"name"]];
      }
      XYActionSheetView *asView = [[XYActionSheetView alloc] init];
      asView.detail = @"选择有效期";
      asView.dataSource = data_m;
      asView.selectedBlock = ^(NSInteger index, NSString *text) {
        if (block) {
          XYRatesConfigModel *info = data.firstObject;
          info.validityName = text;
          info.validity = self.ratesConfigData_o[index][@"id"];
          block(info.yy_modelToJSONObject);
        }
      };
      [asView show];
    }
  }];
}

- (void)displayAgeSheetViewWithBlock:(void(^)(NSString *text, NSNumber * min, NSNumber * max))block {
  XYRangeSliderPopView *asView = [[XYRangeSliderPopView alloc] initWithMinValue:18 maxValue:50 minSelectValue:24 maxSelectValue:38 unit:@"岁"];
  asView.title = @"选择年龄";
  asView.selectedBlock = ^(NSNumber * _Nonnull min, NSNumber * _Nonnull max) {
    if (block) {
      NSUInteger minV = roundf(min.floatValue);
      NSUInteger maxV = roundf(max.floatValue);
      block([NSString stringWithFormat:@"%lu～%lu",(unsigned long)minV, (unsigned long)maxV], @(minV), @(maxV));
    }
  };
  [asView show];
}

- (void)displayHeightSliderSheetViewWithBlock:(void(^)(NSString *text, NSNumber * min, NSNumber * max))block {
  XYShowLoading;
  [self ps_fetchHeightDataWithBlock:^(NSArray *data) {
    XYHiddenLoading;
    if (data) {
      NSNumber *min = self.heightData_o.firstObject[@"size"];
      NSNumber *max = self.heightData_o.lastObject[@"size"];
      XYRangeSliderPopView *asView = [[XYRangeSliderPopView alloc] initWithMinValue:min.integerValue maxValue:max.integerValue unit:@"cm"];
      asView.title = @"选择身高";
      asView.selectedBlock = ^(NSNumber * _Nonnull min, NSNumber * _Nonnull max) {
        if (block) {
          NSUInteger minV = roundf(min.floatValue);
          NSUInteger maxV = roundf(max.floatValue);
          block([NSString stringWithFormat:@"%lu～%lu",(unsigned long)minV, (unsigned long)maxV], @(minV), @(maxV));
        }
      };
      [asView show];
    }
  }];
  
}

- (void)displaySexSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  NSMutableArray *data_m = @[].mutableCopy;
  for (NSDictionary *info in self.sexData_o) {
    [data_m addObject:info[@"name"]];
  }
  XYActionSheetView *asView = [[XYActionSheetView alloc] init];
  asView.detail = @"性别";
  asView.dataSource = data_m;
  asView.selectedBlock = ^(NSInteger index, NSString *text) {
    if (block) {
      NSDictionary *info = self.sexData_o[index];
      block(text, info[@"id"]);
    }
  };
  [asView show];
}

- (void)displayHasCarSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  NSMutableArray *data_m = @[].mutableCopy;
  for (NSDictionary *info in self.hasCarData_o) {
    [data_m addObject:info[@"name"]];
  }
  XYActionSheetView *asView = [[XYActionSheetView alloc] init];
  asView.detail = @"是否买车";
  asView.dataSource = data_m;
  asView.selectedBlock = ^(NSInteger index, NSString *text) {
    if (block) {
      NSDictionary *info = self.hasCarData_o[index];
      block(text, info[@"id"]);
    }
  };
  [asView show];
}

- (void)displayHasHouseSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  NSMutableArray *data_m = @[].mutableCopy;
  for (NSDictionary *info in self.hasHouseData_o) {
    [data_m addObject:info[@"name"]];
  }
  XYActionSheetView *asView = [[XYActionSheetView alloc] init];
  asView.detail = @"是否买房";
  asView.dataSource = data_m;
  asView.selectedBlock = ^(NSInteger index, NSString *text) {
    if (block) {
      NSDictionary *info = self.hasHouseData_o[index];
      block(text, info[@"id"]);
    }
  };
  [asView show];
}

- (void)displayHasMarriedSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  NSMutableArray *data_m = @[].mutableCopy;
  for (NSDictionary *info in self.hasMarriedData_o) {
    [data_m addObject:info[@"name"]];
  }
  XYActionSheetView *asView = [[XYActionSheetView alloc] init];
  asView.detail = @"是否结婚";
  asView.dataSource = data_m;
  asView.selectedBlock = ^(NSInteger index, NSString *text) {
    if (block) {
      NSDictionary *info = self.hasMarriedData_o[index];
      block(text, info[@"id"]);
    }
  };
  [asView show];
}

- (void)displayAdvertisingLocationSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  NSMutableArray *data_m = @[].mutableCopy;
  for (NSDictionary *info in self.advertisingData_o) {
    [data_m addObject:info[@"name"]];
  }
  XYActionSheetView *asView = [[XYActionSheetView alloc] init];
  asView.detail = @"广告位置";
  asView.dataSource = data_m;
  asView.selectedBlock = ^(NSInteger index, NSString *text) {
    if (block) {
      NSDictionary *info = self.advertisingData_o[index];
      block(text, info[@"id"]);
    }
  };
  [asView show];
}

- (void)displayHasWeightSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  NSMutableArray *data_m = @[].mutableCopy;
  for (NSDictionary *info in self.weightData_o) {
    [data_m addObject:info[@"name"]];
  }
  XYActionSheetView *asView = [[XYActionSheetView alloc] init];
  asView.detail = @"体重";
  asView.dataSource = data_m;
  asView.defaultRow = 15;
  asView.selectedBlock = ^(NSInteger index, NSString *text) {
    if (block) {
      NSDictionary *info = self.weightData_o[index];
      block(text, info[@"id"]);
    }
  };
  [asView show];
}

- (void)displayHeightSheetViewWithBlock:(void(^)(NSString *text, NSNumber * size))block {
  XYShowLoading;
  [self ps_fetchHeightDataWithBlock:^(NSArray *data) {
    XYHiddenLoading;
    if (data) {
      XYActionSheetView *asView = [[XYActionSheetView alloc] init];
      asView.detail = @"身高";
      asView.dataSource = data;
      asView.defaultRow = 20;
      asView.selectedBlock = ^(NSInteger index, NSString *text) {
        if (block) {
          NSDictionary *info = self.heightData_o[index];
          block(text, info[@"size"]);
        }
      };
      [asView show];
    }
  }];
}

- (void)displayEduSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  XYShowLoading;
  [self ps_fetchEducationDataWithBlock:^(NSArray *data) {
    XYHiddenLoading;
    if (data) {
      XYActionSheetView *asView = [[XYActionSheetView alloc] init];
      asView.detail = @"学历";
      asView.dataSource = data;
      asView.selectedBlock = ^(NSInteger index, NSString *text) {
        if (block) {
          NSDictionary *info = self.educationData_o[index];
          block(text, info[@"id"]);
        }
      };
      [asView show];
    }
  }];
}

- (void)displaySalarySheetViewWithBlock:(void(^)(NSString *text, NSNumber *start, NSNumber *end))block {
  XYShowLoading;
  [self ps_fetchSalaryDataWithBlock:^(NSArray *data) {
    XYHiddenLoading;
    if (data) {
      XYActionSheetView *asView = [[XYActionSheetView alloc] init];
      asView.detail = @"月薪";
      asView.dataSource = data;
      asView.selectedBlock = ^(NSInteger index, NSString *text) {
        if (block) {
          NSDictionary *info = self.salaryData_o[index];
          block(text, info[@"SalaryStart"], info[@"SalaryEnd"]);
        }
      };
      [asView show];
    }
  }];
}

- (void)displayShopSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  XYShowLoading;
  [self ps_fetchShopDataWithBlock:^(NSArray *data) {
    XYHiddenLoading;
    if (data) {
      XYActionSheetView *asView = [[XYActionSheetView alloc] init];
      asView.detail = @"门店";
      asView.dataSource = data;
      asView.selectedBlock = ^(NSInteger index, NSString *text) {
        if (block) {
          NSDictionary *info = self.shopData_o[index];
          block(text, info[@"id"]);
        }
      };
      [asView show];
    }
  }];
}

- (void)displayCharacterSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  XYShowLoading;
  [self ps_fetchCharacterDataWithBlock:^(NSArray *data) {
    XYHiddenLoading;
    if (data) {
      XYActionSheetView *asView = [[XYActionSheetView alloc] init];
      asView.detail = @"性格";
      asView.dataSource = data;
      asView.selectedBlock = ^(NSInteger index, NSString *text) {
        if (block) {
          NSDictionary *info = self.characterData_o[index];
          block(text, info[@"id"]);
        }
      };
      [asView show];
    }
  }];
}

- (void)displayPositionSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block {
  XYShowLoading;
  [self ps_fetchPositionDataWithBlock:^(NSArray *data) {
    XYHiddenLoading;
    if (data) {
      XYActionSheetView *asView = [[XYActionSheetView alloc] init];
      asView.detail = @"职位";
      asView.dataSource = data;
      asView.selectedBlock = ^(NSInteger index, NSString *text) {
        if (block) {
          NSDictionary *info = self.positionData_o[index];
          block(text, info[@"id"]);
        }
      };
      [asView show];
    }
  }];
}

- (void)displaySchoolSheetViewWithProvice:(NSString *)provice
                                     city:(NSString *)city
                                     area:(NSString *)area
                                     type:(NSNumber *)type
                                    block:(void(^)(NSString *text, NSNumber * ID))block {
  XYShowLoading;
  [self fetchSchoolDataWithProvice:provice city:city area:area type:type.integerValue block:^(NSArray<XYSchoolModel *> *data, XYError *error) {
    XYHiddenLoading;
    if (data) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (XYSchoolModel *info in data) {
        [data_m addObject:info.schoolName];
      }
      XYActionSheetView *asView = [[XYActionSheetView alloc] init];
      asView.detail = @"毕业学校";
      asView.dataSource = data_m;
      asView.selectedBlock = ^(NSInteger index, NSString *text) {
        if (block) {
          XYSchoolModel *info = data[index];
          block(text, info.id);
        }
      };
      [asView show];
    }
  }];
}

- (void)ps_fetchCharacterDataWithBlock:(void(^)(NSArray *data))block {
    if (self.characterData_o && self.characterData_o.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in self.characterData_o) {
        [data_m addObject:info[@"name"] ?: @""];
      }
      if (block) block(data_m.copy);
      return;
  }
    
  XYCharacterAPI *api = [[XYCharacterAPI alloc] init];
  api.apiCompletionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
    if (error) {
        if (block) block(nil);
        return;
    }
    if ([responseObject[@"character"] isKindOfClass:[NSArray class]]) {
      NSArray *arr = responseObject[@"character"];
      self.characterData_o = arr.deepCopy;
      if (arr && arr.count > 0) {
        NSMutableArray *data_m = @[].mutableCopy;
        for (NSDictionary *info in arr) {
          [data_m addObject:info[@"name"] ?: @""];
        }
        if (block) block(data_m.copy);
        return;
      }
    } else {
      if (block) block(nil);
    }
  };
  [api start];
}

- (void)ps_fetchPositionDataWithBlock:(void(^)(NSArray *data))block {
    if (self.positionData_o && self.positionData_o.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in self.positionData_o) {
        [data_m addObject:info[@"name"] ?: @""];
      }
      if (block) block(data_m.copy);
      return;
  }
    
  XYPositionAPI *api = [[XYPositionAPI alloc] init];
  api.apiCompletionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
    if (error) {
        if (block) block(nil);
        return;
    }
    NSArray *arr = responseObject[@"position"];
    self.positionData_o = arr.deepCopy;
    if (arr && arr.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in arr) {
        [data_m addObject:info[@"name"] ?: @""];
      }
      if (block) block(data_m.copy);
      return;
    } else {
      if (block) block(nil);
    }
  };
  [api start];
}

- (void)ps_fetchHeightDataWithBlock:(void(^)(NSArray *data))block {
    if (self.heightData_o && self.heightData_o.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in self.heightData_o) {
        [data_m addObject:[NSString stringWithFormat:@"%@cm",((NSNumber *)info[@"size"]).stringValue]];
      }
      if (block) block(data_m.copy);
      return;
    }
    
  XYHeightAPI *api = [[XYHeightAPI alloc] init];
  api.apiCompletionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
    if (error) {
        if (block) block(nil);
        return;
    }
    NSArray *arr = responseObject[@"height"];
    self.heightData_o = arr.deepCopy;
    if (arr && arr.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in arr) {
        [data_m addObject:[NSString stringWithFormat:@"%@cm",((NSNumber *)info[@"size"]).stringValue]];
      }
      if (block) block(data_m.copy);
      return;
    }
    
    if (block) block(nil);
  };
  [api start];
}

- (void)ps_fetchEducationWithBlock:(void(^)(NSArray *data))block{
  [self ps_fetchEducationDataWithBlock:^(NSArray *data) {
    if (block) block(self.educationData_o);
  }];
}

- (void)ps_fetchEducationDataWithBlock:(void(^)(NSArray *data))block {
    if (self.educationData_o && self.educationData_o.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in self.educationData_o) {
        [data_m addObject:info[@"name"] ?: @""];
      }
      if (block) block(data_m.copy);
      return;
  }
    
  XYDeuAPI *api = [[XYDeuAPI alloc] init];
  api.apiCompletionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
    if (error) {
        if (block) block(nil);
        return;
    }
    
    NSArray *arr = responseObject[@"Education"];
    self.educationData_o = arr.deepCopy;
    if (arr && arr.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in arr) {
        [data_m addObject:info[@"name"] ?: @""];
      }
      if (block) block(data_m.copy);
      return;
    }
    
    if (block) block(nil);
  };
  [api start];
}

- (void)ps_fetchSalaryDataWithBlock:(void(^)(NSArray *data))block {
  if (self.salaryData_o && self.salaryData_o.count > 0) {
    NSMutableArray *data_m = [NSMutableArray new];
    
    for (int i=0; i<self.salaryData_o.count; i++) {
      NSString *text;
      NSDictionary *info = [self.salaryData_o objectAtIndex:i];
      if (i== 0) {
        text = [NSString stringWithFormat:@"%@以下",info[@"SalaryEnd"]?:@""];
      }else if (i == (self.salaryData_o.count-1)){
        text = [NSString stringWithFormat:@"%@以上",info[@"SalaryStart"]?:@""];
      }else{
        text = [NSString stringWithFormat:@"%@-%@",info[@"SalaryStart"]?:@"",info[@"SalaryEnd"]?:@""];
      }
      [data_m addObject:text];
    }
//
//    for (NSDictionary *info in self.salaryData_o) {
//      NSString *text;
//      if (index == 0) {
//        text = [NSString stringWithFormat:@"%@以下",info[@"SalaryEnd"]?:@""];
//      } else if (index == self.salaryData_o.count - 1) {
//        text = @"50000以上";
//      } else {
//        text = [NSString stringWithFormat:@"%@-%@",info[@"SalaryStart"]?:@"",info[@"SalaryEnd"]?:@""];
//      }
//      [data_m addObject:text];
//      index ++;
//    }
    if (block) block(data_m.copy);
    return;
  }
  
  XYSalaryAPI *api = [[XYSalaryAPI alloc] init];
  api.apiCompletionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
    if (error) {
        if (block) block(nil);
        return;
    }
    
    NSArray *arr = responseObject[@"salary"];
    self.salaryData_o = arr;
    if (arr && arr.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      int i=0;
      for (NSDictionary *info in arr) {
        NSString *text = @"";
        if (i== 0) {
          text = [NSString stringWithFormat:@"%@以下",info[@"SalaryEnd"]?:@""];
        }else if (i == (arr.count-1)){
          text = [NSString stringWithFormat:@"%@以上",info[@"SalaryStart"]?:@""];
        }else{
          text = [NSString stringWithFormat:@"%@-%@",info[@"SalaryStart"]?:@"",info[@"SalaryEnd"]?:@""];
        }
        [data_m addObject:text];
        i++;
      }
      if (block) block(data_m.copy);
      return;
    }
    
    if (block) block(nil);
  };
  [api start];
}

- (void)ps_fetchShopDataWithBlock:(void(^)(NSArray *data))block {
  
  if (self.shopData_o && self.shopData_o.count > 0) {
    NSMutableArray *data_m = @[].mutableCopy;
    for (NSDictionary *info in self.shopData_o) {
      [data_m addObject:[NSString stringWithFormat:@"%@",info[@"name"]]];
    }
    if (block) block(data_m.copy);
    return;
  }
  
  XYShopAPI *api = [[XYShopAPI alloc] init];
  api.apiCompletionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
    if (error) {
        if (block) block(nil);
        return;
    }
    
    NSArray *arr = responseObject[@"shop"];
    self.shopData_o = arr;
    
    if (arr && arr.count > 0) {
      NSMutableArray *data_m = @[].mutableCopy;
      for (NSDictionary *info in arr) {
        [data_m addObject:info[@"name"]];
      }
      if (block) block(data_m.copy);
    } else {
      if (block) block(nil);
    }
  };
  [api start];
}
-(void)getSystemJson{
  //[self fetchIndustryDataWithBlock:nil];
  [self ps_fetchCharacterDataWithBlock:nil];
  [self ps_fetchEducationDataWithBlock:nil];
  [self ps_fetchPositionDataWithBlock:nil];
 
}
- (void)fetchIndustryDataWithBlock:(void(^)(NSArray <XYIndustryModel *> *data, XYError *error))block {
  if (self.industryData_o && self.industryData_o.count > 0) {
    if (block) block(self.industryData_o, nil);
    return;
  }
  
  XYIndustryAPI *api = [[XYIndustryAPI alloc] init];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (error) {
        if (block) block(nil , error);
        return;
    }
    
    NSArray <XYIndustryModel *> *arr = [NSArray yy_modelArrayWithClass:[XYIndustryModel class] json:data];
    self.industryData_o = arr;
    if (arr && arr.count > 0) {
      if (block) block(arr , nil);
      return;
    }
    
    if (block) block(nil, ClientExceptionNULL());
  };
  [api start];
}

- (void)fetchSchoolDataWithProvice:(NSString *)provice city:(NSString *)city area:(NSString *)area type:(NSUInteger)type block:(void(^)(NSArray <XYSchoolModel *> *data, XYError *error))block {
  
  XYSchoolAPI *api = [[XYSchoolAPI alloc] initWithProvice:provice city:city area:area type:@(type)];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (error) {
        if (block) block(nil , error);
        return;
    }
    
    NSArray <XYSchoolModel *> *arr = [NSArray yy_modelArrayWithClass:[XYSchoolModel class] json:data];
    if (arr && arr.count > 0) {
      if (block) block(arr , nil);
      return;
    }
    
    if (block) block(nil, ClientExceptionNULL());
  };
  [api start];
}

- (void)fetchRatesConfigDataWithType:(NSNumber *)type block:(void(^)(NSArray <XYRatesConfigModel *> *data, XYError *error))block {
  
  XYRatesConfigAPI *api = [[XYRatesConfigAPI alloc] initWithType:type.integerValue];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (error) {
        if (block) block(nil , error);
        return;
    }
    
    NSArray <XYRatesConfigModel *> *arr = [NSArray yy_modelArrayWithClass:[XYRatesConfigModel class] json:data];
    if (arr && arr.count > 0) {
      if (block) block(arr , nil);
      return;
    }
    
    if (block) block(nil, ClientExceptionNULL());
  };
  [api start];
}

#pragma - getter

- (NSArray *)weightData_o {
  if (!_weightData_o) {
    NSMutableArray *arr_M = @[].mutableCopy;
    for (NSUInteger i = 30; i <= 110; i ++) {
      [arr_M addObject:@{@"name":[NSString stringWithFormat:@"%zdkg", i], @"id":@(i)}];
    }
    _weightData_o = arr_M.copy;
  }
  return _weightData_o;
}

- (NSArray *)advertisingData_o {
  if (!_advertisingData_o) {
    _advertisingData_o = @[
    @{@"name":@"所有栏目", @"id":@(1)},
    @{@"name":@"首页", @"id":@(2)},
    @{@"name":@"相亲区", @"id":@(3)} ,
    @{@"name":@"拼车区", @"id":@(4)} ,
    @{@"name":@"美食区", @"id":@(5)} ,
    @{@"name":@"找工作区", @"id":@(6)} ,
    @{@"name":@"活动区", @"id":@(7)} ,
    @{@"name":@"找需求区", @"id":@(8)},
    ];
  }
  return _advertisingData_o;
}

- (NSArray *)sexData_o {
  if (!_sexData_o) {
    _sexData_o = @[@{@"name":@"男", @"id":@(1)}, @{@"name":@"女", @"id":@(2)}];
  }
  return _sexData_o;
}

- (NSArray *)hasCarData_o {
  if (!_hasCarData_o) {
    _hasCarData_o = @[@{@"name":@"已买车", @"id":@(1)}, @{@"name":@"未买车", @"id":@(0)}];
  }
  return _hasCarData_o;
}

- (NSArray *)hasHouseData_o {
  if (!_hasHouseData_o) {
    _hasHouseData_o = @[@{@"name":@"已买房", @"id":@(1)}, @{@"name":@"未买房", @"id":@(0)}];
  }
  return _hasHouseData_o;
}

- (NSArray *)hasMarriedData_o {
  if (!_hasMarriedData_o) {
    _hasMarriedData_o = @[
    @{@"name":@"一年内", @"id":@(1)},
    @{@"name":@"两年内", @"id":@(2)},
    @{@"name":@"三年内", @"id":@(3)},
    @{@"name":@"认同闪婚", @"id":@(4)},
    @{@"name":@"顺其自然", @"id":@(5)},
    @{@"name":@"暂无计划", @"id":@(6)},
    ];
  }
  return _hasMarriedData_o;
}

- (NSArray *)ratesConfigData_o {
  if (!_ratesConfigData_o) {
    _ratesConfigData_o = @[@{@"name":@"永久", @"id":@(-1)},
                           @{@"name":@"一年内", @"id":@(1)} ,
                           @{@"name":@"半年内", @"id":@(2)},
                           @{@"name":@"一月内", @"id":@(3)},
                           @{@"name":@"一周内", @"id":@(4)},];
  }
  return _ratesConfigData_o;
}

@end
