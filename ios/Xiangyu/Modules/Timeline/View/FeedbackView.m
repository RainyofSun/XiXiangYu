//
//  FeedbackView.m
//  XieXie
//
//  Created by Apple on 2020/12/18.
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
#import "FeedbackView.h"

@implementation FeedbackView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{

    
    self.bgView=[LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
    [self.bgView roundSize:AutoSize(4) color:ColorHex(XYThemeColor_E)];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(AutoSize(15));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(AutoSize(0));
        make.height.mas_equalTo(AutoSize(140));
        make.bottom.equalTo(self).offset(-AutoSize(0)).priority(800);
    }];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
   // [self.textView setMaxLength:RM_LeaveMessageLength];
    //self.textView.placeholder=LOCALIZATION(@"input_sign");//
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.font=AdaptedFont(14);
    [self.bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(AutoSize(8));
        make.top.equalTo(self.bgView).offset(AutoSize(4));
        make.center.equalTo(self.bgView);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
