//
//  WWBaseTextView.h
//  WWChat
//
//  Created by Ron on 2019/7/15.
//  Copyright © 2019 KEN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WWBaseTextView;
@protocol WWBaseTextViewDelegte <NSObject>

@optional
-(void)WWBaseTextViewTextDidBeginEdit:(UITextView *)view;
-(void)WWBaseTextViewTextDidChanged:(UITextView *)view;
-(BOOL)WWBaseTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
@end

@interface WWBaseTextView : UIView

@property(nonatomic,strong)UITextView * textView;
//@property(nonatomic,assign)int maxCount;
@property(nonatomic,strong)UILabel * placeHolder;
@property(nonatomic,weak)id<WWBaseTextViewDelegte> delegate;

//-(void)setText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView;
@end

NS_ASSUME_NONNULL_END
