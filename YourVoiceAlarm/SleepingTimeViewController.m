//
//  SleepingTimeViewController.m
//  YourVoiceAlarm
//
//  Created by  koichi-hayashida on 2014/11/07.
//  Copyright (c) 2014年  koichi-hayashida. All rights reserved.
//

#import "SleepingTimeViewController.h"
#import "ViewController.h"

@interface SleepingTimeViewController ()
{
    AVAudioPlayer *player;
    UIDatePicker *datePicker;
    UITextField *wakeUpTimeField;
    NSString *datePickerTime;
}
@property (weak, nonatomic) IBOutlet UILabel *datePickerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNowLabel;

@end

@implementation SleepingTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorderUrl error:&error];
    [player setDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.datePickerLabel.text = self.wakeUpTime;

    NSTimer *timeCountTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(timeCountEvent:)
                                                         userInfo:nil
                                                          repeats:YES];

    NSTimer *alarmTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(alarmTimerEvent:)
                                                         userInfo:nil
                                                          repeats:YES];

    NSTimer *popUpTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(popUpEvent:)
                                                         userInfo:nil
                                                          repeats:YES];
}


- (void)timeCountEvent:(NSTimer *)timer
{
    NSDate *time = [NSDate date];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"HH:mm:ss"];
    NSString *timeNow = [form stringFromDate:time];
    _timeNowLabel.text = timeNow;
    
}

- (void)alarmTimerEvent:(NSTimer *)timer
{
    if ([self currentHour]   == [self datePickerTimeHour] &&
        [self currentMinute] == [self datePickerTimeMinute])
    {
        [player play];
        if (![player play]){
            [timer invalidate];
        }
    }
}

- (void)popUpEvent:(NSTimer *)timer
{
    if ([self currentHour]   == [self datePickerTimeHour] &&
        [self currentMinute] == [self datePickerTimeMinute])
    {
        UIAlertView *alarmAlert = [[UIAlertView alloc] initWithTitle:@"アラーム"
                                                             message:@"朝になりました"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"起きる", nil];
        [alarmAlert show];
        if (alarmAlert){
            [timer invalidate];
        }
    }
}

- (void)alarmAlert:(UIAlertView *)alarmAlert clickButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            // 前ページに戻って、アラームをリセットする
//            ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TopPage"];
//            [self presentViewController:controller animated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
    
}



- (void)tappedStopButtonOnPopUp:(id)sender
{
    [player stop];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//現在時刻について/////////////////////////////////////////////
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




// 指定した時刻(hour)
- (NSInteger)datePickerTimeHour
{
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
    hourFormatter.dateFormat = @"HH";
    NSString *datePickerHour = [hourFormatter stringFromDate:self.wakeUpTimePicker.date];
    return [datePickerHour intValue];
}

// 指定した時刻(minute)
- (NSInteger)datePickerTimeMinute
{
    NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc] init];
    minuteFormatter.dateFormat = @"mm";
    NSString *datePickerHour = [minuteFormatter stringFromDate:self.wakeUpTimePicker.date];
    return [datePickerHour intValue];
}





@end
