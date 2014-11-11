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
    NSString *datePickerTime;
    UILabel *datePickerLabel;
    NSArray *pathComponents;
    NSURL *outputFileURL;
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    pathComponents = [NSArray arrayWithObjects:path, @"MyAudioMemo.m4a", nil];
    // pathComponentsという配列を定義。その中に、ファイルの場所と、ファイルの名前を含めている。nilを書くことで、配列の一番最後だということを示している。
    outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
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
    [playButton setEnabled:YES];
    [recordPauseButton setEnabled:YES];
    [stopButton setEnabled:NO];

}





// ここからdatePickerについて-------------------------------------------------------------------------------------------------------
- (void)TimeChanged:(id)sender
{
    // 日付の表示形式を設定
    NSDateFormatter *dF = [[NSDateFormatter alloc] init];
    dF.dateFormat = @"HH:mm";
    datePickerTime = [dF stringFromDate:datePicker.date];
    datePickerLabel.text = datePickerTime;
    NSLog(@"%ld", (unsigned long)[self datePickerTime]);

}




// 止めるボタンを押すと止まるメソッド
- (IBAction)stopAlarm:(id)sender
{
    [player stop];
}


// ページ遷移の時に値を渡すためのメソッド
// ページ遷移に名前をつける
- (IBAction)pushStartAlarmButton:(id)sender
{
    [self performSegueWithIdentifier:@"goToSleepingTimeView" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToSleepingTimeView"])
    {
        ViewController *viewCon = segue.destinationViewController;
        viewCon.wakeUpTime = datePickerTime;
        viewCon.wakeUpTimePicker = datePicker;
        viewCon.recorderUrl = recorder.url;
        
        
    
        
    }
}


@end
