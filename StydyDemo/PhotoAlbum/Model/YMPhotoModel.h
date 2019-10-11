//
//  YMPhotoModel.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/10.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface YMPhotoModel : NSObject
/// 相片
@property (nonatomic, strong) PHAsset *asset;
/// 高清图
@property (nonatomic, strong) UIImage *highDefinitionImage;

/**  位置信息 - 如果当前天数内包含带有位置信息的资源则有值 */
@property (strong, nonatomic) CLLocation * _Nullable location;

@end


@interface YMPhotoDateModel : NSObject
/**  日期信息 */
@property (strong, nonatomic) NSDate *_Nullable date;
/**  日期信息字符串 */
@property (copy, nonatomic) NSString *_Nullable dateString;
/**  同一天的资源数组 */
@property (strong, nonatomic) NSMutableArray * _Nullable photoModelArray;

@end

NS_ASSUME_NONNULL_END
