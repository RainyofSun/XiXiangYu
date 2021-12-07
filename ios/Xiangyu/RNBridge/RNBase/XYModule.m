//
//  XYModule.m
//  Xiangyu
//
//  Created by GQLEE on 2020/12/19.
//

#import "XYModule.h"
#import "XYGeneralAPI.h"
#import "XYAddressService.h"
#import "XYImageUploadManager.h"
#import "XYAddressSelector.h"
#import "XYLinkageRecycleViewController.h"
#import "XYPlatformService.h"
#import "XYDatePickerView.h"
#import "NSDate+YYAdd.h"
#import "XYLoginViewModel.h"
#import "XYUserService.h"
#import "XYLocationService.h"
#import "XYPlatformDataAPI.h"
#import "ShareView.h"
#import "XYBlindProfileController.h"
#import "XYPaymentController.h"
#import "TZImagePickerController.h"
#import "WebViewController.h"
#import "XYFaceAuthViewController.h"
#import "TUIConversationCellData.h"
#import "ChatViewController.h"
#import "XYTimelineProfileController.h"
#import "GKDYGiftView.h"
#import "GKSlidePopupView.h"
#import "FriendRequestViewController.h"
#import "XYFirendRequestViewController.h"
#import "XYRNBaseViewController.h"

#import "XYSelectedCityViewController.h"
#import "XYNewsInformationDecViewController.h"
#import "BRDatePickerView.h"
#import "HZPhotoBrowser.h"
#import "XYEditNickNameViewController.h"

#import "XYRemindPopView.h"

#import "XYCarNeedScreenView.h"
@interface XYModule ()

@property (nonatomic,strong) XYLoginViewModel *loginViewModel;
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) GKSlidePopupView *giftPopupView ;


@end
@implementation XYModule

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}
RCT_EXPORT_METHOD(UpdateUserInfo:(NSString *)dic ){
  [[NSNotificationCenter defaultCenter] postNotificationName:XYUpdateUserInfoNotificationName object:nil];

}
//获取web url host
RCT_EXPORT_METHOD(getUrlHost:(NSString *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  
  resolve(XY_SERVICE_HOST);
}
RCT_EXPORT_METHOD(toVCWithBlock:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  if ([dic[@"VC"] isEqualToString:@"XYSelectedCityViewController"]) {
    XYSelectedCityViewController *vc = [[XYSelectedCityViewController alloc] init];
    vc.selectedBlock = ^(XYAddressItem * _Nonnull item) {
      resolve([item yy_modelToJSONObject]);
    };
    [[self getCurrentVC] cyl_pushViewController:vc animated:YES];
  }
}

RCT_EXPORT_METHOD(toVC:(NSDictionary *)dic ){
  
  //
 //
 if ([dic[@"VC"] isEqualToString:@"XYNewsInformationDecViewController"]) {
    XYNewsInformationDecViewController *vc = [[XYNewsInformationDecViewController alloc] init];
    vc.params = dic[@"data"];
    [[self getCurrentVC] cyl_pushViewController:vc animated:YES];
  }
  
  if ([dic[@"VC"] isEqualToString:@"XYBlindProfileController"]) {
    XYBlindProfileController *vc = [[XYBlindProfileController alloc] init];
    vc.userId = dic[@"userId"];
    vc.blindId = dic[@"blindId"];
    
    [[self getCurrentVC] cyl_pushViewController:vc animated:YES];
  }else if([dic[@"VC"] isEqualToString:@"WebViewController"]) {
    WebViewController *vc = [[WebViewController alloc] init];
    if ([dic[@"type"] isEqualToString:@"1"]) {
      vc.dataDec = dic[@"data"];
    }else {
      vc.urlStr = dic[@"url"];
    }
    vc.title =  dic[@"title"];
    vc.type = dic[@"type"];
    
    [[self getCurrentVC] cyl_pushViewController:vc animated:YES];
  }else if([dic[@"VC"] isEqualToString:@"XYFaceAuthViewController"]) {
    XYFaceAuthViewController *vc = [[XYFaceAuthViewController alloc] init];
    vc.dataDic = dic;
    [[self getCurrentVC] cyl_pushViewController:vc animated:YES];
  }else if([dic[@"VC"] isEqualToString:@"ChatViewController"]) {
    TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
      conversationData.groupID = dic[@"jumpLink"];
      ChatViewController *chat = [[ChatViewController alloc] init];
      chat.conversationData = conversationData;
      [[self getCurrentVC] cyl_pushViewController:chat animated:YES];
  }else if([dic[@"VC"] isEqualToString:@"XYTimelineProfileController"]) {
    XYTimelineProfileController *profile = [[XYTimelineProfileController alloc] init];
    profile.userId = dic[@"userId"];
    [[self getCurrentVC] cyl_pushViewController:profile animated:YES];
  } else if ([dic[@"VC"] isEqualToString:@"加好友"]) {
      XYShowLoading;
      [[V2TIMManager sharedInstance] getUsersInfo:@[[dic[@"user_id"] stringValue]] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
        XYHiddenLoading;
        XYFirendRequestViewController *frc = [[XYFirendRequestViewController alloc] init];
        frc.profile = infoList.firstObject;
        [[self getCurrentVC] cyl_pushViewController:frc animated:YES];
      } fail:^(int code, NSString *msg) {
        XYHiddenLoading;
        XYToastText(msg);
      }];
  }
}
// 获取缓存大小
RCT_EXPORT_METHOD(cleanCachesSize:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  // 利用NSFileManager实现对文件的管理

//  CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
  CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject];
  
      NSString *message = size > 1 ? [NSString stringWithFormat:@"%.2fM", size] : [NSString stringWithFormat:@"%.2fK", size * 1024.0];
  resolve(@{@"size":message});
      
    
}
// 根据路径删除文件
RCT_EXPORT_METHOD(cleanCaches:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  // 利用NSFileManager实现对文件的管理

  CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject]; //+ [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
      
      NSString *message = size > 1 ? [NSString stringWithFormat:@"缓存%.2fM, 删除缓存", size] : [NSString stringWithFormat:@"缓存%.2fK, 删除缓存", size * 1024.0];
      
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
      
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject];
      //  [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
       // [self cleanCaches:NSTemporaryDirectory()];
        resolve(@{});
      }];
      
      UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
      [alert addAction:action];
      [alert addAction:cancel];
      [[self getCurrentVC] showDetailViewController:alert sender:nil];

    
}

// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
   // 利用NSFileManager实现对文件的管理
   NSFileManager *manager = [NSFileManager defaultManager];
   CGFloat size = 0;
   if ([manager fileExistsAtPath:path]) {
       // 获取该目录下的文件，计算其大小
       NSArray *childrenFile = [manager subpathsAtPath:path];
       for (NSString *fileName in childrenFile) {
           NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
           size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
       }
       // 将大小转化为M
       return size / 1024.0 / 1024.0;
   }
   return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
   // 利用NSFileManager实现对文件的管理
   NSFileManager *fileManager = [NSFileManager defaultManager];
   if ([fileManager fileExistsAtPath:path]) {
       // 获取该路径下面的文件名
       NSArray *childrenFiles = [fileManager subpathsAtPath:path];
       for (NSString *fileName in childrenFiles) {
           // 拼接路径
           NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
           // 将文件删除
           [fileManager removeItemAtPath:absolutePath error:nil];
       }

   }}
RCT_EXPORT_METHOD(toVCCertification:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  if ([dic[@"VC"] isEqualToString:@"实名认证"]) {
    NSString *method = @"api/v1/User/GetAuthStatus";
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];
    NSDictionary *params = @{
      @"userId":user.userId
    };

    XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
    api.requestParameters = params ?: @{};
    XYShowLoading;
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      XYHiddenLoading;
      if (!error) {
        if ([data[@"enterprise"] intValue] == 2 || [data[@"personal"] intValue] == 2) {
          resolve(@{@"type":@"1"});
        }else {

          if(dic[@"car"]){
   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发布成功" message:@"现在完成实名认证，拼车更迅速，旅程更安全" preferredStyle:UIAlertControllerStyleAlert];
          [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
          [alert addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            resolve(@{@"type":@"2"});
          }]];
              // 弹出对话框
              [[self getCurrentVC] presentViewController:alert animated:true completion:nil];
          }else{
   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未实名认证" preferredStyle:UIAlertControllerStyleAlert];
          [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
          [alert addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            resolve(@{@"type":@"2"});
          }]];
              // 弹出对话框
              [[self getCurrentVC] presentViewController:alert animated:true completion:nil];
          }

       
        }
      } else {
        
      }
    };
    [api start];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      XYHiddenLoading;
        });
  }else if([dic[@"VC"] isEqualToString:@"GKDYGiftView"]) {
    
    GKDYGiftView *commentView = [GKDYGiftView new];
    MJWeakSelf
    commentView.closePage = ^{
      [weakSelf clickGiftCloseBtn];
    };
//    [commentView.closeBtn handleControlEventWithBlock:^(id sender) {
//      [weakSelf clickGiftCloseBtn];
//    }];
  commentView.payWithSuccessGift = ^{
    [weakSelf clickGiftCloseBtn];
    resolve(@{});

    
  };
    [commentView.closeBtn addTarget:self action:@selector(clickGiftCloseBtn) forControlEvents:UIControlEventTouchUpInside];
      commentView.frame = CGRectMake(0, 0, GK_SCREEN_WIDTH, ADAPTATIONRATIO * 780.0f);
  commentView.user_id = dic[@"user_id"];
      _giftPopupView = [GKSlidePopupView popupViewWithFrame:[UIScreen mainScreen].bounds contentView:commentView];
      [_giftPopupView showFrom:[UIApplication sharedApplication].keyWindow completion:^{
        [commentView requestData];
      }];
}
}

- (void)clickGiftCloseBtn {
  [_giftPopupView dismiss];
}

RCT_EXPORT_METHOD(toVCInfo2:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
 // MJWeakSelf
  
  [[XYLocationService sharedService] requestCachedLocationWithBlock:^(XYFormattedArea *model) {
//    XYFormattedArea *item = [[XYFormattedArea alloc] init];
//    item.code = model.cityCode;
   // item.latitude = model.latitude;
   
    
    //item.longitude = model.longitude;
   // resolve([item yy_modelToJSONObject]);

  
  
  
  [[XYUserService service] updateNoNeedPerfectBlock:^(BOOL success, NSDictionary *info) {
    XYUserInfo *newInfo = [XYUserInfo yy_modelWithJSON:info];
      if (success) {
        
        
        NSString *city =  [[XYAddressService sharedService] queryAreaNameWithAdcode:newInfo.city];
        NSString *area =  [[XYAddressService sharedService] queryAreaNameWithAdcode:newInfo.area];
        
        NSString *dcity =  model.cityName;
        NSString *darea =  model.districtName;
        
        resolve(@{@"homeAdd":[NSString stringWithFormat:@"%@%@",city,area],@"endArea":newInfo.area,@"startArea":model.code,@"address":[NSString stringWithFormat:@"%@%@",dcity,darea]});
      }
    }];
  }];
}

