//
//  XYBlindDataManager.m
//  Xiangyu
//
//  Created by dimon on 09/02/2021.
//

#import "XYBlindDataManager.h"
#import "XYBlindInfoAPI.h"
#import "XYFollowAPI.h"
#import "XYBlindGetGiftListAPI.h"
#import "XYBlindInfoTapView.h"
@import ImSDK;

@interface XYBlindDataManager ()

@end

@implementation XYBlindDataManager

- (void)fetchUserInfoWithBlock:(void(^)(XYError * error))block {

  XYBlindInfoAPI *api = [[XYBlindInfoAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId blindId:self.blindId];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (!error) {
      NSDictionary *detail = data[@"detail"];
      self.model = [XYBlindProfileModel yy_modelWithDictionary:detail];
      self.claimModel = [XYClaimInfoModel yy_modelWithJSON:[data objectForKey:@"claim"]];
      self.model.isFriend = data[@"isFriend"];
      self.model.follow = data[@"follow"];
      self.model.isFollow = data[@"isFollow"];
      self.model.claimStr = data[@"claimStr"];
      self.model.remarkHeight = [self _calculateHeightWithString:self.model.claimStr];
      [self _formattInfo];
      [self _formattIntroduction];
      [self creatLikesAttrString];
      [self fetchGiftListWithBlock:block];
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (void)fetchGiftListWithBlock:(void(^)(XYError * error))block {

  XYBlindGetGiftListAPI *api = [[XYBlindGetGiftListAPI alloc] initWithUserId:self.userId];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (!error) {
      NSArray *list = data[@"list"];
      self.giftList = [NSArray yy_modelArrayWithClass:[XYBlindGiftModel class] json:list];
      if (block) block(nil);
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (void)followUserWithBlock:(void(^)(XYError * error))block {
  
  XYFollowAPI *api = [[XYFollowAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId destUserId:self.userId operation:self.model.isFollow.integerValue == 1 ? @(2) : @(1) source:@(1) dyId:self.model.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      BOOL isFollow = self.model.isFollow.integerValue == 1;
      self.model.isFollow = isFollow ? @(0) : @(1);
      if (block) block(nil);
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (CGFloat)_calculateHeightWithString:(NSString *)string {
  
  XYBlindInfoTapView *view = [[XYBlindInfoTapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize(60))];
  view.dataSource = self.model.itemData;
  
  
  return view.height;
//  UILabel *temp = [[UILabel alloc] init];
//  temp.font = AdaptedFont(14);
//  temp.numberOfLines = 0;
//  temp.text = string;
//  return [temp sizeThatFits:CGSizeMake(kScreenWidth-32, CGFLOAT_MAX)].height;
}

- (void)_formattInfo {
  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
  
  NSAttributedString *att_marr = [self creatSingleItemInfoWithTitle:[NSString stringWithFormat:@"家乡 %@    现居 %@",self.claimModel.address,self.claimModel.dwelladdress] text:@""];
  [all_attr appendAttributedString:att_marr];
  
  if (self.claimModel.startAge && [self.claimModel.startAge integerValue]>0) {
    NSAttributedString *att_s = [self creatSingleItemInfoWithTitle:@" " text:[NSString stringWithFormat:@"%@~%@岁", self.claimModel.startAge,self.claimModel.endAge]];
    UIImage *image = [UIImage imageNamed:@"icon_24_nianling"];
    NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(15) alignment:YYTextVerticalAlignmentCenter];
    
    [all_attr appendAttributedString:image_attr];
    [all_attr appendAttributedString:att_s];
  }
  
  if (self.claimModel.startHeight && [self.claimModel.startHeight integerValue]>0) {
    
    UIImage *image = [UIImage imageNamed:@"icon_24_shengao"];
    NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(15) alignment:YYTextVerticalAlignmentCenter];
    
    [all_attr appendAttributedString:image_attr];
    
    NSAttributedString *att_s = [self creatSingleItemInfoWithTitle:@" " text:[NSString stringWithFormat:@"%@~%@cm", self.claimModel.startHeight,self.claimModel.endHeight]];
    [all_attr appendAttributedString:att_s];
  }
  
  if (self.claimModel.twoIndustry) {
    
    UIImage *image = [UIImage imageNamed:@"icon_24_shouru"];
    NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(15) alignment:YYTextVerticalAlignmentCenter];
    
    [all_attr appendAttributedString:image_attr];
    
    NSAttributedString *att_s = [self creatSingleItemInfoWithTitle:@" " text:[NSString stringWithFormat:@"%@", self.claimModel.twoIndustry]];
    [all_attr appendAttributedString:att_s];
  }
  
  if (self.claimModel.educationName && self.claimModel.educationName.isNotBlank) {
    UIImage *image = [UIImage imageNamed:@"icon_24_xueli"];
    NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(15) alignment:YYTextVerticalAlignmentCenter];
    
    [all_attr appendAttributedString:image_attr];
    
    NSAttributedString *att_s = [self creatSingleItemInfoWithTitle:@" " text:[NSString stringWithFormat:@"%@", self.claimModel.educationName]];
    [all_attr appendAttributedString:att_s];
  }
  
  if (self.claimModel.salaryStart && [self.claimModel.salaryStart doubleValue]>0) {
    UIImage *image = [UIImage imageNamed:@"icon_24_zhiye"];
    NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(15) alignment:YYTextVerticalAlignmentCenter];
    
    [all_attr appendAttributedString:image_attr];
    
    NSAttributedString *att_s = [self creatSingleItemInfoWithTitle:@" " text:[NSString stringWithFormat:@"%@以上", self.claimModel.salaryStart]];
    [all_attr appendAttributedString:att_s];
  }
  
//  if (self.model.isCar || self.model.isHouse) {
//    NSAttributedString *att_s = [self creatSingleItemInfoWithTitle:@"经济条件：" text:[NSString stringWithFormat:@"%@ %@", self.model.isCar.integerValue == 1 ? @"已买车" : @"未买车", self.model.isHouse.integerValue == 1 ? @"已买房" : @"未买房"]];
//    [all_attr appendAttributedString:att_s];
//  }
  
//  if (self.model.intentionDate) {
//    NSAttributedString *att_s = [self creatSingleItemInfoWithTitle:@"其他：" text:[NSString stringWithFormat:@"准备%@年内结婚", self.model.intentionDate]];
//    [all_attr appendAttributedString:att_s];
//  }
  
  all_attr.yy_lineSpacing = 14;
  // 创建文本容器
  YYTextContainer *container = [YYTextContainer new];
  container.size = CGSizeMake(kScreenWidth-32, CGFLOAT_MAX);
    
  // 生成排版结果
  self.profileLayout = [YYTextLayout layoutWithContainer:container text:all_attr];

}

- (void)_formattIntroduction {
  if (!self.model.remark.isNotBlank) {
    self.model.remark = @"暂无";
  }
  NSMutableAttributedString *all_attr = [[NSMutableAttributedString alloc] initWithString:[self.model.remark toSafeValue] attributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_222222), NSFontAttributeName: AdaptedFont(14)}];
  all_attr.yy_lineSpacing = 14;
  // 创建文本容器
  YYTextContainer *container = [YYTextContainer new];
  container.size = CGSizeMake(kScreenWidth-32, CGFLOAT_MAX);
    
  // 生成排版结果
  self.introductionLayout = [YYTextLayout layoutWithContainer:container text:all_attr];

}

- (NSAttributedString *)creatSingleItemInfoWithTitle:(NSString *)title text:(NSString *)text {
  UIColor *titleColor = ColorHex(XYTextColor_666666);
  UIColor *textColor = ColorHex(XYTextColor_444444);
  NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@\n", [title toSafeValue], [text toSafeValue]]];
  [text_attr addAttributes:@{NSForegroundColorAttributeName:titleColor, NSFontAttributeName: AdaptedFont(14)} range:NSMakeRange(0, title.length)];
  [text_attr addAttributes:@{NSForegroundColorAttributeName:textColor, NSFontAttributeName: AdaptedFont(14)} range:NSMakeRange(title.length, text.length)];
  return text_attr;
}

- (void)creatLikesAttrString {
  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  
  // 嵌入 UIImage
  UIImage *image = [UIImage imageNamed:@"icon_22_dianzan_blank"];
  NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [all_attr appendAttributedString:image_attr];
  
  //创建属性字符串
  NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", self.model.follow]];
  text_attr.yy_font = font;
  text_attr.yy_color = ColorHex(XYTextColor_222222);
  [all_attr appendAttributedString:text_attr];
  
  self.likesAttrString = all_attr;
}

@end
