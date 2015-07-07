//
//  BItemContent.h
//  Bird
//
//  Created by 孙永刚 on 15-6-29.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BItemContent : NSObject

@property (nonatomic, strong) NSString *itemID;             //id
@property (nonatomic, strong) NSString *name;               //名字
@property (nonatomic, strong) NSString *categoryId;           //所属分类
@property (nonatomic, strong) NSArray *imageIDs;            //图片id列表， 成员：NSString
@property (nonatomic, strong) NSArray *property;            //属性列表，成员：NSString
@property (nonatomic, assign) NSTimeInterval createTime;    //创建时间
@property (nonatomic, assign) NSTimeInterval updateTime;    //更新时间
//create用
@property (nonatomic, strong) NSArray *imageDatas;          //图片数据
//update时删除
@property (nonatomic, strong) NSArray *deleteImageID;       //要删除的图片id
//update时添加
@property (nonatomic, strong) NSArray *addImageData;       //要添加的图片数据

//创建时保存图片并生成本地id
- (void)createImageIds;
//编辑物品后更新图片内容
- (void)updateImageIds;
//删除
- (void)deleteImages;

- (UIImage *)imageWithId:(NSString *)aImageId;

@end
