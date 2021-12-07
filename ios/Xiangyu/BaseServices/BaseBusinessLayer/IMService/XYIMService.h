//
//  XYIMService.h
//  Xiangyu
//
//  Created by dimon on 27/01/2021.
//

#import <Foundation/Foundation.h>

@interface XYIMService : NSObject

+ (instancetype)shareService;

- (void)setupIMService;

- (void)loginIMWithIdentifier:(NSString *)identifier
                         sign:(NSString *)sign
                        block:(void(^)(BOOL ret))block;
@end
