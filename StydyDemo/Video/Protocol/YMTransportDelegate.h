//
//  YMTransportDelegate.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YMTransportDelegate <NSObject>

- (void)play;
- (void)pause;
- (void)stop;

- (void)scrubbingDidStart;
- (void)scrubbedToTime:(NSTimeInterval)time;
- (void)scrubbingDidEnd;

- (void)jumpedToTime:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
