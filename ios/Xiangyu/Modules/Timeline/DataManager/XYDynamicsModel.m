//
//  XYDynamicsModel.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYDynamicsModel.h"

@implementation XYDynamicsModel

- (NSString *)content {
    if (_content == nil) {
      _content = @"";
    }
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:_content];
    text.yy_font = [UIFont systemFontOfSize:14];
    
    YYTextContainer * container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth - 15 - 45 - 10 - 15, CGFLOAT_MAX)];
    
    YYTextLayout * layout = [YYTextLayout layoutWithContainer:container text:text];
    
    if (layout.rowCount <= 6) {
        _shouldShowMoreButton = NO;
    } else {
        _shouldShowMoreButton = YES;
    }
    
  return _content;
}

- (NSString *)location {
  return [NSString stringWithFormat:@"%@%@",_dwellProvince, _dwellCity];
}

- (NSString *)homeTown {
  return [NSString stringWithFormat:@"%@%@",_province, _city];
}

@end

@implementation XYLikesUserModel
-(NSString *)addressDec{
  if (!_addressDec) {
    
    NSString *cityN =[[XYAddressService sharedService] queryAreaNameWithAdcode:self.city];
    
    NSString *areaN =[[XYAddressService sharedService] queryAreaNameWithAdcode:self.area];
    
    _addressDec = [NSString stringWithFormat:@"%@%@",cityN,areaN];
  }
  return _addressDec;
}
@end
@implementation XYLikesUserListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"list" : [XYLikesUserModel class] ,
              @"page" : [XYPageModel class]
    };
}
@end
@implementation XYCommentModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             
             @"commentBody":@[@"commentBody",@"content"],
             @"commentDate":@[@"commentDate",@"createTime"],
             };
}
@end
