//
//  SSChatKeyboardEmotionData.h
//  WWChat
//
//  Created by Ron on 2019/8/22.
//  Copyright © 2019 KEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SSChatKeyboardEmotionCellData;

typedef enum : NSUInteger {
    SSChatKeyboardEmotionDataTypeImage = 0,
    SSChatKeyboardEmotionDataTypeText,
} SSChatKeyboardEmotionDataType;

@interface SSChatKeyboardEmotionData : NSObject

@property(nonatomic,assign)int rows;
@property(nonatomic,assign)int cols;
@property(nonatomic,strong)NSArray<SSChatKeyboardEmotionCellData *> * origins; //展示的数据源
@property(nonatomic,copy)NSString * typeNormalImgName;   // 底部选择按钮普通时图片
@property(nonatomic,copy)NSString * typeSelectedImgName; //底部选择按钮选择时图片

@property(nonatomic,assign,readonly)long itemsPerSection;
@property(nonatomic,assign,readonly)long pages;

-(instancetype)initWith:(int)rows cols:(int)cols origins:(NSArray *)origins typeNormalImgName:(NSString *)typeNormalImgName typeSelectedImgName:(NSString *)typeSelectedImgName;

@end


//每个cell展示内容 基类
@interface SSChatKeyboardEmotionCellData : NSObject

@property(nonatomic,assign)SSChatKeyboardEmotionDataType type;
@property(nonatomic,copy)NSString * name; //文本时：文本，图片时：图片获取方式
-(instancetype)initWith:(SSChatKeyboardEmotionDataType)type name:(NSString *)name;

@end


@interface SSChatSystemEmotionCellData : SSChatKeyboardEmotionCellData   //系统头像模型x

//for post, ex:[0]
@property (nonatomic, copy) NSString* code;   //code码
//for parse, ex:[微笑]
@property (nonatomic, copy) NSString* showingText; //返回时文本框展示的文字

@property (nonatomic, strong) UIImage* icon; //返回时文本框展示的文字

+ (SSChatSystemEmotionCellData *)modelWithName:(NSString*)name atIndex:(int)index;

@end

@interface SSChatCollectionData : SSChatKeyboardEmotionCellData   //收藏数据

@property(nonatomic,assign)long emotionID;
-(instancetype)initWith:(SSChatKeyboardEmotionDataType)type name:(NSString *)name emotionID:(long)emotionID;
@end

NS_ASSUME_NONNULL_END
