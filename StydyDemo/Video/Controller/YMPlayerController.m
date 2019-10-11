//
//  YMPlayerController.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "YMTransport.h"
#import "YMPlayerView.h"
#import "YMThumbnail.h"

#define STATUS_KEYPATH @"status"
#define REFRESH_INTERVAL 0.5f

static const NSString * PlayerItemStatusContext;


@interface YMPlayerController ()<YMTransportDelegate>
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) YMPlayerView *playerView;

@property (nonatomic, weak) id <YMTransport>transport;

@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) id itemEndObserver;
@property (nonatomic, assign) float lastPlaybackRate;

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;

@end

@implementation YMPlayerController

- (id)initWithURL:(NSURL *)assetURL{
    self = [super init];
    if (self) {
        _asset = [AVAsset assetWithURL:assetURL]; //1
        [self prepareToPlay];
    }
    return self;
}


- (void)prepareToPlay{
    NSArray *keys = @[@"tracks",@"duration",@"commonMetadata",@"availableMediaCharacteristicsWithMediaSelectionOptions"];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];  //2
    [self.playerItem addObserver:self forKeyPath:STATUS_KEYPATH options:0 context:&PlayerItemStatusContext]; //3
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];//4
    self.playerView = [[YMPlayerView alloc] initWithPlayer:self.player];//5
    self.playerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.transport = self.playerView.transport;
    self.transport.delegate = self;
    
}

- (UIView *)getView{
    return self.playerView;
}

#pragma mark — 字幕选择
//获取支持的字幕格式
- (void)loadMediaOptions{
    /*
     AVMediaCharacteristicLegible 字幕
     */
    NSString *mc  = AVMediaCharacteristicLegible;
    AVMediaSelectionGroup *group = [self.asset mediaSelectionGroupForMediaCharacteristic:mc];
    if (group) {
        NSMutableArray *subtitles = [NSMutableArray array];
        for (AVMediaSelectionOption *option in group.options) {
            [subtitles addObject:option.displayName];
        }
        [self.transport setSubtitles:subtitles];
    }else{
        [self.transport setSubtitles:nil];
    }
}

//设置字幕
- (void)subtitleSelected:(NSString *)subtitle{
    NSString *mc = AVMediaCharacteristicLegible;
    AVMediaSelectionGroup *group = [self.asset mediaSelectionGroupForMediaCharacteristic:mc];
    BOOL selected = NO;
    for (AVMediaSelectionOption *option in group.options) {
        if ([option.displayName isEqualToString:subtitle]) {
            [self.playerItem selectMediaOption:option inMediaSelectionGroup:group];
            selected= YES;
        }
    }
    if (!selected) {
        [self.playerItem selectMediaOption:nil inMediaSelectionGroup:group];
    }
}



#pragma mark — imageGenerator
- (void)generatorThumbnails{
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
    self.imageGenerator.maximumSize = CGSizeMake(200.0f, 0.0f);
    CMTime duration = self.asset.duration;
    
    NSMutableArray * times = [NSMutableArray array];
    //增量
    CMTimeValue increment = duration.value / 20;
    CMTimeValue currentValue = 0;
    while (currentValue <= duration.value) {
        CMTime time = CMTimeMake(0, duration.timescale);
        [times addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment;
    }
    
    __block NSUInteger imageCount = times.count;
    __block NSMutableArray *images = [NSMutableArray array];
    
    AVAssetImageGeneratorCompletionHandler  handler = ^(CMTime requestedTime,
                                                       CGImageRef _Nullable imageRef,
                                                       CMTime actualTime,
                                                       AVAssetImageGeneratorResult result,
                                                       NSError * _Nullable error){
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            id thumbnail = [YMThumbnail thumnailWithImage:image actualTime:actualTime];
            [images addObject:thumbnail];
        }else{
            NSLog(@"创建缩略图失败");
        }
        
        if (--imageCount == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:YMThunbnailGenaratedNotification object:images];
            });
        }
        
        [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
    };
}


#pragma mark — delegate
- (void)play{
    [self.player play];
}

- (void)pause{
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
}

- (void)stop{
    self.player.rate = 0.0f;
    [self.transport playbackComplete];
}

- (void)jumpedToTime:(NSTimeInterval)time{
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}


-(void)scrubbingDidStart{
    self.lastPlaybackRate = self.player.rate;
    [self.player pause];
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)scrubbedToTime:(NSTimeInterval)time{
    [self.playerItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void)scrubbingDidEnd{
    [self addPlayerItemTimeObserver];
    if (self.lastPlaybackRate >0.0f) {
        [self.player play];
    }
}

#pragma mark — 时间监听
- (void)addPlayerItemTimeObserver{
    CMTime interval = CMTimeMakeWithSeconds(REFRESH_INTERVAL, NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    __weak YMPlayerController *weakSelf = self;
    
    void(^callBack)(CMTime time) = ^(CMTime time){
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval duration = CMTimeGetSeconds(self.playerItem.duration);
        //设置播放时间
        [weakSelf.transport setCurrentTime:currentTime duration:duration];
    };
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:queue usingBlock:callBack];
}

- (void)addItemEndObserverForPlayerItem{
    NSString * name= AVPlayerItemDidPlayToEndTimeNotification;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    __weak YMPlayerController * weakSelf = self;
    void (^callback) (NSNotification *noti) = ^(NSNotification *noti){
        [weakSelf.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [weakSelf.transport playbackComplete];
            NSLog(@"播放结束");
//            [self.player play];
        }];
    };
    
    self.itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:name object:self.playerItem queue:queue usingBlock:callback];
}


#pragma mark — 监听
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    if (context == &PlayerItemStatusContext) {
        //AVFoundation 没有指定那个线程执行改变通知，所以要回到主线程操作
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
            if (self.playerItem.status == AVPlayerStatusReadyToPlay) {
                //设置监听
                [self addPlayerItemTimeObserver];
                [self addItemEndObserverForPlayerItem];
                
                CMTime duration = self.playerItem.duration;
                //设置播放时间
                [self.transport setCurrentTime:CMTimeGetSeconds(kCMTimeZero) duration:CMTimeGetSeconds(duration)];
                //设置视频标题 self.asset.title
                [self.transport setTitle:@"这是视频标题"];
                [self.player play];
                //创建s缩略图
                [self generatorThumbnails];
                //字幕选择
                [self loadMediaOptions];
            }else{
                NSLog(@"当前播放状态----%ld",self.playerItem.status);
            }
        });
    }
}

#pragma mark — dealloc
- (void)dealloc{
    if (self.itemEndObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        self.itemEndObserver = nil;
    }
}

@end
