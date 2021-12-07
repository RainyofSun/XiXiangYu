//
//  ShareView.m
//  JShareDemo
//
//  Created by ys on 11/01/2017.
//  Copyright © 2017 ys. All rights reserved.
//

#import "ShareView.h"
#import "XYGeneralAPI.h"
#import "XYUserService.h"
#import "XYReportView.h"

@interface ShareView() {
}

@property (nonatomic, assign) JSHAREMediaType type;

@property (nonatomic, strong) NSMutableDictionary * platformData;
@property (nonatomic, strong) NSMutableArray * currentContentSupportPlatform;

@property (nonatomic, strong) UIView * shareView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * cancelBtn;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, strong) XYReportView * reportView;


@end

#define TopSpace 29
#define MidSpace 36
#define BottomSpace 34

#define ImageSize 58
#define ImageLabelSpace 13
#define ItemFontSize 10
#define CancelItemHeight 61
#define CancelFontSize 13

#define LineColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]
#define FontColor [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]

@implementation ShareView {
    ShareBlock _block;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
      _urlStr = @"";
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.screenHeight = [UIScreen mainScreen].bounds.size.height;
        self.space = (self.screenWidth-4*ImageSize)/5;
        self.shareView = [[UIView alloc] init];
        self.currentContentSupportPlatform = [[NSMutableArray alloc] init];
        
        self.platformData = [[NSMutableDictionary alloc] init];
//      [self shareLinkWithPlatform:platform];

    }
    return self;
}
- (void)requestData:(NSDictionary *)dicDic {
  NSString *method = @"api/v1/Platform/GetShareConf";
  
  
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  NSDictionary *params = @{
    @"type": @([dicDic[@"type"] integerValue]),
  };
  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
  api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  MJWeakSelf
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      if ([dicDic[@"type"] integerValue] == 6 || [dicDic[@"type"] integerValue] == 7 || [dicDic[@"type"] integerValue] == 4) {
          weakSelf.titleStr = dicDic[@"title"];
          weakSelf.textStr = dicDic[@"remark"];
          weakSelf.imageURL = dicDic[@"iconUrl"];
        weakSelf.urlStr = [NSString stringWithFormat:@"%@?id=%@",data[@"name"],dicDic[@"id"]];
      }else if([dicDic[@"type"] integerValue] == 2) {
        weakSelf.urlStr = [NSString stringWithFormat:@"%@",dicDic[@"link"]];
      }else if([dicDic[@"type"] integerValue] == 5) {
        weakSelf.titleStr = dicDic[@"title"];
        weakSelf.textStr = dicDic[@"remark"];
        weakSelf.imageURL = dicDic[@"iconUrl"];
        weakSelf.urlStr = [NSString stringWithFormat:@"%@?id=%@&userid=%@",data[@"name"],dicDic[@"id"],user.userId];
      }
      
    } else {
      
    }
  };
  [api start];
}
- (ShareView *)getFactoryShareViewWithCallBack:(ShareBlock)block {
//    ShareView * shareView = [[ShareView alloc] init];
  [self setShareCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
    
      switch (type) {
        case JSHAREText:
          [self shareTextWithPlatform:platform];
          break;
        case JSHAREImage:
          [self shareImageWithPlatform:platform];
          break;
        case JSHARELink:
          [self shareLinkWithPlatform:platform];
          break;
        case JSHAREAudio:
          [self shareMusicWithPlatform:platform];
          break;
        case JSHAREVideo:
          [self shareVideoWithPlatform:platform];
          break;
        case JSHAREApp:
          [self shareAppWithPlatform:platform];
          break;
        case JSHAREEmoticon:
          [self shareEmoticonWithPlatform:platform];
          break;
        case JSHAREFile:
          [self shareFileWithPlatform:platform];
          break;
          case JSHAREGraphic:
          [self shareGraphicWithPlatform:platform];
          break;
        case JSHAREMiniProgram:
          [self shareMiniProgramWithPlatform:platform];
          break;
        default:
          [self getUserInfoWithPlatform:platform];
          break;
      }
     
  }];
    [self setShareView];
    [self setFacade];
    [self setCancelView];
    return self;
}

