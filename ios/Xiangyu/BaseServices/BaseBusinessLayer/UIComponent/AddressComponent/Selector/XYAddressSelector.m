//
//  XYAddressSelector.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/23.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAddressSelector.h"
#import "XYAddressContentView.h"

#define kSelectorHeight 400
@interface XYAddressSelector ()

@property (strong, nonatomic) UIControl *closeControl;

@property (strong, nonatomic) UIImageView *maskImageView;

@property (nonatomic,strong) XYAddressContentView *contentView;

@property (nonatomic, weak) UIViewController *baseViewController;

@property (nonatomic,strong) UIImage * image;

@property (nonatomic, assign) BOOL withTown;

@end

@implementation XYAddressSelector

- (instancetype)initWithBaseViewController:(UIViewController *)baseViewController withTown:(BOOL)withTown {
    if (self = [super init]) {
      self.withTown = withTown;
      self.image = [[UIApplication sharedApplication].keyWindow snapshotImage];
      self.baseViewController = baseViewController;
      [self layoutPageSubviews];
    }
    return self;
}
- (instancetype)initWithBaseViewController:(UIViewController *)baseViewController withTown:(BOOL)withTown desc:(NSString *)desc{
  if (self = [super init]) {
    self.withTown = withTown;
    self.image = [[UIApplication sharedApplication].keyWindow snapshotImage];
    self.descString = desc;
    self.baseViewController = baseViewController;
    [self layoutPageSubviews];
  }
  return self;
}
- (void)layoutPageSubviews {
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.contentView];
    [self addSubview:self.maskImageView];
    [self addSubview:self.closeControl];
    
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kSelectorHeight);
    
    if (self.baseViewController) {
        [self.baseViewController.view addSubview:self];
    }
    
}

- (void)show
{
    if (!self.narrowedOff) {
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.maskImageView.layer.zPosition = -10000;
        self.maskImageView.image = self.image;
        
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 0.4;
            self.contentView.frame = CGRectMake(0,kScreenHeight - kSelectorHeight,kScreenWidth,kSelectorHeight);
        }];
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DRotate(t, 5/90.0 * M_PI_2, 1, 0, 0);
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    [self transNavigationBarToHide:YES];
                }
            }
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -40, -40);
            }];
        }];
    } else {
        self.maskImageView.image = self.image;
        
        self.closeControl.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 0.4;
            self.contentView.frame = CGRectMake(0,kScreenHeight - kSelectorHeight,kScreenWidth,kSelectorHeight);
            
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    self.baseViewController.navigationController.navigationBarHidden = YES;
                }
            }
        }];
    }
}

- (void)dismiss {

    if (!self.narrowedOff) {
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -0.004;
        [self.maskImageView.layer setTransform:t];
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,kScreenHeight,kScreenWidth,kSelectorHeight);
        } completion:^(BOOL finished) {

            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    [self transNavigationBarToHide:NO];
                }
            }
        }];
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -40, -40);
            self.maskImageView.layer.transform = CATransform3DRotate(t, 5/90.0 * M_PI_2, 1, 0, 0);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25f animations:^{
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, 0, 0);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
    } else {
        self.closeControl.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.maskImageView.alpha = 1;
            self.contentView.frame = CGRectMake(0,kScreenHeight,kScreenWidth,kSelectorHeight);
        } completion:^(BOOL finished) {
            if (self.baseViewController) {
                if (self.baseViewController.navigationController) {
                    self.baseViewController.navigationController.navigationBarHidden = NO;
                }
            }
            [self removeFromSuperview];
        }];
    }
}
- (void)transNavigationBarToHide:(BOOL)hide
{
    if (hide) {
        CGRect frame = self.baseViewController.navigationController.navigationBar.frame;
        [self setNavigationBarOriginY:-frame.size.height animated:NO];
    } else {
        [self setNavigationBarOriginY:StatusBarHeight() animated:NO];
    }
}

- (void)setNavigationBarOriginY:(CGFloat)y animated:(BOOL)animated
{
    CGFloat statusBarHeight         = StatusBarHeight();
    UIWindow *appKeyWindow          = [UIApplication sharedApplication].keyWindow;
    UIView *appBaseView             = appKeyWindow.rootViewController.view;
    CGRect viewControllerFrame      = [appBaseView convertRect:appBaseView.bounds toView:appKeyWindow];
    CGFloat overwrapStatusBarHeight = statusBarHeight - viewControllerFrame.origin.y;
    CGRect frame                    = self.baseViewController.navigationController.navigationBar.frame;
    frame.origin.y                  = y;
    CGFloat navBarHiddenRatio       = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0;
    CGFloat alpha                   = MAX(1.f - navBarHiddenRatio, 0.000001f);
    [UIView animateWithDuration:animated ? 0.1 : 0 animations:^{
        self.baseViewController.navigationController.navigationBar.frame = frame;
        NSUInteger index = 0;
        for (UIView *view in self.baseViewController.navigationController.navigationBar.subviews) {
            index++;
            if (index == 1 || view.hidden || view.alpha <= 0.0f) continue;
            view.alpha = alpha;
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            UIColor *tintColor = self.baseViewController.navigationController.navigationBar.tintColor;
            if (tintColor) {
                self.baseViewController.navigationController.navigationBar.tintColor = [tintColor colorWithAlphaComponent:alpha];
            }
        }
    }];
}

- (void)setAdcode:(NSString *)adcode {
  _adcode = adcode;
  if (adcode.isNotBlank) {
    _contentView.adcode = adcode;
  }
}

#pragma mark - getter
- (UIControl *)closeControl {
    if (!_closeControl) {
        _closeControl = [[UIControl alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,kScreenHeight-kSelectorHeight)];
        _closeControl.userInteractionEnabled = NO;
        _closeControl.backgroundColor        = [UIColor clearColor];
        [_closeControl addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeControl;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    }
    return _maskImageView;
}

- (XYAddressContentView *)contentView {
    if (!_contentView) {
        @weakify(self);
      _contentView = [[XYAddressContentView alloc] initWithWithoutTitleView:NO withTown:self.withTown withSure:NO withDesc:self.descString];
        _contentView.backgroundColor = ColorHex(XYThemeColor_B);
        _contentView.dismissAction = ^{
            [weak_self dismiss];
        };
        _contentView.chooseFinish = ^(XYFormattedArea *area) {
            if (weak_self.chooseFinish) weak_self.chooseFinish(area);
            [weak_self dismiss];
        };
    }
    return _contentView;
}
@end
