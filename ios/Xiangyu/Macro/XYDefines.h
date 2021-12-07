//
//  XYDefines.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#ifndef XYDefines_h
#define XYDefines_h

#define GKConfigure [GKNavigationBarConfigure sharedInstance]

#ifdef DEBUG
#define DLog(FORMAT, ...) {\
fprintf(stderr,"FUNCTION：%s\n%s\n",__PRETTY_FUNCTION__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}
#else
# define DLog(...);
#endif

#if defined(__cplusplus)
#define XY_EXTERN extern "C"
#else
#define XY_EXTERN extern
#endif
// 颜色

#define GKColorRGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define GKColorRGB(r, g, b)     GKColorRGBA(r, g, b, 1.0)
#define GKColorGray(v)          GKColorRGB(v, v, v)

//#define GK_SAFEAREA_TOP                 [GKConfigure gk_safeAreaInsets].top      // 顶部安全区域
//#define GK_SAFEAREA_BTM                 [GKConfigure gk_safeAreaInsets].bottom   // 底部安全区域
//#define GK_STATUSBAR_HEIGHT             [GKConfigure gk_statusBarFrame].size.height  // 状态栏高度
// 适配比例
#define ADAPTATIONRATIO     SCREEN_WIDTH / 750.0f
// 屏幕宽高
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define AutoSize(__size) (__size*ADAPTATIONRATIO*2)

// 判断是否是iPhone X系列
#define IS_iPhoneX          GK_NOTCHED_SCREEN
// 导航栏高度与tabbar高度
#define NAVBAR_HEIGHT       (IS_iPhoneX ? 88.0f : 64.0f)
#define TABBAR_HEIGHT       (IS_iPhoneX ? 83.0f : 49.0f)

#define MAS_SHORTHAND

#define kKeyWindow [UIApplication sharedApplication].keyWindow




#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#define QN_RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define QN_RGBCOLOR_ALPHA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define QN_COMMON_BACKGROUND_COLOR [UIColor colorWithWhite:.2 alpha:.8]

// MARK: - Color
#define QN_MAIN_COLOR QN_RGBCOLOR(6.0, 130.0, 255.0)
#define QN_HELP_COLOR QN_RGBCOLOR(254.0, 45.0, 85.0)
#define QN_BLUE_COLOR QN_RGBCOLOR(135.0,195.0,255.0)
#define QN_ALPHA_SHADOW_COLOR QN_RGBCOLOR_ALPHA(139.0, 139.0, 139.0, 0.7)

// MARK: - Screen Size
#define QN_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define QN_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

#define QN_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define QN_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define QN_iPhoneXSMAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define QN_iPhoneP ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

static inline CGFloat StatusBarHeight() {
  
  CGFloat statusBarHeight = 0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
  if (@available(iOS 13.0, *)) {
      UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
      statusBarHeight = keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;

  } else
#endif
  {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
      statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
#endif
  }
    return statusBarHeight;
}

static inline BOOL iPhoneX() {
  static BOOL isIPhoneX = NO;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dispatch_async_on_main_queue(^{
     // CGSize screenSize = [UIScreen mainScreen].nativeBounds.size;
     // CGSize iPhone_XR_11_ScreenSize = CGSizeMake(828, 1792);
     // CGSize iPhone_X_XS_11Pro_ScreenSize = CGSizeMake(1125, 2436);
      //CGSize iPhone_XSMax_11ProMax_ScreenSize = CGSizeMake(1242, 2688);
     // CGSize iPhone_12mini_ScreenSize = CGSizeMake(1080, 2340);
    //  CGSize iPhone_12_12Pro_ScreenSize = CGSizeMake(1170, 2532);
     // CGSize iPhone_12ProMax_ScreenSize = CGSizeMake(1284, 2778);

      isIPhoneX = StatusBarHeight()>20;
//                  CGSizeEqualToSize(screenSize, iPhone_XR_11_ScreenSize) ||
//                  CGSizeEqualToSize(screenSize, iPhone_X_XS_11Pro_ScreenSize) ||
//                  CGSizeEqualToSize(screenSize, iPhone_XSMax_11ProMax_ScreenSize) ||
//                  CGSizeEqualToSize(screenSize, iPhone_12mini_ScreenSize) ||
//                  CGSizeEqualToSize(screenSize, iPhone_12_12Pro_ScreenSize) || CGSizeEqualToSize(screenSize, iPhone_12ProMax_ScreenSize);
    });
  });

  return isIPhoneX;
}

static inline CGFloat AdaptedWidth(CGFloat width){
    if (kScreenWidth <= 375) {
        return width;
    } else {
        return width * 1.1;
    }
}

static inline CGFloat AdaptedHeight(CGFloat height){
    if (kScreenWidth <= 375) {
        return height;
    } else {
        return height * 1.1;
    }
}



static inline CGFloat SafeAreaTop(){
    if (iPhoneX()) {
        return StatusBarHeight();
    } else {
        return 0.0;
    }
}

static inline CGFloat SafeAreaBottom(){
    if (iPhoneX()) {
        return 34.0;
    } else {
        return 0.0;
    }
}

static inline CGFloat SafeAreaTabbarBottom() {
    if (iPhoneX()) {
      return 83.0;
    } else {
        return 49.0;
    }
}

typedef void(^XYNetworkRespone)(_Nullable id data, XYError * _Nullable error);

#endif /* XYDefines_h */