- (void)showAlertWithState:(JSHAREState)state error:(NSError *)error{
    
    NSString *string = nil;
    if (error) {
        string = [NSString stringWithFormat:@"分享失败,error:%@", error.description];
    }else{
        switch (state) {
            case JSHAREStateSuccess:
                string = @"分享成功";
                break;
            case JSHAREStateFail:
                string = @"分享失败";
                break;
            case JSHAREStateCancel:
                string = @"分享取消";
                break;
            case JSHAREStateUnknown:
                string = @"Unknown";
                break;
            default:
                break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Alert show];
    });
}
- (NSString *)localizedStringTime{
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];[formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
- (void)shareTextWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.text = [NSString stringWithFormat:@"分享功能！",[self localizedStringTime]];
    message.platform = platform;
    message.mediaType = JSHAREText;
    if (platform == JSHAREPlatformJChatPro) {
        [JSHAREService share:message completionHandler:^(JSHAREState state, NSError *error, id responseObject) {
            NSLog(@"responseObject :%@", responseObject);
            [self showAlertWithState:state error:error];
        }];
    }else{
        if(platform == JSHAREPlatformSinaWeibo && ![JSHAREService isSinaWeiBoInstalled]) {
            message.text = [message.text stringByAppendingString:@""];
        }
        [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
            [self showAlertWithState:state error:error];
        }];
    }
}

- (void)shareImageWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    NSString *imageURL = @"http://img2.3lian.com/2014/f5/63/d/23.jpg";
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    
    message.mediaType = JSHAREImage;
    message.text = [NSString stringWithFormat:@"时间:%@ JShare SDK支持主流社交平台、帮助开发者轻松实现社会化功能！",[self localizedStringTime]];
    message.platform = platform;
    message.image = imageData;
    
    
    
    /*QQ 空间 / Facebook/Messenger /Twitter 支持多张图片
     1.QQ 空间图片数量限制为20张。若只分享单张图片使用 image 字段即可。
     2.Facebook/Messenger 图片数量限制为6张。如果分享单张图片，图片大小建议不要超过12M；如果分享多张图片，图片大小建议不要超过700K，否则可能出现重启手机或者不能分享。
     3、Twitter最多支持4张*/
    
    //message.images = @[imageData,imageData];
    if (platform == JSHAREPlatformJChatPro) {
        [JSHAREService share:message completionHandler:^(JSHAREState state, NSError *error, id responseObject) {
            NSLog(@"responseObject :%@", responseObject);
            [self showAlertWithState:state error:error];
        }];
    }else{
        if(platform == JSHAREPlatformSinaWeibo && ![JSHAREService isSinaWeiBoInstalled]) {
            message.text = [message.text stringByAppendingString:@" http://www.jiguang.cn"];
        }
        [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
            [self showAlertWithState:state error:error];
        }];
    }
}
- (XYReportView *)reportView {
  if (!_reportView) {
    _reportView = [[XYReportView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  }
  return _reportView;
}
- (void)shareLinkWithPlatform:(JSHAREPlatform)platform {
  if (JSHAREPlatformQzone == platform) {
    [[UIApplication sharedApplication].delegate.window addSubview:self.reportView];
    [self.reportView addView];
    [self hiddenView];
    return;
  }
    
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHARELink;
  NSString *url =_urlStr;
  message.url = url;

    message.text = _textStr;
    message.title = _titleStr;
    message.platform = platform;
  if (!_imageURL || _imageURL.length < 1) {
    message.image = UIImagePNGRepresentation([UIImage imageNamed:@"logo120"]);
  }else {
    NSString *imageURL = _imageURL;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    
    message.image = imageData;
  }
//    if(platform == JSHAREPlatformSinaWeibo && ![JSHAREService isSinaWeiBoInstalled]) {
//        message.text = [message.text stringByAppendingString:@" http://www.jiguang.cn"];
//    }
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

- (void)shareMusicWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREAudio;
    message.url =  @"https://y.qq.com/n/yqq/song/003RCA7t0y6du5.html";
    message.text = [NSString stringWithFormat:@"时间:%@ JShare SDK支持主流社交平台、帮助开发者轻松实现社会化功能！",[self localizedStringTime]];
    message.title = @"欢迎使用极光社会化组件JShare";
    message.platform = platform;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

- (void)shareVideoWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREVideo;
    message.url =@"http://v.youku.com/v_show/id_XOTQwMDE1ODAw.html?from=s1.8-1-1.2&spm=a2h0k.8191407.0.0";
    message.text = [NSString stringWithFormat:@"时间:%@ JShare SDK支持主流社交平台、帮助开发者轻松实现社会化功能！",[self localizedStringTime]];
    message.title = @"欢迎使用极光社会化组件JShare";
    if (platform == JSHAREPlatformTwitter) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"jiguangVideoForTwitter" ofType:@"mp4"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        message.videoData = data;
    }
    message.platform = platform;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

- (void)shareAppWithPlatform:(JSHAREPlatform)platform {
    Byte* pBuffer = (Byte *)malloc(10*1024*1024);
    memset(pBuffer, 0, 10*1024);
    NSData* data = [NSData dataWithBytes:pBuffer length:10*1024*1024];
    free(pBuffer);
    
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREApp;
    message.url =@"https://www.jiguang.cn/";
    message.text = [NSString stringWithFormat:@"时间:%@ JShare SDK支持主流社交平台、帮助开发者轻松实现社会化功能！",[self localizedStringTime]];
    message.title = @"欢迎使用极光社会化组件JShare";
    message.extInfo = @"<xml>extend info</xml>";
    message.fileData = data;
    message.platform = platform;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
        
    }];
}

