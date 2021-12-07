#import "UIViewAdditions.h"
#import <objc/runtime.h>
#import <AudioToolbox/AudioToolbox.h>
/**
 * Additions.
 */
static const void *tapEventKey = "tapEvent";
static const void *longEventKey = "longEvent";
@implementation UIView (KNCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
  return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
  return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
  return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
  CGRect frame = self.frame;
  frame.origin.x = right - frame.size.width;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
  return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
  CGRect frame = self.frame;
  frame.origin.y = bottom - frame.size.height;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
  return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
  self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
  return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
  self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
  return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
  return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
  CGFloat x = 0;
  for (UIView* view = self; view; view = view.superview) {
    x += view.left;
  }
  return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
  CGFloat y = 0;
  for (UIView* view = self; view; view = view.superview) {
    y += view.top;
  }
  return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
  CGFloat x = 0;
  for (UIView* view = self; view; view = view.superview) {
      x += view.left;

    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      x -= scrollView.contentOffset.x;
    }
  }

  return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
  CGFloat y = 0;
  for (UIView* view = self; view; view = view.superview) {
    y += view.top;

    if ([view isKindOfClass:[UIScrollView class]]) {
      UIScrollView* scrollView = (UIScrollView*)view;
      y -= scrollView.contentOffset.y;
    }
  }
  return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
  return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
  return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
  CGRect frame = self.frame;
  frame.origin = origin;
  self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
  return self.frame.size;
}
/**
 设置边框
 
 @param color 颜色
 @param width 宽度
 */
- (void)setBorder:(UIColor *)color width:(CGFloat)width{
    
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

-(void)roundSize:(CGFloat )round{
    self.layer.cornerRadius = round;
    self.layer.masksToBounds=YES;
    self.clipsToBounds=YES;
}
/**
 * 设置圆角
 */
-(void)roundSize:(CGFloat)round andCorner:(UIRectCorner)corners{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(round, round)];
    
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    CAShapeLayer *borderMaskLayer = [CAShapeLayer layer];
    borderMaskLayer.path = maskPath.CGPath;
    borderMaskLayer.lineWidth = self.layer.borderWidth;
    borderMaskLayer.strokeColor = self.layer.borderColor;
    borderMaskLayer.fillColor = [UIColor clearColor].CGColor;
    
    self.layer.mask = maskLayer;
//    self.layer.cornerRadius = corners;
    [self.layer addSublayer:borderMaskLayer];
}
-(void)roundSize:(CGFloat)round color:(UIColor*)color{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = .5;
    self.layer.cornerRadius = round;
    self.layer.masksToBounds=YES;
    self.clipsToBounds=YES;
}
-(void)roundSize:(CGFloat)round color:(UIColor*)color width:(CGFloat)width{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = round;
    self.layer.masksToBounds=YES;
    self.clipsToBounds=YES;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
  CGRect frame = self.frame;
  frame.size = size;
  self.frame = frame;
}
-(void)setDottedLineWithRoundSize:(CGFloat)round color:(UIColor *)color{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = color.CGColor;
    border.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:round];
    //设置路径
    border.path = path.CGPath;
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = 1.0f;
    //设置线条的样式
    //  border.lineCap = @"round";
    //虚线的间隔
    border.lineDashPattern = @[@6, @6];
    [self.layer addSublayer:border];
}

-(NSArray*)allSubviews {
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:self];
    for (UIView * subview in self.subviews) {
        [arr addObjectsFromArray:(NSArray*)[subview allSubviews]];
    }
    return arr;
}

- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    
    theView.layer.masksToBounds = NO;
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,1.5);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
}

-(void)setViewBorder:(UIView *)view color:(UIColor *)color border:(float)border type:(UIViewBorderLineType)borderLineType{
    [self setViewBorder:view color:color border:border type:borderLineType setX:0];
}

