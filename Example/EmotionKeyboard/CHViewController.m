//
//  CHViewController.m
//  EmotionKeyboard
//
//  Created by 1060566471@qq.com on 11/30/2020.
//  Copyright (c) 2020 1060566471@qq.com. All rights reserved.
//

#import "CHViewController.h"
#import <EmotionKeyboard/SSChatKeyboardEmotionView.h>
#import <Masonry/Masonry.h>
#import <EmotionKeyboard/CHCommonUtil.h>
#import "WWBaseTextView.h"


@interface CHViewController ()<SSChatKeyBordEmotionViewDelegate,WWBaseTextViewDelegte>
@property(nonatomic,strong)SSChatKeyboardEmotionView * emotionView;

@property(nonatomic,strong)WWBaseTextView * textView;

@property(nonatomic,copy)NSString * planText;
@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _emotionView = [SSChatKeyboardEmotionView new];
    _emotionView.viewModel.delegate = self;
    [self.view addSubview:self.emotionView];
    [self.emotionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.mas_equalTo(self.view);
//        make.height.width.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(WXSafeAreaBottomHeight+ WX_WIDTHPX(470));
    }];
    

    self.textView = [WWBaseTextView new];
    self.textView.placeHolder.textColor = [UIColor redColor];
    self.textView.placeHolder.font = [UIFont systemFontOfSize:WX_WIDTHPX(30)];
    self.textView.placeHolder.text = @"吐个槽呗~";
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(WX_WIDTHPX(200));
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(WX_WIDTHPX(200));
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.textView endEditing:YES];
}

#pragma mark - WWBaseTextViewDelegte
- (void)WWBaseTextViewTextDidChanged:(UITextView *)view{
    

    if (view.attributedText.length > 0) {
        [self refreshTextUI];

//        self.planText = [[SSChatKeyboardEmotionUtil shareInstance] getOriStringWith:view.attributedText];
    }else{
//        self.planText = view.text;
    }
    
}

- (BOOL)WWBaseTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {

         return NO;
     }
    return YES;
}


- (void)refreshTextUI
{
    UITextView * textView = self.textView.textView;
    if (!textView.attributedText.length) {
        return;
    }

    UITextRange *markedTextRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:markedTextRange.start offset:0];
    if (position) {
        return;     // 正处于输入拼音还未点确定的中间状态
    }

    NSRange selectedRange = textView.selectedRange;

    NSMutableAttributedString *attributedComment = [[SSChatKeyboardEmotionUtil shareInstance] emotionImgsWithString:[self plainText] withImageSize:WX_WIDTHPX(30) baseLineOffset:WX_WIDTHPX(6)];;

    // 匹配表情
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0;
    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,attributedComment.length)];
    [attributedComment addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:WX_WIDTHPX(30)] range:NSMakeRange(0,attributedComment.length)];
    NSUInteger offset = textView.attributedText.length - attributedComment.length;
    textView.attributedText = attributedComment;
    textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
}
- (NSString *)plainText
{
    return [[SSChatKeyboardEmotionUtil shareInstance] getOriStringWith:self.textView.textView.attributedText];;
}


#pragma mark SSChatKeyBordEmotionViewDelegate
//点击表情
-(void)SSChatKeyBordSymbolViewBtnClick:(NSString *)emojiText{
    NSMutableAttributedString * mTextAttr;
    UITextView * textView = self.textView.textView;
    if (textView.attributedText.length > 0) {
        mTextAttr = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    }else{
        mTextAttr = [NSMutableAttributedString new];
    }
    
    NSRange oldRange = textView.selectedRange;
    NSRange newRange = NSMakeRange(oldRange.location+1,0);
    [mTextAttr deleteCharactersInRange:oldRange];
    NSAttributedString * emotionAttr = [[SSChatKeyboardEmotionUtil shareInstance] emotionImgsWithString:emojiText withImageSize:WX_WIDTHPX(32) baseLineOffset:WX_WIDTHPX(6)];
    [mTextAttr insertAttributedString:emotionAttr atIndex:textView.selectedRange.location];
    [mTextAttr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:WX_WIDTHPX(32)]} range:NSMakeRange(0, mTextAttr.length)];
    textView.attributedText = mTextAttr;
    textView.selectedRange = newRange;
    [textView.delegate textViewDidChange:textView];
}


//点击删除表情
-(void)SSChatKeyBordEmotionDelete{
    UITextView * textView = self.textView.textView;
    if (textView.attributedText.length > 0) {
        [textView deleteBackward];
    }else{
        return;
    }
}


@end
