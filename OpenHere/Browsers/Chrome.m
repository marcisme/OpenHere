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

- (void)openURL:(NSString*) url inBrowserTarget:(BrowserTarget) browserTarget andActivate:(BOOL) activate {
    NSParameterAssert(url);
    NSParameterAssert(browserTarget);
    ChromeApplication* application =
    [SBApplication applicationWithBundleIdentifier:self.bundleIdentifier];

    switch (browserTarget) {
        case BrowserTargetNewWindow: {
            ChromeWindow* newWindow = [[[application classForScriptingClass:@"window"] alloc] init];
            [[application windows] addObject:newWindow];
            newWindow.activeTab.URL = url;
            break;
        }
        case BrowserTargetNewTab: {
            ChromeWindow *frontWindow = [[application windows] firstObject];
            ChromeTab *newTab = [[[application classForScriptingClass:@"tab"] alloc] init];
            [frontWindow.tabs addObject:newTab];
            frontWindow.activeTab.URL = url;
            break;
        }
        default: {
            // TODO: Make this  shit work
            ChromeWindow *frontWindow = [[application windows] firstObject];
            frontWindow.activeTab.URL = url;
            break;
        }
    }

    if (activate) {
        [application activate];
    }
}

@end
