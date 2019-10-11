//
//  YMAlbumModel.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/10.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMAlbumModel.h"
#import "YMPhotoModel.h"
#import "NSDate+HXExtension.h"
@implementation YMAlbumModel
-(void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    //按时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    // 获得某个相簿中的所有PHAsset对象
    self.assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    
    NSMutableArray *dateArray = [NSMutableArray array];
    NSDate *currentIndexDate;
    NSMutableArray *sameDayArr;
    
    YMPhotoDateModel *dateModel;
    
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
            dateModel.photoModelArray = sameDayArr;
        }else{
            if ([dateModel.date hx_isSameDay:currentIndexDate]) {
//                [sameDayArr addObject:photoModel];
                [dateModel.photoModelArray addObject:photoModel];
            }else {
//                sameDayArr = [NSMutableArray array];
                dateModel = [[YMPhotoDateModel alloc] init];
                dateModel.date = photoModel.asset.creationDate;
                dateModel.photoModelArray = @[].mutableCopy;
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
