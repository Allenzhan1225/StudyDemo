//
//  YMThumbnail.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMThumbnail.h"

const NSString * YMThunbnailGenaratedNotification = @"YMThunbnailGenaratedNotification";
@interface YMThumbnail ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CMTime actualTime;
@end


@implementation YMThumbnail
+(instancetype)thumnailWithImage:(UIImage *)image actualTime:(CMTime)time{
    YMThumbnail * thumbnail = [[YMThumbnail alloc] init];
    thumbnail.image = image;
    thumbnail.actualTime = time;
    return thumbnail;
}
@end
