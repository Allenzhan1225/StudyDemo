//
//  YMAudioEditTool.m
//  StydyDemo
//
//  Created by 占益民 on 2019/9/19.
//  Copyright © 2019 占益民. All rights reserved.
//

/**
AVAsset：音频源
AVAssetTrack：素材的轨道
AVMutableComposition ：一个用来合成音频的"合成器"
AVMutableCompositionTrack ："合成器"中的轨道，里面可以插入各种对应的素材
 AVAssetExportSession : 导出
 **/

#import "YMAudioEditTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation YMAudioEditTool


/**
 音频的拼接
 
 @param fromPath 第一个音频地址
 @param toPath   后面的音频地址
 @param outputPath 合成后音频的地址
 */
+ (void)addAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath{
    //1.获得音频源
    AVAsset *fromAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:fromPath]];
    AVAsset *toAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:toPath]];
    
    //2.获得音频轨道
    AVAssetTrack *fromAudioTrack = [[fromAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    AVAssetTrack *toAudioTrack = [[toAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    //3.初始化音频合成器、添加一个空素材
    AVMutableComposition * composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    
    //4.向容器素材中插入音轨素材
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, toAsset.duration) ofTrack:toAudioTrack atTime:kCMTimeZero error:nil];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, fromAsset.duration) ofTrack:fromAudioTrack atTime:toAsset.duration error:nil];
    
    //导出
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetPassthrough];
//    [exportSession supportedFileTypes];
    exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
    // 导出类型
    exportSession.outputFileType = AVFileTypeCoreAudioFormat;
    // 6. 开始导出数据
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        AVAssetExportSessionStatus status = exportSession.status;
        /**
         AVAssetExportSessionStatusUnknown,
         AVAssetExportSessionStatusWaiting,
         AVAssetExportSessionStatusExporting,
         AVAssetExportSessionStatusCompleted,
         AVAssetExportSessionStatusFailed,
         AVAssetExportSessionStatusCancelled
         */
        switch (status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"未知状态");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"等待导出");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"导出中");
                break;
            case AVAssetExportSessionStatusCompleted:{
                NSLog(@"导出成功，路径是：%@", outputPath);
            }
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"导出失败");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"取消导出");
                break;
            default:
                break;
        }
    }];

}

/**
 音频的裁剪
 
 @param audioPath 音频文件地址
 @param fromTime 起始时间T
 @param toTime 结束时间
 @param outputPath 裁剪后的音频地址
 */
+ (void)catAudio:(NSString *)audioPath fromTime:(NSUInteger)fromTime toTime:(NSUInteger)toTime outputPath:(NSString *)outputPath{
    // 1. 获取音频源
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    
    // 2. 创建一个音频会话, 并且,设置相应的配置
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    session.outputFileType = AVFileTypeAppleM4A;
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    CMTime startTime = CMTimeMake(fromTime, 1);
    CMTime endTime = CMTimeMake(toTime, 1);
    session.timeRange = CMTimeRangeFromTimeToTime(startTime, endTime);
    // 3. 导出
    [session exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = session.status;
        if (status == AVAssetExportSessionStatusCompleted)
        {
           NSLog(@"导出成功，路径是：%@", outputPath);
        }
    }];
}
@end
