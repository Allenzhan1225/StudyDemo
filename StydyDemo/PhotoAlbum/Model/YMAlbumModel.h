//
//  YMAlbumModel.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/10.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN
@class YMPhotoModel;
@interface YMAlbumModel : NSObject
/// 相册
@property (nonatomic, strong) PHAssetCollection *collection;
/// 第一个相片
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;

///相片数组
@property (nonatomic, strong) NSMutableArray <YMPhotoModel *>*photos;

//时间数组
@property (nonatomic, strong) NSMutableArray *dateArr;


@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) NSInteger rowCount;


- (void)loadDataFromAsset:(PHFetchResult<PHAsset *> *)assets;
@end

NS_ASSUME_NONNULL_END
