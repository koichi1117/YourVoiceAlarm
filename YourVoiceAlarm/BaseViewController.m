//
//  BaseViewController.m
//  YourVoiceAlarm
//
//  Created by  koichi-hayashida on 2014/11/11.
//  Copyright (c) 2014年  koichi-hayashida. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 録音するためのファイルを用意する
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    pathComponents = [NSArray arrayWithObjects:path, @"MyAudioMemo.m4a", nil];
    // pathComponentsという配列を定義。その中に、ファイルの場所と、ファイルの名前を含めている。nilを書くことで、配列の一番最後だということを示している。
    outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    // outputFileURLで、pathComponentsのURLを作る
    
    // audio sessionを開始する。sessionの種類は、PlayとRecordが出来るようなものに設定。
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}




@end
