//
//  XYReleaseDynamicDataManager.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/14.
//

#import "XYReleaseDynamicDataManager.h"
#import "XYBaseAPI.h"
#import "TZImageManager.h"
#import "XYImageUploadManager.h"

@interface XYReleaseDynamicAPI : XYBaseAPI

@end

@implementation XYReleaseDynamicAPI
{
  NSNumber *userId_;
  NSNumber *type_;
  NSString *coverUrl_;
  NSString *content_;
  NSString *resources_;
  NSNumber *subjectId_;
  NSString *subjectText_;
}

- (instancetype)initWithUserId:(NSNumber *)userId
                          type:(NSNumber *)type
                      coverUrl:(NSString *)coverUrl
                       content:(NSString *)content
                     resources:(NSString *)resources
                     subjectId:(NSNumber *)subjectId
                   subjectText:(NSString *)subjectText
{
    if (self = [super init]) {
      userId_ = userId;
      type_ = type;
      coverUrl_ = coverUrl;
      content_ = content;
      resources_ = resources;
      subjectId_ = subjectId;
      subjectText_ = subjectText;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/Dynamic/Release";
}

- (id)requestParameters {
    return @{
            @"userId": userId_ ?: @(0),
            @"type": type_ ?: @(0),
            @"coverUrl": coverUrl_ ?: @"",
            @"content": content_ ?: @"",
            @"resources": resources_ ?: @"",
            @"subjectId": subjectId_ ?: @(0),
            @"subjectText": subjectText_ ?: @"",
            };
}
@end


@interface XYReleaseDynamicDataManager ()

@property (nonatomic,strong) NSMutableArray *uploadPicUrls;

@end

@implementation XYReleaseDynamicDataManager

- (void)releaseDynamicWithType:(NSNumber *)type
                      coverUrl:(NSString *)coverUrl
                       content:(NSString *)content
                     resources:(NSString *)resources
                     subjectId:(NSNumber *)subjectId
                   subjectText:(NSString *)subjectText
                         block:(void(^)(XYError *error))block {
  XYReleaseDynamicAPI *api = [[XYReleaseDynamicAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId type:type coverUrl:coverUrl content:content resources:resources subjectId:subjectId subjectText:subjectText];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (block) block(error);
  };
  [api start];
}

- (void)releaseDynamicWithBlock:(void(^)(XYError *error))block {
  switch (self.type) {
    case 1:
    {
      [self releaseDynamicWithType:@(self.type) coverUrl:@"" content:self.content resources:nil subjectId:self.subjectId subjectText:self.subjectText block:block];
    }
      break;
    case 2:
    {
      [self.uploadPicUrls removeAllObjects];
      [self uploadImagesBlock:^(BOOL success) {
        if (success) {
          [self releaseDynamicWithType:@(self.type) coverUrl:@"" content:self.content resources:[self.uploadPicUrls componentsJoinedByString:@"|"] subjectId:self.subjectId subjectText:self.subjectText block:block];
        } else {
          block([XYError clientErrorWithCode:@"-12000" msg:@"图片上传失败~"]);
        }
      }];
    }
      break;
    case 3:
    {
      [[XYImageUploadManager uploadManager] uploadObject:self.selectedPhotos.firstObject block:^(BOOL success, NSString *coverUrl) {
        if (success) {
          [[TZImageManager manager] getVideoOutputPathWithAsset:self.selectedAssets.firstObject presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
            [[XYImageUploadManager uploadManager] uploadObject:outputPath block:^(BOOL success, NSString *url) {
              if (success) {
                [self releaseDynamicWithType:@(self.type) coverUrl:coverUrl content:self.content resources:url subjectId:self.subjectId subjectText:self.subjectText block:block];
              } else {
                block([XYError clientErrorWithCode:@"-12000" msg:@"视频上传失败~"]);
              }
            }];
          } failure:^(NSString *errorMessage, NSError *error) {
            if (block) {
              block([XYError clientErrorWithCode:@"-12000" msg:@"视频上传失败~"]);
            }
          }];
        } else {
          block([XYError clientErrorWithCode:@"-12000" msg:@"视频上传失败~"]);
        }
      }];
    }
      break;
    default:
      break;
  }
}

-(void)uploadImagesBlock:(void(^)(BOOL success))block {
  
  dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
  dispatch_group_t group = dispatch_group_create();
      
  dispatch_async(queue, ^{
      
        for (UIImage *image in self.selectedPhotos) {
          dispatch_group_enter(group);
          [[XYImageUploadManager uploadManager] uploadObject:image block:^(BOOL success, NSString *url) {
            if (success) {
              [self.uploadPicUrls addObject:url];
            }
            dispatch_group_leave(group);
          }];
          
          dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        }
      
      dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
          dispatch_group_notify(group, queue, ^{
            dispatch_async_on_main_queue(^{
              if (block) block(self.uploadPicUrls.count == self.selectedPhotos.count);
            });
          });
    });
}

- (NSMutableArray *)selectedPhotos {
  if (!_selectedPhotos) {
    _selectedPhotos = @[].mutableCopy;
  }
  return _selectedPhotos;
}

- (NSMutableArray *)selectedAssets {
  if (!_selectedAssets) {
    _selectedAssets = @[].mutableCopy;
  }
  return _selectedAssets;
}

- (NSMutableArray *)uploadPicUrls {
  if (!_uploadPicUrls) {
    _uploadPicUrls = @[].mutableCopy;
  }
  return _uploadPicUrls;
}
@end
