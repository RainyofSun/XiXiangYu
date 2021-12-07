//
//  XYPlatformService.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/18.
//

#import <Foundation/Foundation.h>

@interface XYRatesConfigModel : NSObject

@property (nonatomic, strong) NSNumber * id;

@property (nonatomic, strong) NSNumber * ruleType;

@property (nonatomic, strong) NSNumber * validity;

@property (nonatomic, strong) NSNumber * price;

@property (nonatomic, strong) NSNumber * status;

@property (nonatomic, strong) NSNumber * isDel;

@property (nonatomic, copy) NSString * createTime;

@property (nonatomic, copy) NSString * validityName;

@end

@interface XYIndustryModel : NSObject

@property (nonatomic, strong) NSNumber * code;

@property (nonatomic, strong) NSNumber * id;

@property (nonatomic, strong) NSNumber * parentId;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSArray <XYIndustryModel *> * list;

@end

@interface XYSchoolModel : NSObject

@property (nonatomic, strong) NSNumber * schoolType;

@property (nonatomic, copy) NSString * schoolName;

@property (nonatomic, strong) NSNumber * id;

@property (nonatomic, strong) NSNumber * isDel;

@property (nonatomic, copy) NSString * province;

@property (nonatomic, copy) NSString * city;

@property (nonatomic, copy) NSString * area;

@property (nonatomic, copy) NSString * createTime;

@end

@interface XYPlatformService : NSObject

@property (nonatomic,strong) NSArray *sexData_o;

@property (nonatomic,strong) NSArray *hasCarData_o;

@property (nonatomic,strong) NSArray *hasHouseData_o;

@property (nonatomic,strong) NSArray *hasMarriedData_o;

@property (nonatomic,strong) NSArray *weightData_o;

@property (nonatomic,strong) NSArray *heightData_o;

@property (nonatomic,strong) NSArray *characterData_o;

@property (nonatomic,strong) NSArray *positionData_o;

@property (nonatomic,strong) NSArray *educationData_o;

@property (nonatomic,strong) NSArray *salaryData_o;

@property (nonatomic,strong) NSArray *industryData_o;

@property (nonatomic,strong) NSArray *shopData_o;

@property (nonatomic,strong) NSArray *advertisingData_o;

@property (nonatomic,strong) NSArray *ratesConfigData_o;


+ (instancetype)shareService;

- (void)fetchOnlineSwitchWithBlock:(void(^)(BOOL status))block;

//广告投放位置
- (void)displayAdvertisingLocationSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

//选择有效期
- (void)displayRatesConfigSheetViewWithType:(NSNumber *)type block:(void(^)(NSDictionary *item))block;

//选择身高范围
- (void)displayHeightSliderSheetViewWithBlock:(void(^)(NSString *text, NSNumber * min, NSNumber * max))block;

//年龄
- (void)displayAgeSheetViewWithBlock:(void(^)(NSString *text, NSNumber * min, NSNumber * max))block;

//性别
- (void)displaySexSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

//是否买车
- (void)displayHasCarSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

//是否买房
- (void)displayHasHouseSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;
 
//是否结婚
- (void)displayHasMarriedSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

//体重
- (void)displayHasWeightSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

//身高
- (void)displayHeightSheetViewWithBlock:(void(^)(NSString *text, NSNumber * size))block;

//学历
- (void)displayEduSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

//薪资
- (void)displaySalarySheetViewWithBlock:(void(^)(NSString *text, NSNumber *start, NSNumber *end))block;

//门店
- (void)displayShopSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

//性格
- (void)displayCharacterSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

//学校（初中和高中通用）- 传入对应家乡省市区code
- (void)displaySchoolSheetViewWithProvice:(NSString *)provice
                                     city:(NSString *)city
                                     area:(NSString *)area
                                     type:(NSNumber *)type
                                    block:(void(^)(NSString *text, NSNumber * ID))block;

//职位
- (void)displayPositionSheetViewWithBlock:(void(^)(NSString *text, NSNumber * ID))block;

- (void)fetchIndustryDataWithBlock:(void(^)(NSArray <XYIndustryModel *> *data, XYError *error))block;

- (void)fetchSchoolDataWithProvice:(NSString *)provice city:(NSString *)city area:(NSString *)area type:(NSUInteger)type block:(void(^)(NSArray <XYSchoolModel *> *data, XYError *error))block;

- (void)ps_fetchEducationWithBlock:(void(^)(NSArray *data))block;



-(void)getSystemJson;


@end
