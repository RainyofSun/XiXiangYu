//
//  XYNewsInformationDecViewController.m
//  Xiangyu
//
//  Created by Kang on 2021/6/6.
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
#import "XYNewsInformationDecViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "ShareView.h"
#import "XYInfomactionDecTitleView.h"
#import "XYBottomCommentView.h"
#import "XYConsultAPI.h"
#import "XYCommentListCell.h"

#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"

#import "XYNewsCommentViewController.h"
#import "XYPageModel.h"
@interface XYNewsInformationDecViewController ()<UITableViewDelegate, UITableViewDataSource,WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) ShareView * shareView;
@property(nonatomic,strong)XYInfomactionDecTitleView *titleView;
@property(nonatomic,strong)UIView *mainScroll;

@property (nonatomic, strong) WKWebView            *webView;

@property(nonatomic,strong)XYBottomCommentView *commentView;

@property (strong, nonatomic) UITableView *listView;
@property (nonatomic, assign) NSUInteger page;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation XYNewsInformationDecViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setTranslucent:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //h5索要app基本信息
   // [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"showIosShare"];
  //[self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //h5索要app基本信息
  //[self.webView removeObserver:self forKeyPath:@"title"];
  //  [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"showIosShare"];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
    [self newNav];
    [self newView];
    [self reshData];
    [self fetchNewData];
}
#pragma mark - 网络请求
-(void)reshData{

  XYConsultAPI *api = [[XYConsultAPI alloc]initWithUserId:[[XYUserService service] fetchLoginUser].userId Id:self.commentView.model.id];
  api.apiRequestMethodType = XYRequestMethodTypeGET;
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    @strongify(self);
    self.commentView.model = [XYConsultDetailModel yy_modelWithJSON:data];
  };
  [api start];
}
-(void)fetchNewData{
  self.page = 0;
  [self fetchNextData];
}
-(void)fetchNextData{
 // self.page ++;
  XYGetConsultCommentListAPI *api = [[XYGetConsultCommentListAPI alloc]initWithConsultId:self.commentView.model.id page:1];
  @weakify(self);
  XYShowLoading;
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    @strongify(self);
    XYHiddenLoading;
    [self.listView.mj_header endRefreshing];
   // [self.listView.mj_footer endRefreshing];
    if (!error) {
     // if (self.page == 1) {
        [self.dataSource removeAllObjects];
     // }
      
      XYPageModel *page = [XYPageModel yy_modelWithJSON:data[@"page"]];
      NSArray *arr = data[@"commentResp"];
      [self.dataSource addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYCommentModel class] json:arr]];
      if (!arr || arr.count == 0) {
      //  self.page --;
      }
    } else {
     // self.page --;
     // if (commentErrorBlock) commentErrorBlock(error);
    }
    [self.listView reloadData];
  };
  [api start];
}
#pragma mark - 界面布局
-(void)newView{
  
  [self.view addSubview:self.commentView];
  [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.bottom.equalTo(self.view);
  }];
  
  [self.view addSubview:self.listView];
  self.listView.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(GK_STATUSBAR_NAVBAR_HEIGHT);
    make.bottom.equalTo(self.commentView.mas_top);
  }];
  [self.mainScroll addSubview:self.titleView];
  [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.mainScroll);
    make.top.equalTo(self.mainScroll);
  }];
  [self.mainScroll addSubview:self.webView];
  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.mainScroll);
    make.top.equalTo(self.titleView.mas_bottom);
    make.bottom.equalTo(self.mainScroll).offset(-16).priority(800);
  }];
  
  self.titleView.params = self.params;
  
  
  NSString *desc = [NSString stringWithFormat:@"%@",[self.params objectForKey:@"context"]?:@""];
