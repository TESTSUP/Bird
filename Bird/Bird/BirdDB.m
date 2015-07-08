//
//  BirdDB.m
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BirdDB.h"
#import "BirdUtil.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"



static NSString *const BirdDBVersion = @"100";


@interface BirdDB ()

//@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue* dbQueue;

@end

@implementation BirdDB

static dispatch_once_t dbToken;
static BirdDB *DBInstance = nil;

+ (BirdDB *)share
{
    dispatch_once(&dbToken, ^{
        DBInstance = [[BirdDB alloc] init];
    });
    
    return DBInstance;
}

- (void)buildDB
{
    if (self.dbQueue) {
        [self.dbQueue close];
        self.dbQueue = nil;
    }
    
    NSString *dbPath = [BGlobalConfig shareInstance].DBPath;
    self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    NSLog(@"db path = %@", dbPath);
    NSString* version = [self getVersion];
    if (version == nil)
    {
        [self createAllTable];
        [self updateDB:BirdDBVersion];
        [self updateVersion];
    }
    else if (![version isEqualToString:BirdDBVersion])
    {
        [self updateDB:version];
        [self updateVersion];
    }
}

- (NSString *)getVersion
{
    __block NSString* version = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT Version FROM bird_db_version WHERE Name = 'version'"];
        while ([rs next]) {
            version = [rs stringForColumnIndex:0];
        }
        [rs close];
        
    }];
    return version;
}

- (void)updateVersion
{
    NSString* version = [self getVersion];
    if (version)
    {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"UPDATE bird_db_version SET Version=? WHERE Name = 'version'", BirdDBVersion];
            [self checkError:db];
        }];
    }
    else
    {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"INSERT INTO bird_db_version (Name, Version) VALUES(?,?)" , @"version", BirdDBVersion];
            [self checkError:db];
        }];
    }
    
}

- (void)createAllTable
{
    [self createDBVersionTable];
    [self createItemTable];
    [self createCategoryTable];
    [self createPropertyTable];
}

- (void)updateDB:(NSString *)aFromVersion
{
    int from = 100;
    if (!aFromVersion)
    {
        from = [aFromVersion intValue];
    }
    int to = [BirdDBVersion intValue];
    while (from < to) {
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"update%d", from]);
        if ([self respondsToSelector:sel])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:sel withObject:nil];
#pragma clang diagnostic pop
        }
        ++from;
    }
}

- (void)checkError:(FMDatabase *)db
{
    if ([db hadError]) {
        NSLog(@"DB Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
}

- (id)checkEmpty:(id)aObject
{
    return aObject == nil ? [NSNull null] : aObject;
}

#pragma mark - Create Table

- (void)createDBVersionTable
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS bird_db_version (Version varchar(20), Name varchar(10))"];
        [self checkError:db];
    }];
}

- (void)createItemTable
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS bird_db_items (itemid char(32), name varchar(64), categoryid char(32), images varchar(256), properties varchar(256), createtime int,  updatetime int, PRIMARY KEY (itemid) ON CONFLICT REPLACE)"];
        [self checkError:db];
    }];
}

- (void)createCategoryTable
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS bird_db_category (name char(32), categoryid char(32), description var(64), createtime int, updatetime int, orderid INTEGER PRIMARY KEY  AUTOINCREMENT)"];
        [self checkError:db];
    }];
}

- (void)createPropertyTable
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS bird_db_property (name varchar(64), used_count int, PRIMARY KEY (name) ON CONFLICT REPLACE)"];
        [self checkError:db];
    }];
}

#pragma mark - item

- (void)insertItem:(BItemContent *)aItem
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT OR REPLACE INTO bird_db_items VALUES (?,?,?,?,?,?,?)",
         aItem.itemID,
         [self checkEmpty:aItem.name],
         aItem.categoryId,
         [self checkEmpty:[aItem.imageIDs componentsJoinedByString:@","]],
         [self checkEmpty:[aItem.property componentsJoinedByString:@","]],
         @(aItem.createTime),
         @(aItem.updateTime)];
        [self checkError:db];
    }];
}

- (BItemContent *)createItemWithResult:(FMResultSet *)rs
{
    BItemContent *item = [[BItemContent alloc] init];
    item.itemID = [rs stringForColumnIndex:0];
    item.name = [rs stringForColumnIndex:1];
    item.categoryId = [rs stringForColumnIndex:2];
    NSString *imageStr = [rs stringForColumnIndex:3];
    item.imageIDs = [imageStr componentsSeparatedByString:@","];
    NSString *proStr = [rs stringForColumnIndex:4];
    item.property = [proStr componentsSeparatedByString:@","];
    item.createTime = [rs intForColumnIndex:5];
    item.updateTime = [rs intForColumnIndex:6];
    
//    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
//    for (NSString *imageID in item.imageIDs) {
//        UIImage *image = [BirdUtil getImageWithID:imageID];
//        [imageArray addObject:image];
//    }
//    item.imageDatas = imageArray;
    
    return item;
}

