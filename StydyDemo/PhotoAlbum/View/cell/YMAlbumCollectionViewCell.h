//
//  YMAlbumCollectionViewCell.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/10.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface YMAlbumCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) PHAsset *asset;
/// 行数
@property (nonatomic, assign) NSInteger row;
#pragma mark - 加载图片
-(void)loadImage:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
