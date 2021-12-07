//
//  XYRollingNoticeView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYRollingNoticeView.h"
#import "YYTimer.h"

@interface XYRollingNoticeView ()
{
    BOOL _isAnimating;
}
@property (nonatomic, strong) NSMutableDictionary *reuseidClassMap;

@property (nonatomic, strong) NSMutableArray *reusePool;

@property (nonatomic, strong) YYTimer *timer;

@property (nonatomic, assign) int currentIndex;

@property (nonatomic, strong) XYRollingNoticeCell *currentCell;

@property (nonatomic, strong) XYRollingNoticeCell *willShowCell;

@property (nonatomic, strong) UITapGestureRecognizer *gyTapGesture;

@end

@implementation XYRollingNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _stayInterval = 2;
        self.clipsToBounds = YES;
        [self addGestureRecognizer:self.gyTapGesture];
    }
    return self;
}


- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [self.reuseidClassMap setObject:NSStringFromClass(cellClass) forKey:identifier];
}

- (__kindof XYRollingNoticeCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    for (XYRollingNoticeCell *cell in self.reusePool) {
        
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            return cell;
        }
    }
    
    Class cellCls = NSClassFromString(self.reuseidClassMap[identifier]);
    XYRollingNoticeCell *cell = [[cellCls alloc] initWithReuseIdentifier:identifier];
    return cell;
    
}


#pragma mark- rolling
- (void)layoutCurrentCellAndWillShowCell {
    int count = (int)[self.dataSource numberOfRowsForNoticeView:self];
    if (_currentIndex > count - 1) {
        _currentIndex = 0;
    }
    
    int willShowIndex = _currentIndex + 1;
    if (willShowIndex > count - 1) {
        willShowIndex = 0;
    }

    float w = self.XY_width;
    float h = self.XY_height;
    
    if (!_currentCell) {
        // 第一次没有currentcell
        _currentCell = [self.dataSource noticeView:self atIndex:_currentIndex];
        _currentCell.frame  = CGRectMake(0, 0, w, h);
        [self addSubview:_currentCell];
        return;
    }
    
    
    
    _willShowCell = [self.dataSource noticeView:self atIndex:willShowIndex];
    _willShowCell.frame = CGRectMake(0, h, w, h);
    [self addSubview:_willShowCell];
    
    [self.reusePool removeObject:_currentCell];
    [self.reusePool removeObject:_willShowCell];
    
    
}

- (void)reloadDataAndStartRolling {
    [self stopRolling];
    [self layoutCurrentCellAndWillShowCell];
    NSInteger count = [self.dataSource numberOfRowsForNoticeView:self];
    if (count && count < 2) {
        return;
    }
    
    _timer = [YYTimer timerWithTimeInterval:_stayInterval target:self selector:@selector(timerHandle) repeats:YES];
}

- (void)stopRolling {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _isAnimating = NO;
    _currentIndex = 0;
    [_currentCell removeFromSuperview];
    [_willShowCell removeFromSuperview];
    _currentCell = nil;
    _willShowCell = nil;
    [self.reusePool removeAllObjects];
}

- (void)timerHandle {
    
    if (_isAnimating) return;
    
    [self layoutCurrentCellAndWillShowCell];
    _currentIndex ++;
    
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    
    _isAnimating = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _currentCell.frame = CGRectMake(0, -h, w, h);
        _willShowCell.frame = CGRectMake(0, 0, w, h);
    } completion:^(BOOL finished) {
        if (_currentCell && _willShowCell) {
            [self.reusePool addObject:_currentCell];
            [_currentCell removeFromSuperview];
            _currentCell = _willShowCell;
        }
        _isAnimating = NO;
    }];
}


- (void)handleCellTapAction {
    int count = (int)[self.dataSource numberOfRowsForNoticeView:self];
    if (_currentIndex > count - 1) {
        _currentIndex = 0;
    }
    if ([self.delegate respondsToSelector:@selector(didClickNoticeView:atIndex:)]) {
        [self.delegate didClickNoticeView:self atIndex:_currentIndex];
    }
}

#pragma mark- getter
- (NSMutableDictionary *)reuseidClassMap {
    if (!_reuseidClassMap) {
        _reuseidClassMap = @{}.mutableCopy;
    }
    return _reuseidClassMap;
}

- (NSMutableArray *)reusePool {
    if (!_reusePool) {
        _reusePool = @[].mutableCopy;
    }
    return _reusePool;
}

- (UITapGestureRecognizer *)gyTapGesture {
    if (!_gyTapGesture) {
        _gyTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCellTapAction)];
    }
    return _gyTapGesture;
}

@end
