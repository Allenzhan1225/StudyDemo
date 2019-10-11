//
//  YMPlayerView.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMPlayerView.h"
#import "YMOverlayView.h"
#import <AVFoundation/AVFoundation.h>

@interface YMPlayerView ()
@property (nonatomic, strong) YMOverlayView *overlayView;
@end

@implementation YMPlayerView

+(Class)layerClass{
    return [AVPlayerLayer class];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.overlayView.frame = self.bounds;
}

- (id<YMTransport>)transport{
    return self.overlayView;
}

- (id) initWithPlayer:(AVPlayer *)player{
    self = [super initWithFrame:CGRectZero];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [(AVPlayerLayer *)[self layer] setPlayer:player];
        self.overlayView = [[YMOverlayView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.overlayView];
    }
    return self;
}


@end
