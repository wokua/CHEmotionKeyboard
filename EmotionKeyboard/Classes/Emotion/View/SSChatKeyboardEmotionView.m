//
//  SSChatKeyboardEmotionView.m
//  WWChat
//
//  Created by Ron on 2019/8/22.
//  Copyright © 2019 KEN. All rights reserved.
//

#import "SSChatKeyboardEmotionView.h"
#import "SSChatEmotionImageCell.h"
#import "SSChatEmotionTitleCell.h"
#import "WWCustomPageControl.h"
#import "WWChatEmotionCollectionLayout.h"
#import "UIColor+CHSocket.h"
#import <Masonry/Masonry.h>
#import "CHCommonUtil.h"

@interface SSChatKeyboardEmotionView()<UICollectionViewDelegate,UICollectionViewDataSource,WWChatEmotionCollectionLayoutDelegate,UIScrollViewDelegate,SSChatKeyBordBottomViewDelegate>

@property(nonatomic,strong)UIPageControl * pageControl; //普通页面控制器
@property(nonatomic,strong)WWCustomPageControl * linePageControl; //线性页面控制器
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSMutableArray<UICollectionView *> * emotionsView;
@property(nonatomic,assign)long currentIndex;

@property(nonatomic,strong)SSChatKeyboardEmotionBottomView * bottomView;
@property(nonatomic,assign)int currentPages;

@property(nonatomic,assign)BOOL isDragScrollview; //是否在滚动表情页面

@end

@implementation SSChatKeyboardEmotionView

//
//+ (instancetype)shareInstance{
//
//    static SSChatKeyboardEmotionView *sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    return sharedInstance;
//
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
      
        self.emotionsView = [NSMutableArray array];
        [self creatUI];
        self.viewModel = [[SSChatKeyboardEmotionViewModel alloc] initWithRow:5 col:9];
    }
    return self;
}

-(void)creatUI{
    
    self.pageControl = [UIPageControl new];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0xFF003B];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xCCCCCC];
    _pageControl.hidden = YES;
    [_pageControl addTarget:self action:@selector(currentPageChanged:) forControlEvents:UIControlEventValueChanged];
    WWChatEmotionCollectionLayout * layout = [WWChatEmotionCollectionLayout new];
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView registerClass:SSChatEmotionImageCell.class forCellWithReuseIdentifier:@"SSChatEmotionImageCell"];
    [collectionView registerClass:SSChatEmotionTitleCell.class forCellWithReuseIdentifier:@"SSChatEmotionTitleCell"];
    [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    [self.emotionsView addObject:collectionView];
    //    self.scrollView = [UIScrollView new];
    //    self.scrollView.showsHorizontalScrollIndicator = NO;
    //    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.delegate = self;
    self.currentIndex = 0;
    
    self.bottomView = [SSChatKeyboardEmotionBottomView new];
    self.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
    self.bottomView.delegate = self;
    
    self.linePageControl = [WWCustomPageControl new];
    [self.linePageControl addTarget:self action:@selector(currentPageChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.linePageControl];
    [self addSubview:self.pageControl];
    //    [self addSubview:self.scrollView];
    [self addSubview:self.bottomView];
    [self addSubview:collectionView];
    
    [self.linePageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(collectionView.mas_bottom);
        make.height.mas_equalTo(WX_WIDTHPX(40));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.8);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(collectionView.mas_bottom);
        make.height.mas_equalTo(WX_WIDTHPX(20));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(WXScreenW);
        make.bottom.mas_equalTo(self).mas_offset(-SSChatKeyBordSymbolFooterH-WX_WIDTHPX(40));
        make.top.mas_equalTo(self);
    }];
    //    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.right.mas_equalTo(self);
    //        make.bottom.mas_equalTo(self).offset(-SSChatKeyBordSymbolFooterH-WX_WIDTHPX(40));
    //        make.height.mas_equalTo(self).offset(-SSChatKeyBordSymbolFooterH-WX_WIDTHPX(40));
    //    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(SSChatKeyBordSymbolFooterH);
    }];
}

