//
//  XYReleaseVideoVC.h
//  Xiangyu
//
//  Created by GQLEE on 2021/3/2.
//

#import "GKNavigationBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYReleaseVideoVC : GKNavigationBarViewController

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) UIImage *onePreImage;
@property (strong, nonatomic) NSURL *url;
@property (nonatomic, strong) NSString *contentText;
@end

NS_ASSUME_NONNULL_END
