//
//  SSChatKeyboardEmotionViewModel.h
//  WWChat
//
//  Created by Ron on 2019/8/23.
//  Copyright © 2019 KEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSChatKeyboardEmotionUtil.h"


NS_ASSUME_NONNULL_BEGIN
@class SSChatKeyboardEmotionView;
@class SSChatKeyboardEmotionData;
@class SSChatCollectionData;

@protocol SSChatKeyBordEmotionViewDelegate <NSObject>

//点击表情
-(void)SSChatKeyBordSymbolViewBtnClick:(NSString *)emojiText;

//点击删除表情
-(void)SSChatKeyBordEmotionDelete;

@optional
//点击收藏的表情
-(void)SSChatKeyBordSendCollectionData:(SSChatCollectionData *)data;
//点击首层图片 编辑事件
-(void)SSChatKeyBordEditEmotion;

@end


@interface SSChatKeyboardEmotionViewModel : NSObject

@property(nonatomic,strong)NSMutableArray<SSChatKeyboardEmotionData *>* datas;

@property(nonatomic,weak)id<SSChatKeyBordEmotionViewDelegate>delegate;


-(instancetype)initWithRow:(int)row col:(int)col;

//-(void)creatDataWithrow:(int)row col:(int)col;
-(void)selectIndexpath:(NSIndexPath *)indexpath currentIndex:(long)currentIndex;


@end

NS_ASSUME_NONNULL_END
