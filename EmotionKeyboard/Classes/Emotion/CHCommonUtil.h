//
//  CHCommonUtil.h
//  LKSocketTest
//
//  Created by Ron on 2020/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHCommonUtil : NSObject



#define IS_IPHONE_XAll (WXScreenLengthMax == 812.0f || WXScreenLengthMax == 896.0f)
//判断iPhoneX和iPhoneXs
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXr
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define iPhoneXS_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)


#define WXScreenH [UIScreen mainScreen].bounds.size.height
#define WXScreenW [UIScreen mainScreen].bounds.size.width
#define WXScreenLengthMin  MIN(WXScreenH, WXScreenW)
#define WXScreenLengthMax  MAX(WXScreenH, WXScreenW)


#define WXNavigationHeight ((IS_IPHONE_XAll == YES) ? 88.0f : 64.0f)
#define WXTabBarHeight ((IS_IPHONE_XAll == YES) ? 83.0f : 49.0f)
#define WXStatusBarHeight ((IS_IPHONE_XAll == YES) ? 44.0f : 20.0f)
#define WXSafeAreaBottomHeight ((IS_IPHONE_XAll == YES) ? 34.0f : 0.0f)

// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

//竖屏
#define WX_WIDTHPX(width) ((width) * WXScreenLengthMin / 750.0)
#define WX_HEIGHTPX(height) ((iPhoneXR == YES || iPhoneXS_Max == YES) ? ((height) * WXScreenLengthMax / 1792.0) : (iPhoneX == YES ? ((height) * WXScreenLengthMax / 1624.0) : ((height) * WXScreenLengthMax / 1334.0)))

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str isEqualToString:@"(null)"] || [str length] < 1 ? YES : NO )
#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

@end

NS_ASSUME_NONNULL_END
