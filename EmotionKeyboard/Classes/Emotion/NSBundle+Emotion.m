//
//  NSBundle+Emotion.m
//  EmotionKeyboard
//
//  Created by Ron on 2020/12/1.
//

#import "NSBundle+Emotion.h"

@implementation NSBundle (Emotion)


+(NSBundle *)currentBundleWithClass:(Class)currentClass{
    NSBundle *bundle = [NSBundle bundleForClass:currentClass];
    NSURL *url = [bundle URLForResource:@"EmotionKeyboard" withExtension:@"bundle"];
    NSBundle *targetBundle = [NSBundle bundleWithURL:url];
    return targetBundle;
}
@end
