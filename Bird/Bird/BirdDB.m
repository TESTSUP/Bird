//
//  BirdDB.m
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BirdDB.h"
#import "FMDatabase.h"

static NSString *const BirdDBVersion = @"100";


@interface BirdDB ()

@property (nonatomic, strong) FMDatabase *db;

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
    if (self.db) {
        [self.db close];
        self.db = nil;
    }
    
    NSString *dbPath = [BGlobalConfig shareInstance].DBPath;
    self.db = [[FMDatabase alloc] initWithPath:dbPath];
    [self.db open];
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
    NSString* version = nil;
    FMResultSet *rs = [self.db executeQuery:@"SELECT Version FROM bird_db_version WHERE Name = 'version'"];
    while ([rs next]) {
        version = [rs stringForColumnIndex:0];
    }
    [rs close];
    return version;
}

- (void)updateVersion
{
    NSString* version = [self getVersion];
    
    if (version)
    {
        [self.db executeUpdate:@"UPDATE bird_db_version SET Version=? WHERE Name = 'version'", BirdDBVersion];
        [self checkError];
    }
    else
    {
        [self.db executeUpdate:@"INSERT INTO bird_db_version (Name, Version) VALUES(?,?)" , @"version", BirdDBVersion];
        [self checkError];
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

- (void)checkError
{
    if ([self.db hadError]) {
        NSLog(@"DB Err %d: %@", [self.db lastErrorCode], [self.db lastErrorMessage]);
    }
}

- (id)checkEmpty:(id)aObject
{
    return aObject == nil ? [NSNull null] : aObject;
}

#pragma mark - Create Table

- (void)createDBVersionTable
{
    [self.db executeUpdate:@"CREATE TABLE bird_db_version (Version varchar(20), Name varchar(10))"];
    [self checkError];
}

- (void)createItemTable
{
    [self.db executeUpdate:@"CREATE TABLE bird_db_items ( name varchar(64), category varchar(32), images varchar(256), properties varchar(256))"];
    [self checkError];
}

- (void)createCategoryTable
{
    [self.db executeUpdate:@"CREATE TABLE bird_db_category (name varchar(32), description var(64))"];
    [self checkError];
}

- (void)createPropertyTable
{
    [self.db executeUpdate:@"CREATE TABLE bird_db_property (name varchar(64), used_count int)"];
}

#pragma mark - item

#pragma mark - category

#pragma mark - property

@end
