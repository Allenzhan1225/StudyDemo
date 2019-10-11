//
//  YMThumbnail.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

extern const NSString * YMThunbnailGenaratedNotification;

@interface YMThumbnail : NSObject
@property (nonatomic, strong,readonly) UIImage *image;
@property (nonatomic, assign,readonly) CMTime actualTime;

+(instancetype)thumnailWithImage:(UIImage *)image actualTime:(CMTime )time;
@end

NS_ASSUME_NONNULL_END
