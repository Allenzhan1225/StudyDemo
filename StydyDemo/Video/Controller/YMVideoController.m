//
//  YMVideoController.m
//  StydyDemo
//
//  Created by 占益民 on 2019/10/8.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMVideoController.h"
#import "YMPlayerController.h"
@interface YMVideoController ()
@property (nonatomic, strong) YMPlayerController *manager;
@end

@implementation YMVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[YMPlayerController alloc] initWithURL:[NSURL URLWithString:@"http://vfx.mtime.cn/Video/2019/03/19/mp4/190319222227698228.mp4"]];
    [self.view addSubview:self.manager.playerView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
