//
//  YMAlbumModel.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/10.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMAlbumModel.h"
#import "YMPhotoModel.h"
#import <UIKit/UIKit.h>
#import "NSDate+HXExtension.h"
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@implementation YMAlbumModel
-(void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    //按时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    // 获得某个相簿中的所有PHAsset对象
//    self.assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
   
    [self loadDataFromAsset:[PHAsset fetchAssetsWithOptions:options]];
}

- (void)loadDataFromAsset:(PHFetchResult<PHAsset *> *)assets{
    self.assets = assets;
    [self.dateArr removeAllObjects];
    [self.photos removeAllObjects];
    
     NSMutableArray *dateArray = [NSMutableArray array];
        NSDate *currentIndexDate;
        NSMutableArray *sameDayArr;
        
        YMPhotoDateModel *dateModel;
//        PHCachingImageManager * manage = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
//        CGFloat imageWidth = (kScreenWidth - 20.f) / 5.5;
//        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//        // 同步获得图片, 只会返回1张图片
//        options.synchronous = NO;
    //    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    //    options.resizeMode = PHImageRequestOptionsResizeModeFast;

//        [manage startCachingImagesForAssets:assets targetSize:CGSizeMake(imageWidth * [UIScreen mainScreen].scale, imageWidth * [UIScreen mainScreen].scale)  contentMode:PHImageContentModeDefault options:options];
        
        for (PHAsset *asset in self.assets) {
            YMPhotoModel * photoModel = [[YMPhotoModel alloc] init];
            photoModel.asset = asset;
            photoModel.location = asset.location;
            if (!currentIndexDate) {
    //            sameDayArr = [NSMutableArray array];
                dateModel = [[YMPhotoDateModel alloc] init];
                dateModel.date = photoModel.asset.creationDate;
                dateModel.photoModelArray = @[].mutableCopy;
                [dateArray addObject:dateModel];
    //            [sameDayArr addObject:photoModel];
                [dateModel.photoModelArray addObject:photoModel];
                [self.dateArr addObject:dateModel];
    //            dateModel.photoModelArray = sameDayArr;
            }else{
                if ([photoModel.asset.creationDate hx_isSameDay:currentIndexDate]) {
    //                [sameDayArr addObject:photoModel];
                    [dateModel.photoModelArray addObject:photoModel];
                }else {
    //                sameDayArr = [NSMutableArray array];
                    dateModel = [[YMPhotoDateModel alloc] init];
                    dateModel.date = photoModel.asset.creationDate;
                    dateModel.photoModelArray = @[].mutableCopy;
                    [dateModel.photoModelArray addObject:photoModel];
    //                dateModel.photoModelArray = sameDayArr;
                    [sameDayArr addObject:photoModel];
                    [dateArray addObject:dateModel];
                    [self.dateArr addObject:dateModel];
                }
            }
            currentIndexDate = photoModel.asset.creationDate;
            
            [self.photos addObject:photoModel];
        }
}


#pragma mark — get
- (NSMutableArray<YMPhotoModel *> *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

-(NSMutableArray *)dateArr{
    if (!_dateArr) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}

@end
