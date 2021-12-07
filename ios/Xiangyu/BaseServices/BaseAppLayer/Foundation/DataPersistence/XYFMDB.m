//
//  XYFMDB.m
//  JQFMDB
//
//  Created by Jacky Dimon on 2017/11/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "XYFMDB.h"
#import "FMDB.h"
#import "XYFileManager.h"
#import <objc/runtime.h>

NSString * const SqlText = @"TEXT";

NSString * const SqlInteger = @"INTEGER";

NSString * const SqlReal = @"REAL";

NSString * const SqlBlob = @"BLOB";

@interface XYFMDB ()

@property (nonatomic, strong)NSString *dbPath;

@property (nonatomic, strong)FMDatabaseQueue *dXYueue;

@property (nonatomic, strong)FMDatabase *db;

@end

@implementation XYFMDB
static XYFMDB *dbManager = nil;
+ (instancetype)sharedDatabase {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[XYFMDB alloc] init];
        NSString *dbPath = [[UIApplication sharedApplication].documentsPath stringByAppendingPathComponent:@"database"];
        if (![XYFileManager isDirectoryItemAtPath:dbPath]) {
            [XYFileManager createDirectoriesForPath:dbPath];
        }
        NSString *path = [dbPath stringByAppendingPathComponent:@"Xiangyu.db"];
        FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
        if ([fmdb open]) {
            dbManager.db = fmdb;
            dbManager.dbPath = path;
        }
    });
    
    if (![dbManager.db open]) {
        DLog(@"database can not open !");
        return nil;
    };
    return dbManager;
}
+ (instancetype)databaseWithDbName:(NSString *)dbName path:(NSString *)dbPath {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[XYFMDB alloc] init];
    });
        NSString *path;
        if (!dbName) {
            dbName = @"XYFMDB.db";
        }
        if (!dbPath) {
            path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
        } else {
            path = [dbPath stringByAppendingPathComponent:dbName];
        }
        
        FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
        if ([fmdb open]) {
            dbManager.db = fmdb;
            dbManager.dbPath = path;
        }

    if (![dbManager.db open]) {
        DLog(@"database can not open !");
        return nil;
    };
    return dbManager;
}


- (void)closeOpenResultSets {
  [_db closeOpenResultSets];
}

- (void)close {
    [_db close];
}

- (void)open {
    [_db open];
}


- (BOOL)createTable:(NSString *)tableName
             object:(id)object
      uniqueColumns:(NSString *)uniqueColumns {
    return [self createTable:tableName
                      object:object
               ignoreColumns:nil
               uniqueColumns:uniqueColumns];
}


- (BOOL)createTable:(NSString *)tableName object:(id)object
      ignoreColumns:(NSArray *)ignoreColumns uniqueColumns:(NSString *)uniqueColumns {
    
    if ([self isExistTable:tableName]) return YES;
    
    NSDictionary *dic;
    if ([object isKindOfClass:[NSDictionary class]]) {
        dic = object;
    } else {
        Class CLS;
        if ([object isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(object)) {
                CLS = nil;
            } else {
                CLS = NSClassFromString(object);
            }
        } else if ([object isKindOfClass:[NSObject class]]) {
            CLS = [object class];
        } else {
            CLS = object;
        }
        dic = [self modelToDictionary:CLS excludePropertyName:ignoreColumns];
    }
    
    NSMutableString *fieldStr = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (pkid  INTEGER PRIMARY KEY,", tableName];
    
    int keyCount = 0;
    for (NSString *key in dic) {
        
        keyCount++;
        if ((ignoreColumns && [ignoreColumns containsObject:key]) || [key isEqualToString:@"pkid"]) {
            continue;
        }
        if (keyCount == dic.count) {
            if ([key isEqualToString:uniqueColumns]) {
                [fieldStr appendFormat:@" %@ %@ UNIQUE)", key, dic[key]];
            } else {
             [fieldStr appendFormat:@" %@ %@)", key, dic[key]];
            }
            break;
        }

        if ([key isEqualToString:uniqueColumns]) {
            [fieldStr appendFormat:@" %@ %@ UNIQUE,", key, dic[key]];
        } else {
            [fieldStr appendFormat:@" %@ %@,", key, dic[key]];
        }
    }
    
    BOOL creatFlag;
    creatFlag = [_db executeUpdate:fieldStr];
    
    return creatFlag;
}

/** 插入数据 */
- (BOOL)insertTable:(NSString *)tableName object:(id)object distinct:(BOOL)distinct {
    NSArray *columnArr = [self getColumnArr:tableName db:_db];
    return [self insertTable:tableName object:object ignoreColumns:columnArr distinct:distinct];
}

/** 插入数据 */
- (BOOL)insertTable:(NSString *)tableName object:(id)object ignoreColumns:(NSArray *)ignoreColumns distinct:(BOOL)distinct {
    BOOL flag;
    NSDictionary *dic;
    if ([object isKindOfClass:[NSDictionary class]]) {
        dic = object;
    }else {
        dic = [self getModelPropertyKeyValue:object tableName:tableName clomnArr:ignoreColumns];
    }
    NSMutableString *finalStr;
    if (distinct) {
        finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT OR REPLACE INTO %@ (", tableName];
    } else {
     finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
    }
    NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        
        if (![ignoreColumns containsObject:key] || [key isEqualToString:@"pkid"]) {
            continue;
        }
        [finalStr appendFormat:@"%@,", key];
        [tempStr appendString:@"?,"];
        
        [argumentsArr addObject:dic[key]];
    }
    
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (tempStr.length)
        [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length-1, 1)];
    
    [finalStr appendFormat:@") values (%@)", tempStr];
    
    flag = [_db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    return flag;
}

/** 删除数据 */
- (BOOL)deleteTable:(NSString *)tableName whereFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
//    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
  NSString *where = format;
    va_end(args);
    BOOL flag;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"delete from %@  %@", tableName,where];
    
    flag = [_db executeUpdate:finalStr];
    
    return flag;
}

