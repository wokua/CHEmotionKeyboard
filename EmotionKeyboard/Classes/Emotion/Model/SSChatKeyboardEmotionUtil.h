//
//  SSChatKeyboardEmotionUtil.h
//  WZZB
//
//  Created by Ron on 2020/5/19.
//  Copyright © 2020 ERIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSChatKeyboardEmotionData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSChatKeyboardEmotionUtil : NSObject

+(instancetype)shareInstance;

@property(nonatomic,strong)NSMutableDictionary * imageMapStr;//图像->名字字符串 字典
@property(nonatomic,strong)NSMutableArray<SSChatSystemEmotionCellData *>* systemDatas;

//将字符串中所有的表情字符串转换成图片 并返回可变字符串
-(NSMutableAttributedString *)emotionImgsWithString:(NSString *)string;

//将字符串中所有的表情字符串转换成图片 并返回可变字符串
-(NSMutableAttributedString *)emotionImgsWithString:(NSString *)string withImageSize:(CGFloat)imgSize baseLineOffset:(CGFloat)baseLineOffset;

//输入视图删除 [微笑] 这类字符串  直接一次性删除
-(void)deleteEmtionString:(UITextView *)textView;
//根据截取后的富文本、原始字符串获取对应的截取字符串
-(NSString *)getSubStringWith:(NSAttributedString *)emotionSubStr string:(NSString *)oriStr;
//根据h富文本获取对应图片名称的文本信息
-(NSString *)getOriStringWith:(NSAttributedString *)emotionAttr;

@end

NS_ASSUME_NONNULL_END
