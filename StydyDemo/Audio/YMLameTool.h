//
//  YMLameTool.h
//  StydyDemo
//
//  Created by 占益民 on 2019/9/20.
//  Copyright © 2019 占益民. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMLameTool : NSObject
+ (void)audioToMP3:(NSString *)sourcePath withSucceedBlock:(void(^)(NSString *outputPath))success withFailBlock:(void(^)(NSString *error))fail;
@end

NS_ASSUME_NONNULL_END
