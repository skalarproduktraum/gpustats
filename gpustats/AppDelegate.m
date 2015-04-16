//
//  AppDelegate.m
//  gpustats
//
//  Created by Ulrik Guenther on 16/04/15.
//  Copyright (c) 2015 ulrik.is. All rights reserved.
//

#import "AppDelegate.h"
#include "CUDAhelper.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL darkModeOn;
@property (strong, nonatomic) NSMutableArray *appTimepoints;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSMenu *statMenu = [[NSMenu alloc] init];
    _appTimepoints = [[NSMutableArray alloc] init];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.image = [NSImage imageNamed:@"menubar-icon"];
    
    [_statusItem setAction:@selector(itemClicked:)];
    [_statusItem.image setTemplate:YES];
    
    gs_setDevice(0);
    unsigned long long total = gs_getTotalGlobalMem();
    unsigned long long free = gs_getFreeGlobalMem();
    
    _statusItem.toolTip = [NSString stringWithFormat:@"Free global/Total global:\n%.0fM/%.0fM, %.0f%% free", free/1048576.0f, total/1048576.0f, (float)free/(float)total*100.0f];
    
    [statMenu addItemWithTitle: @"GPUstats" action:nil keyEquivalent:@""];
    [statMenu addItemWithTitle: [NSString stringWithFormat:@"Free/Total: %.0fM/%.0fM", free/1048576.0f, total/1048576.0f] action:nil keyEquivalent:@""];
    [statMenu addItem:[NSMenuItem separatorItem]];
    [statMenu addItemWithTitle:@"Quit" action:@selector(quit:) keyEquivalent:@""];
    
    _statusItem.menu = statMenu;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(reenquireGPUStatus:)
                                   userInfo:nil
                                    repeats:YES];
    
    NSMutableArray *runningApps = [[NSMutableArray alloc] init];
    for(NSRunningApplication *app in [[NSWorkspace sharedWorkspace] runningApplications]) {
        [runningApps addObject:[NSString stringWithString:[app localizedName]]];
    }
    
    [_appTimepoints addObject:runningApps];
}

- (void)quit:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)reenquireGPUStatus:(id)sender {
    gs_setDevice(0);
    unsigned long long total = gs_getTotalGlobalMem();
    unsigned long long free = gs_getFreeGlobalMem();
    
    _statusItem.toolTip = [NSString stringWithFormat:@"Free global/Total global:\n%.0fM/%.0fM, %.0f%% free", free/1048576.0f, total/1048576.0f, (float)free/(float)total*100.0f];
    
    [[_statusItem.menu itemAtIndex:1] setTitle:[NSString stringWithFormat:@"Free/Total: %.0fM/%.0fM", free/1048576.0f, total/1048576.0f]];
    
    NSMutableArray *runningApps = [[NSMutableArray alloc] init];
    for(NSRunningApplication *app in [[NSWorkspace sharedWorkspace] runningApplications]) {
        [runningApps addObject:[NSString stringWithString:[app localizedName]]];
    }
    
    if([_appTimepoints count] >= 20) {
        [_appTimepoints removeObjectAtIndex:0];
    }
    
    // check whether any apps have been started or quit
    
    NSSet *original = [NSSet setWithArray:[_appTimepoints lastObject]];
    NSSet *new = [NSSet setWithArray:runningApps];
    
    NSMutableSet *starts = [NSMutableSet setWithCapacity: [runningApps count]];
    NSMutableSet *quits = [NSMutableSet setWithCapacity:[[_appTimepoints lastObject] count]];
    
    [starts addObjectsFromArray:runningApps];
    [quits addObjectsFromArray:[_appTimepoints lastObject]];
    
    [starts minusSet:original];
    [quits minusSet:new];

    [_appTimepoints addObject:runningApps];
    
    NSLog(@"Starts: %@", starts);
    NSLog(@"Quits: %@", quits);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (void)itemClicked:(id)sender {

}

- (void)refreshDarkMode {
    NSString * value = (__bridge NSString *)(CFPreferencesCopyValue((CFStringRef)@"AppleInterfaceStyle", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
    
    if ([value isEqualToString:@"Dark"]) {
        self.darkModeOn = YES;
    } else {
        self.darkModeOn = NO;
    }
}

@end