RCT_EXPORT_METHOD(toVCInfo:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  MJWeakSelf
    [[XYUserService service] updateNoNeedPerfectBlock:^(BOOL success, NSDictionary *info) {
      XYUserInfo *newInfo = [XYUserInfo yy_modelWithJSON:info];
      if (success) {
      
        
        if ([dic objectForKey:@"show"] && [[dic objectForKey:@"show"] intValue] == 1) {
          resolve(@{@"type":newInfo.education.isNotBlank?@"0":@"1"});
          return;
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未完善资料" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
          resolve(@{@"type":@"2"});
        }]];
            // 弹出对话框
            [[weakSelf getCurrentVC] presentViewController:alert animated:true completion:nil];
      }else {
        if ([dic objectForKey:@"show"] && [[dic objectForKey:@"show"] intValue] == 1) {
          resolve(@{@"type":newInfo.education.isNotBlank?@"0":@"1"});
          return;
        }
        resolve(@{@"type":@"1"});
      }
    }];
  
  
}
RCT_EXPORT_METHOD(toastText:(NSString *)text){
  XYToastText(text);
}
RCT_EXPORT_METHOD(navigateBack){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XYModuleNavigateBack" object:nil];
}

RCT_EXPORT_METHOD(navigateFrontSideBack){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XYModuleNavigateFrontSideBack" object:nil];
}
RCT_EXPORT_METHOD(navigateFrontSideBackNo){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XYModuleNavigateFrontSideBackNo" object:nil];
}
//退出登录
RCT_EXPORT_METHOD(logout){
  
  [[XYUserService service] logoutUserWithBlock:^(BOOL success) {
      if (!success) {
//          self.lable.text = @"已登录";
      } else {
//          self.lable.text = @"未登录";
      }
  }];
}

//支付
RCT_EXPORT_METHOD(payPage:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  XYPaymentController *toVC = [[XYPaymentController alloc] init];
  toVC.money = dic[@"money"];
  toVC.buyType = dic[@"buyType"];
  toVC.merchantOrderNo = dic[@"merchantOrderNo"];
  MJWeakSelf
  toVC.payWithSuccess = ^{
    [[weakSelf getCurrentVC] dismissViewControllerAnimated:YES completion:nil];

    resolve(dic);

  };
  [[self getCurrentVC] presentViewController:toVC animated:YES completion:nil];
 
}

//修改昵称
RCT_EXPORT_METHOD(editNickNamePage:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  XYEditNickNameViewController *toVC = [[XYEditNickNameViewController alloc] init];
  toVC.pram = dic;
  toVC.saveBlock = ^(NSString * _Nonnull text) {
    resolve(text);
  };
//  toVC.buyType = dic[@"buyType"];
//  toVC.merchantOrderNo = dic[@"merchantOrderNo"];
//  MJWeakSelf
//  toVC.payWithSuccess = ^{
//    [[weakSelf getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
//
//    resolve(dic);
//
//  };
  [[self getCurrentVC].navigationController pushViewController:toVC animated:YES];;
 
}
//发布需求
RCT_EXPORT_METHOD(ratesConfigSheet:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  [[XYPlatformService shareService] displayRatesConfigSheetViewWithType:[code numberValue] block:^(NSDictionary *item) {
   
    resolve(item);
  }];
}
//门店
RCT_EXPORT_METHOD(shopSheet:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  [[XYPlatformService shareService] displayShopSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    
     resolve(@{
       @"text":text,
       @"id":[NSString stringWithFormat:@"%@",ID],
     });
  }];
}

//获取用户信息
RCT_EXPORT_METHOD(getUserData:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  NSString *item =  [[XYAddressService sharedService] queryAreaNameWithAdcode:user.city];
  
  resolve(
          @{
            @"province":user.province,
            @"city":user.city,
            @"cityName":item?item:@"",
            @"realName":user.nickName
          });
}

RCT_EXPORT_METHOD(cityData:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  
  
  NSArray *cityDataSouce = [[XYAddressService sharedService] querySubAreaWithAdcode:code level:XYAddressLevelSecond];
  resolve([cityDataSouce yy_modelToJSONObject]);
  
}
RCT_EXPORT_METHOD(areaData:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  
  
  NSArray *cityDataSouce = [[XYAddressService sharedService] querySubAreaWithAdcode:code level:XYAddressLevelThird];
  resolve([cityDataSouce yy_modelToJSONObject]);
  
}
RCT_EXPORT_METHOD(townData:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  [[XYAddressService sharedService] queryTownWithAreacode:code block:^(NSArray *data) {
    resolve([data yy_modelToJSONObject]);

    
  }];
}
RCT_EXPORT_METHOD(queryProvince:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  
  NSArray *province = [[XYAddressService sharedService] queryProvince];
  
  resolve([province yy_modelToJSONObject]);
  
}
RCT_EXPORT_METHOD(location:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  [[XYLocationService sharedService] requestCachedLocationWithBlock:^(XYFormattedArea *model) {
    XYFormattedArea *item = [[XYFormattedArea alloc] init];
    item.code = model.cityCode;
    item.latitude = model.latitude;
    item.longitude = model.longitude;
    resolve([item yy_modelToJSONObject]);
  }];
  
}
RCT_EXPORT_METHOD(requestLocation:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  XYShowLoading;
  [[XYLocationService sharedService] requestLocationWithBlock:^(XYFormattedArea *model) {
    XYHiddenLoading;
    resolve(model.formattedAddress);
  }];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    XYHiddenLoading;
      });
}

RCT_EXPORT_METHOD(requestPCALocation:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  XYShowLoading;
  [[XYLocationService sharedService] requestLocationWithBlock:^(XYFormattedArea *model) {
    XYHiddenLoading;
    resolve(@{
      @"provinceCode":model.provinceCode,
      @"provinceName":model.provinceName,
      @"cityCode":model.cityCode,
      @"cityName":model.cityName,
      @"code":model.code,
      @"districtName":model.districtName,
      @"formattedAddress":model.formattedAddress,
      
            });
  }];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    XYHiddenLoading;
      });
}

