//
//  YMPhotoAlbumController.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/10.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMPhotoAlbumController.h"
#import "YMAlbumCollectionViewCell.h"
#import "YMAlbumModel.h"
#import "YMPhotoModel.h"
#import "YMAlbumHeaderReuseableView.h"
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
static NSString *const YMAlbumHeaderReuseableViewID = @"YMAlbumHeaderReuseableView";

@interface YMPhotoAlbumController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *albumCollectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) YMAlbumModel *albumModel;
@property (nonatomic, strong) NSMutableArray *assetCollectionList;

@end
static NSString *albumCollectionViewCell = @"YMAlbumCollectionViewCell";
@implementation YMPhotoAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取所有图片的相册
    [self getAllAlbum];

}


#pragma mark — privite
- (void)getAllAlbum{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PHFetchResult<PHAssetCollection *> * cameraRolls = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        for (PHAssetCollection * collection in cameraRolls) {
            YMAlbumModel * albumModel = [[YMAlbumModel alloc] init];
            albumModel.collection = collection;
            if(albumModel.assets.count >0){
                [self.assetCollectionList addObject:albumModel];
            }
            //按时间排序
//            PHFetchOptions *options = [[PHFetchOptions alloc] init];
//            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//            PHFetchResult<PHAsset *> * assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
//            for (PHAsset *asset in assets) {
//                [self.dataSource addObject:asset];
//            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albumModel = self.assetCollectionList.firstObject;
            
            
            [self.albumCollectionView reloadData];
        });
    });
}







#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.albumModel.dateArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    YMPhotoDateModel * dateModel = self.albumModel.dateArr[section];
    return dateModel.photoModelArray.count;
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:albumCollectionViewCell forIndexPath:indexPath];
//    cell.row = indexPath.row;
    YMPhotoDateModel * dateModel = self.albumModel.dateArr[indexPath.section];
    YMPhotoModel * model = dateModel.photoModelArray[indexPath.row];
    cell.asset = model.asset;
//    [cell loadImage:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionReusableView *reusableview = nil;
    YMPhotoDateModel * dateModel = self.albumModel.dateArr[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader){
        YMAlbumHeaderReuseableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YMAlbumHeaderReuseableViewID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        headerView.dateModel = dateModel;
        reusableview = headerView;
    }
   
    if (kind == UICollectionElementKindSectionFooter){
        YMAlbumHeaderReuseableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YMAlbumHeaderReuseableViewID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        reusableview = headerView;
    }
    return reusableview;
}



#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 20.f) / 3.f, (kScreenWidth - 20.f) / 3.f);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
  
    return CGSizeMake(kScreenWidth, 80);
 
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 0.02);
}


#pragma mark - Get方法
-(UICollectionView *)albumCollectionView {
    if (!_albumCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5.f;
        layout.minimumInteritemSpacing = 5.f;
        
        _albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _albumCollectionView.delegate = self;
        _albumCollectionView.dataSource = self;
        _albumCollectionView.backgroundColor = [UIColor whiteColor];
        _albumCollectionView.scrollEnabled = YES;
        _albumCollectionView.alwaysBounceVertical = YES;
        
        [_albumCollectionView registerClass:[YMAlbumCollectionViewCell class] forCellWithReuseIdentifier:albumCollectionViewCell];
        
        [_albumCollectionView registerClass:[YMAlbumHeaderReuseableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:YMAlbumHeaderReuseableViewID];
         [_albumCollectionView registerClass:[YMAlbumHeaderReuseableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:YMAlbumHeaderReuseableViewID];
        [self.view addSubview:_albumCollectionView];
    }
    
    return _albumCollectionView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)assetCollectionList{
    if (!_assetCollectionList) {
        _assetCollectionList = [NSMutableArray array];
    }
    return _assetCollectionList;
}

@end
