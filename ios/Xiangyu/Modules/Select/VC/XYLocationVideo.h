//
//  XYLocationVideo.h
//  Xiangyu
//
//  Created by Kang on 2021/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface XYLocationVideoItem : NSObject
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *video;
@property (nonatomic,copy) NSString *text;

+(void)saveLocationVideoWithUrl:(NSURL *)url image:(UIImage *)image text:(NSString *)text block:(void(^)(XYLocationVideoItem *item))block;
-(void)deleteLocationFile;
@end
@interface XYLocationVideo : NSObject
+ (instancetype)sharedService ;
- (NSArray *)queryLocationVideo;
- (void)cleanVideoDataWithVideo:(NSString *)video block:(void(^)(BOOL ret))block;

-(void)insetVideoDataWithItem:(XYLocationVideoItem *)item block:(void(^)(BOOL ret))block;
-(BOOL)queryLocationVideoItemWithVideo:(NSString *)video;
@end

NS_ASSUME_NONNULL_END