//省市区id转名称
RCT_EXPORT_METHOD(loginModel:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  
  resolve([NSString stringWithFormat:@"%@",self.loginViewModel.loginModel.mobile]);
}
RCT_EXPORT_METHOD(nickName:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];

  resolve([NSString stringWithFormat:@"%@",user.nickName]);
}
//省市区id转名称
RCT_EXPORT_METHOD(provinceIDName:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  
  NSString *province = [[XYAddressService sharedService] queryAreaNameWithAdcode:dic[@"province"]];
  NSString *city = [[XYAddressService sharedService] queryAreaNameWithAdcode:dic[@"city"]];
  NSString *area = [[XYAddressService sharedService] queryAreaNameWithAdcode:dic[@"area"]];
  resolve([NSString stringWithFormat:@"%@%@%@",province,city,area]);
}
//省市区id转名称
RCT_EXPORT_METHOD(provinceIDName1:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  
  NSString *province = [[XYAddressService sharedService] queryAreaNameWithAdcode:dic[@"province"]];
 // NSString *city = [[XYAddressService sharedService] queryAreaNameWithAdcode:dic[@"city"]];
//  NSString *area = [[XYAddressService sharedService] queryAreaNameWithAdcode:dic[@"area"]];
  resolve([NSString stringWithFormat:@"%@",province]);
}
//市区id转名称
RCT_EXPORT_METHOD(cityIDName:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  
  NSString *city = [[XYAddressService sharedService] queryAreaNameWithAdcode:dic[@"city"]];
  NSString *area = [[XYAddressService sharedService] queryAreaNameWithAdcode:dic[@"area"]];
  resolve([NSString stringWithFormat:@"%@%@",city,area]);
}
//选择省市区
RCT_EXPORT_METHOD(chooseAddress:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[IQKeyboardManager sharedManager] resignFirstResponder];
  XYAddressSelector *selector = [[XYAddressSelector alloc] initWithBaseViewController:[self getCurrentVC] withTown:NO];
  selector.adcode = code;
  selector.chooseFinish = ^(XYFormattedArea *area) {
    NSDictionary *dic = @{
      @"provinceCode":area.provinceCode,
      @"provinceName":area.provinceName,
      @"cityCode":area.cityCode,
      @"cityName":area.cityName,
      @"code":area.code,
      @"districtName":area.districtName,
      @"formattedAddress":area.formattedAddress,
    };
    resolve(dic);
  };
  [selector show];
}
//选择省市区
RCT_EXPORT_METHOD(chooseAddressWithTown:(NSString *)code resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[IQKeyboardManager sharedManager] resignFirstResponder];
  XYAddressSelector *selector = [[XYAddressSelector alloc] initWithBaseViewController:[self getCurrentVC] withTown:YES];
  selector.adcode = code;
  selector.chooseFinish = ^(XYFormattedArea *area) {
    NSDictionary *dic = @{
      @"provinceCode":area.provinceCode,
      @"provinceName":area.provinceName,
      @"cityCode":area.cityCode,
      @"cityName":area.cityName,
      @"code":area.code,
      @"districtName":area.districtName,
      @"townCode":area.townCode,
      @"townName":area.townName,
      @"formattedAddress":area.formattedAddress,
    };
    resolve(dic);
  };
  [selector show];
}
//选择行业
RCT_EXPORT_METHOD(selectIndustry:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  XYLinkageRecycleViewController *vc = [[XYLinkageRecycleViewController alloc] init];
  vc.selectedBlock = ^(NSString *name, NSNumber *firstCode, NSNumber *secondCode) {
    NSDictionary *dic = @{
      @"name":name,
      @"firstCode":firstCode.stringValue,
      @"secondCode":secondCode.stringValue,
    };
    resolve(dic);
  };
  [[self getCurrentVC] cyl_pushViewController:vc animated:YES];
}

