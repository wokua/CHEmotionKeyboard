//
//  SSChatKeyboardEmotionUtil.m
//  WZZB
//
//  Created by Ron on 2020/5/19.
//  Copyright © 2020 ERIC. All rights reserved.
//

#import "SSChatKeyboardEmotionUtil.h"
#import "CHCommonUtil.h"
#import "NSAttributedString+CHAttrs.h"
#import "NSBundle+Emotion.h"

@implementation SSChatKeyboardEmotionUtil


+ (instancetype)shareInstance{
    
    static SSChatKeyboardEmotionUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance creatData];
    });
    return sharedInstance;

}

-(void)creatData{
    self.imageMapStr = [NSMutableDictionary dictionary];
    //获取系统表情
    
    NSString *path = [[NSBundle currentBundleWithClass:self.class] pathForResource:@"emotion.txt" ofType:nil];
    
    NSString * emotionContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray * emotionArr = [[emotionContent stringByReplacingOccurrencesOfString:@", \"" withString:@""]componentsSeparatedByString:@"\""];
//    [emotionArr remove];
    NSMutableArray * emotionMArr = [NSMutableArray arrayWithArray:emotionArr];
    if (emotionArr.count > 0) {
        [emotionMArr removeObjectAtIndex:0];
    }
    [emotionMArr removeLastObject];
    NSArray* array = emotionMArr;
    NSMutableArray * systemDatas = [NSMutableArray array];
    
    for (int i = 0; i<array.count; i++) {
        NSString * emotionName = array[i];
        SSChatSystemEmotionCellData * data = [SSChatSystemEmotionCellData modelWithName:emotionName atIndex:i];
        [self.imageMapStr setObject:emotionName forKey:data.icon.description];
        [systemDatas addObject:data];
    }
    self.systemDatas = systemDatas;
}


//将字符串中所有的表情字符串转换成图片 并返回可变字符串
-(NSMutableAttributedString *)emotionImgsWithString:(NSString *)string{
    
    return [self emotionImgsWithString:string withImageSize:WX_WIDTHPX(30) baseLineOffset:WX_WIDTHPX(6)];
}

-(NSMutableAttributedString *)emotionImgsWithString:(NSString *)string withImageSize:(CGFloat)imgSize baseLineOffset:(CGFloat)baseLineOffset{
    
      if (kStringIsEmpty(string)) {
            return nil;
        }
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:string];
        
        //正则匹配要替换的文字的范围
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (!re) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        //遍历字符串,获得所有的匹配字符串
        NSArray *resultArray = [re matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        
//        SSChatKeyboardEmotionData * data = self.datas[0];
        
        for(int i=(int)resultArray.count-1;i>=0;--i){
            
            NSTextCheckingResult *checkingResult = resultArray[i];
            
            for(int j=0;j<self.systemDatas.count;++j){
                
                SSChatSystemEmotionCellData * cellData = (SSChatSystemEmotionCellData *)self.systemDatas[j];
                
                //截取闭区间的字符串
                if ([[string substringWithRange:checkingResult.range] isEqualToString:cellData.showingText]){
                    
                    NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
                    textAttachment.image = cellData.icon;
                    
                    textAttachment.bounds = CGRectMake(0, 0, imgSize, imgSize);
                    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    
                    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc]initWithAttributedString:imageStr];
                    if (baseLineOffset > 0) {
                        [mstr addAttribute:NSBaselineOffsetAttributeName value:@(-baseLineOffset) range:NSMakeRange(0, mstr.length)];
                    }
//                    [mstr appendString:@" "];
//                    NSMutableParagraphStyle *paragraphString = [[NSMutableParagraphStyle alloc] init];
//                    [paragraphString setLineSpacing:5];
//                    [mstr addAttribute:NSParagraphStyleAttributeName value:paragraphString range:NSMakeRange(0, mstr.length)];
                    
                    [attStr replaceCharactersInRange:checkingResult.range withAttributedString:mstr];
    //                [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphString range:NSMakeRange(0, attStr.length)];
                    break;
                }
                
                else{
                    
                }
            }
        }
        
        return attStr;
    
    
}

