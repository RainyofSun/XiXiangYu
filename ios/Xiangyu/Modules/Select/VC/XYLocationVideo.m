//
//  XYLocationVideo.m
//  Xiangyu
//
//  Created by Kang on 2021/6/22.
//

#import "XYLocationVideo.h"
#import "NSBundle+Extension.h"
#import "XYFMDB.h"

@implementation XYLocationVideoItem
+(void)saveLocationVideoWithUrl:(NSURL *)url image:(UIImage *)image text:(NSString *)text block:(nonnull void (^)(XYLocationVideoItem * _Nonnull))block{
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  XYLocationVideoItem *item = [[XYLocationVideoItem alloc]init];
  item.mobile = user.mobile;
  item.text = text;
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
 
  NSData *data = UIImagePNGRepresentation(image);

  NSString *videoName = [NSString stringWithFormat:@"short_video_%f.mp4", [NSDate date].timeIntervalSince1970];
  NSString *imageName = [NSString stringWithFormat:@"short_image_%f.png", [NSDate date].timeIntervalSince1970];
  NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:videoName];
  NSData *videoData = [NSData dataWithContentsOfURL:url];
  [videoData writeToFile:videoPath atomically:YES];
  
  NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:imageName];
  [data writeToFile:imagePath atomically:YES];
  item.logo = imagePath;
  item.video = videoPath;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if (block) {
        block(item);
      }
    });
    
  });
  
}
-(void)deleteLocationFile{
  NSFileManager*fileManager = [NSFileManager defaultManager];
  if([fileManager removeItemAtPath:self.logo error:nil])
  {
      NSLog(@"删除");
  }
  if([fileManager removeItemAtPath:self.video error:nil])
  {
      NSLog(@"删除");
  }
}
@end

static NSString *const VideoTableName = @"t_locationvideo";
@interface XYLocationVideo ()

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,assign) BOOL cResult;
@end
@implementation XYLocationVideo
static XYLocationVideo *service = nil;
+ (instancetype)sharedService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[XYLocationVideo alloc] init];
    });
    return service;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadingDataBase];
    }
    return self;
}
- (void)loadingDataBase {
    self.cResult = [[XYFMDB sharedDatabase] createTable:VideoTableName
                                                 object:@{
                                                         // @"userId":SqlInteger,
                                                          @"text":SqlText,
                                                          @"logo":SqlText,
                                                          @"video":SqlText,
                                                          @"mobile":SqlText,
                                                          }
                                          uniqueColumns:@"video"];
    
}
- (void)cleanVideoDataWithVideo:(NSString *)video block:(void(^)(BOOL ret))block {
  __block BOOL iResult;
  
  __block NSArray *data = nil;
  [[XYFMDB sharedDatabase] inDatabase:^{
    data = [[XYFMDB sharedDatabase] queryTable:VideoTableName object:[XYLocationVideoItem class] condition:[NSString stringWithFormat:@"where video = '%@'",video]];
  }];
  if (data && data.count) {
    XYLocationVideoItem *item = data.firstObject;
    [item deleteLocationFile];
  }
 
  
  [[XYFMDB sharedDatabase] inDatabase:^{
    iResult = [[XYFMDB sharedDatabase] deleteTable:VideoTableName whereFormat:[NSString stringWithFormat:@"where video = '%@'",video]];
  }];
  if (block) block(iResult);
}
-(BOOL)queryLocationVideoItemWithVideo:(NSString *)video{
  if (self.cResult) {
    __block NSArray *data = nil;
    [[XYFMDB sharedDatabase] inDatabase:^{
      data = [[XYFMDB sharedDatabase] queryTable:VideoTableName object:[XYLocationVideoItem class] condition:[NSString stringWithFormat:@"where video = '%@'",video]];
    }];
      return data.count;
  } else {
      return NO;
  }
}


//根据areaLevel 查询
- (NSArray *)queryLocationVideo {
    if (self.cResult) {
      __block NSArray *data = nil;
      __block XYUserInfo *user = [[XYUserService service] fetchLoginUser];
      [[XYFMDB sharedDatabase] inDatabase:^{
        data = [[XYFMDB sharedDatabase] queryTable:VideoTableName object:[XYLocationVideoItem class] condition:[NSString stringWithFormat:@"where mobile = '%@'",user.mobile]];
      }];
        return data;
    } else {
        return nil;
    }
}
-(void)insetVideoDataWithItem:(XYLocationVideoItem *)item block:(void (^)(BOOL))block{
  __block BOOL iResult;
  [[XYFMDB sharedDatabase] inDatabase:^{
    iResult = [[XYFMDB sharedDatabase] insertTable:VideoTableName object:item distinct:NO];
  }];
  if (block) block(iResult);
}
@end
