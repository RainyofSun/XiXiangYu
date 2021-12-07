//
//  WebViewController.m
//  HangZhan
//
//  Created by GQLEE on 2019/3/12.
//  Copyright © 2019年 GQLEE. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "ShareView.h"
#import "XYUserService.h"

@interface WebViewController ()<WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView            *webView;
@property (nonatomic, strong) UIProgressView       *progressView;
@property (nonatomic, strong) ShareView * shareView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = ColorHex(XYThemeColor_B);

  [self setupNavBar];

    //针对 iphoneX  不要有下面的安全区
  if (@available(iOS 11.0, *))//针对iOS11
  {
      if ([self.webView.scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)])
      {
          self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      }
  }
  if ([self.type isEqualToString:@"10"]) {
    _urlStr = [NSString stringWithFormat:@"%@%@",XY_SERVICE_HOST,_urlStr];
  }
  [self requestData:_urlStr];
  
}

- (void)leftBarButtonClick {
  
  
  if ([self.webView canGoBack]) {
    [self.webView goBack];
  }else
  if ([self isPresent]) {
         [self dismissViewControllerAnimated:YES completion:^{
         }];
     }else {
         [self.navigationController popViewControllerAnimated:YES];
     }
}
- (BOOL)isPresent {
    BOOL isPresent;
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1) {
      isPresent = ![viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self;
    } else {
      isPresent = YES;
    }
    return isPresent;
}

- (void)setupNavBar {
  self.gk_navTitle = self.title;
  self.gk_navLineHidden = NO;
  UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [backBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  [backBtn setImage:[UIImage imageNamed:@"icon_arrow_back_22"] forState:UIControlStateNormal];
  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
  self.gk_navLeftBarButtonItem = backItem;
}

- (void)requestData:(NSString *)urlStr {
  if ([_type isEqualToString:@"1"]) {
    [self.webView loadHTMLString:_dataDec baseURL:nil];
  }else {
    
    XYUserInfo*info =  [[XYUserService service] fetchLoginUser];
    
    
    
    
NSString *urlpram = [NSString stringWithFormat:@"&userid=%@&nickName=%@&mobile=%@&parentcode=%@",info.userId,info.nickName,info.mobile,info.invitationCode];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",urlStr,[urlpram stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
    if (![urlStr containsString:@"?"]) {
      
      urlpram = [NSString stringWithFormat:@"userid=%@&nickName=%@&mobile=%@&parentcode=%@",info.userId,info.nickName,info.mobile,info.invitationCode];
      
     url = [NSString stringWithFormat:@"%@?%@",urlStr,[urlpram stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
    }
    
    
    
    if ([self.type isEqualToString:@"10"]) {
      //urlpram =@"";
    }
    

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    //
    [self.webView loadRequest:request];
  }
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setTranslucent:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //h5索要app基本信息
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"showIosShare"];
  [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //h5索要app基本信息
  [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"showIosShare"];
    
    
}
//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
 
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]&& object == self.webView) {
        self.progressView.hidden = NO;
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >=1.0f) {
            [self.progressView setProgress:1.0f animated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView setProgress:0.0f animated:NO];
                self.progressView.hidden = YES;
            });
        }
    }else if ([keyPath isEqualToString:@"title"]  &&  object == self.webView){
    if ( self.webView.title.length) {
      self.gk_navTitle = self.webView.title;
    }
  }
  else {
      [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
  
}
#pragma mark - WKNavigationDelegate
// 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"页面开始加载");
}
// 加载完成
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
  if ( webView.title.length>0) {
  self.gk_navTitle = webView.title;
  }else {
      self.gk_navTitle = self.title;
  }
  
 // NSLog(@"========   %@",webView.title);
 // self.gk_navTitle = webView.title;
  if ([_type isEqualToString:@"1"]) {
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    [webView evaluateJavaScript:jScript completionHandler:nil];

  }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"当内容开始返回时调用");
    
}
// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
    
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"跳转失败");
}
#pragma mark - 拦截url
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - WKScriptMessageHandler
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"showIosShare"]){
      [self.shareView showWithContentType:JSHARELink shareType:@{@"type":@"2",@"link":message.body}];

        
    }
}
-(WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 0;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // web内容处理池
        config.processPool = [[WKProcessPool alloc] init];
        config.allowsInlineMediaPlayback = YES;
        
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:noneSelectScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT) configuration:config];
        //kvo 添加进度监控
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:NULL];
        // 设置代理
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.contentInset = UIEdgeInsetsZero;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.alwaysBounceVertical = NO;
        _webView.scrollView.alwaysBounceHorizontal = NO;
    }
    return _webView;
}
-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        [_progressView setFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, 0.5)];
        
        //设置进度条颜色
        [_progressView setTintColor:ColorHex(@"#FE2D63")];
    }
    return _progressView;
}
- (void)clearCache {
    /* 取得Library文件夹的位置*/
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES)[0];
    /* 取得bundle id，用作文件拼接用*/
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleIdentifier"];
    /*
     * 拼接缓存地址，具体目录为App/Library/Caches/你的APPBundleID/fsCachedData
     */
    NSString *webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    /* 取得目录下所有的文件，取得文件数组*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:webKitFolderInCachesfs error:&error];
    /* 遍历文件组成的数组*/
    for(NSString * fileName in fileList){
        /* 定位每个文件的位置*/
        NSString * path = [[NSBundle bundleWithPath:webKitFolderInCachesfs] pathForResource:fileName ofType:@""];
        /* 将文件转换为NSData类型的数据*/
        NSData * fileData = [NSData dataWithContentsOfFile:path];
        /* 如果FileData的长度大于2，说明FileData不为空*/
        if(fileData.length >2){
            /* 创建两个用于显示文件类型的变量*/
            int char1 =0;
            int char2 =0;
            
            [fileData getBytes:&char1 range:NSMakeRange(0,1)];
            [fileData getBytes:&char2 range:NSMakeRange(1,1)];
            /* 拼接两个变量*/
            NSString *numStr = [NSString stringWithFormat:@"%i%i",char1,char2];
            /* 如果该文件前四个字符是6033，说明是Html文件，删除掉本地的缓存*/
            if([numStr isEqualToString:@"6033"]){
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",webKitFolderInCachesfs,fileName]error:&error];
                continue;
            }
        }
    }
}
- (void)dealloc {
    
    [self clearCache];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *types = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
                                             WKWebsiteDataTypeMemoryCache
                                             ]];
        NSDate *datefrom = [NSDate date];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:datefrom completionHandler:^{

        }];
    }else {
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
    
    //移除通知
    if (_webView != nil) {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (ShareView *)shareView {
    if (!_shareView) {
      _shareView = [[ShareView alloc] init];
      _shareView.titleStr = @"新人好礼免费领";
      _shareView.textStr = @"注册登录即得18乡币，10+种新人好礼免费包邮到家";
//      _shareView.imageURL = @"AppIcon";
      [_shareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
              
      }];
        [self.view addSubview:self.shareView];
    }
    return _shareView;
}

@end
