//
//  WWChatEmotionCollectionLayout.m
//  WWChat
//
//  Created by Ron on 2019/8/26.
//  Copyright © 2019 KEN. All rights reserved.
//

#import "WWChatEmotionCollectionLayout.h"

@interface WWChatEmotionCollectionLayout()

@property(nonatomic,strong)NSMutableArray<UICollectionViewLayoutAttributes *> * attributesArr;

@end


@implementation WWChatEmotionCollectionLayout


- (void)prepareLayout{
    [super prepareLayout];
    [self updateAttr];
}

-(void)updateAttr{
    self.attributesArr = [NSMutableArray array];
       self.delegate = (id<WWChatEmotionCollectionLayoutDelegate>)self.collectionView.delegate;
       long sections = self.collectionView.numberOfSections;
       for (long section = 0; section < sections; section ++) {
           
           long rows = [self.collectionView numberOfItemsInSection:section];  //行数
           
           UIEdgeInsets sectionInset = self.sectionInset; //secction缩入间隔
           if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
               sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
           }
           
           CGFloat minLineSpace = self.minimumLineSpacing; //最小行间距
           if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
               minLineSpace = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
           }
           
           CGFloat minInteritemSpace = self.minimumInteritemSpacing; //最小列间距
           if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
               minInteritemSpace = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
           }
           
           CGRect bounds = self.collectionView.bounds;
           CGFloat allWidth = bounds.size.width;
           
           CGFloat lastItemRight = sectionInset.left;
           CGFloat lastItemBottom = sectionInset.top;
           
           //时间不够,暂时按每个section里面个数不超过一页处理
           
           for (long row = 0; row<rows; row++) {
               
               CGSize itemSize = self.itemSize;
               if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                   itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
               }
               
               NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
               UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
               
               CGFloat x = 0;
               CGFloat y = 0;
               if (allWidth == 0) {
                   attr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
                   [self.attributesArr addObject:attr];
                   continue;
               }
               if (lastItemRight + itemSize.width + minLineSpace < allWidth) {
                   y = lastItemBottom;
                   if (row == 0) {
                       x = section * bounds.size.width + lastItemRight;
                       lastItemRight = lastItemRight+itemSize.width;
                   }else{
                       x = section * bounds.size.width + lastItemRight + minLineSpace;
                       lastItemRight = minLineSpace + lastItemRight+itemSize.width;
                   }
               }else{
                   lastItemRight = sectionInset.left;
                   lastItemBottom = minInteritemSpace + lastItemBottom + itemSize.height;
                   x = section * bounds.size.width + lastItemRight;
                   y = lastItemBottom;
                   lastItemRight = lastItemRight+itemSize.width;
               }
               
               attr.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
               [self.attributesArr addObject:attr];
           }

       }
}


- (CGSize)collectionViewContentSize{
    long sections = self.collectionView.numberOfSections;
    return CGSizeMake(self.collectionView.bounds.size.width*sections, self.collectionView.bounds.size.height);
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    if (self.attributesArr.count > 2) {
        if (CGRectEqualToRect(self.attributesArr.firstObject.frame,self.attributesArr[1].frame)) {
            [self updateAttr];
        }
    }

    if (rect.origin.x == 0) {
        return self.attributesArr;
    }
    
    NSMutableArray * marr = [NSMutableArray new];

    for (UICollectionViewLayoutAttributes * attr in self.attributesArr) {
        CGRect frame = attr.frame;
        if (rect.origin.x <= frame.origin.x && rect.origin.x+rect.size.width > frame.origin.x+frame.size.width) {
            [marr addObject:attr];
        }
    }
    
    return marr;

}

@end
