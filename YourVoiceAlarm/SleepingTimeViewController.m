//
//  SleepingTimeViewController.m
//  YourVoiceAlarm
//
//  Created by  koichi-hayashida on 2014/11/07.
//  Copyright (c) 2014年  koichi-hayashida. All rights reserved.
//

#import "SleepingTimeViewController.h"

@interface SleepingTimeViewController ()
{
    AVAudioRecorder *recorder;
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
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.datePickerLabel.text = self.wakeUpTime;
    
//    NSDate *nowDate = [NSDate date];
//    NSDateComponents *nowComponents;
//    nowComponents = [[NSCalendar currentCalendar] components:( NSCalendarUnitHour | NSCalendarUnitMinute ) fromDate:nowDate];
    
    NSDate *time = [NSDate date];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"HH:mm"];
    NSString * timeNow = [form stringFromDate:time];
    _timeNowLabel.text = timeNow;

    
//    NSTimer *alarmTimer = [NSTimer scheduledTimerWithTimeInterval:10
//                                                  target:self
//                                                selector:@selector(alarmTimerEvent:)
//                                                userInfo:nil
//                                                 repeats:YES];

    
//    // アラームのタイマー
//    if ([self currentHour]   == [self datePickerTimeHour] &&
//        [self currentMinute] == [self datePickerTimeMinute])
//    {
//                    NSLog(@"equal");
//                    NSLog(@"%ld", (unsigned long)[self currentHour]);
//                    NSLog(@"%ld", (unsigned long)[self datePickerTimeHour]);
//                    NSLog(@"%ld", (unsigned long)[self currentMinute]);
//                    NSLog(@"%ld", (unsigned long)[self datePickerTimeMinute]);
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
//        [player setDelegate:self];
//        [player play];
//    }
//    else{
//                    NSLog(@"else");
//    }

    
}


//- (void)alarmTimerEvent:(NSTimer *)timer
//
////    if (!recorder.recording) //この中身これで良いのか確かめる。さらにアラームがオンになってるかどうか、という制限もかけなければならないのではないか？しかも、一回再生するのではなくて、永遠に再生してほしい。
//{
//    if ([self currentHour]   == [self datePickerTimeHour] &&
//        [self currentMinute] == [self datePickerTimeMinute])
//    {
//        //            NSLog(@"equal");
//        //            NSLog(@"%ld", (unsigned long)[self currentHour]);
//        //            NSLog(@"%ld", (unsigned long)[self datePickerTimeHour]);
//        //            NSLog(@"%ld", (unsigned long)[self currentMinute]);
//        //            NSLog(@"%ld", (unsigned long)[self datePickerTimeMinute]);
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
//        [player setDelegate:self];
//        [player play];
//    }
//    else{
//        //            NSLog(@"else");
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



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
    
    //    [hourFormatter setLocale:[NSLocale currentLocale]];
    //    [hourFormatter setDateFormat:@"HH"];
    NSString *datePickerHour = [hourFormatter stringFromDate:self.wakeUpTimePicker.date];
    return [datePickerHour intValue];
}

// 指定した時刻(minute)
- (NSInteger)datePickerTimeMinute
{
    NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc] init];
    minuteFormatter.dateFormat = @"mm";
    //    [minuteFormatter setLocale:[NSLocale currentLocale]];
    //    [minuteFormatter setDateFormat:@"mm"];
    NSString *datePickerHour = [minuteFormatter stringFromDate:self.wakeUpTimePicker.date];
    return [datePickerHour intValue];
}





@end
