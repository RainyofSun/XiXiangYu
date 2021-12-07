//
//  XYLocationService.h
//  Xiangyu
//
//  Created by dimon on 22/01/2021.
//

#import <Foundation/Foundation.h>
#import "XYAddressItem.h"


typedef void(^XYLocationServiceBlock)(XYFormattedArea *models);

@interface XYLocationService : NSObject

+ (XYLocationService *)sharedService;

- (void)start;

- (void)requestLocationWithBlock:(void(^)(XYFormattedArea *model))block;

- (void)requestCachedLocationWithBlock:(void(^)(XYFormattedArea *model))block;

- (void)changeLocationWithArea:(XYFormattedArea *)area;

@end

