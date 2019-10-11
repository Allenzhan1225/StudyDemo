//
//  YMOverlayView.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMOverlayView.h"



@implementation YMOverlayView
@synthesize delegate = _delegate;
@synthesize subtitles = _subtitles;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration{
    
}

- (void)setTitle:(NSString *)title{
    
}

- (void)setScrubbingTime:(NSTimeInterval)time{
    
}
- (void)playbackComplete{
    
}
@end
