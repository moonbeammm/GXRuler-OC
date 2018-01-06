//
//  GXBaseCollectionViewFlowLayout.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBaseCollectionViewFlowLayout.h"

#define GXColletionViewDoubleFirstLineSpace 12
#define BiliScreenMinWidth MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define BiliScreenMaxWidth MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

@interface GXBaseCollectionViewFlowLayout ()

//所有item属性
@property (nonatomic,strong) NSMutableArray *itemAttributes;
//item的数量
@property (nonatomic, assign) NSUInteger numberOfItems;
// header
@property (nonatomic, strong) UICollectionViewLayoutAttributes *headerLayoutAttributes;
// footer
@property (nonatomic, strong) UICollectionViewLayoutAttributes *footerLayoutAttributes;

@property (nonatomic, assign) CGFloat currentHeight;

@property (nonatomic, strong) NSDictionary *fadeAnimationFrameDic; // 原地刷新卡片的frame

@end

@implementation GXBaseCollectionViewFlowLayout


- (void)prepareLayout
{
    [super prepareLayout];
    [self.itemAttributes removeAllObjects];
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    if (!self.numberOfItems) {
        return;
    }
    id <UICollectionViewDelegateFlowLayout> layout = (id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    // 初始top高度
    CGFloat top = self.sectionInset.top;
    if ([layout respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        top = [layout collectionView:self.collectionView layout:self insetForSectionAtIndex:0].top;
    }
    // header
    CGSize headerSize = CGSizeZero;
    if ([layout respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        headerSize = [layout collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:0];
        self.headerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.headerLayoutAttributes.frame = CGRectMake(0, top, headerSize.width, headerSize.height);
        self.headerReferenceSize = self.headerLayoutAttributes.frame.size;
        top += headerSize.height;
    }
    
    self.currentHeight = top;
    BOOL isStart = YES; // 是否在左侧起点
    CGFloat lineSpace = self.minimumLineSpacing;
    if ([layout respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        lineSpace = [layout collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:0];
    }
    // 第一行距离顶部留出GXColletionViewDoubleFirstLineSpace像素
    self.currentHeight += GXColletionViewDoubleFirstLineSpace;
    
    NSMutableArray *heightArray = [NSMutableArray new];
    for (int i = 0; i < self.numberOfItems; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        CGSize itemSize = CGSizeZero;
        if ([layout respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
            itemSize = [layout collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        }
        CGFloat itemWidth = itemSize.width;
        CGFloat itemHeight = itemSize.height;
        if (itemWidth == 0 || itemHeight == 0) {//不感兴趣，itemwidth返回0
            continue;
        }
        if (itemWidth > 200) {
            // 通栏
            isStart = YES;
            //更新高度
            if ([heightArray count] == 1) {
                self.currentHeight += (lineSpace + [heightArray[0] floatValue]);
                [heightArray removeAllObjects];
            }
        }
        // 生成属性对象
        UICollectionViewLayoutAttributes *layoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        //计算Frame
        UIEdgeInsets itemInsets = self.sectionInset;
        if ([layout respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            itemInsets = [layout collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.section];
        }
        CGFloat x;
        if (isStart) {
            x = itemInsets.left;
        } else {
            x = BiliScreenMinWidth - itemInsets.right - itemWidth;
        }
        layoutAttr.frame = CGRectMake(x, self.currentHeight, itemWidth, itemHeight);
        [self.itemAttributes addObject:layoutAttr];
        
        if (itemWidth <= 200) {
            [heightArray addObject:@(itemHeight)];
        } else {
            self.currentHeight += (lineSpace + itemHeight);
        }
        //更新高度
        if ([heightArray count] == 2) {
            self.currentHeight += (lineSpace + MAX([heightArray[0] floatValue], [heightArray[1] floatValue]));
            [heightArray removeAllObjects];
        }
        if (itemWidth > 200) {
            // 通栏
            isStart = YES;
        } else {
            isStart = !isStart;
        }
    }
    //更新高度
    if ([heightArray count] == 1) {
        self.currentHeight += (lineSpace + [heightArray[0] floatValue]);
        [heightArray removeAllObjects];
    }
    
    // footer
    CGSize footerSize = CGSizeZero;
    if ([layout respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        footerSize = [layout collectionView:self.collectionView layout:self referenceSizeForFooterInSection:0];
        self.footerLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.footerLayoutAttributes.frame = CGRectMake(0, self.currentHeight, footerSize.width, footerSize.height);
        self.footerReferenceSize = self.footerLayoutAttributes.frame.size;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (self.collectionView.dataSource != nil) {//http://stackoverflow.com/questions/32777059/uicollectionview-and-supplementary-view-crash 
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.itemAttributes];
        if (self.headerLayoutAttributes) {
            [array addObject:self.headerLayoutAttributes];
        }
        if (self.footerLayoutAttributes) {
            [array addObject:self.footerLayoutAttributes];
        }
        return [NSArray arrayWithArray:array];
    }
    return nil;
    
}

// 获取collectionView的Size
- (CGSize)collectionViewContentSize
{
    CGSize contentSize = self.collectionView.frame.size;
    contentSize.height = self.currentHeight + self.sectionInset.bottom + self.footerLayoutAttributes.frame.size.height;
    
    return contentSize;
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if (self.animationMode == GXColletionViewAnimationLocalFade) {
        if (itemIndexPath && self.fadeAnimationFrameDic[itemIndexPath]) {
            attributes.frame = [self.fadeAnimationFrameDic[itemIndexPath] CGRectValue];
        }
    }
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath;
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if (self.animationMode == GXColletionViewAnimationLocalFade) {
        if (itemIndexPath) {
            self.fadeAnimationFrameDic = @{itemIndexPath:[NSValue valueWithCGRect:attributes.frame]};
        }
    }
    return attributes;
}

#pragma mark - getter
- (NSMutableArray *)itemAttributes
{
    if (!_itemAttributes) {
        _itemAttributes = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _itemAttributes;
}

@end