//  NSLog(@"====== %@",desc);
  [self.webView loadHTMLString:desc baseURL:nil];
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
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  //获取网页的高度
    [webView evaluateJavaScript:@"document.body.offsetHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([result floatValue]);
            make.bottom.equalTo(self.mainScroll).offset(-12).priority(800);
        }];
      CGFloat height = [self.mainScroll systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
     //CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
      CGRect frame = self.mainScroll.frame;
      frame.size.height = height;
      self.mainScroll.frame = frame;
      
      self.listView.tableHeaderView = self.mainScroll;
      
    }];
}
//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
 
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]&& object == self.webView) {
      //  self.progressView.hidden = NO;
      //  [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >=1.0f) {
           // [self.progressView setProgress:1.0f animated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[self.progressView setProgress:0.0f animated:NO];
                //self.progressView.hidden = YES;
            });
        }
    }else if ([keyPath isEqualToString:@"title"]  &&  object == self.webView){
    if ( self.webView.title.length) {
      //self.gk_navTitle = self.webView.title;
    }
  }
  else {
      [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
  
}
#pragma mark - 拦截url
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //if (section == 0) return 1;
  
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XYCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYCommentListCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.isFirstCell = indexPath.row == 0;
    //@weakify(self);
//    cell.deleteBlock = ^{
//     [weak_self deleteCommentWithIndexPath:indexPath];
//    };
  cell.deleteBtn.alpha = 0;
  
    return cell;
  
}
//- (void)deleteCommentWithIndexPath:(NSIndexPath *)indexPath {
//  @weakify(self);
//  XYShowLoading;
//  [self.dataManager deleteCommentWithIndex:indexPath.row block:^(XYError * _Nonnull error) {
//    XYHiddenLoading;
//    if (error) {
//      XYToastText(error.msg);
//    } else {
//      [weak_self.listView beginUpdates];
//      [weak_self.listView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//      [weak_self.listView endUpdates];
//    }
//  }];
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   // [self.commentInputTF resignFirstResponder];
}

#pragma mark - WKScriptMessageHandler
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if([message.name isEqualToString:@"showIosShare"]){
      [self.shareView showWithContentType:JSHARELink shareType:@{@"type":@"2",@"link":message.body}];

        
    }
}
#pragma mark - UI
- (void)keyBoardWillShow:(NSNotification *) note {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
        //self.commentBgView.XY_bottom = kScreenHeight - keyBoardHeight;
      [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyBoardHeight-GK_SAFEAREA_BTM);
      }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

- (void)keyBoardWillHide:(NSNotification *) note {
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
     // self.commentBgView.XY_bottom = kScreenHeight;
      [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
      }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
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
      // 适应高度及其图片
      NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);var objs = document.getElementsByTagName('img');for(var i=0;i<objs.length;i++){var img = objs[i];img.style.width = '100%';}";
      [javascript appendString:jScript];//禁止长按
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
      _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.alwaysBounceVertical = NO;
        _webView.scrollView.alwaysBounceHorizontal = NO;
    }
    return _webView;
}
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
      [_listView registerClass:[XYCommentListCell class] forCellReuseIdentifier:NSStringFromClass([XYCommentListCell class])];
      //[_listView registerClass:[XYCommentLikeCell class] forCellReuseIdentifier:NSStringFromClass([XYCommentLikeCell class])];
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
     // _listView.tableHeaderView = self.headerView;
