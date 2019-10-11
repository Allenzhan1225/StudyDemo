//
//  YMTransport.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMTransportDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YMTransport <NSObject>
@property (nonatomic, weak) id <YMTransportDelegate> delegate;
@property (nonatomic, strong) NSArray *subtitles;

- (void)setTitle:(NSString *)title;
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
- (void)setScrubbingTime:(NSTimeInterval)time;
- (void)playbackComplete;
//- (void)setSubtitles:(n)
@end

NS_ASSUME_NONNULL_END
