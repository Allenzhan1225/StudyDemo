//
//  YMTextToAudioPlay.m
//  StydyDemo
//
//  Created by 占益民 on 2019/9/26.
//  Copyright © 2019 占益民. All rights reserved.
//

#import "YMTextToAudioPlay.h"
#import <AVFoundation/AVFoundation.h>
@implementation YMTextToAudioPlay
- (void)textToAudio:(NSString *)text{
    //初略实现，具体要研究可以查看相关资料
    //相关文章 https://www.jianshu.com/p/0c4a3aa467fa
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc] initWithString:@"The 1896 Cedar Keys hurricane was a powerful tropical cyclone that devastated much of the East Coast of the United States, starting with Florida's Cedar Keys, near the end of September. The storm's rapid movement allowed it to maintain much of its intensity after  最近做项目时使用到要将一段文本通过按钮点击控制转换成语音朗读，之前一直不知道系统有这个功能，所以今记录下来，以便于下次使用。之前自己的项目中曾经使用过讯飞的文字转语音技术，但是通过实际测试，发现它的免费在线转语音不是很好，受网络的影响声音经常断断续续的；而它的离线转语音价格有太贵，最便宜的要8000RMB/2000装机量，令许多开发者望而止步。那么既然支付不了讯飞那昂贵的费用，iOS自带的文字转语音也是我们不错的选择，只是他的发音效果不够理想，不过还可以接受。在iOS7之前，想要实现语音播报文字内容，可能需要第三方资源库来实现。现在在iOS7之后，系统为我们提供了语音播报文字的功能，我们不仅可以播报英语内容，也可以播报汉语文字。"];
    //设置发音，这是中文普通话
    NSString * preferredLang = @"zh-CN";
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:[NSString stringWithFormat:@"%@",preferredLang]];
    utterance.voice = voice;
    utterance.rate = 0.5;
    [synthesizer speakUtterance:utterance];
}
@end
