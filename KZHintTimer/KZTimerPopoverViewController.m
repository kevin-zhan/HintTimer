//
//  KZTimerPopoverViewController.m
//  KZHintTimer
//
//  Created by kevinzhan(湛杨梦晓) on 25/09/2017.
//  Copyright © 2017 kevinzhan(湛杨梦晓). All rights reserved.
//

#import "KZTimerPopoverViewController.h"
typedef NS_ENUM(NSInteger, KZWorkPositionSytle) {
    KZWorkPositionSytleStand = 0,
    KZWorkPositionSytleSit = 1,
} NS_ENUM_AVAILABLE(10_8, NA);

@interface KZTimerPopoverViewController () <NSUserNotificationCenterDelegate,NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *standTimeDurationTextField;
@property (weak) IBOutlet NSTextField *sitTimeDurationTextField;
@property (weak) IBOutlet NSTextField *currentCount;
@property (strong, nonatomic) NSTimer *theOnlyTimer;
@property (assign, nonatomic) NSInteger standTime;
@property (assign, nonatomic) NSInteger sitTime;
@property (assign, atomic) KZWorkPositionSytle currentWorkPositionStyle;
@end
@implementation KZTimerPopoverViewController
static int count = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置通知代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    [self.standTimeDurationTextField setTag:0];
    [self.sitTimeDurationTextField setTag:1];
    [self.standTimeDurationTextField setDelegate:self];
    [self.sitTimeDurationTextField setDelegate:self];
}
//点击操作方法
- (IBAction)pressStandFirstButton:(id)sender {
    [self refreshTextFieldInfomation];
    self.currentWorkPositionStyle = KZWorkPositionSytleStand;
    [self universalBeginTimer];
}

- (IBAction)pressSitFirstBtn:(id)sender {
    [self refreshTextFieldInfomation];
    self.currentWorkPositionStyle = KZWorkPositionSytleSit;
    [self universalBeginTimer];
}

- (IBAction)pressQuitButton:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

//启动timer
- (void)universalBeginTimer {
    count = 0;
    [self.theOnlyTimer invalidate];
    __weak typeof (self) weakSelf = self;
    self.theOnlyTimer = [NSTimer scheduledTimerWithTimeInterval:1*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        count ++;
        int canSit = count % self.standTime;
        int canStand = count % self.sitTime;
        if ((canSit != 0) && (canStand != 0)) {
            return;
        }
        if (self.currentWorkPositionStyle == KZWorkPositionSytleStand) {
            if (canSit == 0) {
                count = 0;
                [weakSelf sendSitNotification];
            }
        } else {
            if (canStand == 0) {
                count = 0;
                [weakSelf sendStandNotification];
            }
        }
    }];
    [self sendSettingSuccessNotification];
}

//发送通知操作
- (void)sendSettingSuccessNotification{
    if (self.currentWorkPositionStyle == KZWorkPositionSytleStand) {
        [self sendNotificationWithTitle:@"设置成功！~" Information:[NSString stringWithFormat:@"先站起来%ld分钟吧！",self.standTime]];
    } else {
        [self sendNotificationWithTitle:@"设置成功！~" Information:[NSString stringWithFormat:@"先坐下来%ld分钟吧！",self.sitTime]];
    }
}

- (void)sendStandNotification {
    self.currentWorkPositionStyle = KZWorkPositionSytleStand;
    [self sendNotificationWithTitle:@"换个姿势吧！？🤣" Information:@"起来，不愿做奴隶的人们！~"];
}

- (void)sendSitNotification {
    self.currentWorkPositionStyle = KZWorkPositionSytleSit;
    [self sendNotificationWithTitle:@"换个姿势吧？!🤣" Information:@"坐下，享受被AS支配的恐惧~~~"];
}


- (void) sendNotificationWithTitle:(NSString *)title Information:(NSString *)infomation {
    
    self.currentCount.stringValue = [NSString stringWithFormat:@"当前状态:%@",self.currentWorkPositionStyle == KZWorkPositionSytleStand?@"站着":@"坐着"];
    
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = title;
    localNotify.informativeText = infomation;
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    
    localNotify.actionButtonTitle = @"OK~";
    
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:localNotify];
}

//控制textfield
- (void)refreshTextFieldInfomation {
    self.standTime = [self getTimeIntegerFromString:self.standTimeDurationTextField.stringValue];
    self.sitTime = [self getTimeIntegerFromString:self.sitTimeDurationTextField.stringValue];
    if (self.sitTime + self.standTime == 0) {
        self.standTime = 20;
    }
    if (self.sitTime == 0) {
        self.sitTime = self.standTime * 2;
    }
    if (self.standTime == 0) {
        self.standTime = self.sitTime / 2;
    }
    self.sitTimeDurationTextField.stringValue = [NSString stringWithFormat:@"%ld",self.sitTime];
    self.standTimeDurationTextField.stringValue = [NSString stringWithFormat:@"%ld",self.standTime];
}

- (NSInteger)getTimeIntegerFromString:(NSString *) timeString {
    NSInteger timeValue = 0;
    if ([timeString length] > 0) {
        timeValue = [timeString integerValue];
    }
    return timeValue;
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