#pragma mark 设置数据源
- (void)setDatas:(NSArray<SSChatKeyboardEmotionData *> *)datas{

    [self updateNumberPages:datas[self.currentIndex].pages];
//    UIView * lastView;
//    for (int i = 0; i < datas.count; i ++) {
//
//
//
//    }
//    [self.emotionsView[0] layoutIfNeeded];
//    [self.emotionsView[0] reloadData];
    self.bottomView.datas = datas;
}

- (void)layoutSubviews{
    [super layoutSubviews];
   [self.emotionsView[0] reloadData];
}


#pragma mark 重新加载收藏图片
- (void)reloadCollectionData{
    if (self.currentIndex == 1) {
        [self.emotionsView[self.currentIndex] reloadData];
        [self updateNumberPages:self.viewModel.datas[self.currentIndex].pages];
    }
}

#pragma mark 设置VM
- (void)setViewModel:(SSChatKeyboardEmotionViewModel *)viewModel{
    _viewModel = viewModel;
    [self setDatas:viewModel.datas];
//    viewModel.view = self;
}

-(long)indexForCollectionView:(UICollectionView *)collView{
    
    for (int i = 0; i < self.emotionsView.count; i++) {
        UIView * view = self.emotionsView[i];
        if ([view isEqual:collView]) {
            return i;
        }
    }
    return 0;
    
}

