//
//  SSChatKeyboardEmotionViewModel.m
//  WWChat
//
//  Created by Ron on 2019/8/23.
//  Copyright © 2019 KEN. All rights reserved.
//

#import "SSChatKeyboardEmotionViewModel.h"
#import "SSChatKeyboardEmotionView.h"

@implementation SSChatKeyboardEmotionViewModel

-(instancetype)initWithRow:(int)row col:(int)col{
    self = [super init];
    if (self) {
        [self creatDataWithrow:row col:col];
    }
    return self;
}

-(void)creatDataWithrow:(int)row col:(int)col{
    
    NSMutableArray * sysDatas = [NSMutableArray arrayWithArray:[SSChatKeyboardEmotionUtil shareInstance].systemDatas];
    NSString * deletEmoName = @"DeleteEmoticonBtn";
    for (int i = 0; i < sysDatas.count ; i ++) {
        if ((i+1) % (row * col) == 0) {
            SSChatSystemEmotionCellData * data = [[SSChatSystemEmotionCellData alloc] initWith:SSChatKeyboardEmotionDataTypeImage name:deletEmoName];
            data.icon = [UIImage imageNamed:deletEmoName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
            [sysDatas insertObject:data atIndex:i];
        }
    }
    
    if (sysDatas.count % (row * col) != 0) {
        
        long page = sysDatas.count / (row * col);
        long allcount = (page + 1)*row * col;
        
        for (long i = sysDatas.count; i < allcount-1; i++) {
            SSChatSystemEmotionCellData * data = [SSChatSystemEmotionCellData new];
            [sysDatas addObject:data];
        }
        SSChatSystemEmotionCellData * data = [[SSChatSystemEmotionCellData alloc] initWith:SSChatKeyboardEmotionDataTypeImage name:deletEmoName];
        data.icon = [UIImage imageNamed:deletEmoName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
        [sysDatas addObject:data];
    }
    
    SSChatKeyboardEmotionData * firstData = [[SSChatKeyboardEmotionData alloc] initWith:row cols:col origins:sysDatas typeNormalImgName:@"chat_expression_unselected" typeSelectedImgName:@"chat_expression_selected"];
    self.datas = [NSMutableArray arrayWithObjects:firstData, nil];
    
}

-(void)selectIndexpath:(NSIndexPath *)indexpath currentIndex:(long)currentIndex{
    
    SSChatKeyboardEmotionData * data = self.datas[currentIndex];
    
    switch (currentIndex) {
        case 0:{
            if (indexpath.row == data.rows*data.cols - 1) {
                if ([self.delegate respondsToSelector:@selector(SSChatKeyBordEmotionDelete)]) {
                    [self.delegate SSChatKeyBordEmotionDelete];
                }
            }else{
                long index = indexpath.section * data.rows*data.cols + indexpath.row;
                if (data.origins.count <= index) {
                    return;
                }
                SSChatSystemEmotionCellData * cellData = (SSChatSystemEmotionCellData *)data.origins[index];
                if (cellData.showingText.length == 0) {
                    return;
                }
                if ([self.delegate respondsToSelector:@selector(SSChatKeyBordSymbolViewBtnClick:)]) {
                    [self.delegate SSChatKeyBordSymbolViewBtnClick:cellData.showingText];
                }
            }
           break;
        }
        case 1:{
            if (indexpath.section == 0 && indexpath.row == 0) {
                if ([self.delegate respondsToSelector:@selector(SSChatKeyBordEditEmotion)]) {
                    [self.delegate SSChatKeyBordEditEmotion];
                }
            }else{
                long index = indexpath.section * data.rows*data.cols + indexpath.row;
                if (data.origins.count <= index) {
                    return;
                }
                if ([self.delegate respondsToSelector:@selector(SSChatKeyBordSendCollectionData:)]) {
                    [self.delegate SSChatKeyBordSendCollectionData:(SSChatCollectionData *)data.origins[index]];
                }
            }
            break;
        }
            
 
        default:
            break;
    }
    
}


@end