RCT_EXPORT_METHOD(hasMarriedSheet:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayHasMarriedSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":ID.stringValue,
    };
    resolve(dic);
  }];
}
RCT_EXPORT_METHOD(advertisingLocation:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayAdvertisingLocationSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":ID.stringValue,
    };
    resolve(dic);
  }];
}
RCT_EXPORT_METHOD(selectSliderHeight:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayHeightSliderSheetViewWithBlock:^(NSString *text, NSNumber *min, NSNumber *max) {
    NSDictionary *dic = @{
      @"text":text,
      @"min":[NSString stringWithFormat:@"%@",min],
      @"max":[NSString stringWithFormat:@"%@",max]
    };
    resolve(dic);
  }];
}
//选择身高
RCT_EXPORT_METHOD(selectHeight:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayHeightSheetViewWithBlock:^(NSString *text, NSNumber *size) {
    NSDictionary *dic = @{
      @"text":text
    };
    resolve(dic);
  }];
}
//选择身高
RCT_EXPORT_METHOD(agreementPinChe:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  
  XYRemindPopView *popView=[[XYRemindPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/0.85)];
  popView.titleLabel.text = @"平台拼车协议";
  popView.urlStr = [NSString stringWithFormat:@"%@%@",XY_SERVICE_HOST,@"share/common.html?id=24"];
//  popView.textView.text = @"《平台用户拼车协议》(以下简称“本协议”)由喜乡遇平台(以下简称“平台”)运营者河南乡遇网络科技有限公司(以下简称“本公司”)和您签订。为保障您的权益，在使用平台“回家拼车”板块服务(以下简称“本服务”)之前，请您先认真阅读、充分理解本协议，特别是免除或限制责任的条款。免除或者限制责任的条款将以粗体及下划线标识，您应重点阅读。当您阅读、并点击确认同意本协议后，即表示您已充分阅读、理解并接受本协议的全部内容，并与本平台达成一致，成为本平台的“用户”，本协议对您及本平台均具有法律约束力。阅读本协议的过程中，如果您不同意本协议或其中任何条款约定，您应立即停止使用平台“回家拼车”板块服务。本协议内容包括本协议正文、本协议援引的其他协议、平台已经发布或后续不时发布、更新的平台规则。平台规则均被视为本协议不可分割的一部分，与本协议正文具有同等的法律效力。\n\n平台可根据法律法规变化及维护平台秩序、保护用户权益需要，不时修改本协议条款，并以提前公示、推送通知或弹窗等方式通知到您。您可以随时在本平台查阅修改后的最新版本协议。如您不同意修改内容，您有权于修改生效之日前于个人中心联系平台反馈意见，如反馈意见得以采纳，平台将酌情调整修改内容。如您不同意修改后的协议，您应当于变更生效之日起停止使用平台“回家拼车”板块服务，变更事项对您不产生效力。本协议更新后，如果您继续使用平台“回家拼车”板块服务，即视为您已接受修改后的协议。\n\n 一、“回家拼车”板块拼车性质及相关定义\n1.“回家拼车”性质：\n私人小客车合乘，也称为拼车，是由合乘服务提供者(以下称“车主”)事先于喜乡遇平台“回家拼车”板块发布出行信息，出行线路相同的人(以下称“合乘乘客”、“乘客”)选择乘坐合乘服务提供者的小客车，或有乘车需求的人于平台发布乘车需求信息，顺路车主主动联系以提供乘车服务，从而分摊部分出行成本或免费互助的共享出行方式。\n2.拼车车主:\n在喜乡遇平台“回家拼车”板块发布出行信息及合乘信息，且通过喜乡遇平台与合乘者达成合乘协议，分享车辆的闲置座位并驾驶合乘小客车的个人；或通过“人找车”栏目下需求信息主动联系乘车人分享闲置座位的个人。\n3.合乘乘客：\n在喜乡遇平台“回家拼车”板块发布合乘需求信息，选择合乘车主，且通过喜乡遇平台与顺风车车主达成合乘协议，乘坐顺风车车主驾驶的小客车，分摊出行成本的个人；或通过“车找人”栏目下需求信息主动联系车主达成拼车约定的个人。\n4.用户:\n顺风车车主和合乘乘客的统称。\n\n二、用户资格与账号使用规范\n1.用户资格\n您确认，在您开始使用喜乡遇“回家拼车”板块服务前，您应当具备中华人民共和国法律规定的与您行为相适应的民事行为能力。若您不具备前述与您行为相适应的民事行为能力，则您及您的监护人应依照法律规定承担相应法律责任。\n2.账号使用\n2.1使用平台“回家拼车”板块服务前，您已在平台进行注册，注册成功后，您则获得平台账号。平台通过用户手机验证码来识别用户的指令。用户确认，使用手机验证码登陆后在平台的一切行为均代表用户本人。用户账号操作所产生的电子信息记录均为用户行为的有效凭据，并由用户本人承担由此产生的法律责任。\n2.2由于用户账号关联用户身份信息，为更好维护平台秩序，用户账号仅供初始注册人使用，任何用户不得将账号转让、售卖、赠与、借用、租用、泄露给第三方或以其他方式许可第三方使用。如用户因违反本条约定或账号遭受攻击、诈骗等而遭受损失，用户应通过司法、行政等救济途径向侵权行为人追偿，平台不承担责任。如用户因违反本条约定给他人造成损失，用户应就全部损失与实际使用人承担连带责任，且平台有权追究用户违约责任，暂停或终止向您提供服务。\n2.3用户如发现账号存在安全漏洞或其他异常情况，应立即以有效方式通知平台，要求平台暂停相关服务，并根据平台的要求，协助平台向公安机关报案等措施。用户向平台发出的通知至少应当包括情况描述、相关的初步证据、要求平台采取的处理措施、通知人联系方式等，缺乏前述信息的通知视为无效通知。用户理解平台对用户的通知请求识别、采取行动需要合理时间，平台对采取行动前已经产生的后果(包括但不限于用户损失)及非因平台过错产生的后果不承担除法律法规明确规定之外的责任。\n\n三、服务内容\n1.国家统计局近日公布了第七次全国人口普查主要数据结果，数据显示，我国城镇流动人口达3.76亿。每逢年过节，大量流动人口需要进行返乡和回城活动，喜乡遇平台希望通过为用户提供回家拼车信息展示平台的服务，方便老乡用户提高车辆利用率，丰富乘车方式。因此您同意并理解，喜乡遇平台“回家拼车”板块提供的并不是运输服务，我们提供的仅是平台注册用户之间的信息交互服务，车主与平台无任何雇佣、合作关系，车主与乘客的顺路同行行为属于民事互助行为。\n2.平台“回家拼车”板块平台向您提供获得合乘机会或发布合乘需求的途径。您可以通过注册成为用户，通过喜乡遇平台“回家拼车”板块发布合乘需求而寻找合适的合乘者。具体线下合乘行为不属于平台服务内容。\n\n1、 车主的权利和义务\n1.车主于喜乡遇“回家拼车”板块发布的信息应真实、准确、完整。由于车主提供虚假或不完整信息所导致的责任或损失，应由车主独立承担。车主和车主的车辆，应当符合法律法规的要求;如发生违法行为或不符合相关条件，给其他用户或者平台造成损失的，平台有权依法追究其法律责任。\n2.车主应为完全民事行为能力人，且年龄为18至70周岁;身体健康，未患有妨碍安全驾驶机动车的疾病;取得 C2以上(含C2)驾驶证，具有1年以上驾驶经历，最近连续3个记分周期内没有记满12分记录;无犯罪记录、无吸毒记录、无饮酒后驾驶记录、非公开失信被执行人，法律法规另有规定的，从其规定。\n3.车主应使用具有公安部门核发的有效机动车号牌、年检合格、投保有效期限内的机动车交通事故责任强制保险的7座以下(含7座)小型非营运车辆合乘，且车辆所有人应为自然人、车辆使用年限在15年以内(含15年)，法律法规另有规定的，从其规定。\n4.车主应合法拥有车辆的使用权，负责监督对车辆进行日常管理和维修，保证车辆性能及技术状况良好，保证车辆行驶手续、行驶安全的合法性、有效性。\n5.车主应提前发布驾车出行信息，并标明出行时间、出发地目的地、费用分摊、特殊需求等信息并保证信息真实，合乘用户主动联系车主后，车主有权自行选择合乘乘客。\n6.车主一旦确认接受合乘需求，应当遵守与合乘乘客的约定，按时到达出发点，并将乘客送至约定抵达地点，按照事先约定收取费用，不得临时加价。\n7.车主所选择的线路应当符合顺路便行的原则，在合乘中应当依法自律、遵守道路交通安全等法律、法规的规定，按照操作规范安全、文明驾驶，确保乘客的出行安全。\n8.为防止乘客私自出借账号等行为的发生，车主在合乘前，请仔细核对乘客信息，如信息与预约信息不一致，车主有权拒继续合乘。\n\n2、 乘客的权利和义务\n1.乘客应具有完全民事行为能力，且年满18周岁，并保证其在喜乡遇“回家拼车”板块发布的需求信息真实、准确、完整。由于乘客提供虚假或不完整信息、变更信息未及时修改和通知车主，所导致的任何责任或损失，应由乘客独立承担。\n2.乘客有权对通过喜乡遇平台主动联系您的车主进行筛选，自愿与车主达成合乘约定。喜乡遇提供拼车需求信息发布、展示平台，不参与车主与合乘乘客的实际约定和线下履约，乘客搭乘车主的顺路车辆行为属于民事互助行为，乘车分摊费用等关键信息需要您在乘车前主动与车主沟通确认。由于路况、车主自身，或无人顺路等原因，行程时间的确定性无法保证，如您行程较为紧急，请提前安排备选计划，避免给您的行程带来影响。\n3.乘客应按照双方约定的时间和地点等候合乘，如因乘客原因无法继续合乘的，乘客应主动通知车主，自行协商道歉或补偿。\n4.为防止车主私自更换车辆、出借账号等行为的发生，乘客在乘坐车辆前，应仔细核对车辆及车主是否与预约信息一致。如发现车辆及车主与预约信息不一致，乘客应拒绝乘坐，并可向平台投诉，平台核实后可以按照平台用户规则对车主用户予以处理。\n5.除乘客提前说明合乘乘客不止一人的情形外，乘客应保证仅由乘客本人与车主合乘，否则车主有权拒绝乘客合乘。\n6.乘客应文明乘车，遵守国家的法律、法规，遵守交通安全管理规定;不得在合乘过程中进行不文明的行为(包括但不限于吸烟、喝酒、吐痰等)，不得携带危险品及其他法律、法规规定禁止携带的物品乘坐等，因乘客原因致使人员受伤、发生安全事故、交通事故、造成车辆损坏或其他损失的，乘客应向受损方进行赔偿，同时车主有权拒绝乘车。\n7.乘客理解并接受，车主并非专业的驾驶服务或出租车服务提供者，在合乘过程中出现的分歧，双方应进行友好协商，协商不成的，可以通过请求消费者组织、行业协会、其他依法成立的调解组织调解，向有关部门投诉，提请仲裁，提起诉讼等方式解决。\n\n六、保证与承诺\n您使用本服务的过程中，作出如下保证和承诺：\n1.您在平台“回家拼车”板块发布的拼车需求信息真实、准确、完整、合法、有效。\n2.您在使用平台服务的过程中实施的所有行为均遵守国家法律法规等的规定，不违背社会公共利益或公共道德不侵犯或试图侵犯他人的合法权益。\n3.您将严格遵守本协议以及平台规则的约定。\n4.您在平台上发送或传播的内容(包括但不限于网页、文字、图片、音频、视频、图表)不包含以下信息:\n4.1违反国家法律法规禁止性规定的;\n4.2政治宣传、封建迷信、淫秽、色情、赌博、暴力、恐怖或者教唆犯罪的;\n4.3欺诈、虚假、不准确或存在误导性的;\n4.4侵犯他人知识产权或涉及第三方商业秘密及其他专有权利的;\n4.5侮辱、诽谤、恐吓、涉及他人隐私等侵害他人合法权益的;\n4.6存在可能破坏、篡改、删除、影响平台任何系统正常运行或未经授权秘密获取平台及其他用户的数据、个人资料的病毒、木马、爬虫等恶意软件、程序代码的;\n4.7其他违背社会公共利益或公共道德或依据相关平台协议、规则的规定不适合在平台上发布的。\n如您违反本条约定，平台有权暂停或终止您使用本平台服务，并删除或屏蔽相关内容。\n\n七、责任限制\n本平台作为居间信息平台，为车主和乘客提供信息联通服务，除法律有明确规定外，平台不对您使用私人小客车合乘过程中可能遭受的损失承担责任，车主与乘客在私人小客车合乘服务过程中产生的任何纠纷/争议，由车主与乘客沟通解决。\n\n八、违约责任\n1.如用户违反法律法规、本协议、平台规则等约定，平台有权采取对在平台上发布的违法违约信息进行删除、屏蔽等措施，同时有权视您的行为严重程度采取警告、中止部分或全部服务、注销账号等措施。\n2.如用户因违反本协议约定给他人造成损失，用户应自行承担全部法律责任。平台因此遭受损失或代为偿还的，用户应予以赔偿，赔偿范围包括平台所受损失及因此支付的合理诉讼费、律师费、公证费、差旅费等。\n3.平台可将用户违约行为处理措施信息以及其他经国家行政或司法机关生效法律文书确认的违法信息在平台上予以公示。\n\n九、法律适用与管辖\n1.本协议之订立、生效、解释、修订、补充、终止、执行与争议解决均适用中华人民共和国大陆地区法律。如法律无相关规定的，参照商业惯例及/或行业惯例。\n2.您因使用平台服务所产生及与平台服务有关的争议，由平台与您协商解决。协商不成时，任何一方均可向被告所在地有管辖权的人民法院提起诉讼。\n2021年6月21日版本\n2021年6月29日生效";
  [popView show];
  
  // [[XYPlatformService shareService] displayHeightSheetViewWithBlock:^(NSString *text, NSNumber *size) {
  //   NSDictionary *dic = @{
  //     @"text":text
  //   };
  //   resolve(dic);
  // }];
}
//
//选择月薪
RCT_EXPORT_METHOD(selectMonthlypay:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displaySalarySheetViewWithBlock:^(NSString *text, NSNumber *start, NSNumber *end) {
    NSDictionary *dic = @{
      @"text":text,
      @"start":[NSString stringWithFormat:@"%@",start],
      @"end":[NSString stringWithFormat:@"%@",end]
    };
    resolve(dic);
  }];
}
//选择学历
RCT_EXPORT_METHOD(selectEducation:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayEduSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":[NSString stringWithFormat:@"%@",ID],
    };
    resolve(dic);
  }];
}
//选择职位
RCT_EXPORT_METHOD(selectPosition:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayPositionSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":[NSString stringWithFormat:@"%@",ID],
    };
    resolve(dic);
  }];
}
//选择性格
RCT_EXPORT_METHOD(selectCharacter:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayCharacterSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":[NSString stringWithFormat:@"%@",ID],
    };
    resolve(dic);
  }];
}
//选择体重
RCT_EXPORT_METHOD(selectHasWeight:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayHasWeightSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":[NSString stringWithFormat:@"%@",ID],
    };
    resolve(dic);
  }];
}
//选择买车
RCT_EXPORT_METHOD(selectHasCar:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayHasCarSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":[NSString stringWithFormat:@"%@",ID],
    };
    resolve(dic);
  }];
}
//选择买房
RCT_EXPORT_METHOD(selectHasHouse:(NSString *)height resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayHasHouseSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":[NSString stringWithFormat:@"%@",ID],
    };
    resolve(dic);
  }];
}
//选择时间
RCT_EXPORT_METHOD(selectDatePicker3:(NSString *)selectedDate resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    //创建日期格式化对象
//    NSDateFormatter *formatter =  [[NSDateFormatter alloc]init];
//    //设置日期格式(一定要和日期格式串中日期的格式保持一致).
//    [formatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
//      //将格式字符串转化为NSDate
//    NSDate *date = [formatter dateFromString:selectedDate];
  
  NSDate *date = [NSDate dateWithString:selectedDate format:@"yyyy-MM-dd'T'HH:mm:ss"];
  [BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"选择日期" selectValue:[date stringWithFormat:XYYTDDateFormatterName] isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
    resolve([selectDate stringWithFormat:XYFullNoZDateFormatterName]);
  }];
  
  
