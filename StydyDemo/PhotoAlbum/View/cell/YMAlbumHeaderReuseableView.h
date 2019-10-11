//
//  YMAlbumHeaderReuseableView.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/11.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMPhotoModel.h"
NS_ASSUME_NONNULL_BEGIN
@class YMPhotoDateModel;
@interface YMAlbumHeaderReuseableView : UICollectionReusableView
@property (nonatomic, strong) YMPhotoDateModel *dateModel;
@end

NS_ASSUME_NONNULL_END