-(void)setViewBorder:(UIView *)view color:(UIColor *)color border:(float)border type:(UIViewBorderLineType)borderLineType setX:(CGFloat)setX{
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = color.CGColor;
    
    switch (borderLineType) {
        case UIViewBorderLineTypeTop:{
            lineLayer.frame = CGRectMake(setX, 0, view.frame.size.width-2*setX, border);
            break;
        }
        case UIViewBorderLineTypeRight:{
            lineLayer.frame = CGRectMake(view.frame.size.width, setX, border, view.frame.size.height-2*setX);
            break;
        }
        case UIViewBorderLineTypeBottom:{
            lineLayer.frame = CGRectMake(setX, view.frame.size.height, view.frame.size.width-2*setX,border);
            break;
        }
        case UIViewBorderLineTypeLeft:{
            lineLayer.frame = CGRectMake(0, setX, border, view.frame.size.height-2*setX);
            break;
        }
        default:{
            lineLayer.frame = CGRectMake(0, 0, view.frame.size.width-42, border);
            break;
        }
    }
   
    [view.layer addSublayer:lineLayer];
}
-(void)handleLongGestureRecognizerEventWithBlock:(ActionBlock)action{
    //longEventKey
    objc_setAssociatedObject(self, &longEventKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UILongPressGestureRecognizer *longTap=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongEvent:)];
    [self addGestureRecognizer:longTap];
    self.userInteractionEnabled=YES;
}
-(void)LongEvent:(UILongPressGestureRecognizer*)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
      
        ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &longEventKey);
        if (block) {
            block(gestureRecognizer);
        }
    }
   
}
-(void)handleTapGestureRecognizerEventWithBlock:(ActionBlock)action{
    objc_setAssociatedObject(self, &tapEventKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapEvent:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled=YES;
}
-(void)TapEvent:(id)sender{
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &tapEventKey);
    if (block) {
        block(sender);
    }
}
-(void)setViewColors:(NSArray *)colors withDirection:(NSInteger)direction{
    CAGradientLayer *layer=[CAGradientLayer layer];
    layer.frame = self.bounds;
    [layer setColors:colors];
    if (direction == 0 ) {
        [layer setStartPoint:CGPointMake(0, 0)];
        [layer setEndPoint:CGPointMake(1, 0)];
    }else if (direction == 1){
        [layer setStartPoint:CGPointMake(0, 0)];
        [layer setEndPoint:CGPointMake(0, 1)];
    }else if (direction == 2){
        [layer setStartPoint:CGPointMake(0, 0)];
        [layer setEndPoint:CGPointMake(1, 1)];
    }else if (direction == 3){
        [layer setStartPoint:CGPointMake(1, 0)];
        [layer setEndPoint:CGPointMake(0, 1)];
    }
    if (![self.layer.sublayers.firstObject isKindOfClass:[CAGradientLayer class]]) {
          [self.layer insertSublayer:layer atIndex:0];
    }
  


}
-(void)setTextColors:(NSArray *)colors withDirection:(NSInteger)direction{
    CAGradientLayer *layer=[CAGradientLayer layer];
    layer.frame = self.frame;
    [layer setColors:colors];
    if (direction == 0 ) {
        [layer setStartPoint:CGPointMake(0, 0)];
        [layer setEndPoint:CGPointMake(1, 0)];
    }else if (direction == 1){
        [layer setStartPoint:CGPointMake(0, 0)];
        [layer setEndPoint:CGPointMake(0, 1)];
    }else if (direction == 2){
        [layer setStartPoint:CGPointMake(0, 0)];
        [layer setEndPoint:CGPointMake(1, 1)];
    }else if (direction == 3){
        [layer setStartPoint:CGPointMake(1, 0)];
        [layer setEndPoint:CGPointMake(0, 1)];
    }
    if (![self.layer.sublayers.firstObject isKindOfClass:[CAGradientLayer class]]) {
        [self.superview.layer addSublayer:layer];
        layer.mask = self.layer;
        self.frame = layer.bounds;
    }

    //   [self.layer insertSublayer:layer atIndex:0];
}

- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}

- (void)shakeAnimation{
    // 获取到当前的View
    CALayer *viewLayer = self.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.06];
    // 设置次数
    [animation setRepeatCount:3];
    // 添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}


@end