- (void)shareEmoticonWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREEmoticon;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res6" ofType:@"gif"];
    NSData *emoticonData = [NSData dataWithContentsOfFile:filePath];
    message.emoticonData = emoticonData;
    message.platform = platform;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

- (void)shareMiniProgramWithPlatform:(JSHAREPlatform) platform{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wechat@2x" ofType:@"png"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREMiniProgram;
    message.title = @"极光分享小程序";
    message.text = @"欢迎使用极光社会化组件 JShare，SDK 包体积小，集成简单，支持主流社交平台、帮助开发者轻松实现社会化功能";
    message.url = @"https://m.jiguang.cn/";
    message.userName = @"gh_cd370c00d3d4";
    message.path = @"pages/index/index";
    message.miniProgramType = 0;
    message.withShareTicket = YES;
    message.image = imageData;
    message.platform = platform;
    
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}


- (void)shareGraphicWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREGraphic;
    message.url = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    message.text = @"欢迎使用极光社会化组件 JShare，SDK 包体积小，集成简单，支持主流社交平台、帮助开发者轻松实现社会化功能";
    message.title = @"极光社会化组件";
    message.thumbUrl = @"http://d.lanrentuku.com/down/png/0905/pngicon-12/png-1102.png";
    message.extInfo = @"extramessage";
    message.callbackUrl = @"https://www.jiguang.cn/";
    message.pkgName = @"android_pkg";
    message.className = @"android_class_name";
    message.appName = @"我是MT";
    message.platform = platform;
    
    if (platform == JSHAREPlatformJChatPro) {
        [JSHAREService share:message completionHandler:^(JSHAREState state, NSError *error, id responseObject) {
            NSLog(@"responseObject :%@", responseObject);
            [self showAlertWithState:state error:error];
        }];
    }else{
        [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
            [self showAlertWithState:state error:error];
        }];
    }
}

- (void)shareFileWithPlatform:(JSHAREPlatform)platform {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREFile;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jiguang" ofType:@"mp4"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    message.fileData = fileData;
    message.fileExt = @"mp4";
    message.platform = platform;
    message.title = @"jiguang.mp4";
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

- (void)shareLinkToSinaWeiboContact{
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHARELink;
    message.url = @"https://www.jiguang.cn/";
    message.text = [NSString stringWithFormat:@"时间:%@ JShare SDK支持主流社交平台、帮助开发者轻松实现社会化功能！",[self localizedStringTime]];
    message.title = @"欢迎使用极光社会化组件JShare";
    message.platform = JSHAREPlatformSinaWeiboContact;
    NSString *imageURL = @"http://img2.3lian.com/2014/f5/63/d/23.jpg";
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    
    message.image = imageData;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        [self showAlertWithState:state error:error];
    }];
}

- (void)getUserInfoWithPlatform:(JSHAREPlatform)platfrom{
    [JSHAREService getSocialUserInfo:platfrom handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
        NSString *alertMessage;
        NSString *title;
        if (error) {
            title = @"失败";
            alertMessage = @"无法获取到用户信息";
        }else{
            title = userInfo.name;
            NSString *gender = nil;
            if (userInfo.gender == 1) {
                gender = @"男";
            }else if (userInfo.gender == 2){
                gender = @"女";
            }else{
                gender = @"未知";
            }
            
            alertMessage = [NSString stringWithFormat:@"昵称: %@\n 头像链接: %@\n 性别: %@\n",userInfo.name,userInfo.iconurl,gender];
        }
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Alert show];
        });
        
        
    }];
}