/** 更新数据 */
- (BOOL)updateTable:(NSString *)tableName object:(id)object whereFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
//    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
  NSString *where = format;
    va_end(args);
    BOOL flag;
    NSDictionary *dic;
    NSArray *clomnArr = [self getColumnArr:tableName db:_db];
    if ([object isKindOfClass:[NSDictionary class]]) {
        dic = object;
    }else {
        dic = [self getModelPropertyKeyValue:object tableName:tableName clomnArr:clomnArr];
    }
    
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        
        if (![clomnArr containsObject:key] || [key isEqualToString:@"pkid"]) {
            continue;
        }
        [finalStr appendFormat:@"%@ = %@,", key, @"?"];
        [argumentsArr addObject:dic[key]];
    }
    
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (where.length) [finalStr appendFormat:@" %@", where];
    
    
    flag =  [_db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    
    return flag;
}

- (NSArray *)queryTable:(NSString *)tableName
                 object:(id)object
              condition:(NSString *)condition  {
    NSString *finalStr = [NSString stringWithFormat:@"select * from %@ %@",tableName,condition];
    
    FMResultSet *set = [_db executeQuery:finalStr];
    
    return [self parserDataForTable:tableName object:object set:set];
    
}

/** 查询数据 */
- (NSArray *)queryTable:(NSString *)tableName object:(id)object whereFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    
//    NSString *where = format ? [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
  NSString *where = format;
    va_end(args);
    
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@", tableName, where?where:@""];
    
    FMResultSet *set = [_db executeQuery:finalStr];
    
    return [self parserDataForTable:tableName object:object set:set];
}

- (NSMutableArray *)parserDataForTable:(NSString *)tableName object:(id)object set:(FMResultSet *)set {
    NSMutableArray *resultMArr = @[].mutableCopy;
    NSDictionary *dic;
    NSArray *clomnArr = [self getColumnArr:tableName db:_db];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        dic = object;
        while ([set next]) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
            
            for (NSString *key in dic) {
                if ([dic[key] isEqualToString:SqlText]) {
                    id value = [set stringForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                    
                } else if ([dic[key] isEqualToString:SqlInteger]) {
                    [resultDic setObject:@([set longLongIntForColumn:key]) forKey:key];
                    
                } else if ([dic[key] isEqualToString:SqlReal]) {
                    
                    [resultDic setObject:[NSNumber numberWithDouble:[set doubleForColumn:key]] forKey:key];
                    
                } else if ([dic[key] isEqualToString:SqlBlob]) {
                    id value = [set dataForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                }
                
            }
            
            if (resultDic) [resultMArr addObject:resultDic];
        }
        
    } else {
        
        Class CLS;
        if ([object isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(object)) {
                CLS = nil;
            } else {
                CLS = NSClassFromString(object);
            }
        } else if ([object isKindOfClass:[NSObject class]]) {
            CLS = [object class];
        } else {
            CLS = object;
        }
        
        if (CLS) {
            NSDictionary *propertyType = [self modelToDictionary:CLS excludePropertyName:nil];
            
            while ([set next]) {
                
                id model = CLS.new;
                for (NSString *name in clomnArr) {
                    if ([propertyType[name] isEqualToString:SqlText]) {
                        id value = [set stringForColumn:name];
                        if (value)
                            [model setValue:value forKey:name];
                    } else if ([propertyType[name] isEqualToString:SqlInteger]) {
                        [model setValue:@([set longLongIntForColumn:name]) forKey:name];
                    } else if ([propertyType[name] isEqualToString:SqlReal]) {
                        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                    } else if ([propertyType[name] isEqualToString:SqlBlob]) {
                        id value = [set dataForColumn:name];
                        if (value)
                            [model setValue:value forKey:name];
                    }
                }
                
                [resultMArr addObject:model];
            }
        }
        
    }
    
    return resultMArr;
}
/** 批量插入数据 */
- (NSArray *)insertTable:(NSString *)tableName objectArray:(NSArray *)objectArray {
    
    int errorIndex = 0;
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSArray *columnArr = [self getColumnArr:tableName db:_db];
    for (id parameters in objectArray) {
        
        BOOL flag = [self insertTable:tableName object:parameters ignoreColumns:columnArr distinct:NO];
        if (!flag) {
            [resultMArr addObject:@(errorIndex)];
        }
        errorIndex++;
    }
    
    return resultMArr;
}

