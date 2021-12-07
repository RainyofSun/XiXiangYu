//
//  GKDYCommentView.m
//  GKDYVideo
//
//  Created by QuintGao on 2019/5/1.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDYCommentView.h"
#import "UIImage+GKCategory.h"
#import "GKBallLoadingView.h"
#import "XYGeneralAPI.h"
#import "XYSDPlayerCommentTableViewCell.h"
@interface GKDYCommentView()<UITableViewDataSource, UITableViewDelegate> {
  NSArray *_dataArr;
}

@property (nonatomic, strong) UIVisualEffectView    *effectView;
@property (nonatomic, strong) UIView                *topView;
@property (nonatomic, strong) UIView                *footView;
@property (nonatomic, strong) UILabel               *countLabel;
@property (nonatomic, strong) UITextField                *tf;
@property (nonatomic, strong) UIButton                *querBtn;

@property (nonatomic, strong) UITableView           *tableView;

@property (nonatomic, assign) NSInteger             count;

@end

@implementation GKDYCommentView

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        [self addSubview:self.topView];
        [self addSubview:self.effectView];
        [self addSubview:self.countLabel];
        [self addSubview:self.closeBtn];
      [self addSubview:self.footView];
        [self addSubview:self.tableView];
      
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(ADAPTATIONRATIO * 100.0f);
        }];
        
//        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.topView);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 16.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 36.0f);
        }];
      [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.right.equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(50);
      }];

      
      [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.footView.mas_top);
          make.top.mas_equalTo(self.topView.mas_bottom);
        }];
      
        self.countLabel.text = [NSString stringWithFormat:@"共%zd条评论", self.count];
      
      
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)requestData {
    GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.tableView];
    [loadingView startLoading];
    
  
  NSString *method = @"api/v1/ShortVideo/GetCommentList";
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  
  NSString *shortVideoId =_videoModel.post_id;
  
  NSDictionary *params = @{
//     @"userId": user.userId,
     @"shortVideoId": @([shortVideoId integerValue]),
     @"page": @{
         @"pageIndex": @1,
         @"pageSize": @1000,
     },
  };

  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    [loadingView stopLoading];
    [loadingView removeFromSuperview];
    if (!error) {
      
      
      NSArray *dataArr =data[@"commentResp"];
      self.count = dataArr.count;
      _dataArr = dataArr;
      self.countLabel.text = [NSString stringWithFormat:@"共%zd条评论", self.count];
      [self.tableView reloadData];
      
    } else {

    }
  };
  [api start];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [loadingView stopLoading];
    [loadingView removeFromSuperview];
  });
}

- (void)setVideoModel:(GKDYVideoModel *)videoModel {
  _videoModel = videoModel;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", _dataArr[indexPath.row][@"commentBody"]];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    return cell;
  XYCommentModel *model = [XYCommentModel yy_modelWithJSON:_dataArr[indexPath.row]];
  
  XYSDPlayerCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYSDPlayerCommentTableViewCell class]) forIndexPath:indexPath];
  cell.model = model;
//cell.deleteBtn.alpha = 0;
  @weakify(self);
   cell.deleteBlock = ^{
     @strongify(self);
     [self clickDeleCommentWith:model];
    };
  return cell;
  
}

#pragma mark - UI
- (void)keyBoardWillShow:(NSNotification *) note {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
        //self.commentBgView.XY_bottom = kScreenHeight - keyBoardHeight;
      [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-keyBoardHeight-GK_SAFEAREA_BTM);
      }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

- (void)keyBoardWillHide:(NSNotification *) note {
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
     // self.commentBgView.XY_bottom = kScreenHeight;
      [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
      }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}
#pragma mark - 懒加载
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _effectView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = ColorHex(XYTextColor_FFFFFF);
        
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, ADAPTATIONRATIO * 100.0f);
        //绘制圆角 要设置的圆角 使用“|”来组合
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //设置大小
        maskLayer.frame = frame;
        
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        
        _topView.layer.mask = maskLayer;
     // [_topView roundSize:5];
    }
    return _topView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = AdaptedFont(13);
        _countLabel.textColor = [UIColor blackColor];
    }
    return _countLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:[UIImage gk_changeImage:[UIImage imageNamed:@"close"] color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
      //  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
      [_tableView registerClass:[XYSDPlayerCommentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XYSDPlayerCommentTableViewCell class])];
        _tableView.backgroundColor = [UIColor whiteColor];
     _tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

- (UIView *)footView {
    if (!_footView) {
      _footView = [UIView new];
      _footView.backgroundColor = ColorHex(XYThemeColor_B);
      [_footView setViewBorder:_footView color:ColorHex(XYThemeColor_F) border:1 type:UIViewBorderLineTypeTop];
      _tf = [[UITextField alloc] initWithFrame:CGRectMake(15, 6, SCREEN_WIDTH - 85, 38)];
      _tf.placeholder = @"有爱评论，说点好听的哟~";
     // _tf.textColor = [UIColor whiteColor];
      _tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
      _tf.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
      _tf.leftViewMode = UITextFieldViewModeAlways;
      _tf.rightViewMode = UITextFieldViewModeAlways;
      _tf.font = AdaptedFont(14);
      [_tf roundSize:19];
      _tf.backgroundColor = ColorHex(XYThemeColor_F);
      [_footView addSubview:_tf];
      
      _querBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tf.frame), 0, 50, 50)];
      [_querBtn setTitle:@"发布" forState:UIControlStateNormal];
      _querBtn.titleLabel.font = AdaptedFont(15);
      [_querBtn setTitleColor:ColorHex(XYThemeColor_H) forState:UIControlStateNormal];
      [_querBtn addTarget:self action:@selector(clickRelease) forControlEvents:UIControlEventTouchUpInside];
      [_footView addSubview:_querBtn];
    }
    return _footView;
}

- (void)clickRelease {
  [_tf resignFirstResponder];
  NSString *method = @"api/v1/ShortVideo/CommentVideo";
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  NSString *shortVideoId =_videoModel.post_id;

  
  NSDictionary *params = @{
     @"shortVideoId": @([shortVideoId integerValue]),
     @"destUserId": user.userId,
      @"commentBody": _tf.text
  };

  XYShowLoading;
  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (!error) {
      XYToastText(@"发布成功");

      [self requestData];
      self.tf.text = nil;
      
    } else {

    }
  };
  [api start];
}


- (void)clickDeleCommentWith:(XYCommentModel *)model {
  [_tf resignFirstResponder];
  NSString *method = @"api/v1/ShortVideo/DelCommentVideo";
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  NSString *shortVideoId =_videoModel.post_id;

  
  NSDictionary *params = @{
     @"shortVideoId": @([shortVideoId integerValue]),
     @"userId": user.userId,
      @"id":model.id
  };
  XYShowLoading;
  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (!error) {
      XYToastText(@"删除成功");

      [self requestData];
      
    } else {

    }
  };
  [api start];
}

@end
