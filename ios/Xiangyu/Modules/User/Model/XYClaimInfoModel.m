//
//  XYClaimInfoModel.m
//  Xiangyu
//
//  Created by Kang on 2021/6/30.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYClaimInfoModel.h"

@implementation XYClaimInfoModel

-(NSString *)educationName{
  if (!_educationName) {
    NSArray *education = @[@{@"id":@2,@"name":@"初中及以下"},@{@"id":@3,@"name":@"高中及中专"},@{@"id":@4,@"name":@"大专"},@{@"id":@5,@"name":@"本科"},@{@"id":@6,@"name":@"硕士及以上"}];
    for (NSDictionary *dic in education) {
      if ([[dic objectForKey:@"id"] integerValue] == [self.education integerValue]) {
        _educationName  = [dic objectForKey:@"name"];
        break;
      }
    }
  }
  return _educationName;
}

-(NSString *)address{
  
  if (!_address) {
    NSString *string = @"";
//    if (self.province && [[XYAddressService sharedService] queryModelWithAdcode:self.province]) {
//      string = [[XYAddressService sharedService] queryModelWithAdcode:self.province].name;
//    }
   if (self.city && [[XYAddressService sharedService] queryModelWithAdcode:self.city]) {
      NSString *cityName = [[XYAddressService sharedService] queryModelWithAdcode:self.city].name;
      string = [NSString stringWithFormat:@"%@",cityName];
    }
    if (self.area && [[XYAddressService sharedService] queryAreaNameWithAdcode:self.area]) {
      NSString *areaName =[[XYAddressService sharedService] queryModelWithAdcode:self.area].name;
      string = [NSString stringWithFormat:@"%@%@",string,areaName];
    }else{
      string = [NSString stringWithFormat:@"%@%@",string,@"不限"];
    }
    if (string.length) {
      _address = string;
    }else{
      _address = @"不限";
    }
    
    
  }
 
  

  
  return _address;
}
-(NSString *)dwelladdress{
  
  if (!_dwelladdress) {
    NSString *string = @"";
//    if (self.dwellProvince && [[XYAddressService sharedService] queryModelWithAdcode:self.dwellProvince]) {
//      string = [[XYAddressService sharedService] queryModelWithAdcode:self.dwellProvince].name;
//    }
//    if (self.dwellCity && [[XYAddressService sharedService] queryModelWithAdcode:self.dwellCity]) {
//      NSString *cityName = [[XYAddressService sharedService] queryModelWithAdcode:self.dwellCity].name;
//      string = [NSString stringWithFormat:@"%@%@",string,cityName];
//    }
    if (self.dwellArea && [[XYAddressService sharedService] queryAreaNameWithAdcode:self.dwellArea]) {
      string =[[XYAddressService sharedService] queryAreaNameWithAdcode:self.dwellArea];
    //  string = [NSString stringWithFormat:@"%@%@",string,cityName];
    }
    if (string.length) {
      _dwelladdress = string;
    }else{
      _dwelladdress = @"不限";
    }
    
    
  }
 
  
  return _dwelladdress;
}
@end
