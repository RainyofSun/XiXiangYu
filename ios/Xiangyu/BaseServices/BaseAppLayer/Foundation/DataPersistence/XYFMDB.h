//
//  XYFMDB.h
//  JQFMDB
//
//  Created by Jacky Dimon on 2017/11/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

XY_EXTERN NSString * const SqlText;

XY_EXTERN NSString * const SqlInteger;

XY_EXTERN NSString * const SqlReal;

XY_EXTERN NSString * const SqlBlob;

@interface XYFMDB : NSObject

/**
 @note 创建数据库
 
 @return default 在cache/database/Xiangyu.db路径下面创建DB */
+ (instancetype)sharedDatabase;
/**
 @note 创建数据库
 
 @param dbName 数据库的名称, 如果dbName = nil,则默认dbName=@"Xiangyu.db"
 @param dbPath 数据库的路径, 如果dbPath = nil, 则路径默认为NSDocumentDirectory
 
 @return XYFMDB操作实例
 */
+ (instancetype)databaseWithDbName:(NSString *)dbName
                              path:(NSString *)dbPath;

/** 关闭FMResultSet */
- (void)closeOpenResultSets;

/** 关闭数据库 */
- (void)close;

/** 打开数据库 (操作时数据库已经open,当调用close后若进行db操作需重新open) */
- (void)open;

/**
 @note 通过传入的object创建表
 
 @param tableName 表的名称
 @param object 设置表的字段,可以传一个自定义对象或字典(@{@"name":@"TEXT"})
 
 @return 是否创建成功
 */
- (BOOL)createTable:(NSString *)tableName
             object:(id)object
      uniqueColumns:(NSString *)uniqueColumns;

/**
 @note 通过传入的object创建表
 
 @param tableName 表的名称
 @param object 设置表的字段,可以传一个自定义对象或字典(@{@"name":@"TEXT"})
 @param ignoreColumns 忽略的字段集合
 
 @return 是否创建成功
 */

- (BOOL)createTable:(NSString *)tableName
             object:(id)object
      ignoreColumns:(NSArray *)ignoreColumns
      uniqueColumns:(NSString *)uniqueColumns;

/**
 @note 增加数据
 
 @param tableName 表的名称
 @param object 要插入的数据,可以是自定义对象或dictionary(格式:@{@"name":@"小李"})
 
 @return 是否插入成功
 */

- (BOOL)insertTable:(NSString *)tableName object:(id)object distinct:(BOOL)distinct;

/**
 @note 批量插入或更改数据
 
 @param objectArray 要insert/update数据的数组,也可以将model和dictionary混合装入array
 
 @return 返回的数组存储未插入成功的下标,数组中元素类型为NSNumber
 */

- (NSArray *)insertTable:(NSString *)tableName objectArray:(NSArray *)objectArray;

/**
 @note 删除数据
 
 @param tableName 表的名称
 @param format 条件语句, 如:@"where name = '小李'"
 
 @return 是否删除成功
 */

- (BOOL)deleteTable:(NSString *)tableName whereFormat:(NSString *)format, ...;

/**
 @note 更新数据
 
 @param tableName 表的名称
 @param object 要更改的数据,可以是自定义对象或dictionary(格式:@{@"name":@"张三"})
 @param format 条件语句, 如:@"where name = '小李'"
 
 @return 是否更改成功
 */

- (BOOL)updateTable:(NSString *)tableName object:(id)object whereFormat:(NSString *)format, ...;


- (NSArray *)queryTable:(NSString *)tableName
                 object:(id)object
              condition:(NSString *)condition;

/**
 @note 查找数据
 
 @param tableName 表的名称
 @param object 每条查找结果放入model(可以是[Person class] or @"Person" or Person实例)或dictionary中
 @param format 条件语句, 如:@"where name = '小李'",
 
 @return 将结果存入array,数组中的元素的类型为parameters的类型
 */

- (NSArray *)queryTable:(NSString *)tableName object:(id)object whereFormat:(NSString *)format, ...;

/** 删除表 */
- (BOOL)dropTable:(NSString *)tableName;

/** 清空表数据 */
- (BOOL)cleanDataFromTable:(NSString *)tableName;

/** 是否存在表 */
- (BOOL)isExistTable:(NSString *)tableName;

/** 表中数据条数 */
- (int)tableItemCount:(NSString *)tableName;

/** 返回表中的字段名 */
- (NSArray *)columnNameArray:(NSString *)tableName;

/**
 @note 增加新字段, 在建表后还想新增字段,可以在原建表model或新model中新增对应属性,然后传入即可新增该字段,该操作已在事务中执行
 
 @param tableName 表的名称
 @param object 如果传自定义对象:数据库新增字段为建表时自定义对象所没有的属性,如果传dictionary格式为@{@"newname":@"TEXT"}
 @param ignoreColumns 不允许生成字段的属性名的数组
 
 @return 是否成功
 */
- (BOOL)alterTable:(NSString *)tableName object:(id)object ignoreColumns:(NSArray *)ignoreColumns;


- (BOOL)alterTable:(NSString *)tableName object:(id)object;


/** 将操作语句放入block中即可保证线程安全 */
- (void)inDatabase:(void (^)(void))block;


/** 执行事务操作，将要执行的语句放入block中可执行回滚操作(*rollback = YES;) */
- (void)inTransaction:(void(^)(BOOL *rollback))block;

/**
 (主键id,自动创建) 返回最后插入的primary key id
 @param tableName 表的名称
 */
- (NSInteger)lastInsertPrimaryKeyId:(NSString *)tableName;


@end
