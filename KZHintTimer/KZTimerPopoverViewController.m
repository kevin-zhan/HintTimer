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
    // Do view setup here.
}
//点击操作方法
- (IBAction)pressConfirmButton:(id)sender {
    NSString *timeString = [self.timeDurationTextField stringValue];
    NSInteger timeValue = 20;
    if (timeString) {
        timeValue = [timeString integerValue];
    }
    timeValue = timeValue;
    __weak typeof (self) weakSelf = self;
    [self.theOnlyTimer invalidate];
    self.theOnlyTimer = [NSTimer scheduledTimerWithTimeInterval:timeValue*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (count % 3 == 0) {
            [weakSelf sendStandNotification];
        }
        if (count %3 == 1) {
            [weakSelf sendSitNotification];
        }
        count ++;
    }];
    [self sendNotificationWithTimeValue:timeValue];
}

- (IBAction)pressSitFirstBtn:(id)sender {
    NSString *timeString = [self.timeDurationTextField stringValue];
    NSInteger timeValue = 20;
    if (timeString) {
        timeValue = [timeString integerValue];
    }
    timeValue = timeValue;
    __weak typeof (self) weakSelf = self;
    count = 1;
    [self.theOnlyTimer invalidate];
    self.theOnlyTimer = [NSTimer scheduledTimerWithTimeInterval:timeValue*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (count % 3 == 0) {
            [weakSelf sendStandNotification];
        }
        if (count %3 == 1) {
            [weakSelf sendSitNotification];
        }
        count ++;
    }];
    [self sendNotificationWithTimeValue:timeValue];
}

- (IBAction)pressQuitButton:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

//发送通知操作
- (void)sendNotificationWithTimeValue:(NSInteger) timeValue{
    if (count%2 == 0) {
        [self sendNotificationWithTitle:@"设置成功！~" Information:[NSString stringWithFormat:@"先站起来%ld分钟吧！",timeValue]];
        return;
    }
    [self sendNotificationWithTitle:@"设置成功！~" Information:[NSString stringWithFormat:@"先坐下来%ld分钟吧！",timeValue*2]];
}

- (void)sendStandNotification {
    [self sendNotificationWithTitle:@"换个姿势吧！？🤣" Information:@"起来，不愿做奴隶的人们！~"];
}

- (void)sendSitNotification {
    [self sendNotificationWithTitle:@"换个姿势吧！？🤣" Information:@"坐下，享受被AS支配的恐惧~~~"];
}


- (void) sendNotificationWithTitle:(NSString *)title Information:(NSString *)infomation {
    
    self.currentCount.stringValue = [NSString stringWithFormat:@"当前状态:%@",count%2==0?@"站着":@"坐着"];
    
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = title;
    localNotify.informativeText = infomation;
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:localNotify];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
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
