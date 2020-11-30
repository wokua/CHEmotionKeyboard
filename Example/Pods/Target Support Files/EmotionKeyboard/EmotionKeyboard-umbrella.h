#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CHCommonUtil.h"
#import "EmojiTextAttachment.h"
#import "SSChatKeyboardEmotionData.h"
#import "SSChatKeyboardEmotionUtil.h"
#import "SSChatKeyboardEmotionViewModel.h"
#import "NSAttributedString+CHAttrs.h"
#import "NSAttributedString+EmojiExtension.h"
#import "UIColor+CHSocket.h"
#import "SSChatEmotionBaseCell.h"
#import "SSChatEmotionImageCell.h"
#import "SSChatEmotionTitleCell.h"
#import "SSChatKeyboardEmotionView.h"
#import "WWChatEmotionCollectionLayout.h"
#import "WWCustomPageControl.h"

FOUNDATION_EXPORT double EmotionKeyboardVersionNumber;
FOUNDATION_EXPORT const unsigned char EmotionKeyboardVersionString[];

