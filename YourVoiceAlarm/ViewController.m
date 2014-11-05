//
//  ViewController.m
//  YourVoiceAlarm
//
//  Created by  koichi-hayashida on 2014/10/23.
//  Copyright (c) 2014年  koichi-hayashida. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    // インスタンス変数を定義する-------------------------------------------------------------------------------------------
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    UIDatePicker *datePicker;
    UITextField *wakeUpTimeField;
}
@end

// ここから実装部分-------------------------------------------------------------------------------------------------------
@implementation ViewController
@synthesize recordPauseButton, stopButton, playButton, stopAlarmButton, datePicker, datePickerTime, datePickerLabel, alarmTimer, startAlarmTimer, wakeUpTimeField, inputView;



// 画面が表示された時に呼び出される
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    // 録音するためのファイルを用意する
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"MyAudioMemo.m4a", nil];
    // pathComponentsという配列を定義。その中に、ファイルの場所と、ファイルの名前を含めている。nilを書くことで、配列の一番最後だということを示している。
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    // outputFileURLで、pathComponentsのURLを作る
    
    // audio sessionを開始する。sessionの種類は、PlayとRecordが出来るようなものに設定。
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // レコーダーの設定
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init]; // NSMutableDictionaryはNSDictionaryの子クラス。キー値と要素を対で保持する配列クラス。変更可能なものとする。
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    // レコーダーを初期化する
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL]; //初期化の中で保存する場所を設定する。上でセットしたURLでその場所を教える。
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    

    
    // ここから時間の表示&設定
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    
    // wakeUpTimeFieldを編集したら、datePickerを呼び出す
    [datePicker addTarget:self action:@selector(wakeUpTimeField) forControlEvents:UIControlEventValueChanged];
    
    // wakeUpTimeFieldの入力をdatePickerに設定
    wakeUpTimeField.inputView = datePicker;
    
    // Delegationの設定
    wakeUpTimeField.delegate = self;
    
    // DoneボタンとそのViewの作成
    UIToolbar *keyboardDoneBuutonView = [[UIToolbar alloc] init];
    keyboardDoneBuutonView.barStyle = UIBarStyleBlack;
    keyboardDoneBuutonView.translucent = YES;
    keyboardDoneBuutonView.tintColor = nil;
    [keyboardDoneBuutonView sizeToFit];
    
    //　DoneボタンとSpacerのセットを用意
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(updateWakeUpTimeField:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneBuutonView setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    
    // Viewの配置
    wakeUpTimeField.inputAccessoryView = keyboardDoneBuutonView;
    
    [self.view addSubview:wakeUpTimeField];
    
    //
    [datePicker addTarget:self action:@selector(TimeChanged:) forControlEvents:UIControlEventValueChanged];

    

}


#pragma mark datePickerの編集が完了（Done）したら、結果をwakeUpTimeFieldに表示
- (void)updateWakeUpTimeField:(id)sender
{
//    datePicker = (UIDatePicker *)sender;
    NSLog(@"あああああああああああああああああ");
    wakeUpTimeField.text = datePickerTime;
    [wakeUpTimeField resignFirstResponder];
    
}



// 一時停止ボタンが押された時に呼び出される
- (IBAction)recordPauseTapped:(id)sender
{
    if(!recorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [recorder record];
        [recordPauseButton setTitle:@"Paused" forState:UIControlStateNormal]; // forState:UIControlStateNomalは「ボタンが有効な時は」という意味。http://iphone-tora.sakura.ne.jp/uibutton.html参照。
    }
    else {
        [recorder pause];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}



// 録音終了ボタンが押された時に呼び出される
- (IBAction)stopTapped:(id)sender
{
    [recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}


// 録音が終わってから呼び出される
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    UIAlertView *alart = [[UIAlertView alloc] initWithTitle: @""
                                                    message: @"Your voice recorded!!"
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    
    [alart show];

    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];

}


// 再生ボタンが押された時に呼び出される
- (IBAction)playTapped:(id)sender
{
    if (!recorder.recording)
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        
        [playButton setEnabled:NO];
        [recordPauseButton setEnabled:NO];
        [stopButton setEnabled:NO];
    }
}


// 再生が終わった時に呼び出される
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    UIAlertView *alart = [[UIAlertView alloc] initWithTitle: @""
//                                                    message: @"Your voice recorded!!"
//                                                   delegate: nil
//                                          cancelButtonTitle: @"OK"
//                                          otherButtonTitles: nil];
//    
//    [alart show];

    [playButton setEnabled:YES];
    [recordPauseButton setEnabled:YES];
    [stopButton setEnabled:NO];

}





