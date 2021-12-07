//
//  XYRNBaseViewController.m
//  Xiangyu
//
//  Created by GQLEE on 2020/12/19.
//
/*
 rn回到原生回调使用方法
 在RN页面中，调用导入XYModules并调用XYModules.navigateBack()方法即可通过导航返回页面：

 import {NativeModules} from 'react-native'
 
 var XYModules = NativeModules.XYModule
 
 <Button onPress={() => XYModules.navigateBack()} />
 
 rn调用导航栏跳转方法
 import { createStackNavigator, createAppContainer } from 'react-navigation'
 static navigationOptions = {
      headerTitle: <xxxx />,
      headerLeft: (
       <Button
         onPress={() => XYModules.navigateBack()}
         title="首页"
         color="#fff"
       />
     ),
   };

   _onItemClick(item) {
     this.props.navigation.navigate('Details',{xxxx:xxxxx})
   }
 */

#import "XYRNBaseViewController.h"
#import <React/RCTRootView.h>
#import "XYReactNativeManager.h"
#import "XYUserService.h"

@interface XYRNBaseViewController ()

@end

@implementation XYRNBaseViewController

+ (instancetype)RNPageWithName:(NSString*)pageName initialProperty:(NSDictionary*)initialProperty{
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  NSMutableDictionary *defaultDic = [[NSMutableDictionary alloc] init];
  [defaultDic setValue:user.userId forKey:@"userID"];
  [defaultDic addEntriesFromDictionary:initialProperty];
  XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:pageName initialProperty:defaultDic];
    return vc;
}

- (instancetype)initWithPageName:(NSString*)pageName initialProperty:(NSDictionary*)initialProperty{
    if(self = [super init]){
      self.pageName = pageName;
      XYUserInfo *user = [[XYUserService service] fetchLoginUser];
      NSMutableDictionary *defaultDic = [[NSMutableDictionary alloc] init];
      [defaultDic setValue:user.userId forKey:@"userID"];
      [defaultDic addEntriesFromDictionary:initialProperty];
      self.initialProperty = defaultDic;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.gk_navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navagateBack) name:@"XYModuleNavigateBack" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navagateFrontSideBack) name:@"XYModuleNavigateFrontSideBack" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navagateFrontSideBackNo) name:@"XYModuleNavigateFrontSideBackNo" object:nil];
  
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:[XYReactNativeManager shareInstance].bridge
                                                     moduleName:self.pageName
                                              initialProperties:self.initialProperty];
    self.view = rootView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)navagateBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navagateFrontSideBack{
  
  self.gk_interactivePopDisabled = NO;
}

- (void)navagateFrontSideBackNo{
  self.gk_interactivePopDisabled = YES;
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
