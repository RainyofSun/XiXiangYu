//
//  XYLocationService.m
//  Xiangyu
//
//  Created by dimon on 22/01/2021.
//

#import "XYLocationService.h"
#import "XYPlatformService.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <LBXPermission/LBXPermission.h>

#import "IPAddressService.h"
static XYLocationService *instance = nil;

@interface XYLocationService ()<AMapSearchDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager * locationManager;

@property(nonatomic,strong)AMapSearchAPI *search;

@property (nonatomic, strong) XYFormattedArea *cachedArea;

@property(nonatomic,copy)XYLocationServiceBlock block;
@end

@implementation XYLocationService
+ (XYLocationService *)sharedService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)start {
  [AMapServices sharedServices].apiKey = AMAP_KEY;
}

- (void)requestLocationWithBlock:(void(^)(XYFormattedArea *model))block {
  [LBXPermission authorizeWithType:LBXPermissionType_Location completion:^(BOOL granted, BOOL firstTime) {
      if (granted) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
       // [self.locationManager startUpdatingLocation];
          [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            if (error ||!regeocode) {
              // 定位失败使用IP定位
              @weakify(self);
              [IPAddressService service].block = ^(NSString *ipString) {
                @strongify(self);
                if (ipString && ipString.length) {
                  [self AMapLocationWithIP:ipString block:block];
                }else{
                  if(block) block(nil);
                }
              };
            }
            if(!regeocode){
              [self doReGeocodeSearchWithLocation:location block:block];
            } else {
              XYFormattedArea *area = [[XYFormattedArea alloc] init];
              area.provinceCode = [regeocode.adcode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"];
              area.provinceName = regeocode.province;
              area.cityCode = [regeocode.adcode stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"];
              area.cityName = regeocode.city;
              area.code = regeocode.adcode;
              area.districtName = regeocode.district;
              area.formattedAddress = regeocode.formattedAddress;
              area.latitude = location.coordinate.latitude;
              area.longitude = location.coordinate.longitude;
              if (block) block(area);
            }
          }];
      } else {
        //if (block) block(nil);
        if (!firstTime) {
          [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
            if (!status) {
              [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"" msg:@"需要访问您的位置以为您推荐老乡、相亲数据。\n是否前往设置打开定位权限?" cancel:@"取消" setting:@"去设置"];
            }
          }];
          // 定位没有权限 使用IP定位
          @weakify(self);
          [IPAddressService service].block = ^(NSString *ipString) {
            @strongify(self);
            if (ipString && ipString.length) {
              [self AMapLocationWithIP:ipString block:block];
            }else{
              if(block) block(nil);
            }
          };
      
      }
      }
  }];
 
}

- (void)requestCachedLocationWithBlock:(void (^)(XYFormattedArea *))block {
  if (_cachedArea) {
    if (block) block(self.cachedArea);
  } else {
    [self requestLocationWithBlock:^(XYFormattedArea *model) {
      self.cachedArea = model;
      if (block) block(self.cachedArea);
    }];
  }
}

- (void)changeLocationWithArea:(XYFormattedArea *)area {
  self.cachedArea = area;
}

- (XYFormattedArea *)cachedArea {
  if (!_cachedArea) {
    _cachedArea = [[XYFormattedArea alloc] init];
  }
  return _cachedArea;
}

- (AMapLocationManager *)locationManager {
  if (!_locationManager) {
    _locationManager = [[AMapLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    _locationManager.distanceFilter = 3000;
   // _locationManager.delegate=self;
    _locationManager.locationTimeout =5;
    _locationManager.reGeocodeTimeout =5;
    //[_locationManager requestWhenInUseAuthorization];
  }
  return _locationManager;
}
-(AMapSearchAPI *)search{
  if (!_search) {
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate=self;
  }
  return _search;
}

-(void)doReGeocodeSearchWithLocation:(CLLocation*)location block:(XYLocationServiceBlock)block{
  self.block = block;
  self.search.delegate=self;
  AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
  regeo.location                    = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
  regeo.requireExtension            = YES;
  [self.search AMapReGoecodeSearch:regeo];
}
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
  if (response.regeocode != nil) {
    XYFormattedArea *area = [[XYFormattedArea alloc] init];
   area.provinceCode = [response.regeocode.addressComponent.adcode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"];
    area.provinceName = response.regeocode.addressComponent.province;
    area.cityCode = [response.regeocode.addressComponent.adcode stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"];
    area.cityName = response.regeocode.addressComponent.city;
    area.code = response.regeocode.addressComponent.adcode;
    area.districtName = response.regeocode.addressComponent.district;
    area.formattedAddress = response.regeocode.formattedAddress;
    area.latitude = request.location.latitude;
    area.longitude = request.location.longitude;
   if (self.block) self.block(area);
  }else{
    if (self.block) self.block(nil);
  }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
  if (self.block) self.block(nil);
}

#pragma mark  - ip 定位

-(void)AMapLocationWithIP:(NSString *)ip block:(XYLocationServiceBlock)block{
  AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
  [manager GET:@"https://restapi.amap.com/v3/ip" parameters:@{@"ip":ip,@"key":@"1eb5df478cf53343ede8a85beacf67a1"} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    XYIPLocationModel *locationModel  = [XYIPLocationModel yy_modelWithJSON:responseObject];
    
    
    if (locationModel.status == 1) {
      XYFormattedArea *area = [[XYFormattedArea alloc] init];
      
      
      
      
      
    area.provinceCode = [locationModel.adcode stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"];
      area.provinceName =locationModel.province;
     area.cityCode = [locationModel.adcode stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"];
    area.cityName = locationModel.city;
     area.code = @"";
      area.districtName = @"";
     area.formattedAddress = @"";
     area.latitude = 0;
     area.longitude = 0;
      if (block) {
        block(area);
      }
    }else{
      if (block) {
        block(nil);
      }
    }
    
    
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if (block) {
      block(nil);
    }
  }];
  
}

@end
