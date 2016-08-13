//
//  Chrome.m
//  OpenHere
//
//  Created by Marc Schwieterman on 8/13/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

#import "Chrome.h"
#import "ChromeSupport.h"

@interface Chrome ()

@property (nonatomic, readonly) NSString* bundleIdentifier;

@end

@implementation Chrome

- (instancetype)initWithBundleIdentifier:(NSString*) bundleIdentifier {
    if (self = [self init]) {
        _bundleIdentifier = bundleIdentifier;
    }
    return self;
}

- (void)openURL:(NSString*) url inNewWindow:(BOOL) openInNewWindow activateInNewWindow:(BOOL) activateInNewWindow activateInExistingWindow:(BOOL) activateInExistingWindow {
    NSParameterAssert(url);
    ChromeApplication* application =
    [SBApplication applicationWithBundleIdentifier:self.bundleIdentifier];
    if (openInNewWindow) {
        [self openURLInNewWindow:url ofApplication:application activate:activateInNewWindow];
    } else {
        [self openURLInNewTab:url ofApplication:application activate:activateInExistingWindow];
    }
}

- (void)openURLInNewWindow:(NSString*) url
             ofApplication:(ChromeApplication*) application
                  activate:(BOOL) activate {
    NSParameterAssert(url);
    NSParameterAssert(application);
    ChromeWindow* newWindow = [[[application classForScriptingClass:@"window"] alloc] init];
    [[application windows] addObject:newWindow];
    newWindow.activeTab.URL = url;

    if (activate) {
        [application activate];
    }
}

- (void)openURLInNewTab:(NSString*) url
          ofApplication:(ChromeApplication*) application
               activate:(BOOL) activate {
    NSParameterAssert(url);
    NSParameterAssert(application);
    ChromeWindow *frontWindow = [[application windows] firstObject];
    ChromeTab *newTab = [[[application classForScriptingClass:@"tab"] alloc] init];
    [frontWindow.tabs addObject:newTab];
    frontWindow.activeTab.URL = url;

    if (activate) {
        [application activate];
    }
}

@end