// ここからdatePickerについて-------------------------------------------------------------------------------------------------------

//// datePickerの初期化
//- (void)pickerDidLoad
//{
//    [super viewDidLoad];
//    
//    // datePickerのイニシャライザー
//    datePicker = [[UIDatePicker alloc] init];
//    NSLog(@"あああ");
//}
//


// datePickerの時間を取り込むメソッド
//- (IBAction)getAlarmTime:(id)sender
//{
////    datePicker = [[UIDatePicker alloc] init];
//    [datePicker addTarget:self action:@selector(TimeChanged:) forControlEvents:UIControlEventValueChanged];
//}

- (void)TimeChanged:(id)sender
{
    // 日付の表示形式を設定
    NSDateFormatter *dF = [[NSDateFormatter alloc] init];
    dF.dateFormat = @"HH:mm";
    datePickerTime = [dF stringFromDate:datePicker.date];
    datePickerLabel.text = datePickerTime;
    NSLog(@"%ld", (unsigned long)[self datePickerTime]);

}


// 設定した時間が、今の時間と一緒か確かめる-----------------------------------------------------------

// 指定した時刻(hour)
- (NSInteger)datePickerTimeHour
{
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
    hourFormatter.dateFormat = @"HH";
    
//    [hourFormatter setLocale:[NSLocale currentLocale]];
//    [hourFormatter setDateFormat:@"HH"];
    NSString *datePickerHour = [hourFormatter stringFromDate:datePicker.date];
    return [datePickerHour intValue];
}

// 指定した時刻(minute)
- (NSInteger)datePickerTimeMinute
{
    NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc] init];
    minuteFormatter.dateFormat = @"mm";
//    [minuteFormatter setLocale:[NSLocale currentLocale]];
//    [minuteFormatter setDateFormat:@"mm"];
    NSString *datePickerHour = [minuteFormatter stringFromDate:datePicker.date];
    return [datePickerHour intValue];
}

//現在時刻のコンポーネント
- (NSDateComponents *)currentDateComponents
{
    //現在の時刻を取得
    NSDate *nowDate = [NSDate date];
    
    //現在時刻のコンポーネント定義
    NSDateComponents *nowComponents;
    nowComponents = [[NSCalendar currentCalendar] components:( NSCalendarUnitHour | NSCalendarUnitMinute ) fromDate:nowDate];
    return nowComponents;
}


// 現在の時間(hour)
- (NSInteger)currentHour
{
    NSDateComponents *currentTimeComponents = [self currentDateComponents];
    return currentTimeComponents.hour;
}

// 現在の時間(minute)
- (NSInteger)currentMinute
{
    NSDateComponents *currentTimeComponents = [self currentDateComponents];
    return currentTimeComponents.minute;
}

//// 設定した時刻が、現在時刻であるかどうか
//- (BOOL)isCurrentTime
//{
//    return ([self currentHour] == [self datePickerTimeHour] &&
//            [self currentMinute] == [self datePickerTimeMinute]);
//}
//
// -----------------------------------------------------------設定した時間が、今の時間と一緒か確かめる

// アラームタイマー開始

- (IBAction)pushStartAlarm:(id)sender
{
    alarmTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                  target:self
                                                selector:@selector(alarmTimerEvent:)
                                                userInfo:nil
                                                 repeats:YES];
}


// アラームの再生メソッド
- (void)alarmTimerEvent:(NSTimer *)timer

//    if (!recorder.recording) //この中身これで良いのか確かめる。さらにアラームがオンになってるかどうか、という制限もかけなければならないのではないか？しかも、一回再生するのではなくて、永遠に再生してほしい。
    {
        if ([self currentHour]   == [self datePickerTimeHour] &&
            [self currentMinute] == [self datePickerTimeMinute])
        {
//            NSLog(@"equal");
//            NSLog(@"%ld", (unsigned long)[self currentHour]);
//            NSLog(@"%ld", (unsigned long)[self datePickerTimeHour]);
//            NSLog(@"%ld", (unsigned long)[self currentMinute]);
//            NSLog(@"%ld", (unsigned long)[self datePickerTimeMinute]);
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
            [player setDelegate:self];
            [player play];
        }
        else{
//            NSLog(@"else");
        }
    }




// 止めるボタンを押すと止まるメソッド
- (IBAction)stopAlarm:(id)sender
{
    [player stop];
}



@end
