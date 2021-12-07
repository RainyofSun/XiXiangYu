//
//  XYAddressService.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/23.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAddressService.h"
#import "NSBundle+Extension.h"
#import "XYFMDB.h"
#import "XYQuerySubTownAPI.h"

static NSString *const AddressTableName = @"t_address";

@interface XYAddressService ()

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,assign) BOOL cResult;
@end

@implementation XYAddressService

static XYAddressService *service = nil;
+ (instancetype)sharedService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[XYAddressService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadingDataBase];
    }
    return self;
}

- (void)start {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!self.cResult) {
            return;
        }
        
        NSString *path = [NSBundle pathForResourceName:@"city" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSArray *tmp = [NSArray yy_modelArrayWithClass:[XYAddressItem class] json:data];

        self.data = tmp.mutableCopy;
        
        if(self.data.count > 0  && self.cResult) {
            [self insertAddressData];
        }
    });
}


- (void)loadingDataBase {
    self.cResult = [[XYFMDB sharedDatabase] createTable:AddressTableName
                                                 object:@{
                                                          @"code":SqlText,
                                                          @"name":SqlText,
                                                          @"parentId":SqlText,
                                                          @"firstLetter":SqlText,
                                                          @"level":SqlText,
                                                          @"longitude":SqlText,
                                                          @"latitude":SqlText,
                                                          }
                                          uniqueColumns:@"code"];
    
}

- (void)insertAddressData {
  
  if ([[XYFMDB sharedDatabase] tableItemCount:AddressTableName] > 0) {
    DLog(@"地址表已存在！");
    return;
  }
  
    __block BOOL a = YES;
    for (XYAddressItem * item in self.data) {
        if (!a) break;
      [[XYFMDB sharedDatabase] inDatabase:^{
        a = [[XYFMDB sharedDatabase] insertTable:AddressTableName object:item distinct:YES];
        [[XYFMDB sharedDatabase] closeOpenResultSets];
      }];
    }

    if (a) {
        DLog(@"批量插入地址信息数据成功！");
    } else {
        DLog(@"插入地址信息数据失败");
    }
    
//    [[XYFMDB sharedDatabase] inTransaction:^(BOOL *rollback) {
//        @try {
//            BOOL a = YES;
//            for (XYAddressItem * item in self.data) {
//                if (!a) break;
//                a = [[XYFMDB sharedDatabase] insertTable:AddressTableName object:item distinct:YES];
//            }
//
//            if (a) {
//                DLog(@"批量插入地址信息数据成功！");
//            } else {
//                *rollback = YES;
//                DLog(@"插入地址信息数据失败");
//            }
//          [[XYFMDB sharedDatabase] close];
//        }
//        @catch (NSException *exception) {
//            *rollback = YES;
//        }
//        @finally {
//
//        }
//    }];
}
//根据areaLevel 查询
- (NSArray *)queryProvince {
    if (self.cResult) {
      __block NSArray *data = nil;
      [[XYFMDB sharedDatabase] inDatabase:^{
        data = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] condition:@"where parentId = '100000'"];
      }];
        return data;
    } else {
        return nil;
    }
}

- (void)queryCityWithBlock:(void(^)(NSArray *data , NSArray <NSString *> *indexTitles))block {
    if (self.cResult) {
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XYFMDB sharedDatabase] inDatabase:^{
          NSArray *data = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] condition:@"where level = '2' order by firstLetter asc"];
          
          NSMutableSet *set = [NSMutableSet set];
          [data enumerateObjectsUsingBlock:^(XYAddressItem * obj, NSUInteger idx, BOOL *stop) {
            [set addObject:obj.firstLetter];
          }];
          
          NSArray *sortSetArray = [set allObjects];
          NSArray *sort = [sortSetArray sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
              return [obj1 compare:obj2];
          }];
          
          NSMutableArray *slices = [NSMutableArray array];
          [sort enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstLetter = %@", obj];
            NSArray *group = [data filteredArrayUsingPredicate:predicate];
             [slices addObject:group];
          }];
          
          NSArray *hotDatas = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@' or code = '%@' or code = '%@' or code = '%@' or code = '%@' or code = '%@' or code = '%@'",@"110100",@"310100",@"440300",@"440100",@"420100",@"330100",@"510100"]];
          
          if (hotDatas) {
            [slices insertObject:hotDatas atIndex:0];
          }
          
          dispatch_async_on_main_queue(^{
            if (block) {
              block(slices, sort);
            }
          });
        }];
      });
    } else {
        if (block) {
          block(nil, nil);
        }
    }
}

- (NSArray *)queryCityWithWords:(NSString *)words {
  if (!words.isNotBlank) {
    return nil;
  }
  
  if (self.cResult) {
    __block NSArray *data = nil;
    [[XYFMDB sharedDatabase] inDatabase:^{
      data = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where name like '%%%@%%' and level = '2'",words]];
    }];
    return data;
  } else {
      return nil;
  }
  
}

