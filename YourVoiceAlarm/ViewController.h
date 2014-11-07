//
//  ViewController.h
//  YourVoiceAlarm
//
//  Created by  koichi-hayashida on 2014/10/23.
//  Copyright (c) 2014年  koichi-hayashida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h> // AVFoundationを読み込む
//#import "SleepingTimeViewController.h"

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate>
//UIViewControllerを継承したViewControllerクラス
// AVAudioRecorderDelegateを宣言することで、AVAudioRecorderDelegateプロトコルが使えるようになる。これで、妨害やエラーに対応するようになったり、録音を完了できるようになったりする。
// AVAudioPlayerDelegateを宣言することで、AVAudioPlayerDelegateプロトコルが使えるようになる。これで、妨害やエラーに対応するようになったり、音の再生を完了できるようになったりする。

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopAlarmButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSString *datePickerTime;
@property (strong, nonatomic) IBOutlet UILabel *datePickerLabel;
@property NSTimer *alarmTimer;
@property (weak, nonatomic) IBOutlet UIButton *startAlarmTimer;


@property (strong, nonatomic) IBOutlet UITextField *wakeUpTimeField;
@property (readwrite, retain) UIView *inputView;


- (IBAction)TimeChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *pushStartAlarmButton;

// ViewController.hに@propertyを設定して、
// ViewController.mに@synthesizeを組み合わせて設定することで、
// setterとgetterをコンパイルの前に生成させることができるようになる。
// Xcodeにこれらのボタンを使ってメソッドの中で作用させることを認識させられる。

@property (nonatomic) NSString *wakeUpTime;

@end