//输入视图删除 [微笑] 这类字符串  直接一次性删除
-(void)deleteEmtionString:(UITextView *)textView{
    NSString *souceText = textView.text;
    NSRange range = textView.selectedRange;
    if (range.location == NSNotFound) {
        range.location = textView.text.length;
    }
    NSString * dealStr = [souceText substringWithRange:NSMakeRange(0, range.location)];
    
    if (range.length > 0) {
        [textView deleteBackward];
        return;
    }else{
        
        //正则匹配要替换的文字的范围
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (!re) {
//            LYLog(@"%@", [error localizedDescription]);
        }
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:dealStr options:0 range:NSMakeRange(0, dealStr.length)];
        
        NSTextCheckingResult *checkingResult = resultArray.lastObject;
        
//        SSChatKeyboardEmotionData * data = self.datas[0];
        
        for (SSChatSystemEmotionCellData *cellData in self.systemDatas) {

            if ([dealStr hasSuffix:@"]"]) {
                
                if ([[dealStr substringWithRange:checkingResult.range] isEqualToString:cellData.showingText] && cellData.showingText.length > 0) {
                    
//                    LYLog(@"faceName %@", cellData.showingText);
                    
                    NSString *newText = [dealStr substringToIndex:dealStr.length - checkingResult.range.length];
                    NSString * suffix = [souceText substringWithRange:NSMakeRange(range.location, souceText.length - range.location)];
                    textView.text = [newText stringByAppendingString:suffix];
                    textView.selectedRange = NSMakeRange(range.location - cellData.showingText.length, 0);
                    return;
                }
            }else{
                [textView deleteBackward];
                return;
            }
        }
        [textView deleteBackward];
    }
}

//根据截取后的富文本、原始字符串获取对应的截取字符串
-(NSString *)getSubStringWith:(NSAttributedString *)emotionSubStr string:(NSString *)oriStr{
    
    if (emotionSubStr.length == 0 || oriStr.length == 0) {
        return oriStr;
    }
    long length = emotionSubStr.length;
//    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    //正则匹配要替换的文字的范围
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //遍历字符串,获得所有的匹配字符串
    NSArray *resultArray = [re matchesInString:oriStr options:0 range:NSMakeRange(0, oriStr.length)];
    
//    SSChatKeyboardEmotionData * data = self.datas[0];
    long resultLoction = 0;
    long lastRangeEnd = 0;
    for(int i=0;i<resultArray.count;i++){
        
        NSTextCheckingResult *checkingResult = resultArray[i];

        if (resultLoction + checkingResult.range.location -lastRangeEnd >= length) {
            long endIndex = lastRangeEnd + length - resultLoction;
            return [oriStr substringToIndex:endIndex];
        }else{
            resultLoction += checkingResult.range.location -lastRangeEnd;
        }
        
        BOOL hasEmotion = NO;
        
        for(int j=0;j<self.systemDatas.count;++j){

            SSChatSystemEmotionCellData * cellData = (SSChatSystemEmotionCellData *)self.systemDatas[j];
            //截取闭区间的字符串
            if ([[oriStr substringWithRange:checkingResult.range] isEqualToString:cellData.showingText]){
                hasEmotion = YES;
                break;
            }

            else{

            }
        }
        
        long newLength = checkingResult.range.length;
        if (hasEmotion) {
            newLength = 1;
        }
        
        lastRangeEnd = checkingResult.range.location + checkingResult.range.length;
        
        if (resultLoction + newLength >= length) {
            long endIndex = lastRangeEnd - (resultLoction + newLength - length);
            return [oriStr substringToIndex:endIndex];
        }else{
            resultLoction += newLength;
        }
    }
    
    long endIndex = lastRangeEnd + length - resultLoction;
    if (endIndex <= oriStr.length) {
        return  [oriStr substringToIndex:endIndex];
    }
    return [oriStr substringToIndex:length];
}


-(NSString *)getOriStringWith:(NSAttributedString *)emotionAttr{
    
    NSMutableString * resultStr = [NSMutableString string];
    for (int i = 0; i<emotionAttr.length; i++) {
        NSAttributedString * attr = [emotionAttr attributedSubstringFromRange:NSMakeRange(i, 1)];
        NSTextAttachment * attach = [attr.attributes objectForKey:@"NSAttachment"];
        if (kObjectIsEmpty(attach)) {
            if (!kStringIsEmpty(attr.string)) {
                [resultStr appendString:attr.string];
            }
        }else{
            NSString * imageName = self.imageMapStr[attach.image.description];
            if (!kStringIsEmpty(imageName)) {
                [resultStr appendString:imageName];
            }
        }
    }
    return resultStr;
}




@end
