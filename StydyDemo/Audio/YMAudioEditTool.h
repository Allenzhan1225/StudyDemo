//
//  YMAudioEditTool.h
//  StydyDemo
//
//  Created by 占益民 on 2019/9/19.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMAudioEditTool : NSObject

/**
 音频的拼接

 @param fromPath 第一个音频地址
 @param toPath   后面的音频地址
 @param outputPath 合成后音频的地址
 */
+ (void)addAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath;

/**
 音频的裁剪

 @param audioPath 音频文件地址
 @param fromTime 起始时间
 @param toTime 结束时间
 @param outputPath 裁剪后的音频地址
 */
+ (void)catAudio:(NSString *)audioPath fromTime:(NSUInteger)fromTime toTime:(NSUInteger)toTime outputPath:(NSString *)outputPath;
@end

NS_ASSUME_NONNULL_END
