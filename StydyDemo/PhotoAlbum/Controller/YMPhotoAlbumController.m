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
#import "YMPhotoViewFlowLayout.h"
#import <Photos/Photos.h>
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
static NSString *const YMAlbumHeaderReuseableViewID = @"YMAlbumHeaderReuseableView";

@interface YMPhotoAlbumController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UICollectionView *albumCollectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) YMAlbumModel *albumModel;
@property (nonatomic, strong) NSMutableArray *assetCollectionList;

@end
static NSString *albumCollectionViewCell = @"YMAlbumCollectionViewCell";
@implementation YMPhotoAlbumController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [PHPhotoLibrary sharedPhotoLibrary]
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*  PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
      PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
                                              // The user cannot change this application’s status, possibly due to active restrictions
                                              //   such as parental controls being in place.
      PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
      PHAuthorizationStatusAuthorized         // User has authorized this application to access photos data.*/
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined:
            NSLog(@"用户还未选择");
            break;
        case PHAuthorizationStatusRestricted:
            NSLog(@"用户受限");
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"用户拒绝");
            break;
        case PHAuthorizationStatusAuthorized:
            NSLog(@"用户已经授权");
            break;
        default:
            break;
    }
 
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){//用户之前已经授权
        //获取所有图片的相册
        [self getAllAlbum];
    }else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied){//用户之前已经拒绝授权
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您之前拒绝了访问相册，请到手机隐私设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertC addAction:sureAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{//弹窗授权时监听
        __weak typeof(self) weakself = self;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){//允许
                [weakself getAllAlbum];//获取数据 刷新视图
            }else{//拒绝
                NSLog(@"用户拒绝访问相册");
            }
        }];
    }
    
    //监听相册变化
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    

}

#pragma mark — PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    PHFetchResultChangeDetails *changeDetial = [changeInstance changeDetailsForFetchResult:self.albumModel.assets];
    PHFetchResult<PHAsset *> * results = [changeDetial fetchResultAfterChanges];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (results.count != self.albumModel.assets.count) {
             [self.albumModel loadDataFromAsset:results];
             [self.albumCollectionView reloadData];
        }
    });
}


#pragma mark — privite
- (void)getAllAlbum{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //获取 All Photos (所有照片相册)
        PHFetchResult<PHAssetCollection *> * cameraRolls = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        
        for (PHAssetCollection * collection in cameraRolls) {
            NSLog(@"相册名称 ---- %@",collection.localizedTitle);
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
//    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    YMPhotoDateModel * dateModel = self.albumModel.dateArr[section];
    
    NSLog(@"section  == %ld , count == %ld",section,dateModel.photoModelArray.count);
    return dateModel.photoModelArray.count;
//    return self.albumModel.photos.count;
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:albumCollectionViewCell forIndexPath:indexPath];
    cell.row = indexPath.row;
    
    YMPhotoDateModel * dateModel = self.albumModel.dateArr[indexPath.section];
    YMPhotoModel * model = dateModel.photoModelArray[indexPath.row];
//     YMPhotoModel * model = self.albumModel.photos[indexPath.row];
//    cell.thumbnailImage = model.thumbnailImage;
    cell.asset = model.asset;
    cell.model= model;
    [cell loadImage:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionReusableView *reusableview = nil;
    YMPhotoDateModel * dateModel = self.albumModel.dateArr[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader){
        YMAlbumHeaderReuseableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YMAlbumHeaderReuseableViewID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.dateModel = dateModel;
        reusableview = headerView;
    }
   
    if (kind == UICollectionElementKindSectionFooter){
        YMAlbumHeaderReuseableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:YMAlbumHeaderReuseableViewID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        reusableview = headerView;
    }
    return reusableview;
}



#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 25.f) / 4.f, (kScreenWidth - 25.f) / 4.f);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
  
    return CGSizeMake(kScreenWidth, 50);
 
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 0.02);
}


#pragma mark - Get方法
-(UICollectionView *)albumCollectionView {
    if (!_albumCollectionView) {
        YMPhotoViewFlowLayout *layout = [[YMPhotoViewFlowLayout alloc] init];
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


-(void)dealloc{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

@end
