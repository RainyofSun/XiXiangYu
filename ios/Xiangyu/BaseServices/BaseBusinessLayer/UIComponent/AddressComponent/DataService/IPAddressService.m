//
//  IPAddressService.m
//  Takeaway
//
//  Created by Kang on 2021/6/11.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "IPAddressService.h"


#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static IPAddressService * _instance;

@implementation IPAddressService
+(instancetype)service{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _instance = [[IPAddressService alloc] init];
        [_instance getGlobleIPAddress];
    });
    return _instance;
}
-(NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

-(NSString *)getIPaddress
{
//    NSString *address = @"0.0.0.0";
//    struct ifaddrs * ifaddress = NULL;
//    struct ifaddrs * temp_address = NULL;
//    int success = 0;
//    success = getifaddrs(&ifaddress);
//    if(success == 0) {
//        temp_address = ifaddress;
//        while(temp_address != NULL) {
//            if(temp_address->ifa_addr->sa_family == AF_INET) {
//                if([[NSString stringWithUTF8String:temp_address->ifa_name] isEqualToString:@"en0"]) {
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_address->ifa_addr)->sin_addr)];
//                }
//            }
//            temp_address = temp_address->ifa_next;
//        }
//        
//    }
    
   
    return @""; //[self getGlobleIPAddress];;
}

-(void)getGlobleIPAddress{
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
  
    
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"https://www.taobao.com/help/getip.php"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];

    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"ipCallback("]) {
    //对字符串进行处理，然后进行json解析
    //删除字符串多余字符串
       // NSRange range = NSMakeRange(0, 19);
       // [ip deleteCharactersInRange:range];
    NSString * nowIp=[ip stringByReplacingOccurrencesOfString:@"ipCallback(" withString:@""];
      nowIp=[nowIp stringByReplacingOccurrencesOfString:@"ip:" withString:@"\"ip\":"];
        nowIp=[nowIp substringToIndex:nowIp.length-1];

    //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding]; NSDictionary * dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSLog(@"%@",dict);

    self.ipAddress = dict[@"ip"] ? dict[@"ip"] : @"";
        
        if (self.block) {
            self.block(self.ipAddress);
        }
    }
        
    });

    
}


@end