//    XYDatePickerView *picker = [[XYDatePickerView alloc] init];
//    picker.date = [NSDate dateWithString:selectedDate format:@"yyyy-MM-dd'T'HH:mm:ss"];
//    picker.selectedBlock = ^(NSDate * _Nonnull date) {
//      resolve([date stringWithFormat:XYFullNoZDateFormatterName]);
//    };
//    [picker show];
}
//选择时间
RCT_EXPORT_METHOD(selectDatePicker2:(NSString *)selectedDate resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    //创建日期格式化对象
//    NSDateFormatter *formatter =  [[NSDateFormatter alloc]init];
//    //设置日期格式(一定要和日期格式串中日期的格式保持一致).
//    [formatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
//      //将格式字符串转化为NSDate
//    NSDate *date = [formatter dateFromString:selectedDate];
  
  NSDate *date = [NSDate dateWithString:selectedDate format:@"yyyy-MM-dd'T'HH:mm:ss"];
  [BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"选择日期" selectValue:[date stringWithFormat:XYYTDDateFormatterName] minDate:[NSDate date] maxDate:nil isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
    resolve([selectDate stringWithFormat:XYFullNoZDateFormatterName]);
  }];
  
  
//    XYDatePickerView *picker = [[XYDatePickerView alloc] init];
//    picker.date = [NSDate dateWithString:selectedDate format:@"yyyy-MM-dd'T'HH:mm:ss"];
//    picker.selectedBlock = ^(NSDate * _Nonnull date) {
//      resolve([date stringWithFormat:XYFullNoZDateFormatterName]);
//    };
//    [picker show];
}
//选择时间
RCT_EXPORT_METHOD(selectDatePicker:(NSString *)selectedDate resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    //创建日期格式化对象
//    NSDateFormatter *formatter =  [[NSDateFormatter alloc]init];
//    //设置日期格式(一定要和日期格式串中日期的格式保持一致).
//    [formatter setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
//      //将格式字符串转化为NSDate
//    NSDate *date = [formatter dateFromString:selectedDate];
  
  
  NSDate *date = [NSDate dateWithString:selectedDate format:@"yyyy-MM-dd'T'HH:mm:ss"];
  [BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"选择日期" selectValue:[date stringWithFormat:XYYTDDateFormatterName] minDate:nil maxDate:[NSDate date] isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
    resolve([selectDate stringWithFormat:XYFullNoZDateFormatterName]);
  }];
