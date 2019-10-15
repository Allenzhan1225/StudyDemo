//
//  YMAlbumHeaderReuseableView.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/11.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMAlbumHeaderReuseableView.h"

#ifdef __IPHONE_11_0
@interface CustomLayer : CALayer
@end
#endif

#ifdef __IPHONE_11_0
@implementation CustomLayer
- (CGFloat) zPosition {
    return 0;
}
@end
#endif



@interface YMAlbumHeaderReuseableView ()

@property (nonatomic, strong) UILabel *dateLb;

@end

@implementation YMAlbumHeaderReuseableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


-(void)setDateModel:(YMPhotoDateModel *)dateModel{
    _dateModel = dateModel;
    self.dateLb.text = dateModel.dateString;
}

- (void)setupUI{
    [self addSubview:self.dateLb];
}


#pragma mark — lazyload
- (UILabel *)dateLb {
    if (!_dateLb) {
        _dateLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width - 40, 30)];
        _dateLb.textColor = [UIColor blackColor];
        _dateLb.font = [UIFont systemFontOfSize:20];
    }
    return _dateLb;
}

#ifdef __IPHONE_11_0
+ (Class)layerClass {
    return [CustomLayer class];
}
#endif
@end
