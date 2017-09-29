//
//  KZTimerPopoverViewController.m
//  KZHintTimer
//
//  Created by kevinzhan(湛杨梦晓) on 25/09/2017.
//  Copyright © 2017 kevinzhan(湛杨梦晓). All rights reserved.
//

#import "KZTimerPopoverViewController.h"

@interface KZTimerPopoverViewController () <NSUserNotificationCenterDelegate>
@property (weak) IBOutlet NSTextField *currentCount;
@property (weak) IBOutlet NSTextField *timeDurationTextField;
@property (strong, nonatomic) NSTimer *theOnlyTimer;
@end
static int count = 0;
@implementation KZTimerPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置通知代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}
//点击操作方法
- (IBAction)pressStandFirstButton:(id)sender {
    count = 0;
    [self universalBeginTimer];
}

- (IBAction)pressSitFirstBtn:(id)sender {
    count = 1;
    [self universalBeginTimer];
}

- (IBAction)pressQuitButton:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)universalBeginTimer {
    NSString *timeString = [self.timeDurationTextField stringValue];
    NSInteger timeValue = 30;
    if ([timeString length] > 0) {
        timeValue = [timeString integerValue];
    }
    if (timeValue < 5) {
        timeValue = 5;
    }
    if (count != 0) {
        //说明是坐姿优先，将时间间距除2
        timeValue = timeValue/2;
    }
    
    [self.theOnlyTimer invalidate];
    __weak typeof (self) weakSelf = self;
    self.theOnlyTimer = [NSTimer scheduledTimerWithTimeInterval:timeValue*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (count % 3 == 0) {
            [weakSelf sendStandNotification];
        }
        if (count %3 == 1) {
            [weakSelf sendSitNotification];
        }
        count++;
    }];
    
    [self sendNotificationWithTimeValue:timeValue];
}

//发送通知操作
- (void)sendNotificationWithTimeValue:(NSInteger) timeValue{
    if (count == 0) {
        [self sendNotificationWithTitle:@"设置成功！~" Information:[NSString stringWithFormat:@"先站起来%ld分钟吧！",timeValue]];
        
    } else {
        [self sendNotificationWithTitle:@"设置成功！~" Information:[NSString stringWithFormat:@"先坐下来%ld分钟吧！",timeValue*2]];
    }
}

- (void)sendStandNotification {
    [self sendNotificationWithTitle:@"换个姿势吧！？🤣" Information:@"起来，不愿做奴隶的人们！~"];
}

- (void)sendSitNotification {
    [self sendNotificationWithTitle:@"换个姿势吧！？🤣" Information:@"坐下，享受被AS支配的恐惧~~~"];
}


- (void) sendNotificationWithTitle:(NSString *)title Information:(NSString *)infomation {
    
    self.currentCount.stringValue = [NSString stringWithFormat:@"当前状态:%@(%d)",count%3==0?@"站着":@"坐着",count];
    
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = title;
    localNotify.informativeText = infomation;
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:localNotify];
}

//通知代理方法
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}


@end
