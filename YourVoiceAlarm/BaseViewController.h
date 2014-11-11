//
//  BaseViewController.h
//  YourVoiceAlarm
//
//  Created by  koichi-hayashida on 2014/11/11.
//  Copyright (c) 2014年  koichi-hayashida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h> // AVFoundationを読み込む

@interface BaseViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate>
{
    AVAudioRecorder *recorder;
    NSArray *pathComponents;
    NSURL *outputFileURL;
}

@property (nonatomic) NSString *wakeUpTime;
@property (nonatomic) UIDatePicker *wakeUpTimePicker;
@property (nonatomic) NSURL *recorderUrl;
@property (nonatomic) NSArray *pathComponents;


- (void)viewDidLoad;

@end
