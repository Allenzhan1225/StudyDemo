//
//  YMAudioRecordTool.h
//  StydyDemo
//
//  Created by 占益民 on 2019/9/18.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface YMAudioRecordTool : NSObject

/**录音工具单例*/
//+ (instancetype)shareRecordTool;

/**开始录音*/
- (void)startRecordWithAudioRecordPath:(NSString *)recordPath;
/**结束录音*/
- (void)stopRecord;
/**播放录音*/
- (void)playRecordFile;
/**停止播放*/
- (void)stopPlaying;
/**删除录音文件*/
- (void)deleteRecordFile;
@end

NS_ASSUME_NONNULL_END
