//
//  AppDelegate.m
//  KZHintTimer
//
//  Created by kevinzhan(湛杨梦晓) on 25/09/2017.
//  Copyright © 2017 kevinzhan(湛杨梦晓). All rights reserved.
//

#import "AppDelegate.h"
#import "KZTimerPopoverViewController.h"

@interface AppDelegate ()
@property(nonatomic,strong) NSStatusItem *demoItem;
@property(nonatomic,strong) NSPopover *popoverView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // 配置status item
    self.demoItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSImage *image = [NSImage imageNamed:@"status_logo"];
    [self.demoItem.button setImage:image];
    
    // 配置弹窗
    self.popoverView = [[NSPopover alloc] init];
    self.popoverView.behavior = NSPopoverBehaviorTransient;
    self.popoverView.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    self.popoverView.contentViewController = [[KZTimerPopoverViewController alloc] initWithNibName:@"KZTimerPopoverViewController" bundle:nil];
    
    //添加点击事件
    self.demoItem.target = self;
    self.demoItem.action = @selector(showMyPopover:);
    
    //添加点击外侧退出事件
    __weak typeof (self) weakSelf = self;
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler: ^(NSEvent * event) {
        if (weakSelf.popoverView.isShown) {
            [weakSelf.popoverView close];
        }
    }];

}


- (void)showMyPopover:(NSStatusBarButton *)button {
    [self.popoverView showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