- (void)setFacade {
    self.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
}

#define RemainTag 9999

- (void)setShareView {
    //white cover
    self.shareView.backgroundColor = [UIColor whiteColor];
    //gary line
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = LineColor;
    self.lineView.tag = RemainTag;
    [self.shareView addSubview:self.lineView];
    [self addSubview:self.shareView];
}

- (void)setShareItem {
    //clear history item
    for (UIView * view in self.shareView.subviews) {
        if (view.tag != 9999) {
            [view removeFromSuperview];
        }
    }
    //layout item
    for (int i=0; i<self.currentContentSupportPlatform.count; i++) {
        NSNumber * platformkey = self.currentContentSupportPlatform[i];
        NSInteger row = i/4;
        NSInteger column = i%4;
        UIButton * shareItem = self.platformData[platformkey][@"item"];
        shareItem.frame = CGRectMake((column+1)*self.space+column*ImageSize, TopSpace+row*(ImageSize+MidSpace+ItemFontSize+ImageLabelSpace), ImageSize, ImageSize);
        shareItem.tag = platformkey.integerValue;
        [shareItem addTarget:self action:@selector(shareTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [shareItem setImage:[UIImage imageNamed:self.platformData[platformkey][@"image"]] forState:UIControlStateNormal];
      
        UILabel * shareLabel = [[UILabel alloc] init];
        shareLabel.frame = CGRectMake(shareItem.frame.origin.x, CGRectGetMaxY(shareItem.frame)+ImageLabelSpace, CGRectGetWidth(shareItem.frame), ItemFontSize);
        shareLabel.textColor = FontColor;
        shareLabel.font = [UIFont systemFontOfSize:ItemFontSize];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.text = self.platformData[platformkey][@"title"];
      
        [self.shareView addSubview:shareItem];
        [self.shareView addSubview:shareLabel];
    }
    NSInteger totalRow = (self.currentContentSupportPlatform.count-1)/4+1;
    CGFloat shareViewHeight = TopSpace+totalRow*(ImageSize+ItemFontSize+ImageLabelSpace)+(totalRow-1)*MidSpace+BottomSpace+CancelItemHeight;
    self.shareView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.screenWidth, shareViewHeight);
    self.cancelBtn.frame = CGRectMake(0, self.shareView.frame.size.height-CancelItemHeight, self.screenWidth, CancelItemHeight);
    self.lineView.frame = CGRectMake(self.space, self.shareView.frame.size.height-62, self.screenWidth-self.space*2, 1);
    [super setHidden:YES];
}

- (void)setCancelView {
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelBtn.tag = RemainTag;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:CancelFontSize];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:FontColor forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:self.cancelBtn];
}

- (void)setShareCallBack:(ShareBlock)block {
    if (block) {
        _block = nil;
        _block = [block copy];
    }
}

- (void)shareTypeSelect:(UIButton *)sender {
    if (_block) {
      _block(sender.tag, self.type);
    }
    [self hiddenView];
}

- (void)showWithContentType:(JSHAREMediaType)type shareType:(NSDictionary *)shareType {
  [self requestData:shareType];
  [self setPlatformDataWithLogin:NO];
  self.type = type;
  [self.currentContentSupportPlatform removeAllObjects];
    switch (type) {
        case JSHAREEmoticon:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession)]];
            break;
        case JSHAREApp:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine)]];
            break;
        case JSHAREFile:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      ]];
            break;
        case JSHAREVideo:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone),
                                                                      @(JSHAREPlatformTwitter)]];
            break;
        case JSHAREAudio:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone)]];
            break;
        case JSHARELink:
