//
//  YMAlbumCollectionViewCell.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/10.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMAlbumCollectionViewCell.h"
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface YMAlbumCollectionViewCell()
/// 相片
@property (nonatomic, strong) UIImageView *photoImageView;
@end

@implementation YMAlbumCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self photoImageView];
    }
    
    return self;
}

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    CGFloat imageWidth = (kScreenWidth - 20.f) / 5.5;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = NO;
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
//    options.resizeMode = PHImageRequestOptionsResizeModeFast;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(imageWidth * [UIScreen mainScreen].scale, imageWidth * [UIScreen mainScreen].scale)  contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photoImageView.image = result;
            });
        }];
//    });
   

}

//-(void)setImg:(UIImage *)img{
//    _img = img;
//    self.photoImageView.image = img;
//}

#pragma mark - 加载图片
-(void)loadImage:(NSIndexPath *)indexPath {
    NSLog(@"%@",self.asset.localIdentifier);
    CGFloat imageWidth = (kScreenWidth - 20.f) / 5.5;
    self.photoImageView.image = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = NO;
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(imageWidth * [UIScreen mainScreen].scale, imageWidth * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (self.row == indexPath.row) {
            self.photoImageView.image = result;
        }
    }];
}

#pragma mark - Get方法 
-(UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth - 20.f) / 3.f, (kScreenWidth - 20.f) / 3.f)];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:_photoImageView];
    }
    
    return _photoImageView;
}
@end
