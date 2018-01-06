//
//  GXBaseCollectionVC.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBaseCollectionVC.h"
#import "GXBaseCollectionViewCell.h"
#import "GXBaseCollectionViewFlowLayout.h"

@interface GXBaseCollectionVC ()

@end

@implementation GXBaseCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height,width = 0;
    id model = self.viewModel.objects[indexPath.row];
    NSString *cellID = nil;
    NSDictionary *params = nil;
    cellID = [[model class] description];
    Class xclass = self.viewModel.dataCellClassMapping[cellID];
    
    height = [xclass getHeightWithModel:model params:params];
    width = [xclass getWidthWithModel:model params:params];
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.viewModel.objects[indexPath.row];
    NSString *cellID = nil;
    cellID = [[model class] description];
    GXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell installWithModel:model params:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{

}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        GXBaseCollectionViewFlowLayout *layout = [[GXBaseCollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (void)dealloc
{
    self.collectionView = nil;
}

@end
