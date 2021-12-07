//
//  XYDynamicsDetailDataManager.m
//  Xiangyu
//
//  Created by dimon on 09/02/2021.
//

#import "XYDynamicsDetailDataManager.h"
#import "XYFollowAPI.h"
#import "XYDynamicsLikesUserAPI.h"
#import "XYDynamicsCommentsAPI.h"
#import "XYAPIBatchAPIRequests.h"
#import "XYCommentDynamicAPI.h"
#import "XYDeleteDynamicsAPI.h"
#import "XYDeleteCommentAPI.h"

@interface XYDynamicsDetailDataManager () <XYAPIBatchAPIRequestsProtocol>

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, strong) XYAPIBatchAPIRequests *batchReq;

@property (nonatomic, copy)void(^requestAllComBlock)(void);

@end

@implementation XYDynamicsDetailDataManager

- (void)layoutViewData {
  if (self.dynamicsModel.type.integerValue != 1) {
    self.headerHeight += kScreenWidth;
  }
  
  if (self.dynamicsModel.content.isNotBlank) {
    self.headerHeight += 16;
    
    _detailLayout = nil;
    
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_dynamicsModel.content?:@""];
    text.yy_font = [UIFont systemFontOfSize:16];
    text.yy_lineSpacing = 5;
    text.yy_color = ColorHex(XYTextColor_222222);
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber | NSTextCheckingTypeLink error:nil];
    
  @weakify(self);
    [detector enumerateMatchesInString:_dynamicsModel.content?:@""
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
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 36, CGFLOAT_MAX)];

    container.truncationType = YYTextTruncationTypeEnd;
    
    _detailLayout = [YYTextLayout layoutWithContainer:container text:text];
    
    self.headerHeight += _detailLayout.textBoundingSize.height;
    
  }
  
  self.headerHeight += 16;
  self.headerHeight += 18;
  self.headerHeight += 16;
}

- (void)followUserWithBlock:(void(^)(XYError * error))block {
  
  XYFollowAPI *api = [[XYFollowAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId destUserId:self.dynamicsModel.userId operation:self.dynamicsModel.isFollow.integerValue == 1 ? @(2) : @(1) source:@(2) dyId:self.dynamicsModel.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      BOOL isFollow = self.dynamicsModel.isFollow.integerValue == 1;
      self.dynamicsModel.isFollow = isFollow ? @(0) : @(1);
      if (block) block(nil);
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (void)deleteDynamicWithBlock:(void(^)(XYError * error))block {
  XYDeleteDynamicsAPI *api = [[XYDeleteDynamicsAPI alloc] initWithDynamicId:self.dynamicsModel.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      if (block) block(nil);
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (void)deleteCommentWithIndex:(NSUInteger)index block:(void(^)(XYError * error))block {
  if (index > self.commentsArray.count - 1) {
    if (block) {
      block(ClientExceptionNULL());
    }
    return;
  }
  XYCommentModel *model = self.commentsArray[index];
  XYDeleteCommentAPI *api = [[XYDeleteCommentAPI alloc] initWithDynamicId:self.dynamicsModel.id commentId:model.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      [self.commentsArray removeObjectAtIndex:index];
      if (block) block(nil);
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (void)postCommont:(NSString *)commont block:(void(^)(XYError * error))block {
  
  XYCommentDynamicAPI *api = [[XYCommentDynamicAPI alloc] initWithDynamicId:self.dynamicsModel.id destUserId:[[XYUserService service] fetchLoginUser].userId commentBody:commont];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error && data) {
      self.page = 1;
      XYDynamicsCommentsAPI *commentApi = [[XYDynamicsCommentsAPI alloc] initWithDynamicId:self.dynamicsModel.id page:self.page];
      commentApi.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
        if (!error) {
          [self.commentsArray removeAllObjects];
          NSArray *arr = data[@"commentResp"];
          [self.commentsArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYCommentModel class] json:arr]];
          if (!arr || arr.count == 0) {
            self.page --;
          }
          if (block) block(nil);
        } else {
          self.page --;
          if (block) block(error);
        }
      };
      [commentApi start];
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (void)fetchNewPageDataWithLikesErrorBlock:(void(^)(XYError * error))likesErrorBlock
                          commentErrorBlock:(void(^)(XYError * error))commentErrorBlock
                                 completion:(void(^)(void))completion {
  self.requestAllComBlock = completion;
//  XYDynamicsLikesUserAPI *likesApi = [[XYDynamicsLikesUserAPI alloc] initWithDynamicId:self.dynamicsModel.id];
//  likesApi.filterCompletionHandler = ^(NSArray *  _Nullable data, XYError * _Nullable error) {
//    if (!error) {
//      self.likesUserArray = [NSArray yy_modelArrayWithClass:[XYLikesUserModel class] json:data];
//    } else {
//      if (likesErrorBlock) likesErrorBlock(error);
//    }
//  };
//  [self.batchReq addAPIRequest:likesApi];
  
  self.page = 1;
  XYDynamicsCommentsAPI *commentApi = [[XYDynamicsCommentsAPI alloc] initWithDynamicId:self.dynamicsModel.id page:self.page];
  commentApi.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      [self.commentsArray removeAllObjects];
      
      NSArray *arr = data[@"commentResp"];
      [self.commentsArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYCommentModel class] json:arr]];
      if (!arr || arr.count == 0) {
        self.page --;
      }
    } else {
      self.page --;
      if (commentErrorBlock) commentErrorBlock(error);
    }
  };
  [self.batchReq addAPIRequest:commentApi];
  [self.batchReq start];
}

- (void)fetchNextPageDataWithBlock:(void(^)(BOOL needRefresh, XYError * error))block {
  self.page ++;
  XYDynamicsCommentsAPI *commentApi = [[XYDynamicsCommentsAPI alloc] initWithDynamicId:self.dynamicsModel.id page:self.page];
  commentApi.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      NSArray *arr = data[@"commentResp"];
      [self.commentsArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYCommentModel class] json:arr]];
      if (!arr || arr.count == 0) {
        self.page --;
        if (block) block(NO, nil);
      } else {
        if (block) block(YES, nil);
      }
    } else {
      self.page --;
      if (block) block(NO, error);
    }
  };
  [commentApi start];
}

- (NSMutableArray<XYCommentModel *> *)commentsArray {
  if (!_commentsArray) {
    _commentsArray = @[].mutableCopy;
  }
  return _commentsArray;
}

- (XYAPIBatchAPIRequests *)batchReq {
  if (!_batchReq) {
    _batchReq = [[XYAPIBatchAPIRequests alloc] init];
    _batchReq.delegate = self;
  }
  return _batchReq;
}

- (void)batchAPIRequestsDidFinished:(nonnull XYAPIBatchAPIRequests *)batchApis {
  [batchApis.apiRequestsSet removeAllObjects];
  if (self.requestAllComBlock) {
    self.requestAllComBlock();
  }
}

@end
