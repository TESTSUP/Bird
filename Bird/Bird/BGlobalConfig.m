//
//  BGlobalConfig.m
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BGlobalConfig.h"
#import "BirdDB.h"

static NSString *const BirdDBName = @"Bird.db";


@interface BGlobalConfig ()
{
    NSArray *_propertyList;
    NSArray *_categoryList;
    NSString *_DBPath;
}
@end


@implementation BGlobalConfig

static dispatch_once_t configtoken;
static BGlobalConfig *configInstance = nil;

+(BGlobalConfig *)shareInstance
{
    dispatch_once(&configtoken, ^{
        configInstance = [[BGlobalConfig alloc] init];
    });
    
    return configInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.currentUser = DefaultUser;
        
        //读取分类和属性列表
        NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultProperty" ofType:@"plist"];
        _propertyList = [[NSArray alloc] initWithContentsOfFile:path];
        path = [[NSBundle mainBundle] pathForResource:@"defaultCategory" ofType:@"plist"];
        _categoryList = [[NSArray alloc] initWithContentsOfFile:path];
    }
    
    return self;
}

- (void)constructPath
{
    //创建图片缓存路径
    _imageSourcePath = [self.userCacheDirectory stringByAppendingPathComponent:@"imageCache"];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:self.imageSourcePath])
    {
        [fm createDirectoryAtPath:self.imageSourcePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //数据库路径
    _DBPath = [self.userCacheDirectory stringByAppendingPathComponent:BirdDBName];
}

- (void)setCurrentUser:(NSString *)aCurrentUser
{
    NSAssert([aCurrentUser length] >0, @"用户字段不能为空");
    
    if (![_currentUser isEqualToString:aCurrentUser]) {
        _currentUser = aCurrentUser;
        
        [self constructPath];
        
        [[BirdDB share] buildDB];
    }
}

- (NSString *)userCacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cache = [paths objectAtIndex:0];
    //增加一级用户文件目录以方便之后扩展
    return [cache stringByAppendingPathComponent:_currentUser];
}

- (NSString *)DBPath
{
    return _DBPath;
}

@end
