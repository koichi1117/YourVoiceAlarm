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
//    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    UIDatePicker *datePicker;
    UITextField *wakeUpTimeField;
    NSString *datePickerTime;
}
@property (weak, nonatomic) IBOutlet UILabel *datePickerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeNowLabel;
@property (nonatomic) AVAudioPlayer *audioPlayer;

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

    NSTimer *alarmTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(alarmTimerEvent:)
                                                         userInfo:nil
                                                          repeats:YES];
    

    
    
}


- (void)alarmTimerEvent:(NSTimer *)timer
{
    NSDate *time = [NSDate date];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"HH:mm:ss"];
    NSString *timeNow = [form stringFromDate:time];
    _timeNowLabel.text = timeNow;
    
    if ([self currentHour]   == [self datePickerTimeHour] &&
        [self currentMinute] == [self datePickerTimeMinute])
    {
//                    NSLog(@"equal");
//                    NSLog(@"%ld", (unsigned long)[self currentHour]);
//                    NSLog(@"%ld", (unsigned long)[self datePickerTimeHour]);
//                    NSLog(@"%ld", (unsigned long)[self currentMinute]);
//                    NSLog(@"%ld", (unsigned long)[self datePickerTimeMinute]);
//
//        
        [player play];
        
    }
    else{
//                    NSLog(@"else");
    }
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
