//
//  SSChatKeyboardEmotionData.m
//  WWChat
//
//  Created by Ron on 2019/8/22.
//  Copyright © 2019 KEN. All rights reserved.
//

#import "SSChatKeyboardEmotionData.h"

@implementation SSChatKeyboardEmotionData


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWith:(int)rows cols:(int)cols origins:(NSArray *)origins typeNormalImgName:(NSString *)typeNormalImgName typeSelectedImgName:(NSString *)typeSelectedImgName{
    self = [super init];
    if (self) {
        self.rows = rows;
        self.cols = cols;
        self.origins = origins;
        self.typeNormalImgName = typeNormalImgName;
        self.typeSelectedImgName = typeSelectedImgName;
    }
    return self;
}

- (long)itemsPerSection{
    
    return self.pages*self.rows*self.cols;
}

-(long)pages{
    long items = self.origins.count/self.rows/self.cols;
    if (self.origins.count % (self.rows * self.cols) == 0) {
        return items;
    }
    
    return items+1;
}

@end

@implementation SSChatKeyboardEmotionCellData


-(instancetype)initWith:(SSChatKeyboardEmotionDataType)type name:(NSString *)name{
    
    self = [super init];
    if (self) {
        self.type = type;
        self.name = name;
    }
    return self;
}

@end


@implementation SSChatSystemEmotionCellData

+ (SSChatSystemEmotionCellData *)modelWithName:(NSString*)name atIndex:(int)index{
    
    SSChatSystemEmotionCellData* model = [SSChatSystemEmotionCellData new];
    model.showingText = name;
    model.code = [NSString stringWithFormat:@"[%d]", index];
    model.name = [NSString stringWithFormat:@"%d.gif", index];
    model.type = SSChatKeyboardEmotionDataTypeImage;
    model.icon =  [UIImage imageNamed:model.name inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    return model;
    
}

@end

@implementation  SSChatCollectionData

- (instancetype)initWith:(SSChatKeyboardEmotionDataType)type name:(NSString *)name emotionID:(long)emotionID{
    
    if (self = [super initWith:type name:name]) {
        self.emotionID = emotionID;
    }
    return self;
}

@end