- (NSArray *)querySubAreaWithAdcode:(NSString *)adcode {
    if (self.cResult) {
      __block NSArray *data = nil;
      [[XYFMDB sharedDatabase] inDatabase:^{
        data = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where parentId = '%@'",adcode]];
      }];
      return data;
    } else {
        return nil;
    }
}

- (NSArray *)querySubAreaWithAdcode:(NSString *)adcode level:(XYAddressLevel)level {
    if (self.cResult) {
      if (!adcode.isNotBlank) {
          return nil;
      }
      
      NSString *code;
      switch (level) {
          case XYAddressLevelFirst:
              code = @"0";
              break;
          case XYAddressLevelSecond:
              code = [adcode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"];
              break;
          case XYAddressLevelThird:
              code = [adcode stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"];
              break;
          default:
              break;
      }
      __block NSArray *data = nil;
      [[XYFMDB sharedDatabase] inDatabase:^{
        data = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where parentId = '%@'",code]];
      }];
      return data;
    } else {
        return nil;
    }
}

- (XYAddressItem *)queryModelWithAdcode:(NSString *)adcode {
  if (self.cResult) {
    __block NSArray *data = nil;
    [[XYFMDB sharedDatabase] inDatabase:^{
      data = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",adcode]];
    }];
    XYAddressItem *item = data.firstObject;
    return item;
  } else {
      return nil;
  }
}

- (NSString *)queryAreaNameWithAdcode:(NSString *)adcode {
    if (self.cResult) {
      __block NSArray *data = nil;
      [[XYFMDB sharedDatabase] inDatabase:^{
        data = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",adcode]];
      }];
      XYAddressItem *item = data.firstObject;
      return item.name;
    } else {
        return nil;
    }
}

- (NSString *)queryFormattNameWithAdcode:(NSString *)adcode {
  if (adcode.length != 6) {
    return nil;
  }
  
  if (self.cResult) {
    __block NSArray *proData = nil;
    __block NSArray *cityData = nil;
    __block NSArray *disctData = nil;
    [[XYFMDB sharedDatabase] inDatabase:^{
      if ([adcode hasSuffix:@"0000"]) {
        proData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",[adcode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"]]];
      } else if ([adcode hasSuffix:@"00"]) {
        proData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",[adcode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"]]];
        cityData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",[adcode stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"]]];
      } else {
        proData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",[adcode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"]]];
        cityData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",[adcode stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"]]];
        disctData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",adcode]];
      }
    }];
    XYAddressItem *proItem = proData.firstObject;
    XYAddressItem *cityItem = cityData.firstObject;
    XYAddressItem *disctItem = disctData.firstObject;
    if ([self isMunicipalityWithCode:adcode]) {
      return [NSString stringWithFormat:@"%@%@",proItem ? proItem.name : @"", disctItem ? disctItem.name : @""];
    } else {
      return [NSString stringWithFormat:@"%@%@%@",proItem ? proItem.name : @"", cityItem ? cityItem.name : @"", disctItem ? disctItem.name : @""];
    }
  } else {
      return nil;
  }
}

- (NSString *)queryCityAreaNameWithAdcode:(NSString *)adcode {
  if (adcode.length != 6) {
    return nil;
  }
  
  if ([adcode hasSuffix:@"0000"] || [adcode hasSuffix:@"00"]) {
    return @"";
  }
  
  if (self.cResult) {
    __block NSArray *proData = nil;
    __block NSArray *cityData = nil;
    __block NSArray *disctData = nil;
    [[XYFMDB sharedDatabase] inDatabase:^{
      proData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",[adcode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"]]];
      cityData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",[adcode stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"]]];
      disctData = [[XYFMDB sharedDatabase] queryTable:AddressTableName object:[XYAddressItem class] whereFormat:[NSString stringWithFormat:@"where code = '%@'",adcode]];
    }];
    XYAddressItem *proItem = proData.firstObject;
    XYAddressItem *cityItem = cityData.firstObject;
    XYAddressItem *disctItem = disctData.firstObject;
    if ([self isMunicipalityWithCode:adcode]) {
      return [NSString stringWithFormat:@"%@%@",proItem ? proItem.name : @"", disctItem ? disctItem.name : @""];
    } else {
      return [NSString stringWithFormat:@"%@%@", cityItem ? cityItem.name : @"", disctItem ? disctItem.name : @""];
    }
  } else {
      return nil;
  }
}

- (void)queryTownWithAreacode:(NSString *)areaCode block:(void(^)(NSArray *data))block {
  XYQuerySubTownAPI *api = [[XYQuerySubTownAPI alloc] initWithCityCode:@(areaCode.integerValue)];
  api.filterCompletionHandler = ^(NSArray *  _Nullable data, XYError * _Nullable error) {
    if (error) {
      if (block) block(nil);
    } else {
      if (block) block([NSArray yy_modelArrayWithClass:[XYAddressItem class] json:data]);
    }
  };
  [api start];
}

- (BOOL)isMunicipalityWithCode:(NSString *)code {
  return [code hasPrefix:@"31"] || [code hasPrefix:@"11"] || [code hasPrefix:@"12"] || [code hasPrefix:@"50"];
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = @[].mutableCopy;
    }
    return _data;
}
@end
