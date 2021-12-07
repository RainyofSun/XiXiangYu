//
//  XYSearchVideoDataManager.m
//  Xiangyu
//
//  Created by dimon on 17/03/2021.
//

#import "XYSearchVideoDataManager.h"
#import "XYSearchVideoAPI.h"

@interface XYSearchVideoDataManager ()

@property (nonatomic,assign) NSUInteger page;

@end

@implementation XYSearchVideoDataManager

- (void)fetchProductNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page = 1;
  XYSearchProductVideoAPI *api = [[XYSearchProductVideoAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId keyword:self.words page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      [self.videos removeAllObjects];
      NSArray *arr = data[@"list"];
      
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

- (void)fetchProductNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page ++;
  
  XYSearchProductVideoAPI *api = [[XYSearchProductVideoAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId keyword:self.words page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      NSArray *arr = data[@"list"];
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

- (void)fetchAuthorNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page = 1;
  XYSearchAuthorVideoAPI *api = [[XYSearchAuthorVideoAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId keyword:self.words page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      [self.authors removeAllObjects];
      NSArray *arr = data[@"list"];
      
      if (arr.count > 0) {
        [self.authors addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYFriendItem class] json:arr]];
      } else {
        self.page --;
      }
      if (block) block(YES, nil);
    }
  };
  [api start];

}

- (void)fetchAuthorNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block {
  self.page ++;
  
  XYSearchAuthorVideoAPI *api = [[XYSearchAuthorVideoAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId keyword:self.words page:self.page];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      self.page --;
      if (block) block(NO, error);
    } else {
      NSArray *arr = data[@"list"];
      if (arr.count > 0) {
        [self.authors addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYFriendItem class] json:arr]];
        if (block) block(YES, nil);
      } else {
        self.page --;
        if (block) block(NO, nil);
      }
    }
  };
  [api start];

}

- (GKDYVideoModel *)createPlayDataWithIndex:(NSUInteger)index {
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
          @"user_name": model.userId ?: @"",
          @"portrait": model.authorPortrait ?: @"",
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

- (NSMutableArray<XYFriendItem *> *)authors {
    if (!_authors) {
      _authors = [NSMutableArray array];
    }
    return _authors;
}
@end
