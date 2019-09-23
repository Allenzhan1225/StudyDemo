//
//  YMGPUImageController.m
//  StydyDemo
//
//  Created by 占益民 on 2019/9/21.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMGPUImageController.h"
#import <GPUImage.h>
#import <GPUImageView.h>
@interface YMGPUImageController ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) GPUImageFilter *filter;
@end

@implementation YMGPUImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIImage * inputImage = [UIImage imageNamed:@"origin"];
    
    UIImageView *originImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,100, 414, 400)];
    originImgView.image = [UIImage imageNamed:@"origin"];
    [self.view addSubview:originImgView];
    
    
    //创建滤镜   //晕影，形成黑色圆形边缘，突出中间图像的效果
    self.filter = [[GPUImageBilateralFilter alloc] init];
//    ((GPUImageMedianFilter *)self.filter).texelWidth = .01f;
//    ((GPUImageMedianFilter *)self.filter).texelHeight = .01f;
    //设置渲染区域
    [self.filter forceProcessingAtSize:inputImage.size];
    [self.filter useNextFrameForImageCapture];
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:inputImage];
    //添加上滤镜
    [stillImageSource addTarget:self.filter];
    //开始渲染
    [stillImageSource processImage];
    //获取渲染后的图片
    UIImage *newImage = [self.filter imageFromCurrentFramebuffer];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,500, 414, 400)];
    self.imgView.image = newImage;
    [self.view addSubview:self.imgView];
    
   
   
}



@end
