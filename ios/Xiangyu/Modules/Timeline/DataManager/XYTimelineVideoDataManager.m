//
//  XYTimelineVideoDataManager.m
//  Xiangyu
//
//  Created by dimon on 09/02/2021.
//

#import "XYTimelineVideoDataManager.h"
#import "XYTimelineVideoAPI.h"
#import "XYLikesVideoAPI.h"
#import "XYDeleteVideoAPI.h"

@interface XYTimelineVideoDataManager ()

@property (nonatomic,assign) NSUInteger page;

@end

@implementation XYTimelineVideoDataManager

- (void)fetchNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page = 1;
  NSNumber *isMine = @(0);
  if ([[XYUserService service] fetchLoginUser].userId.integerValue == self.userID.integerValue) {
    isMine = @(1);
  } else {
    isMine = @(0);
  }
  XYTimelineVideoAPI *api = [[XYTimelineVideoAPI alloc] initWithUserId:self.userID isMyQuery:isMine page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      [self.videos removeAllObjects];
      NSArray *arr = data[@"videos"];
      
      if (arr.count > 0) {
        [self.videos addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYTimelineVideoModel class] json:arr]];
      } else {
        self.page --;
      }
      if (block) block(YES, nil);
    }
  };
  [api start];

}

- (void)fetchNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page ++;
  NSNumber *isMine = @(NO);
  if ([[XYUserService service] fetchLoginUser].userId.integerValue == self.userID.integerValue) {
    isMine = @(YES);
  } else {
    isMine = @(NO);
  }
  XYTimelineVideoAPI *api = [[XYTimelineVideoAPI alloc] initWithUserId:self.userID isMyQuery:isMine page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      NSArray *arr = data[@"videos"];
      if (arr.count > 0) {
        [self.videos addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYTimelineVideoModel class] json:arr]];
        if (block) block(YES, nil);
      } else {
        self.page --;
        if (block) block(NO, nil);
      }
    }
  };
  [api start];

}


- (void)fetchLikesNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page = 1;
  NSNumber *isMine = @(0);
  if ([[XYUserService service] fetchLoginUser].userId.integerValue == self.userID.integerValue) {
    isMine = @(1);
  } else {
    isMine = @(0);
  }
  XYLikesVideoAPI *api = [[XYLikesVideoAPI alloc] initWithUserId:self.userID isMyQuery:isMine page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      [self.likesVideos removeAllObjects];
      NSArray *arr = data[@"videos"];
      
      if (arr.count > 0) {
        [self.likesVideos addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYTimelineVideoModel class] json:arr]];
      } else {
        self.page --;
      }
      if (block) block(YES, nil);
    }
  };
  [api start];

}

- (void)fetchLikesNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page ++;
  NSNumber *isMine = @(NO);
  if ([[XYUserService service] fetchLoginUser].userId.integerValue == self.userID.integerValue) {
    isMine = @(YES);
  } else {
    isMine = @(NO);
  }
  XYLikesVideoAPI *api = [[XYLikesVideoAPI alloc] initWithUserId:self.userID isMyQuery:isMine page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      NSArray *arr = data[@"videos"];
      if (arr.count > 0) {
        [self.likesVideos addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYTimelineVideoModel class] json:arr]];
        if (block) block(YES, nil);
      } else {
        self.page --;
        if (block) block(NO, nil);
      }
    }
  };
  [api start];

}

- (void)deleteVideoWithIndex:(NSUInteger)index block:(void(^)(XYError * error))block {
  if (index >= self.videos.count) {
    if (block) block(ClientExceptionUndefined());
    return;
  }
  if (self.videos[index].userId.integerValue != [[XYUserService service] fetchLoginUser].userId.integerValue) {
    if (block) block(ClientExceptionUndefined());
    return;
  }
  XYDeleteVideoAPI *api = [[XYDeleteVideoAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId videoId:self.videos[index].id];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      if (block) block(error);
    } else {
      [self.videos removeObjectAtIndex:index];
      if (block) block(nil);
    }
  };
  [api start];

}

- (GKDYVideoModel *)createVideoDataWithIndex:(NSUInteger)index {
  XYTimelineVideoModel *model = self.videos[index];
    NSDictionary *dict = @{
      @"post_id": model.id,
      @"video_url": model.videoUrl,
      @"thumbnail_url": model.coverUrl,
      @"first_frame_cover":  model.coverUrl,
      @"title": model.content,
      @"share_num": model.forward,
      @"comment_num": model.discuss,
      @"agree_num": model.fabulous,
      @"gif_cover": model.coverUrl,
      @"isAgree": model.isLike,
      @"author": @{
                  @"user_name": model.userId,
                  @"portrait": model.authorPortrait,
              }
    };
  return [GKDYVideoModel yy_modelWithDictionary:dict];
}

- (GKDYVideoModel *)createLikesVideoDataWithIndex:(NSUInteger)index {
  XYTimelineVideoModel *model = self.likesVideos[index];
    NSDictionary *dict = @{
      @"post_id": model.id,
      @"video_url": model.videoUrl,
      @"thumbnail_url": model.coverUrl,
      @"first_frame_cover":  model.coverUrl,
      @"title": model.content,
      @"share_num": model.forward,
      @"comment_num": model.discuss,
      @"agree_num": model.fabulous,
      @"gif_cover": model.coverUrl,
      @"isAgree": @(1),
      @"author": @{
                  @"user_name": model.userId,
                  @"portrait": model.authorPortrait,
              }
    };
  return [GKDYVideoModel yy_modelWithDictionary:dict];
}

- (NSMutableArray<XYTimelineVideoModel *> *)videos {
    if (!_videos) {
      _videos = [NSMutableArray array];
    }
    return _videos;
}

- (NSMutableArray<XYTimelineVideoModel *> *)likesVideos {
    if (!_likesVideos) {
      _likesVideos = [NSMutableArray array];
    }
    return _likesVideos;
}

@end
