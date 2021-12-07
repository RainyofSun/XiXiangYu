//
//  XYRemindPopView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/22.
//

#import "XYRemindPopView.h"

@implementation XYRemindPopView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
        [self configProperty];
      self.backgroundColor =  [UIColor whiteColor];
      
      CGFloat radius = ADAPTATIONRATIO*20; // 圆角大小
      UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerTopRight; // 圆角位置
      UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
      CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
      maskLayer.frame = self.bounds;
      maskLayer.path = path.CGPath;
      self.layer.mask = maskLayer;
      
    }
    return self;
}
- (void)configProperty
{
    FWPopupBaseViewProperty *property = [FWPopupBaseViewProperty manager];
    property.popupAlignment = FWPopupAlignmentBottomCenter;
    property.popupAnimationStyle = FWPopupAnimationStylePosition;
    property.touchWildToHide = @"1";
  property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.8];
    //    property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.3];
    //    property.popupEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    property.animationDuration = 0.2;
    self.vProperty = property;
}
-(void)newView{
  
  self.titleLabel = [UILabel new];
  self.titleLabel.text = @"短视频发布规范须知";
  self.titleLabel.font =  [UIFont systemFontOfSize:ADAPTATIONRATIO *36];
  self.titleLabel.textColor = ColorHex(XYTextColor_333333);
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self).offset(ADAPTATIONRATIO *64);
  }];
  
  self.closeBtn = [UIButton new];
  [self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
  [self.closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.closeBtn];
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self).offset(-ADAPTATIONRATIO *30);
    make.top.equalTo(self).offset(ADAPTATIONRATIO *30);
    make.width.height.mas_equalTo(ADAPTATIONRATIO *32);
  }];

  self.textView = [[UITextView alloc]init];
  self.textView.editable = NO;
  self.textView.font =[UIFont systemFontOfSize:ADAPTATIONRATIO *28];
  self.textView.textColor = ColorHex(XYTextColor_999999);
  self.textView.text = @"一、社区内容规范\n1. 不能涉及国家领导人、公检法军、国家机关、国徽国旗等形象或词语。\n2. 不能涉及社会负面事件、敏感事件、红歌军歌、革命烈士等。\n3. 不能涉及邪教宗教、封建迷信、反动组织等相关元素。\n4. 不能涉及违法违规、低俗色情、血腥恐怖相关元素。\n5. 不能出现违反公序良俗、社会价值观相关元素，如出轨、家暴、歧视、引战、抽烟、脏话、恶搞、虐待等。\n6. 尊重版权，投放内容不得使用侵犯第三方合法权益的元素(包括文字、图片、视频、创意等)\n7. 不能出现危害未成年人或残疾人身心健康的内容未成年人不能作为代言人拍摄商业营销内容。\n\n二、版权法律风险\n1. 不能使用未授权的第三方的名字、logo、形象、图片、音频、视频等(相关素材需要单独确认)\n2. 不能使用未经艺人、红人等权利人授权的涉及其肖像权、姓名权、知识产权等相关素材\n3. 不可使用未授权的影视剧、综艺片段等素材不可搬运站内外视频\n\n三、 具体规范\n1.不可出现扰乱社会秩序的内容\n● 危险行为(暴力行为、未系安全带、公路上违法拍摄)等危险物品或潜在的危险元素，易引发人身安全风险\n● 打架斗殴、家暴、使用非正规刀具进行演绎\n2. 不可出现违反公序良俗相关内容\n抽烟、酗酒、虐待、恶搞、歧视、出轨等社会不良风气或不文明行为\n3.不可出现违法行为\n视频中存在赌博彩票、封建迷信、邪教组织、毒品、管制刀具、攻击器械等物品或相关演绎行为。\n4.不可出现风险内容\n视频中可能存在金融诈骗、个人隐私泄露、医疗药品(器具)、保健产品、医美整形等易引发人身或财产安全风险的内容。\n5.不可出现引人不适内容\n视频中出现血腥暴力、密集恐惧、恐怖灵异等引人不适的画面或剧情。\n6.不可出现低俗内容\n● 穿着暴露、轮廓明显、露点等\n● 视频中存在行为挑逗动作\n● 性暗示行为、不正当男女关系等\n7.硬性营销\n● 不可出现联系方式、微信号、二维码、链接、地址等硬性营销元素。\n● 不可出现促销活动、商品价格、打折信息、优惠券红包、引导购买、站外平台导流等商业招揽或类似信息。\n8.软性营销\n● 不可以抽奖、送红包等形式引导用户点赞关注等\n● 可植入性提及品牌，但不能有吹捧性质的效果引导\n免责条款\n1. 您理解并同意：若用户所发内容侵犯第三方合法权益导致不良后果的，应由发布者自行承担全部责任。\n2. 您理解并同意：若用户发布虚假内容从而导致不良后果的，应由发布者自行承担全部责任。";
  [self addSubview:self.textView];
  [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(ADAPTATIONRATIO *30);
    make.centerX.equalTo(self);
    make.top.equalTo(self.titleLabel.mas_bottom).offset(ADAPTATIONRATIO *34);
    make.bottom.equalTo(self).offset(-SafeAreaBottom());
  }];
  
  [self addSubview:self.webView];
  self.webView.hidden = YES;
  [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.bottom.top.equalTo(self.textView);
    
  }];
  
}

-(void)show{
  [super show];
  
  if (self.urlStr) {
    
    self.textView.hidden = YES;
    self.webView.hidden = !self.textView.hidden;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    //
    [self.webView loadRequest:request];
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
       // [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:NULL];
        // 设置代理
        //_webView.navigationDelegate = self;
        //_webView.UIDelegate = self;
        _webView.scrollView.contentInset = UIEdgeInsetsZero;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.alwaysBounceVertical = NO;
        _webView.scrollView.alwaysBounceHorizontal = NO;
    }
    return _webView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
