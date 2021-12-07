//
//  XYBlindProfileModel.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYBlindProfileModel.h"
#import "XYAddressService.h"
#import "XYPlatformService.h"
@implementation XYBlindProfileModel
-(NSArray *)itemData{
  if (!_itemData) {
    NSMutableArray *list = [NSMutableArray new];
    
    if (self.age) {
      [list addObject:[NSString stringWithFormat:@"%@岁",self.age]];
    }
    if (self.weight) {
      [list addObject:[NSString stringWithFormat:@"%@kg",self.weight]];
    }
    
    if (self.jobs) {
      
      for (NSDictionary *dic in [XYPlatformService shareService].positionData_o) {
        if ([[dic objectForKey:@"id"] integerValue] == [self.jobs integerValue]) {
          [list addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
          break;
        }
      }
      
//      [list addObject:[NSString stringWithFormat:@"%@",self.jobs]];
    }
    
    //
    if (self.disposition) {
      
      for (NSDictionary *dic in [XYPlatformService shareService].characterData_o) {
        if ([[dic objectForKey:@"id"] integerValue] == [self.disposition integerValue])  {
          [list addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
          break;
        }
      }
      
   
    }
    
    if (self.salaryStart) {
      [list addObject:[NSString stringWithFormat:@"%@以上",self.salaryStart]];
    }
    
    if (self.educationName) {
      [list addObject:[NSString stringWithFormat:@"%@",self.educationName]];
    }
    if (self.oneIndustry) {
      [list addObject:[NSString stringWithFormat:@"%@",self.oneIndustry]];
    }
  
    if (self.twoIndustry) {
      [list addObject:[NSString stringWithFormat:@"%@",self.twoIndustry]];
    }
    if (self.isCar) {
      [list addObject:[NSString stringWithFormat:@"%@",self.isCar.integerValue == 1 ? @"已买车" : @"未买车"]];
    }
    if (self.isHouse) {
      [list addObject:[NSString stringWithFormat:@"%@",self.isHouse.integerValue == 1 ? @"已买房" : @"未买房"]];
    }
    if (self.intentionDate) {
      
      //
      
      for (NSDictionary *dic in [XYPlatformService shareService].hasMarriedData_o) {
        if ([[dic objectForKey:@"id"]integerValue] == [self.intentionDate integerValue]) {
          [list addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
          break;
        }
      }
      
      
   //   [list addObject:[NSString stringWithFormat:@"%@",self.intentionDate]];
    }
    
    if (self.dwellCity ) {
      
      if ([[XYAddressService sharedService] queryAreaNameWithAdcode:self.dwellCity]) {
        [list addObject:[NSString stringWithFormat:@"现居 %@",[[XYAddressService sharedService] queryAreaNameWithAdcode:self.dwellCity]]];
      }else{
        [list addObject:[NSString stringWithFormat:@"现居 %@",[[XYAddressService sharedService] queryAreaNameWithAdcode:self.dwellProvince]]];
      }
      
     
    }
    
    if (self.city) {
      
      
      if ([[XYAddressService sharedService] queryAreaNameWithAdcode:self.city]) {
        [list addObject:[NSString stringWithFormat:@"故乡 %@",[[XYAddressService sharedService] queryAreaNameWithAdcode:self.city]]];
      }else{
        [list addObject:[NSString stringWithFormat:@"故乡 %@",[[XYAddressService sharedService] queryAreaNameWithAdcode:self.province]]];
      }
      
    
    }
    
//    if (self.area) {
//      [list addObject:[NSString stringWithFormat:@"故乡 %@",[[XYAddressService sharedService] queryAreaNameWithAdcode:self.area]]];
//    }
    _itemData = list.copy;
  }
  return _itemData;
}
@end

@implementation XYBlindGiftModel

@end
