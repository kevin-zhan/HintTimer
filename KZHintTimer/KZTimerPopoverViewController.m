//
//  KZTimerPopoverViewController.m
//  KZHintTimer
//
//  Created by kevinzhan(湛杨梦晓) on 25/09/2017.
//  Copyright © 2017 kevinzhan(湛杨梦晓). All rights reserved.
//

#import "KZTimerPopoverViewController.h"

@interface KZTimerPopoverViewController () <NSUserNotificationCenterDelegate>
@property (weak) IBOutlet NSTextField *timeDurationTextField;

@end
static int count = 0;
@implementation KZTimerPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)pressConfirmButton:(id)sender {
    NSString *timeString = [self.timeDurationTextField stringValue];
    NSInteger timeValue = 20;
    if (timeString) {
        timeValue = [timeString integerValue];
    }
    timeValue = timeValue;
    __weak typeof (self) weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:timeValue*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
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
    [NSTimer scheduledTimerWithTimeInterval:timeValue*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
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

- (void)sendNotificationWithTimeValue:(NSInteger) timeValue {
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = @"启动成功！~";
    if (count%2 == 0) {
        localNotify.informativeText = [NSString stringWithFormat:@"先站起来%ld分钟吧！",timeValue];
    }else {
        localNotify.informativeText = [NSString stringWithFormat:@"先坐下来%ld分钟吧！",timeValue*2];
    }
    
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:localNotify];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)sendStandNotification {
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = @"换个姿势吧？🤣";
    localNotify.informativeText = @"起来，不愿做奴隶的人们！~";
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:localNotify];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)sendSitNotification {
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = @"换个姿势吧？🤣";
    localNotify.informativeText = @"坐下，享受被AS支配的恐惧~~~";
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:localNotify];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}


@end
