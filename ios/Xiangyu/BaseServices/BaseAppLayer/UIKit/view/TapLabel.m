
//
//  TapLabel.m
//  ZuU
//
//  Created by Apple on 2020/1/13.
//  Copyright © 2020 Apple. All rights reserved.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　━　　　┃
 * 　　┃ 　^      ^ 　┃
 * 　　┃　　　┻　　　┃
 * 　　┗━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "TapLabel.h"

@implementation TapLabel

+(instancetype)createViewWithTitleColor:(UIColor *)textColor font:(UIFont *)font{
    TapLabel *tapLabel =[[TapLabel alloc ]init];
    tapLabel.titleLabel.textColor = textColor;
    tapLabel.titleLabel.font = font;
    return tapLabel;
}
+(instancetype)createViewWithTitleColor:(UIColor *)textColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor{
    TapLabel *tapLabel =[TapLabel createViewWithTitleColor:textColor font:font];
  tapLabel.backgroundColor = backgroundColor;
    return tapLabel;
}


-(id)initWithFrame:(CGRect)frame{
    
    
    
    
    self=[super initWithFrame:frame];
    if (self) {
        self.titleLabel = [LSHControl createLabelWithFrame:CGRectZero Font:AdaptedFont(10) Text:@"" color:ColorHex(XYTextColor_999999) textAlignment:NSTextAlignmentCenter];
        [self addSubview:self.titleLabel];
      
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.trailing.equalTo(self).offset(-AutoSize(6));
            
           // make.bottom.equalTo(self).offset(-AutoSize(5));
        }];
    }
    return self;
}
-(void)setIsRedNum:(BOOL)isRedNum{
    _isRedNum = isRedNum;
    if (_isRedNum) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
             make.trailing.equalTo(self).offset(-AutoSize(6));
                  // make.bottom.equalTo(self).offset(-AutoSize(5));
        }];
    }
}
-(void)setSetoff:(CGFloat)setoff{
    _setoff = setoff;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.trailing.equalTo(self).offset(-setoff);
        
       // make.bottom.equalTo(self).offset(-AutoSize(5));
    }];
}
-(NSString *)text{
  return self.titleLabel.text;
}
-(void)setText:(NSString *)text{
  self.titleLabel.text = text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