//    XYDatePickerView *picker = [[XYDatePickerView alloc] init];
//    picker.date = [NSDate dateWithString:selectedDate format:@"yyyy-MM-dd'T'HH:mm:ss"];
//    picker.selectedBlock = ^(NSDate * _Nonnull date) {
//      resolve([date stringWithFormat:XYFullNoZDateFormatterName]);
//    };
//    [picker show];
}
//选择学校（初中和高中通用）- 传入对应家乡省市区code
RCT_EXPORT_METHOD(selectSchool:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displaySchoolSheetViewWithProvice:dic[@"provice"] city:dic[@"city"] area:dic[@"area"] type:dic[@"type"] block:^(NSString *text, NSNumber *ID) {
    NSDictionary *dic = @{
      @"text":text,
      @"ID":[NSString stringWithFormat:@"%@",ID],
    };
    resolve(dic);
  }];
}
//选择年龄
RCT_EXPORT_METHOD(selectAge:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [[XYPlatformService shareService] displayAgeSheetViewWithBlock:^(NSString *text, NSNumber *min, NSNumber *max) {
    NSDictionary *dic = @{
      @"text":text,
      @"min":[NSString stringWithFormat:@"%@",min],
      @"max":[NSString stringWithFormat:@"%@",max],
    };
    resolve(dic);
  }];
}
// 拼车筛选
RCT_EXPORT_METHOD(carScreen:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  
  
  XYCarNeedScreenView *view = [[XYCarNeedScreenView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
  //view.reqParams = self.reqParams;
  //@weakify(self);
  view.dic = dic;
  view.selectedBlock = ^(NSDictionary * _Nonnull item) {
   // @strongify(self);
    if (resolve) {
      resolve(item);
    }
    
   // [self reshData];
  };
  [view show];
//  XYCarNeedScreenView *view = [XYCarNeedScreenView alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
}
//查看大图
RCT_EXPORT_METHOD(lookBigImage:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {

  //---
  
  NSArray *lists =[dic objectForKey:@"lists"];
  
  
  
  HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
  browser.isFullWidthForLandScape = YES;
  browser.isNeedLandscape = YES;
 browser.currentImageIndex = (int)[lists indexOfObject:[dic objectForKey:@"current"]];
  browser.imageArray = lists;
  [browser show];
  
}

/// 以promise形式回传数据到RN端
RCT_EXPORT_METHOD(requestData:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  if (!dic || [dic isKindOfClass:[NSNull class]]) {
    reject(@"XY1001", @"缺少请求参数", nil);
    return;
  }
  
  NSString *method = dic[@"method"];
  NSString *methodType = dic[@"methodType"];
  NSDictionary *params = dic[@"requestParameters"];

  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
  if (methodType && [methodType isEqualToString:@"post"]) {
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  } else {
    api.apiRequestMethodType = XYRequestMethodTypeGET;
  }
  api.requestParameters = params ?: @{};
  XYShowLoading;
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (!error) {
      resolve(data);
    } else {
      reject(error.code, error.msg, nil);
    }
  };
  [api start];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    XYHiddenLoading;
      });
}

