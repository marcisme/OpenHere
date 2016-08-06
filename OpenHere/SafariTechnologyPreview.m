//
//  SafariTechnologyPreview.m
//  OpenHere
//
//  Created by Marc Schwieterman on 8/3/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

#import "SafariTechnologyPreview.h"
#import "SafariTechnologyPreviewSupport.h"

@implementation SafariTechnologyPreview

+ (void)openURL:(NSString*) url {
    NSParameterAssert(url);
    [self.class openURL:url inNewWindow:NO];
}

+ (void)openURL:(NSString*) url inNewWindow:(BOOL) openInNewWindow {
    NSParameterAssert(url);
    SafariTechnologyPreviewApplication* application =
    [SBApplication applicationWithBundleIdentifier:@"com.apple.SafariTechnologyPreview"];
    if (openInNewWindow) {
        [self.class openURLInNewWindow:url ofApplication:application];
    } else {
        [self.class openURLInNewTab:url ofApplication:application];
    }
}

+ (void)openURLInNewWindow:(NSString*) url
             ofApplication:(SafariTechnologyPreviewApplication*) application {
    NSParameterAssert(url);
    NSParameterAssert(application);
    SafariTechnologyPreviewDocument* newDocument = [[[application classForScriptingClass:@"document"] alloc] init];
    [[application documents] addObject:newDocument];

    SafariTechnologyPreviewWindow* frontWindow = [[application windows] firstObject];
    frontWindow.currentTab.URL = url;

    [application activate];
}

+ (void)openURLInNewTab:(NSString*) url
          ofApplication:(SafariTechnologyPreviewApplication*) application {
    NSParameterAssert(url);
    NSParameterAssert(application);
    SafariTechnologyPreviewWindow* frontWindow = [[application windows] firstObject];

    SafariTechnologyPreviewTab* newTab = [[[application classForScriptingClass:@"tab"] alloc] init];
    [[frontWindow tabs] addObject:newTab];
    frontWindow.currentTab = newTab;

    newTab.URL = url;
}

@end
