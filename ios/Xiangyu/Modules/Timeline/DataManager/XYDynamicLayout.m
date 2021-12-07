//
//  XYDynamicLayout.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYDynamicLayout.h"
#import "XYPhotoContainerView.h"

@implementation XYDynamicLayout
- (instancetype)initWithModel:(XYDynamicsModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        [self resetLayout];
    }
    return self;
}

- (void)resetLayout {
  _height = 0;
  _height += kDynamicsNormalPadding;
  _height += kDynamicsNameHeight;
  
  if (_model.isExt.integerValue != 1) {
    _height += 4;
    _height += 18;
  }
  
  [self layoutLocation];
  [self layoutHometown];
  
  if (_model.isExt.integerValue != 1) {
    _height += (_locationLayout || _homeTownLayout) ? _locationLayout.textBoundingSize.height : 18;
  }
  
  _height += kDynamicsNameDetailPadding;
  
  [self layoutDetail];
  _height += _detailLayout.textBoundingSize.height;

  if (_model.shouldShowMoreButton) {
      _height += kDynamicsNameDetailPadding;
      _height += kDynamicsMoreLessButtonHeight;
  }
  
  if (_model.images.count != 0) {
      [self layoutPicture];
      _height += kDynamicsNameDetailPadding;
      _height += _photoContainerSize.height;
  }
  if ([_model.subjectId integerValue]) {
    _height += kDynamicsNameDetailPadding;
    _height += AutoSize(20);
  }

  [self layoutLike];
  [self layoutEvaluate];
  
  if (_model.isExt.integerValue != 1) {
    _height += kDynamicsPortraitNamePadding;
    _height += kDynamicsNameHeight;//时间
  }
  
  _height += kDynamicsPortraitNamePadding;
    
}

- (void)layoutDetail {
    _detailLayout = nil;
    
  NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_model.content?:@""];
  text.yy_font = [UIFont systemFontOfSize:16];
  text.yy_color = ColorHex(XYTextColor_222222);
  text.yy_lineSpacing = kDynamicsLineSpacing;
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber | NSTextCheckingTypeLink error:nil];
    
  @weakify(self);
    [detector enumerateMatchesInString:_model.content?:@""
                               options:kNilOptions
                                 range:text.yy_rangeOfAll
                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                
                                if (result.URL) {
                                    YYTextHighlight * highLight = [YYTextHighlight new];
                                    [text yy_setColor:[UIColor colorWithRed:69/255.0 green:88/255.0 blue:133/255.0 alpha:1] range:result.range];
                                    highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                        if (weak_self.clickUrlBlock) {
                                          weak_self.clickUrlBlock([text.string substringWithRange:range]);
                                        }
                                    };
                                  [text yy_setTextHighlight:highLight range:result.range];
                                }
                                if (result.phoneNumber) {
                                    YYTextHighlight * highLight = [YYTextHighlight new];
                                  [text yy_setColor:[UIColor colorWithRed:69/255.0 green:88/255.0 blue:133/255.0 alpha:1] range:result.range];
                                    highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                        if (weak_self.clickPhoneNumBlock) {
                                          weak_self.clickPhoneNumBlock([text.string substringWithRange:range]);
                                        }
                                    };
                                  [text yy_setTextHighlight:highLight range:result.range];
                                }
                            }];
    
    NSInteger lineCount = 6;
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - kDynamicsNormalPadding - kDynamicsPortraitWidthAndHeight - kDynamicsPortraitNamePadding - kDynamicsNormalPadding, 16 * lineCount + kDynamicsLineSpacing * (lineCount - 1))];

    container.truncationType = YYTextTruncationTypeEnd;
    
    _detailLayout = [YYTextLayout layoutWithContainer:container text:text];
    
}

