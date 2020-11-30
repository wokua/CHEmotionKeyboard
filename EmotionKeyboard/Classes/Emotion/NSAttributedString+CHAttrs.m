//
//  NSAttributedString+CHAttrs.m
//  LKSocketTest
//
//  Created by Ron on 2020/11/16.
//

#import "NSAttributedString+CHAttrs.h"

@implementation NSAttributedString (CHAttrs)


- (NSDictionary *)attributes {
    return [self attributesAtIndex:0];
}


- (NSDictionary *)attributesAtIndex:(NSUInteger)index {
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}


@end
