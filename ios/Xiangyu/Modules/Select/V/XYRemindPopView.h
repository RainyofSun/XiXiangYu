//
//  XYRemindPopView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/22.
//

#import <UIKit/UIKit.h>
#import "FWPopupBaseView.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface XYRemindPopView : FWPopupBaseView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UITextView *textView;

@property(nonatomic,strong)NSString *urlStr;
@property (nonatomic, strong) WKWebView            *webView;
@end

NS_ASSUME_NONNULL_END
