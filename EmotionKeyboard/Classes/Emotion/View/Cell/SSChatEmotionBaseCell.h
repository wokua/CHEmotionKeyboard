//
//  SSChatEmotionBaseCell.h
//  WWChat
//
//  Created by Ron on 2019/8/23.
//  Copyright © 2019 KEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSChatKeyboardEmotionData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatEmotionBaseCell : UICollectionViewCell

@property(nonatomic,strong)SSChatKeyboardEmotionCellData * data;

@end

NS_ASSUME_NONNULL_END
