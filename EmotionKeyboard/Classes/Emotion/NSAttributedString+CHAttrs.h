//
//  NSAttributedString+CHAttrs.h
//  LKSocketTest
//
//  Created by Ron on 2020/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (CHAttrs)
/**
 Returns the attributes at first charactor.
 */
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString *, id> *attributes;
@end

NS_ASSUME_NONNULL_END
