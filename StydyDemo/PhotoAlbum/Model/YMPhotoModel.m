//
//  YMPhotoModel.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/10.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMPhotoModel.h"
#import "NSDate+HXExtension.h"
@implementation YMPhotoModel

-(void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        /// 当选择后获取原图
        [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.highDefinitionImage = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }];
    });
}

@end


@implementation  YMPhotoDateModel

#pragma mark — get
-(NSString *)dateString{
    if (!_dateString) {
        NSDateComponents *modelComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay   |
                                             NSCalendarUnitMonth |
                                             NSCalendarUnitYear
                                                                            fromDate:self.date];
        NSUInteger modelMonth = [modelComponents month];
        NSUInteger modelYear  = [modelComponents year];
        NSUInteger modelDay   = [modelComponents day];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%lu-%lu-%lu",
                                                      (unsigned long)modelYear,
                                                      (unsigned long)modelMonth,
                                                      (unsigned long)modelDay]];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay   |
                                        NSCalendarUnitMonth |
                                        NSCalendarUnitYear
                                                                       fromDate:[NSDate date]];
        NSUInteger month = [components month];
        NSUInteger year  = [components year];
        NSUInteger day   = [components day];
        
       
        NSLocale *locale;
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
        
        dateFormatter.locale    = locale;
        dateFormatter.dateStyle = kCFDateFormatterLongStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        
        if (year == modelYear) {
            NSString *longFormatWithoutYear = [NSDateFormatter dateFormatFromTemplate:@"MMMM d"
                                                                              options:0
                                                                               locale:locale];
            [dateFormatter setDateFormat:longFormatWithoutYear];
        }
        NSString *resultString = [dateFormatter stringFromDate:date];
        
        if (year == modelYear && month == modelMonth)
        {
            if (day == modelDay)
            {
                resultString = @"今天";
            }
            else if (day - 1 == modelDay)
            {
                resultString = @"昨天";
            }else if ([self.date hx_isSameWeek]) {
                resultString = [self.date hx_getNowWeekday];
            }
        }
        _dateString = resultString;
    }
    return _dateString;
}
//-(NSArray *)photoModelArray{
//    if (!_photoModelArray) {
//        _photoModelArray = [NSArray array];
//    }
//    return _photoModelArray;
//}
@end
