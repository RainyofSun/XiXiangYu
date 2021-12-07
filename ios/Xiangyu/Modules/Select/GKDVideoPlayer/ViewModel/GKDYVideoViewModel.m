//
//  GKDYVideoViewModel.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoViewModel.h"
#import "GKNetworking.h"
#import "XYGeneralAPI.h"
#import "GKBallLoadingView.h"
#import "XYLocationService.h"

@interface GKDYVideoViewModel()

// 页码
@property (nonatomic, assign) NSInteger pn;
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation GKDYVideoViewModel

- (void)refresh:(NSString *)typeStr newListWithSuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
  self.pn = 1;
  self.typeStr = typeStr;
  
  NSString *method = @"api/v1/ShortVideo/GetVideoList";
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  XYShowLoading;
  [[XYLocationService sharedService] requestCachedLocationWithBlock:^(XYFormattedArea *model) {
    NSDictionary *params = @{
       @"userId": user.userId,
       @"queryType": @([typeStr integerValue]),
       @"dwellProvince": model.provinceCode?:@"",
       @"dwellCity": model.cityCode?:@"",
       @"page": @{
           @"pageIndex": @1,
           @"pageSize": @10,
       },
    };
    XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
      api.apiRequestMethodType = XYRequestMethodTypePOST;
    
    api.requestParameters = params ?: @{};
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      XYHiddenLoading;
      if (!error) {
        NSArray *dataArr =data[@"list"];
        NSMutableArray *dataEArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArr.count; i++) {
          [dataEArr addObject:@{
            @"post_id": dataArr[i][@"id"]?:@"",
            @"video_url": dataArr[i][@"videoUrl"]?:@"",
            @"thumbnail_url": dataArr[i][@"coverUrl"]?:@"",
            @"first_frame_cover":  dataArr[i][@"coverUrl"]?:@"",
            @"title": dataArr[i][@"content"]?:@"",
            @"share_num": dataArr[i][@"forward"]?:@"",
            @"comment_num": dataArr[i][@"discuss"]?:@"",
            @"agree_num": dataArr[i][@"fabulous"]?:@"",
            @"gif_cover": dataArr[i][@"coverUrl"]?:@"",
            @"remark": dataArr[i][@"remark"]?:@"",
            @"isAgree": dataArr[i][@"isLike"]?:@"",
            @"isExt": dataArr[i][@"isExt"]?:@"",
            @"extUrl": dataArr[i][@"extUrl"]?:@"",
            @"userId": dataArr[i][@"userId"]?:@(0),
            @"isFollow": dataArr[i][@"isFollow"]?:@(0),
            @"author": @{
                @"user_id":dataArr[i][@"userId"]?:@"",
                        @"user_name": dataArr[i][@"userId"]?:@"",
                        @"portrait": dataArr[i][@"headPortrait"]?:@"",
                    }
          }];
        }
          
          NSMutableArray *array = [NSMutableArray new];
          for (NSDictionary *dict in dataEArr) {
              GKDYVideoModel *model = [GKDYVideoModel yy_modelWithDictionary:dict];
              [array addObject:model];
          }
          
          !success ? : success(array);
        
      } else {
        
      }
    };

    [api start];
  }];
}

- (void)refreshMoreListWithSuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    self.pn ++;
  
  NSString *method = @"api/v1/ShortVideo/GetVideoList";
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  XYShowLoading;
  [[XYLocationService sharedService] requestCachedLocationWithBlock:^(XYFormattedArea *model) {
    NSDictionary *params = @{
      @"userId": user.userId,
      @"queryType": @([self.typeStr integerValue]),
      @"dwellProvince": model.provinceCode?:@"",
      @"dwellCity": model.cityCode?:@"",
      @"page": @{
          @"pageIndex": @(self.pn),
          @"pageSize": @10,
      },
   };

    XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
      api.apiRequestMethodType = XYRequestMethodTypePOST;
    api.requestParameters = params ?: @{};
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      XYHiddenLoading;
      if (!error) {
        
        NSArray *dataArr =data[@"videos"];
        if (!dataArr) {
          dataArr =data[@"list"];
        }
        NSMutableArray *dataEArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArr.count; i++) {
          [dataEArr addObject:@{
            @"thread_id": @"5905925287",
            @"isExt": dataArr[i][@"isExt"]?:@"",
            @"post_id": dataArr[i][@"id"]?:@"",
            @"video_url": dataArr[i][@"videoUrl"]?:@"",
            @"thumbnail_url": dataArr[i][@"coverUrl"]?:@"",
            @"first_frame_cover":  dataArr[i][@"coverUrl"]?:@"",
            @"title": dataArr[i][@"content"]?:@"",
            @"remark": dataArr[i][@"remark"]?:@"",
            @"share_num": dataArr[i][@"forward"]?:@"",
            @"comment_num": dataArr[i][@"discuss"]?:@"",
            @"agree_num": dataArr[i][@"fabulous"]?:@"",
            @"gif_cover": dataArr[i][@"coverUrl"]?:@"",
            @"isAgree": dataArr[i][@"isLike"]?:@"",
            @"extUrl": dataArr[i][@"extUrl"]?:@"",
            @"userId": dataArr[i][@"userId"]?:@(0),
            @"isFollow": dataArr[i][@"isFollow"]?:@(0),
            @"author": @{
                @"user_id":dataArr[i][@"userId"]?:@"",
                        @"user_name": dataArr[i][@"nickName"]?:@"",
                        @"portrait": dataArr[i][@"headPortrait"]?:@"",
                    }
          }];
        }
        
          NSMutableArray *array = [NSMutableArray new];
          for (NSDictionary *dict in dataEArr) {
              GKDYVideoModel *model = [GKDYVideoModel yy_modelWithDictionary:dict];
              [array addObject:model];
          }
          
          !success ? : success(array);
        
      } else {

      }
    };
    [api start];
  }];
}

@end
