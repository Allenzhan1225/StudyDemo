//
//  YMPlayerView.h
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTransport.h"
NS_ASSUME_NONNULL_BEGIN
@class AVPlayer;
@interface YMPlayerView : UIView
- (id) initWithPlayer:(AVPlayer *)player;

@property (nonatomic, readonly) id <YMTransport> transport;

@end

NS_ASSUME_NONNULL_END
