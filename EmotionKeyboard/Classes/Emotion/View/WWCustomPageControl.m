//
//  WWCustomPageControl.m
//  WWChat
//
//  Created by Ron on 2019/8/23.
//  Copyright © 2019 KEN. All rights reserved.
//

#import "WWCustomPageControl.h"
#import "Masonry.h"
#import "UIColor+CHSocket.h"

@interface WWCustomPageControl()

@property(nonatomic,strong)NSMutableArray<WWCircleView *> * tipViews;

@end

@implementation WWCustomPageControl


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    UIPanGestureRecognizer * ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:ges];
    [self addGestureRecognizer:tap];
    self.tipViews = [NSMutableArray array];
    
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:0xbbbcc1];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self);
    }];
}

-(void)pan:(UIGestureRecognizer *)ges{
    
    CGPoint loction = [ges locationInView:self];
    CGFloat x = loction.x;
    
    CGFloat width = self.bounds.size.width;
 
    CGFloat scale = x*self.numberOfPages / width;
    
    long page = (long)scale;
    if (page <  0) {
        page = 0;
    }else if (page < self.numberOfPages) {
    
    }else{
        page = self.numberOfPages - 1;
    }
    [self setCurrentPage:page];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setNumberOfPages:(long)numberOfPages{
    _numberOfPages = numberOfPages;
    for (UIView * view in self.tipViews) {
        [view removeFromSuperview];
    }
    
    [self.tipViews removeAllObjects];
    WWCircleView * lastView;
    for (int i = 0; i < numberOfPages; i ++) {
        
        WWCircleView * circleView = [WWCircleView new];
        [self addSubview:circleView];
        [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.centerX.mas_equalTo(self).multipliedBy((float)2*i/(numberOfPages - 1));
            }else{
                make.left.mas_equalTo(self);
            }
            make.width.height.mas_equalTo(4);
            make.centerY.mas_equalTo(self);
        }];
        if (i != self.currentPage) {
            circleView.hidden = YES;
        }
        
        lastView = circleView;
        [self.tipViews addObject:lastView];
        
    }
}

- (void)setCurrentPage:(long)currentPage{
    
    if (_currentPage == currentPage) {
        return;
    }
    self.tipViews[_currentPage].hidden = YES;
    self.tipViews[currentPage].hidden = NO;
    _currentPage = currentPage;
}


@end


@implementation WWCircleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHex:0xbbbcc1];
    }
    return self;
}

@end
