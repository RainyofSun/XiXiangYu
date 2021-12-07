//
//  OrderKeyValueView.m
//  XieXie
//
//  Created by Apple on 2020/10/27.
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
#import "OrderKeyValueView.h"

@implementation OrderKeyValueView
+(instancetype)initWithTitleLabel:(NSString *)title
                        valueLabel:(NSString *)values {

    OrderKeyValueView *view = [[OrderKeyValueView alloc] initWithFrame:CGRectZero];
    if (view) {
        view.titleLabel.text = title;
        view.valueLabel.text = values;
    }
    return view;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    self.titleLabel=[LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999) text:@""];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self);
       
    }];
    
    self.valueLabel=[LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_222222) text:@""];
    [self addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self);
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
