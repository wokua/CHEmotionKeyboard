//
//  SSChatEmotionTitleCell.m
//  WWChat
//
//  Created by Ron on 2019/8/22.
//  Copyright © 2019 KEN. All rights reserved.
//

#import "SSChatEmotionTitleCell.h"
#import <Masonry/Masonry.h>
#import "CHCommonUtil.h"

@interface SSChatEmotionTitleCell()

@property(nonatomic,strong)UILabel * titleLabel;

@end

@implementation SSChatEmotionTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.titleLabel.text = @"";
}

-(void)creatUI{
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:WX_WIDTHPX(32)];
    self.titleLabel.textColor = [UIColor blackColor];

    self.contentView.alpha = 1;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.left.right.mas_equalTo(self.contentView);
    }];
    
}

- (void)setBounds:(CGRect)bounds{

    [super setBounds:bounds];

    for (CALayer * layer in self.layer.sublayers) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            [layer removeFromSuperlayer];
        }
    }

    CAShapeLayer *border = [CAShapeLayer layer];
//    border.strokeColor = [UIColor commonBlueColor].CGColor;
    border.strokeColor = [UIColor blackColor].CGColor;
    border.fillColor = nil;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    border.path = path.CGPath;
//    border.path = [UIBezierPath bezierPathWithRect:].CGPath;
    border.frame = self.bounds;
    border.lineWidth = 2.f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@9, @6];

    [self.layer addSublayer:border];
}


- (void)setData:(SSChatKeyboardEmotionCellData *)data{
    [super setData:data];
    self.titleLabel.text = data.name;
}

@end
