//
//  YMPlayerController.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YMPlayerView;
@interface YMPlayerController : NSObject
- (id)initWithURL:(NSURL *)assetURL;

//返回 YMPlayerView
@property (nonatomic, strong,readonly) YMPlayerView *playerView;

@end

NS_ASSUME_NONNULL_END
