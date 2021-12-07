//
//  XYMainViewController.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/16.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYMainViewController.h"
#import "XYUserService.h"
#import "XYLoginMobileViewController.h"
#import "NSBundle+Extension.h"

#import "XYImageUploadManager.h"
#import "XYMediator.h"
#import "XYPlatformService.h"
#import "XYAddressSelector.h"
#import "XYLinkageRecycleViewController.h"

#import "XYAddressService.h"
#import "XYDatePickerView.h"
#import "XYCitySelector.h"

@interface XYMainViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,weak) UILabel *lable;

@property (nonatomic, strong) UIImage *pickImage;

@end

@implementation XYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:XYLoginNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:XYLogoutNotificationName object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 5;
    [btn setBackgroundColor:ColorHex(XYThemeColor_A)];
    [btn setTitle:@"测试登录" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.layer.cornerRadius = 5;
    [btn2 setBackgroundColor:ColorHex(XYThemeColor_A)];
    [btn2 setTitle:@"退出登录" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 300, 100, 40);
    [btn2 addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.layer.cornerRadius = 5;
    lable.backgroundColor = [UIColor greenColor];
    lable.frame = CGRectMake(100, 180, 140, 40);
    if ([[XYUserService service] isLogin]) {
     lable.text = @"已登录";
    } else {
        lable.text = @"未登录";
    }
    [self.view addSubview:lable];
    self.lable = lable;
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.layer.cornerRadius = 5;
    [btn3 setBackgroundColor:ColorHex(XYThemeColor_A)];
    [btn3 setTitle:@"选择图片" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(100, 400, 100, 40);
    [btn3 addTarget:self action:@selector(gotoImageLibrary) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
  
  UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
  btn4.layer.cornerRadius = 5;
  [btn4 setBackgroundColor:ColorHex(XYThemeColor_A)];
  [btn4 setTitle:@"上传图片" forState:UIControlStateNormal];
  btn4.frame = CGRectMake(100, 500, 100, 40);
  [btn4 addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn4];
}

- (void)test {
    if ([[XYUserService service] isLogin]) {
        XYToastText(@"已经登录");
    } else {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
      nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)refresh {
    if ([[XYUserService service] isLogin]) {
        self.lable.text = @"已登录";
    } else {
        self.lable.text = @"未登录";
    }
}

- (void)logout {
    [[XYUserService service] logoutUserWithBlock:^(BOOL success) {
        if (!success) {
            self.lable.text = @"已登录";
        } else {
            self.lable.text = @"未登录";
        }
    }];
    
}

- (void)upload {
  
//    [[XYShareService shareService] getUserInfo];

//  [[XYImageUploadManager uploadManager] uploadObject:self.pickImage block:^(BOOL success, NSString *token) {
//
//
//    }];
  
//  XYPlatformService *platformService = [XYPlatformService shareService];
//  [platformService displayHasWeightSheetViewWithBlock:^(NSString *text, NSNumber *ID) {
//
//  }];
  
//  [[XYAddressService sharedService] queryTownWithAreacode:@"310118" block:^(NSArray *data) {
//
//  }];
  
//  XYDatePickerView *view = [[XYDatePickerView alloc] init];
//  [view show];

//  XYLinkageRecycleViewController *vc = [[XYLinkageRecycleViewController alloc] init];
//  [self cyl_pushViewController:vc animated:YES];
  
//  XYAddressSelector *selector = [[XYAddressSelector alloc] initWithBaseViewController:self withTown:YES];
//  selector.adcode = @"13020408";
//  selector.chooseFinish = ^(XYFormattedArea *area) {
//
//  };
//  [selector show];
  
//  [[XYAddressService sharedService] queryCityWithBlock:^(NSArray *data) {
//
//  }];
  
  
//  NSString *path = [NSBundle pathForResourceName:@"city" ofType:@"json"];
//  NSData *data = [NSData dataWithContentsOfFile:path];
//
//  NSArray *tmp = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//
//  NSMutableArray *newData = @[].mutableCopy;
//  for (NSDictionary *item in tmp) {
//    NSMutableDictionary *dict_M = item.mutableCopy;
//    [dict_M setValue:[self convertToParentId:item[@"code"]] forKey:@"parentId"];
//    [dict_M setValue:[self firstCharactor:item[@"name"]] forKey:@"firstLetter"];
//    [dict_M setValue:[self pinyinCharactor:item[@"name"]] forKey:@"spell"];
//    [dict_M setValue:[self getlevel:item[@"code"]] forKey:@"level"];
//    [newData addObject:dict_M];
//  }
//
//  NSString *json = newData.yy_modelToJSONString;
//
//  NSString *newPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"city.json"];
//  BOOL ret = [json writeToFile:newPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
//
//  DLog(@"路径：%@",newPath);
  
//  XYCitySelector *selector = [[XYCitySelector alloc] init];
//  selector.selectedBlock = ^(XYAddressItem *item) {
//
//  };
//  [self cyl_pushViewController:selector animated:YES];
  
  
}

- (NSString *)getlevel:(NSString *)code {
  if (!code.isNotBlank) {
    return @"";
  }
  
  if ([code hasSuffix:@"0000"]) {
    return @"1";
  }
  
  if ([code hasSuffix:@"00"] && ![code hasSuffix:@"0000"]) {
    return @"2";
  }
  
  if (![code hasSuffix:@"00"] && ![code hasSuffix:@"0000"]) {
    return @"3";
  }
  
  return @"null";
}

- (NSString *)convertToParentId:(NSString *)code {
  if (!code.isNotBlank) {
    return @"";
  }
  
  if ([code hasSuffix:@"0000"]) {
    return @"100000";
  }
  
  if ([code hasSuffix:@"00"] && ![code hasSuffix:@"0000"]) {
    return [code stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"];
  }
  
  if (![code hasSuffix:@"00"] && ![code hasSuffix:@"0000"]) {
    return [code stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"];
  }
  
  return @"null";
}

- (NSString *)firstCharactor:(NSString *)aString {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

- (NSString *)pinyinCharactor:(NSString *)aString {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return pinYin;
}

- (void)gotoImageLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
}

//再调用以下委托：
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    self.pickImage = image; //imageView为自己定义的UIImageView
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
