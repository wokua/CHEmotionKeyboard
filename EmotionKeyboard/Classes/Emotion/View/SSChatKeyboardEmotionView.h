//
//  SSChatKeyboardEmotionView.h
//  WWChat
//
//  Created by Ron on 2019/8/22.
//  Copyright © 2019 KEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSChatKeyboardEmotionData.h"
#import "SSChatKeyboardEmotionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

#define SSChatKeyBordSymbolFooterH  WX_WIDTHPX(20)

@interface SSChatKeyboardEmotionView : UIView

@property(nonatomic,strong)SSChatKeyboardEmotionViewModel * viewModel;

//+ (instancetype)shareInstance;
//- (void)setDatas:(NSArray<SSChatKeyboardEmotionData *> *)datas;
- (void)reloadCollectionData;

@end


@protocol SSChatKeyBordBottomViewDelegate <NSObject>

//点击表情
-(void)emotionChanged:(long)index;

@end

@interface SSChatKeyboardEmotionBottomView : UIView

@property(nonatomic,weak)id<SSChatKeyBordBottomViewDelegate>delegate;
@property(nonatomic,strong)NSArray* datas;
@property(nonatomic,assign)long selectIndex;

@end

NS_ASSUME_NONNULL_END
