//
//  YMCameraController.m
//  StydyDemo
//
//  Created by 占益民 on 2019/9/23.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMCameraController.h"
#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YMCameraController ()<UIGestureRecognizerDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出图片
@property (nonatomic ,strong) AVCaptureStillImageOutput *imageOutput;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;


@property (nonatomic, strong) UIButton *takePictureBtn;//拍摄按钮
@property (nonatomic, strong) UIImageView *imgView;

#pragma mark — 缩放

/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 * 最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;


@end


@implementation YMCameraController
- (void)viewDidLoad {
    
    
  
    UIPinchGestureRecognizer *pan = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:pan];
    
    
    // AVCaptureDevicePositionBack 后置摄像头
    // AVCaptureDevicePositionFront 前置摄像头
    self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    
    self.session = [[AVCaptureSession alloc] init];
    //  拿到的图像的大小可以自行设定
    // AVCaptureSessionPreset320x240
    // AVCaptureSessionPreset352x288
    // AVCaptureSessionPreset640x480
    // AVCaptureSessionPreset960x540
    // AVCaptureSessionPreset1280x720
    // AVCaptureSessionPreset1920x1080
    // AVCaptureSessionPreset3840x2160
    self.session.sessionPreset = AVCaptureSessionPreset3840x2160;
    //输入输出设备结合
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    
    
    //预览层的生成
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
//    CALayer *waterMark = [CALayer layer];
//    waterMark.contents = (id)[UIImage imageNamed:@"123"].CGImage;
//    waterMark.frame = CGRectMake(100, 100, 100, 100);
//    [self.previewLayer addSublayer:waterMark];
    
    [self.view.layer addSublayer:self.previewLayer];
    

    //设备取景开始
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        //自动闪光灯，
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡,但是好像一直都进不去
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
    
     [self.view addSubview:self.takePictureBtn];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}



- (void)takePicture{
    NSLog(@"拍照");
    AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    [_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error = %@",error);
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        
        
        self.imgView.image = image;
        [self.view addSubview:self.imgView];

    }];

}



//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    CGFloat factor = powf(5, recognizer.velocity/20);
    if (self.device.activeFormat.videoMaxZoomFactor > recognizer.velocity && recognizer.velocity >= 1.0) {
        NSError *error;
        if ([self.device lockForConfiguration:&error]) {
            [self.device rampToVideoZoomFactor:recognizer.velocity withRate:4.0];
            [self.device unlockForConfiguration];
        }
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //获取指定连接
    AVCaptureConnection *stillImageConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //设置缩放比例
    [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    
    return YES;
}

- (UIButton *)takePictureBtn{
    if (!_takePictureBtn) {
        _takePictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, 100, 40)];
        _takePictureBtn.backgroundColor = [UIColor redColor];
        [_takePictureBtn setTitle:@"拍照" forState:0];
        
        [_takePictureBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePictureBtn;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, SCREEN_HEIGHT-100, 100, 100)];
    }
    return _imgView;
}

@end
