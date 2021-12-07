//
//  IPAddressService.h
//  Takeaway
//
//  Created by Kang on 2021/6/11.
//

#import <Foundation/Foundation.h>
typedef void(^IPAddressServiceBlock)(NSString *ipString);
NS_ASSUME_NONNULL_BEGIN

@interface IPAddressService : NSObject
+(instancetype)service;
@property(nonatomic,strong)NSString *ipAddress;
@property(nonatomic,strong)IPAddressServiceBlock block;
-(NSString *)getIPAddress:(BOOL)preferIPv4;
-(NSString *)getIPaddress;
@end

NS_ASSUME_NONNULL_END