-(void)currentPageChanged:(UIControl *)control{
    
    long currentPage = [self getCurrentPage];
    UICollectionView * view = self.emotionsView[self.currentIndex];
    if (currentPage == 0) {
        [view scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentPage] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }else{
        [view scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentPage] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    long index = [self indexForCollectionView:collectionView];
    SSChatKeyboardEmotionData * data = self.viewModel.datas[index];
    return data.pages;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    long index = [self indexForCollectionView:collectionView];
    SSChatKeyboardEmotionData * data = self.viewModel.datas[index];
    return data.rows*data.cols;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    long index = [self indexForCollectionView:collectionView];
    SSChatKeyboardEmotionData * data = self.viewModel.datas[index];
    
    long dataIndex = indexPath.row+indexPath.section*data.rows*data.cols; //数据在数据源中的位置
    
    if (data.origins.count > dataIndex) {
        SSChatKeyboardEmotionCellData * cellData = data.origins[dataIndex];
        SSChatEmotionBaseCell * cell;
        
        switch (cellData.type) {
            case SSChatKeyboardEmotionDataTypeText:{
                SSChatEmotionTitleCell * titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SSChatEmotionTitleCell" forIndexPath:indexPath];
                cell = titleCell;
                 break;
            }

            case SSChatKeyboardEmotionDataTypeImage:{
                SSChatEmotionImageCell * imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SSChatEmotionImageCell" forIndexPath:indexPath];
                cell = imageCell;
                break;
            }
        }
        [cell setData:cellData];
        return cell;
    }
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.viewModel selectIndexpath:indexPath currentIndex:self.currentIndex];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    long index = [self indexForCollectionView:collectionView];
    SSChatKeyboardEmotionData * data = self.viewModel.datas[index];
    return CGSizeMake((collectionView.bounds.size.width - (data.cols - 1) * WX_WIDTHPX(10) - 2*WX_WIDTHPX(30))/data.cols, (collectionView.bounds.size.height - (data.rows - 1)*WX_WIDTHPX(10) - WX_WIDTHPX(30) - WX_WIDTHPX(52))/data.rows  - 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return WX_WIDTHPX(10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return WX_WIDTHPX(10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(WX_WIDTHPX(52), WX_WIDTHPX(30), WX_WIDTHPX(20), WX_WIDTHPX(30));
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    self.isDragScrollview = YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isDragScrollview = NO;
    if ([scrollView isEqual:self.scrollView]) {
        long index = (self.scrollView.contentOffset.x + 0.5*WXScreenW) / WXScreenW;
        if (index == self.currentIndex) {
            return;
        }
        self.currentIndex = index;
        [self.emotionsView[self.currentIndex] reloadData];
        [self updateNumberPages:self.viewModel.datas[self.currentIndex].pages];
        self.bottomView.selectIndex = index;
        [self setCurrentPage:self.emotionsView[self.currentIndex].contentOffset.x / WXScreenW];
    }else{
        long currentPage = scrollView.contentOffset.x / WXScreenW;
        long numberOfPages = self.viewModel.datas[self.currentIndex].pages;
        [self setCurrentPage:currentPage];
        if ((currentPage == 0 && self.currentIndex > 0)|| (currentPage == numberOfPages-1 && self.currentIndex < self.viewModel.datas.count-1)) {
            self.scrollView.scrollEnabled = YES;
        }else{
            self.scrollView.scrollEnabled = NO;
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.isDragScrollview) {
        return;
    }
    if (![scrollView isEqual:self.scrollView]) {
        [self setCurrentPage:scrollView.contentOffset.x / WXScreenW];
    }
}

#pragma mark SSChatKeyBordBottomViewDelegate
- (void)emotionChanged:(long)index{
    self.currentIndex = index;
    [self updateNumberPages:self.viewModel.datas[index].pages];
    self.scrollView.contentOffset = CGPointMake(WXScreenW*index, 0);
    [self.emotionsView[index] reloadData];
    [self setCurrentPage:self.emotionsView[index].contentOffset.x / WXScreenW];
    
    
    long currentPage = [self getCurrentPage];
    long numberOfPages = self.viewModel.datas[self.currentIndex].pages;

    if ((currentPage == 0 && self.currentIndex > 0)|| (currentPage == numberOfPages-1 && self.currentIndex < self.viewModel.datas.count-1)) {
        self.scrollView.scrollEnabled = YES;
    }else{
        self.scrollView.scrollEnabled = NO;
    }
}


#pragma mark 更新总页数
-(void)updateNumberPages:(long)numberOfPages{
    
    if (numberOfPages <= 10) {
        self.pageControl.numberOfPages = numberOfPages;
        self.pageControl.hidden = NO;
        self.linePageControl.hidden = YES;
    }else{
        self.linePageControl.numberOfPages = numberOfPages;
        self.pageControl.hidden = YES;
        self.linePageControl.hidden = NO;
    }
    
}

#pragma mark 设置当前第几页
-(void) setCurrentPage:(long)currentPage{
 
    if (self.pageControl.hidden) {
        self.linePageControl.currentPage = currentPage;
    }else{
        self.pageControl.currentPage = currentPage;
    }
    
}

#pragma mark 获取当前第几页
-(long)getCurrentPage{
    if (self.pageControl.hidden) {
        return self.linePageControl.currentPage;
    }else{
        return self.pageControl.currentPage;
    }
}

@end


@interface SSChatKeyboardEmotionBottomView()

@property(nonatomic,strong)UIScrollView * contentView;
@property(nonatomic,strong)NSMutableArray <UIButton *>* btns;

@end
@implementation SSChatKeyboardEmotionBottomView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectIndex = 0;
        self.btns = [NSMutableArray array];
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    self.contentView = [UIScrollView new];
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];

}

- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    UIButton * lastBtn;
    [self.btns removeAllObjects];
    
    for (long i = 0 ; i<self.datas.count; i++) {
        SSChatKeyboardEmotionData * data = self.datas[i];
        UIButton * btn = [UIButton new];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:data.typeNormalImgName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:data.typeSelectedImgName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        if (i == self.selectIndex) {
            btn.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
            btn.selected = YES;
        }else{
            btn.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
            btn.selected = NO;
        }
        [btn addTarget:self action:@selector(btnTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastBtn) {
                make.left.mas_equalTo(lastBtn.mas_right);
            }else{
                make.left.mas_equalTo(self.contentView).offset(10);
            }
            make.top.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(self);
            make.width.mas_equalTo(btn.mas_height);
        }];
        lastBtn = btn;
        [self.btns addObject:lastBtn];
    }
    
}


- (void)setSelectIndex:(long)selectIndex{
    if (_selectIndex == selectIndex) {
        return;
    }
    _selectIndex = selectIndex;
    [self refreshViewState];
}

-(void)btnTaped:(UIButton *)sender{
    
    self.selectIndex = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(emotionChanged:)]) {
        [self.delegate emotionChanged:sender.tag];
    }
}

-(void)refreshViewState{
    
    for (UIButton * btn in self.btns) {
        if (btn.tag == self.selectIndex) {
            btn.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
            btn.selected = YES;
        }else{
            btn.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
            btn.selected = NO;
        }
    }
}

@end