/// 以promise形式回传数据到RN端
RCT_EXPORT_METHOD(requestHeightData:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  if (!dic || [dic isKindOfClass:[NSNull class]]) {
    reject(@"XY1001", @"缺少请求参数", nil);
    return;
  }
  
  
  XYShowLoading;
  XYHeightAPI *api = [[XYHeightAPI alloc] init];
  api.apiCompletionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
    XYHiddenLoading;
    if (error) {
        return;
    }
    
    NSArray *arr = responseObject[@"height"];
    
      resolve(arr.deepCopy);
  };
  [api start];

}
/// 以promise形式回传数据到RN端
RCT_EXPORT_METHOD(requestDeuData:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  if (!dic || [dic isKindOfClass:[NSNull class]]) {
    reject(@"XY1001", @"缺少请求参数", nil);
    return;
  }
  
  
  XYShowLoading;
  XYDeuAPI *api = [[XYDeuAPI alloc] init];
  api.apiCompletionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
    XYHiddenLoading;
    if (error) {
        return;
    }
    
    NSArray *arr = responseObject[@"Education"];
    
      resolve(arr.deepCopy);
  };
  [api start];

}
//上传图片
RCT_EXPORT_METHOD(uploadObjectPic:(NSString *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  MJWeakSelf

  TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
     imagePickerVc.isSelectOriginalPhoto = NO;
     imagePickerVc.allowTakePicture = YES;
     imagePickerVc.allowTakeVideo = NO;
     imagePickerVc.videoMaximumDuration = 180;
     [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
         imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
     }];
     imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
     imagePickerVc.showPhotoCannotSelectLayer = YES;
     imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
     imagePickerVc.allowPickingVideo = NO;
     imagePickerVc.allowPickingImage = YES;
     imagePickerVc.allowPickingOriginalPhoto = NO;
     imagePickerVc.allowPickingGif = NO;
     imagePickerVc.allowPickingMultipleVideo = NO;
     imagePickerVc.sortAscendingByModificationDate = YES;
     imagePickerVc.showSelectBtn = NO;
     imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
     imagePickerVc.showSelectedIndex = YES;
     imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
     imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
       [[weakSelf getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
       XYShowLoading;
       [[XYImageUploadManager uploadManager] uploadObject:photos[0] block:^(BOOL success, NSString *token) {
         XYHiddenLoading;
         resolve(token);
       }];
     };
     [[self getCurrentVC] presentViewController:imagePickerVc animated:YES completion:nil];
}
//分享
RCT_EXPORT_METHOD(shareUI:(NSDictionary *)dic){
  [self.shareView showWithContentType:JSHARELink shareType:dic];
  //三方登录
  //        [self.shareView showWithSupportedLoginPlatform];
}
// 对外提供调用方法,Callback
RCT_EXPORT_METHOD(getAppVersion:(NSDictionary *)dic resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
  NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//获取项目版本号
   resolve(@[[NSString stringWithFormat:@"V %@",version]]);
}

-(UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

-(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
      
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {

        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
     
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
       
     
        currentVC = rootVC;
    }
    
    return currentVC;
}


- (XYLoginViewModel *)loginViewModel {
    if (!_loginViewModel) {
        _loginViewModel = [[XYLoginViewModel alloc] init];
    }
    return _loginViewModel;
}


- (ShareView *)shareView {
    if (!_shareView) {
      _shareView = [[ShareView alloc] init];
      [_shareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
              
      }];
        [[self getCurrentVC].view addSubview:self.shareView];
    }
    return _shareView;
}


@end