/** 删除表 */
- (BOOL)dropTable:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        return NO;
    }
    return YES;
}

/** 清空表中的所有数据 */
- (BOOL)cleanDataFromTable:(NSString *)tableName {
    
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        return NO;
    }
    
    return YES;
}

/** 是否存在表 */
- (BOOL)isExistTable:(NSString *)tableName {
    
    FMResultSet *set = [_db executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([set next])
    {
        NSInteger count = [set intForColumn:@"count"];
        if (count == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

/** 所有列字段 */
- (NSArray *)columnNameArray:(NSString *)tableName {
    return [self getColumnArr:tableName db:_db];
}

/** 表中所有数据个数 */
- (int)tableItemCount:(NSString *)tableName {
    
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *set = [_db executeQuery:sqlstr];
    while ([set next])
    {
        return [set intForColumn:@"count"];
    }
    return 0;
}

/** 表中最新插入的主键id */
- (NSInteger)lastInsertPrimaryKeyId:(NSString *)tableName {
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM %@ where pkid = (SELECT max(pkid) FROM %@)", tableName, tableName];
    FMResultSet *set = [_db executeQuery:sqlstr];
    while ([set next])
    {
        return [set longLongIntForColumn:@"pkid"];
    }
    return 0;
}

/** 插入多个键 */
- (BOOL)alterTable:(NSString *)tableName object:(id)object {
    return [self alterTable:tableName object:object ignoreColumns:nil];
}

/** 通过模型或者字典插入键，并且忽略某些键值 */
- (BOOL)alterTable:(NSString *)tableName object:(id)object ignoreColumns:(NSArray *)ignoreColumns {
    __block BOOL flag;
    [self inTransaction:^(BOOL *rollback) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in object) {
                if ([ignoreColumns containsObject:key]) {
                    continue;
                }
                flag = [_db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, object[key]]];
                if (!flag) {
                    *rollback = YES;
                    return;
                }
            }
            
        } else {
            Class CLS;
            if ([object isKindOfClass:[NSString class]]) {
                if (!NSClassFromString(object)) {
                    CLS = nil;
                } else {
                    CLS = NSClassFromString(object);
                }
            } else if ([object isKindOfClass:[NSObject class]]) {
                CLS = [object class];
            } else {
                CLS = object;
            }
            NSDictionary *modelDic = [self modelToDictionary:CLS excludePropertyName:ignoreColumns];
            NSArray *columnArr = [self getColumnArr:tableName db:_db];
            for (NSString *key in modelDic) {
                if (![columnArr containsObject:key] && ![ignoreColumns containsObject:key]) {
                    flag = [_db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, modelDic[key]]];
                    if (!flag) {
                        *rollback = YES;
                        return;
                    }
                }
            }
        }
    }];
    
    return flag;
}

/** 多线程操作数据 */
- (void)inDatabase:(void(^)(void))block {
    [[self dXYueue] inDatabase:^(FMDatabase *db) {
        block();
    }];
}

/** 数据库事务操作 */
- (void)inTransaction:(void(^)(BOOL *rollback))block {
    [[self dXYueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        block(rollback);
    }];
}
/** 数据库操作队列 */

- (FMDatabaseQueue *)dXYueue {
    if (!_dXYueue) {
        FMDatabaseQueue *fmdb = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
        self.dXYueue = fmdb;
        [_db close];
        self.db = [fmdb valueForKey:@"_db"];
    }
    return _dXYueue;
}
#pragma mark - private

- (NSDictionary *)modelToDictionary:(Class)cls excludePropertyName:(NSArray *)nameArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if ([nameArr containsObject:name]) continue;
        
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        
        id value = [self propertTypeConvert:type];
        if (value) {
            [mDic setObject:value forKey:name];
        }
        
    }
    free(properties);
    
    return mDic;
}
- (NSString *)propertTypeConvert:(NSString *)typeStr {
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SqlText;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SqlBlob;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SqlInteger;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SqlReal;
    }
    
    return resultStr;
}

// 获取model的key和value
- (NSDictionary *)getModelPropertyKeyValue:(id)model tableName:(NSString *)tableName clomnArr:(NSArray *)clomnArr {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (int i = 0; i < outCount; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if (![clomnArr containsObject:name]) {
            continue;
        }
        
        id value = [model valueForKey:name];
        if (value) {
            [mDic setObject:value forKey:name];
        }
    }
    free(properties);
    
    return mDic;
}

// 得到表里的字段名称
- (NSArray *)getColumnArr:(NSString *)tableName db:(FMDatabase *)db {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    
    FMResultSet *resultSet = [db getTableSchema:tableName];
    
    while ([resultSet next]) {
        [mArr addObject:[resultSet stringForColumn:@"name"]];
    }
    
    return mArr;
}

@end
