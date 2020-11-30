//
//  WWBaseTextView.m
//  WWChat
//
//  Created by Ron on 2019/7/15.
//  Copyright © 2019 KEN. All rights reserved.
//

#import "WWBaseTextView.h"
#import <Masonry/Masonry.h>
//#import "UIColor+CHSocket.h"
#import "CHCommonUtil.h"

@interface WWBaseTextView()<UITextViewDelegate>


@end

@implementation WWBaseTextView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.font = [UIFont systemFontOfSize:WX_WIDTHPX(30)];
    self.textView.textColor =[UIColor lightGrayColor];
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.enablesReturnKeyAutomatically = YES;
    
    UILabel * placeHolder = [UILabel new];
    placeHolder.backgroundColor = [UIColor clearColor];
    self.placeHolder = placeHolder;
    

    [self addSubview:self.textView];
    self.textView.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:placeHolder];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(WX_WIDTHPX(10));
        make.centerY.mas_equalTo(self);
    }];
    placeHolder.hidden = NO;

}

- (void)textViewDidChange:(UITextView *)textView{
//    long count = self.textView.text.length;
    if (textView.text.length > 0 || textView.attributedText.length > 0) {
        self.placeHolder.hidden = YES;
    }else{
        self.placeHolder.hidden = NO;
    }
    if ([self.delegate respondsToSelector:@selector(WWBaseTextViewTextDidChanged:)]) {
        [self.delegate WWBaseTextViewTextDidChanged:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([self.delegate respondsToSelector:@selector(WWBaseTextView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate WWBaseTextView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(WWBaseTextViewTextDidBeginEdit:)]) {
        [self.delegate WWBaseTextViewTextDidBeginEdit:self.textView];
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
   
}

//- (void)setText:(NSString *)text{
//    self.textView.text = text;
//    self.placeHolder.hidden = text.length > 0;
//}



- (BOOL)becomeFirstResponder{
    [self.textView becomeFirstResponder];
    return  [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}


@end
