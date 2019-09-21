//
//  ViewController.m
//  StydyDemo
//
//  Created by 占益民 on 2019/9/18.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "ViewController.h"
#import "YMAudioRecordTool.h"
#import "YMAudioEditTool.h"
#import "YMLameTool.h"
@interface ViewController ()
@property (nonatomic, strong) YMAudioRecordTool *recordTool;
@end

@implementation ViewController
- (IBAction)start:(id)sender {
    self.recordTool =  [YMAudioRecordTool new];
   
    //@"/Users/zhanyimin/Desktop/abc.caf"
    //  /Users/zhanyimin/Desktop/1234.caf
    [self.recordTool startRecordWithAudioRecordPath:@"/Users/zhanyimin/Desktop/1234.caf"];
    
}
- (IBAction)end:(id)sender {
    [self.recordTool stopRecord];
}
- (IBAction)add:(id)sender {
    [YMAudioEditTool addAudio:@"/Users/zhanyimin/Desktop/abc.caf" toAudio:@"/Users/zhanyimin/Desktop/1234.caf" outputPath:@"/Users/zhanyimin/Desktop/add.caf"];
}
- (IBAction)cut:(id)sender {
    
}
- (IBAction)toMP3:(id)sender {
    [YMLameTool audioToMP3:@"/Users/zhanyimin/Desktop/add.caf" withSucceedBlock:^(NSString * _Nonnull outputPath) {
        
    } withFailBlock:^(NSString * _Nonnull error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
