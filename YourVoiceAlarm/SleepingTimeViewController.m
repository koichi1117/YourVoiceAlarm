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
    
}


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

@end
