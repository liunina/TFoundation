//
//  TAudioPlayer.m
//  TFoundation
//
//  Created by liu nian on 2020/3/28.
//

#import "TAudioPlayer.h"
#import <AudioToolBox/AudioToolbox.h>
#import "TFoundationLogging.h"

@implementation TAudioPlayer

+ (void)playSoundWithFileName:(NSString *)aFileName
				   bundleName:(NSString *)aBundleName
					   ofType:(NSString *)ext
					 andAlert:(BOOL)alert {
	
    NSBundle *bundle = [NSBundle mainBundle];
    if (aBundleName.length) {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:aBundleName withExtension:@"bundle"]];
    }
	NSAssert(bundle, @"aBundleName must be true!");
    NSString *path = [bundle pathForResource:aFileName ofType:ext];
    NSAssert(path, @"play sound cannot find file!");
    NSURL *urlFile = [NSURL fileURLWithPath:path];
    
    // 声明需要播放的音频文件ID[unsigned long]
    SystemSoundID ID;
    
    // 创建系统声音，同时返回一个ID
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlFile, &ID);
    
    if (err) {
        TFLogError(@"play sound cannot create file url [%@]",urlFile);
        return ;
    }
    
    // 根据ID播放自定义系统声音
    if (alert) {
        AudioServicesPlayAlertSound(ID);
    }else {
        AudioServicesPlaySystemSound(ID);
    }
}

@end
