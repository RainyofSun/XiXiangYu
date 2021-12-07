//
//  XYImageUploadManager.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/25.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYImageUploadManager.h"
#import <QiniuSDK.h>
#import "UIImage+Compress.h"
#import "XYImageTokenAPI.h"
#import "NSUUID+Extension.h"
#import "XYAppVersion.h"
#import "XYUserService.h"

static XYImageUploadManager *instance = nil;

@interface XYImageUploadManager ()

@property (nonatomic,strong) QNUploadManager * uploadManager;

@end

@implementation XYImageUploadManager

+ (instancetype)uploadManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XYImageUploadManager alloc] init];
    });
    return instance;
}

- (void)uploadObject:(id)object
               block:(void(^)(BOOL success, NSString *url))block {
    
  [self _fetchTokenWithKey:nil block:^(NSString *token) {
        if (!token.isNotBlank) {
            if (block) block(NO, nil);
            return;
        }
        QNUploadOption *uploadOption = [[QNUploadOption alloc]
                                        initWithMime:nil
                                        progressHandler:^(NSString *key, float percent) {
                                        }
                                        params:nil
                                        checkCrc:YES
                                        cancellationSignal:nil];
        
        if ([object isKindOfClass:[NSString class]]) {
            [self.uploadManager putFile:object
                                    key:nil
                                  token:token
                               complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                   if(info.ok) {
                                     NSString *url = [NSString stringWithFormat:@"http://img.xixiangyuapp.com/%@", resp[@"key"]];
                                     DLog(@"上传成功-图片的URL：%@", url);
                                     if (block) block(YES, url);
                                   } else {
                                       DLog(@"失败");
                                     if (block) block(NO, nil);
                                   }
                               }
                                 option:uploadOption];
        }
        else if ([object isKindOfClass:[NSData class]]) {
            [self.uploadManager putData:object
                                    key:nil
                                  token:token
                               complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                  if(info.ok) {
                                    NSString *url = [NSString stringWithFormat:@"http://img.xixiangyuapp.com/%@", resp[@"key"]];
                                    DLog(@"上传成功-图片的URL：%@", url);
                                    if (block) block(YES, url);
                                  } else {
                                      DLog(@"失败");
                                    if (block) block(NO, nil);
                                  }
                                   DLog(@"info ===== %@", info);
                                   DLog(@"resp ===== %@", resp);
                               }
                                 option:uploadOption];
        }
        else if ([object isKindOfClass:[UIImage class]]) {
          NSData *imageData = [(UIImage *)object compressImage];
          [self.uploadManager putData:imageData
                                  key:nil
                                token:token
                             complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                if(info.ok) {
                                  NSString *url = [NSString stringWithFormat:@"http://img.xixiangyuapp.com/%@", resp[@"key"]];
                                  DLog(@"上传成功-图片的URL：%@", url);
                                  if (block) block(YES, url);
                                } else {
                                    DLog(@"上传失败");
                                  if (block) block(NO, nil);
                                }
                             }
                               option:uploadOption];
        }
        
    }];
}

- (void)_fetchTokenWithKey:(NSString *)key block:(void(^)(NSString *token))block {
    XYImageTokenAPI *api = [[XYImageTokenAPI alloc] initWithKey:key];
    api.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
        if (error) {
         if (block) block(nil);
        } else {
            if (block) block(data[@"data"]);
        }
    };
    [api start];
}

- (NSDictionary *)setupUploadParamsWithId:(NSString *)relatedId type:(NSString *)type {
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setValue:[NSUUID keychainUUID]?:@"" forKey:@"x:device_id"];
    
    [params setValue:@"iOS" forKey:@"x:req_source"];
    
    [params setValue:[XYAppVersion currentVersion]?:@"" forKey:@"x:app_version"];
    
    [params setValue:[@([UIDevice systemVersion]) stringValue]?:@"" forKey:@"x:os_version"];
    
    [params setValue:[UIDevice currentDevice].machineModelName?:@"" forKey:@"x:machine"];
    
    [params setValue:XY_CHANNLE forKey:@"x:channel"];
    
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];
    if (user) {
        [params setValue:user.token ?: @"" forKey:@"x:token"];
        
        [params setValue:user.mobile ?: @"" forKey:@"x:mobile"];
    }
    
    [params setValue:relatedId?:@"" forKey:@"x:related_id"];
    
    [params setValue:type?:@"" forKey:@"x:pic_type"];

    return params.copy;

}

#pragma mark - getter
- (QNUploadManager *)uploadManager {
    if (!_uploadManager) {
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.useHttps = NO;
            builder.zone = [QNFixedZone zone0];
        }];
        _uploadManager = [[QNUploadManager alloc] initWithConfiguration:config];
    }
    return _uploadManager;
}
@end
