//
//  BirdDB.m
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BirdDB.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "BItemContent.h"
#import "BCategoryContent.h"

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
    
//    NSString* version = nil;
//    FMResultSet *rs = [self.db executeQuery:@"SELECT Version FROM bird_db_version WHERE Name = 'version'"];
//    while ([rs next]) {
//        version = [rs stringForColumnIndex:0];
//    }
//    [rs close];
//    return version;
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
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS bird_db_items ( name varchar(64), category varchar(32), images varchar(256), properties varchar(256))"];
        [self checkError:db];
    }];
}

- (void)createCategoryTable
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS bird_db_category (name varchar(32), description var(64))"];
        [self checkError:db];
    }];
}

- (void)createPropertyTable
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS bird_db_property (name varchar(64), used_count int)"];
        [self checkError:db];
    }];
}

#pragma mark - item

- (void)insertItem:(BItemContent *)aItem
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT OR REPLACE INTO bird_db_items VALUES (?,?,?,?,?)",
         aItem.name,
         aItem.category,
         [aItem.images componentsJoinedByString:@","],
         [aItem.property componentsJoinedByString:@","]];
         [self checkError:db];
    }];
}

#pragma mark - category

#pragma mark - property

@end
