//
//  YMAudioRecordTool.m
//  StydyDemo
//
//  Created by 占益民 on 2019/9/18.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMAudioRecordTool.h"

@interface  YMAudioRecordTool ()
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, copy) NSString *recorderFileStr;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


@end

@implementation YMAudioRecordTool
#pragma mark - 单例 
/**录音工具单例*/
//static YMAudioRecordTool *instance = nil;
//+ (instancetype)shareRecordTool{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (instance == nil) {
//            instance = [[self alloc] init];
//        }
//    });
//    return instance;
//}
//+ (instancetype)allocWithZone:(struct _NSZone *)zone{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (instance == nil) {
//            instance = [[self alloc] init];
//        }
//    });
//    return instance;
//}



/**开始录音*/
- (void)startRecordWithAudioRecordPath:(NSString *)recordPath{
    if (!recordPath) {
        return ;
    }
    self.recorderFileStr = recordPath;
    // 准备录音
    [self.recorder prepareToRecord];
    // 开始录音
    [self.recorder record];
    
}
/**结束录音*/
- (void)stopRecord{
    [self.recorder stop];
}
/**播放录音*/
- (void)playRecordFile{
    [self.recorder stop];
    if ([self.audioPlayer isPlaying]) return;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}
/**停止播放*/
- (void)stopPlaying{
    [_audioPlayer stop];
}
/**删除录音文件*/
- (void)deleteRecordFile{
    [self.recorder stop];
    [self.recorder deleteRecording];
}


#pragma mark — lazyload
- (AVAudioRecorder *)recorder{
    if (!_recorder) {
        // 0. 设置录音会话
        /**
         AVAudioSessionCategoryPlayAndRecord: 可以边播放边录音(也就是平时看到的背景音乐)
         */
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        //启动会话
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        //1.设置r录音存放的位置
        NSURL *url = [NSURL fileURLWithPath:self.recorderFileStr];
        
        //2. 设置录音参数
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        //设置编码格式
        /**
         kAudioFormatLinearPCM: 无损压缩，内容非常大
         */
        [settings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置采样率 必须保证和转码设置的相同
        [settings setValue:@(11025.0) forKey:AVSampleRateKey];
        //通道数
        [settings setValue:@(1) forKey:AVNumberOfChannelsKey];
        //音频质量,采样质量(音频质量越高，文件的大小也就越大)
        [settings setValue:@(AVAudioQualityMin) forKey:AVEncoderAudioQualityKey];

        
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
        _recorder.meteringEnabled = YES;
    }
    return _recorder;
}

- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.recorderFileStr] error:nil];
    }
    return _audioPlayer;
}

@end
