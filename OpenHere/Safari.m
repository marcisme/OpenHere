//
//  Safari.m
//  OpenHere
//
//  Created by Marc Schwieterman on 8/6/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

#import "Safari.h"
#import "SafariSupport.h"

@interface Safari ()

@property (nonatomic, readonly) NSString* bundleIdentifier;

@end

@implementation Safari

- (instancetype)initWithBundleIdentifier:(NSString*) bundleIdentifier {
    if (self = [self init]) {
        _bundleIdentifier = bundleIdentifier;
    }
    return self;
}

- (void)openURL:(NSString*) url inNewWindow:(BOOL) openInNewWindow activateInNewWindow:(BOOL) activateInNewWindow activateInExistingWindow:(BOOL) activateInExistingWindow {
    NSParameterAssert(url);
    SafariApplication* application =
    [SBApplication applicationWithBundleIdentifier:self.bundleIdentifier];
    if (openInNewWindow) {
        [self openURLInNewWindow:url ofApplication:application activate:activateInNewWindow];
    } else {
        [self openURLInNewTab:url ofApplication:application activate:activateInExistingWindow];
    }
}

- (void)openURLInNewWindow:(NSString*) url
             ofApplication:(SafariApplication*) application
                  activate:(BOOL) activate {
    NSParameterAssert(url);
    NSParameterAssert(application);
    SafariDocument* newDocument = [[[application classForScriptingClass:@"document"] alloc] init];
    [[application documents] addObject:newDocument];

    SafariWindow* frontWindow = [[application windows] firstObject];
    frontWindow.currentTab.URL = url;

    if (activate) {
        [application activate];
    }
}

- (void)openURLInNewTab:(NSString*) url
          ofApplication:(SafariApplication*) application
               activate:(BOOL) activate {
    NSParameterAssert(url);
    NSParameterAssert(application);
    SafariWindow* frontWindow = [[application windows] firstObject];

    SafariTab* newTab = [[[application classForScriptingClass:@"tab"] alloc] init];
    [[frontWindow tabs] addObject:newTab];
    frontWindow.currentTab = newTab;

    newTab.URL = url;

    if (activate) {
        [application activate];
    }
}

@end