//            [self.currentContentSupportPlatform addObjectsFromArray:@[
//                                                                      @(JSHAREPlatformWechatSession),
//                                                                      @(JSHAREPlatformWechatTimeLine),
//                                                                      @(JSHAREPlatformQQ),
//                                                                      @(JSHAREPlatformQzone),
//                                                                      ]];
      {
        NSMutableArray * typeArr = [[NSMutableArray alloc] init];
        if ([JSHAREService isWeChatInstalled]) {
          [typeArr addObject:@(JSHAREPlatformWechatSession)];
          [typeArr addObject:@(JSHAREPlatformWechatTimeLine)];
        }
        if ([JSHAREService isQQInstalled]) {
          [typeArr addObject:@(JSHAREPlatformQQ)];
        }
        [typeArr addObject:@(JSHAREPlatformQzone)];
        
            [self.currentContentSupportPlatform addObjectsFromArray:typeArr];
      }
        
            break;
        case JSHAREGraphic:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformJChatPro)]];
            break;
        case JSHAREImage:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformSinaWeibo),
                                                                      @(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine),
                                                                      @(JSHAREPlatformWechatFavourite),
                                                                      @(JSHAREPlatformQQ),
                                                                      @(JSHAREPlatformQzone),
                                                                      @(JSHAREPlatformFacebook),
                                                                      @(JSHAREPlatformFacebookMessenger),
                                                                      @(JSHAREPlatformTwitter),
                                                                      @(JSHAREPlatformJChatPro)]];
            break;
        case JSHAREText:
            [self.currentContentSupportPlatform addObjectsFromArray:@[
                                                                      @(JSHAREPlatformWechatSession),
                                                                      @(JSHAREPlatformWechatTimeLine)
                                                                      
                                                                      
                                                                      ]];
            break;
        case JSHAREMiniProgram:
            [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession)]];
            break;
        default:
            break;
    }
  [self setShareItem];
  self.hidden = NO;
}

- (void)showWithSupportedLoginPlatform{
    [self setPlatformDataWithLogin:YES];
    [self.currentContentSupportPlatform removeAllObjects];
    [self.currentContentSupportPlatform addObjectsFromArray:@[@(JSHAREPlatformWechatSession),@(JSHAREPlatformQQ),@(JSHAREPlatformSinaWeibo),@(JSHAREPlatformFacebook),@(JSHAREPlatformTwitter), @(JSHAREPlatformJChatPro)]];
    [self setShareItem];
    self.hidden = NO;
}

- (void)setPlatformDataWithLogin:(BOOL)isLogin {
  NSMutableArray * typeArr = [[NSMutableArray alloc] init];
  NSMutableArray * titleArr = [[NSMutableArray alloc] init];
  NSMutableArray * imageArr = [[NSMutableArray alloc] init];
  
  if ([JSHAREService isWeChatInstalled]) {
    [typeArr addObject:@(JSHAREPlatformWechatSession)];
    [typeArr addObject:@(JSHAREPlatformWechatTimeLine)];
    [titleArr addObject:@"微信"];
    [titleArr addObject:@"微信朋友圈"];
    [imageArr addObject:@"weixinhaoyou"];
    [imageArr addObject:@"pengyouquan"];
  }
  if ([JSHAREService isQQInstalled]) {
    [typeArr addObject:@(JSHAREPlatformQQ)];
    [titleArr addObject:@"QQ好友"];
    [imageArr addObject:@"qqhaoyou"];
  }
  [typeArr addObject:@(JSHAREPlatformQzone)];
  [titleArr addObject:@"举报"];
  [imageArr addObject:@"jubao"];
//    NSArray * titleArr = nil;
//    if(isLogin){
//        titleArr = @[@"微信",@"微信朋友圈",@"QQ"];
//    }else {
//        titleArr = @[@"微信好友",@"微信朋友圈",@"QQ好友"];
//    }
//  titleArr = @[@"微信",@"微信朋友圈",@"QQ好友",@"举报"];
//    NSArray * imageArr = @[@"weixinhaoyou",@"pengyouquan",@"qqhaoyou",@"jubao"];
    for (int i=0; i<typeArr.count; i++) {
        [self.platformData setObject:@{@"title":titleArr[i], @"image":imageArr[i], @"item":[UIButton buttonWithType:UIButtonTypeCustom]} forKey:typeArr[i]];
    }
}
- (void)setHidden:(BOOL)hidden {
    if (!hidden) {
        [super setHidden:hidden];
        [UIView animateWithDuration:0.3 animations:^{
            self.shareView.frame = CGRectMake(0, self.screenHeight-CGRectGetHeight(self.shareView.frame), CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame));
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];;
        }];
    }else{
      [UIView animateWithDuration:0.3 animations:^{
          self.shareView.frame = CGRectMake(0, self.screenHeight, CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame));
      }];
      [UIView animateWithDuration:0.5 animations:^{
          self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.0];;
      } completion:^(BOOL finished) {
          [super setHidden:hidden];
      }];
    }
}

- (void)hiddenView {
    self.type = 0;
    self.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hiddenView];
}

@end
