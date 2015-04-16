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
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSMenu *statMenu = [[NSMenu alloc] init];
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