//      @weakify(self);
//      _listView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
//          @strongify(self);
//
//        [self fetchNewData];
//      }];
//      _listView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
//        @strongify(self);
//
//        [self fetchNextData];
//      }];
    }
    return _listView;
}
-(XYInfomactionDecTitleView *)titleView{
  if (!_titleView) {
    _titleView = [[XYInfomactionDecTitleView alloc]initWithFrame:CGRectZero];;
  }
  return _titleView;
}
-(UIView *)mainScroll{
    if (_mainScroll == nil) {
        _mainScroll=[[UIView alloc]initWithFrame:self.view.bounds];
//        _mainScroll.backgroundColor=;
//        _mainScroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        if (@available(iOS 11.0, *)) {
//            _mainScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _mainScroll.scrollIndicatorInsets = _mainScroll.contentInset;
//        }
    }
    return _mainScroll;
}
-(XYBottomCommentView *)commentView{
  if (!_commentView) {
    _commentView = [[XYBottomCommentView alloc] initWithFrame:CGRectZero];
    _commentView.model = [XYConsultDetailModel yy_modelWithJSON:self.params];
    @weakify(self);
    _commentView.block = ^(NSInteger index, XYConsultDetailModel *obj) {
      @strongify(self);
      if (index == 0) { // 评论按钮
       // [self comment];
        //
        
        XYNewsCommentViewController *vc = [[XYNewsCommentViewController alloc] init];
        vc.params = self.params;
        [self cyl_pushViewController:vc animated:YES];
      }else if (index == 5) { // 点赞
        [self comment];
      }else{
        [self praiseEvent:obj];
      }
    };
  }
  return _commentView;
}
-(void)praiseEvent:(XYConsultDetailModel*)model{
  XYConsultFabulousAPI *api = [[XYConsultFabulousAPI alloc] initWithConsultId:model.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      BOOL isFabulous = model.isFabulous.integerValue == 1;
      model.isFabulous = isFabulous ? @(0) : @(1);
      model.fabulousCount = isFabulous ? @(model.fabulousCount.integerValue-1) : @(model.fabulousCount.integerValue+1);
     // XYDynamicLayout *layout = [[XYDynamicLayout alloc] initWithModel:model];
     // [self.layoutsArr replaceObjectAtIndex:index withObject:layout];
      //if (block) block(layout, error);
    } else {
     // if (block) block(nil, error);
    }
    self.commentView.model = model;
  };
  [api start];
}
- (void)comment {
  if (!self.commentView.textView.text.isNotBlank) {
    return;
  }
//
  if (self.commentView.textView.text.length > 60) {
    XYToastText(@"评论字数在60字以内");
    return;
  }
//

  //XYShowLoading;
  XYConsultCommentAPI *api = [[XYConsultCommentAPI alloc]initWithUserId:[[XYUserService service] fetchLoginUser].userId Id:self.commentView.model.id content:self.commentView.textView.text];
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
   // XYHiddenLoading;
    @strongify(self);
    if (!error) {
      self.commentView.textView.text = nil;
      [self fetchNewData];
    }else
    {
      XYHiddenLoading;
    }
   
    //self.commentView.model = [XYConsultDetailModel yy_modelWithJSON:data];
   
  };
  [api start];
  
//  XYShowLoading;
//  [self.dataManager postCommont:self.commentView.textView.text block:^(XYError * _Nonnull error) {
//    XYHiddenLoading;
//    if (error) {
//      XYToastText(error.msg);
//    } else {
//      weak_self.commentView.textView.text = @"";
//      [weak_self.listView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
//    }
//  }];
}
-(NSMutableArray *)dataSource{
  if (!_dataSource) {
    _dataSource = [NSMutableArray new];
  }
  return _dataSource;
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
#pragma mark - 导航
- (void)newNav {
//  self.gk_navLineHidden = YES;
//  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
//  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
//  self.gk_navigationBar.layer.shadowOpacity = 0.06;
//  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [moreButton setImage:[UIImage imageNamed:@"icon_22_fenxiang"] forState:UIControlStateNormal];
  [moreButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
  
  self.gk_navTitle = @"资讯详情";
}
- (void)rightBarButtonClick {
  [self.shareView showWithContentType:JSHARELink shareType:@{@"type":@"6",@"id":[self.params objectForKey:@"id"]?:@"",@"title":[self.params objectForKey:@"title"]?:@"",@"remark":[self.params objectForKey:@"introduction"]?:@"",@"iconUrl":[self.params objectForKey:@"image"]?:@""}];

}
- (ShareView *)shareView {
    if (!_shareView) {
      _shareView = [[ShareView alloc] init];
      [_shareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
              
      }];
        [self.view addSubview:self.shareView];
    }
    return _shareView;
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