- (NSArray *)getItemWithCategory:(NSString *)category
{
    NSMutableArray *rt = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([category length]) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"SELECT * FROM bird_db_items WHERE categoryid = ? ORDER BY createtime DESC", category];
            [self checkError:db];
            if ([rs next]) {
                BItemContent *item = [self createItemWithResult:rs];
                if (item) {
                    [rt addObject:item];
                }
            }
            [rs close];
        }];
    } else {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"SELECT * FROM bird_db_items ORDER BY createtime DESC"];
            [self checkError:db];
            while([rs next]) {
                BItemContent *item = [self createItemWithResult:rs];
                if (item) {
                    [rt addObject:item];
                }
            }
            [rs close];
        }];
    }
    
    return rt;
}

- (void)deleteItmeWithId:(NSString *)aItemId
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM bird_db_items WHERE itemid = ?", aItemId];
        [self checkEmpty:db];
    }];
}

#pragma mark - category

- (void)insertCategory:(BCategoryContent *)aCategory
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:@"INSERT OR REPLACE INTO bird_db_category VALUES (?,?,?,?)",
//         aCategory.name,
//         [self checkEmpty:aCategory.descr],
//         @(aCategory.createTime),
//         @(aCategory.updateTime)];
        

        [db executeUpdate:@"INSERT OR REPLACE INTO bird_db_category (name, categoryid, description, createtime, updatetime) VALUES (?,?,?,?,?)",
         aCategory.name,
         aCategory.categoryId,
         [self checkEmpty:aCategory.descr],
         @(aCategory.createTime),
         @(aCategory.updateTime)];
        
        [self checkError:db];
    }];
}

- (void)updateCategoryDesc:(BCategoryContent *)aCategory
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE bird_db_category SET description = ? WHERE categoryid = ?", aCategory.descr, aCategory.categoryId];
        [self checkError:db];
    }];
}

- (void)updateCategoryListOrder:(NSArray *)aCategoryList
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM bird_db_category"];
        [self checkError:db];
        
        for (BCategoryContent *aCategory in aCategoryList) {
            [db executeUpdate:@"INSERT OR REPLACE INTO bird_db_category (name, categoryid, description, createtime, updatetime) VALUES (?,?,?,?,?)",
             aCategory.name,
             aCategory.categoryId,
             [self checkEmpty:aCategory.descr],
             @(aCategory.createTime),
             @(aCategory.updateTime)];
        }
    }];
}

- (NSArray *)getAllCategory
{
     NSMutableArray *rt = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM bird_db_category ORDER BY orderid"];
        [self checkError:db];
        while ([rs next]) {
            BCategoryContent *category = [[BCategoryContent alloc] init];
            category.name = [rs stringForColumnIndex:0];
            category.categoryId = [rs stringForColumnIndex:1];
            category.descr = [rs stringForColumnIndex:2];
            category.createTime = [rs intForColumnIndex:3];
            category.updateTime = [rs intForColumnIndex:4];
            [rt addObject:category];
        }
        [rs close];
    }];
    
    return rt;
}

- (void)deleteCateGoryWithId:(NSString *)aCategoryId
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM bird_db_category WHERE categoryid = ?", aCategoryId];
        [self checkEmpty:db];
    }];
    
    //删除图片
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:0];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT images FROM bird_db_items WHERE categoryid = ?", aCategoryId];
        [self checkError:db];
        while ([rs next]) {
            NSString *imageStr = [rs stringForColumnIndex:0];
            NSArray *idArray = [imageStr componentsSeparatedByString:@","];
            if ([idArray count]) {
                [images addObjectsFromArray:idArray];
            };
        }
    }];
    for (NSString *imageId in images) {
        [BirdUtil deleteImageWithId:imageId];
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM bird_db_items WHERE categoryid = ?", aCategoryId];
        [self checkError:db];
    }];
}

#pragma mark - property

- (void)insertPropertyList:(NSArray *)aProperty
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSString *name in aProperty) {
            //查询次数
            FMResultSet *rs = [db executeQuery:@"SELECT used_count FROM bird_db_property WHERE name = ?", name];
            [self checkError:db];
            NSInteger count = 0;
            if ([rs next]) {
                count = [rs intForColumnIndex:0];
            }
            //插入
            [db executeUpdate:@"INSERT OR REPLACE INTO bird_db_property (name, used_count) VALUES (?,?)", name, @(++count)];
            [self checkError:db];
        }
    }];
}

- (NSArray *)getUsuallyPropertyWithLimit:(NSInteger)aLimit
{
     NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM bird_db_property ORDER BY used_count DESC LIMIT 10"];
        [self checkError:db];
        while ([rs next]) {
            NSString *property = [rs stringForColumnIndex:0];
            [array addObject:property];
        }
    }];
    
    return array;
}

@end
