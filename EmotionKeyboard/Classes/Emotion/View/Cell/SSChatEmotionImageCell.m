//
//  SSChatEmotionImageCell.m
//  WWChat
//
//  Created by Ron on 2019/8/22.
//  Copyright © 2019 KEN. All rights reserved.
//

#import "SSChatEmotionImageCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+CHSocket.h"
//#import "UIImage+GIF.h"
//#import "FLAnimatedImageView+WebCache.h"

@interface SSChatEmotionImageCell()

@property(nonatomic,strong)UIImageView * imageView;

@end

@implementation SSChatEmotionImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.imageView.image = nil;
}

- (void)setData:(SSChatKeyboardEmotionCellData *)data{
    [super setData:data];
    if ([data isKindOfClass:SSChatSystemEmotionCellData.class]) {
        SSChatSystemEmotionCellData * cellData = (SSChatSystemEmotionCellData *)data;
        self.imageView.image = cellData.icon;
//    }else if ([data isKindOfClass:SSChatCollectionData.class]){
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.layer.borderColor = [UIColor colorWithHex:0xf7f7f7].CGColor;
//        self.layer.borderWidth = 1;
    }else{
        self.imageView.image =  [UIImage imageNamed:data.name inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];;
    }

}

-(void)creatUI{
    self.contentView.backgroundColor =[UIColor clearColor];
    UIImageView * view = [UIImageView new];
    view.contentMode = UIViewContentModeCenter;
    
    self.imageView = view;
    
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

@end