- (void)layoutLocation {
  if (!_model.dwellArea) return;
  
  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  
  // 嵌入 UIImage
  UIImage *image = [UIImage imageNamed:@"icon_12_dingwe"];
  NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [all_attr appendAttributedString:image_attr];
  
  //创建属性字符串
  NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[[XYAddressService sharedService] queryCityAreaNameWithAdcode:_model.dwellArea.stringValue]?:@""];
  text_attr.yy_font = font;
  text_attr.yy_color = ColorHex(XYTextColor_635FF0);
  [all_attr appendAttributedString:text_attr];
  
   // 创建文本容器
   YYTextContainer *container = [YYTextContainer new];
   container.size = CGSizeMake(CGFLOAT_MAX, 18);
   container.maximumNumberOfRows = 1;
     
   // 生成排版结果
   _locationLayout = [YYTextLayout layoutWithContainer:container text:all_attr];
}

- (void)layoutHometown {
  if (!_model.area) return;
  
  //创建属性字符串
  NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"故乡:%@", [[XYAddressService sharedService] queryCityAreaNameWithAdcode:_model.area.stringValue]]];
  text_attr.yy_font = AdaptedFont(12);
  text_attr.yy_color = ColorHex(XYTextColor_999999);
  
   // 创建文本容器
   YYTextContainer *container = [YYTextContainer new];
   container.size = CGSizeMake(CGFLOAT_MAX, 18);
   container.maximumNumberOfRows = 1;
     
   // 生成排版结果
   _homeTownLayout = [YYTextLayout layoutWithContainer:container text:text_attr];
}

- (void)layoutLike {
  NSMutableAttributedString *like_attr = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  
  // 嵌入 UIImage
  UIImage *likeImage = [UIImage imageNamed:_model.isFabulous.integerValue == 0 ? @"icon_22_dianzan_normal" : @"icon_22_dianzan_selected"];
  NSMutableAttributedString *like_image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:likeImage contentMode:UIViewContentModeCenter attachmentSize:likeImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [like_attr appendAttributedString:like_image_attr];
  
  //创建属性字符串
  NSMutableAttributedString *like_text_attr = [[NSMutableAttributedString alloc] initWithString:_model.fabulous ? _model.fabulous.stringValue : @"0"];
  like_text_attr.yy_font = font;
  like_text_attr.yy_color = ColorHex(XYTextColor_999999);
  [like_attr appendAttributedString:like_text_attr];
  
   // 创建文本容器
   YYTextContainer *container = [YYTextContainer new];
   container.size = CGSizeMake(CGFLOAT_MAX, 22);
   container.maximumNumberOfRows = 1;
  
  _likeLayout = [YYTextLayout layoutWithContainer:container text:like_attr];
  
}

- (void)layoutEvaluate {
  NSMutableAttributedString *evaluate_attr = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  
  // 嵌入 UIImage
  UIImage *evaluateImage = [UIImage imageNamed:@"icon_22_pinglu"];
  NSMutableAttributedString *evaluate_image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:evaluateImage contentMode:UIViewContentModeCenter attachmentSize:evaluateImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [evaluate_attr appendAttributedString:evaluate_image_attr];
  
  //创建属性字符串
  NSMutableAttributedString *evaluate_text_attr = [[NSMutableAttributedString alloc] initWithString:_model.discuss ? _model.discuss.stringValue : @"0"];
  evaluate_text_attr.yy_font = font;
  evaluate_text_attr.yy_color = ColorHex(XYTextColor_999999);
  [evaluate_attr appendAttributedString:evaluate_text_attr];
  
   // 创建文本容器
   YYTextContainer *evaluateContainer = [YYTextContainer new];
  evaluateContainer.size = CGSizeMake(CGFLOAT_MAX, 22);
  evaluateContainer.maximumNumberOfRows = 1;
  
  _evaluateLayout = [YYTextLayout layoutWithContainer:evaluateContainer text:evaluate_attr];
  
}

- (void)layoutPicture {
    self.photoContainerSize = CGSizeZero;
  if (_model.type.integerValue == 3) {
    self.photoContainerSize = [XYPhotoContainerView getContainerSizeWithPicPathStringsArray:@[_model.coverUrl]];
  } else {
    self.photoContainerSize = [XYPhotoContainerView getContainerSizeWithPicPathStringsArray:_model.images];
  }
}

@end
