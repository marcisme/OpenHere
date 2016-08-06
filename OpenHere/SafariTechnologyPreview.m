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

+ (void)openURL:(NSString*) url inNewWindow:(BOOL) openInNewWindow activateInNewWindow:(BOOL) activateInNewWindow activateInExistingWindow:(BOOL) activateInExistingWindow {
    NSParameterAssert(url);
    SafariTechnologyPreviewApplication* application =
    [SBApplication applicationWithBundleIdentifier:@"com.apple.SafariTechnologyPreview"];
    if (openInNewWindow) {
        [self.class openURLInNewWindow:url ofApplication:application activate:activateInNewWindow];
    } else {
        [self.class openURLInNewTab:url ofApplication:application activate:activateInExistingWindow];
    }
}

+ (void)openURLInNewWindow:(NSString*) url
             ofApplication:(SafariTechnologyPreviewApplication*) application
                  activate:(BOOL) activate {
    NSParameterAssert(url);
    NSParameterAssert(application);
    SafariTechnologyPreviewDocument* newDocument = [[[application classForScriptingClass:@"document"] alloc] init];
    [[application documents] addObject:newDocument];

    SafariTechnologyPreviewWindow* frontWindow = [[application windows] firstObject];
    frontWindow.currentTab.URL = url;

    if (activate) {
        [application activate];
    }
}

+ (void)openURLInNewTab:(NSString*) url
          ofApplication:(SafariTechnologyPreviewApplication*) application
               activate:(BOOL) activate {
    NSParameterAssert(url);
    NSParameterAssert(application);
    SafariTechnologyPreviewWindow* frontWindow = [[application windows] firstObject];

    SafariTechnologyPreviewTab* newTab = [[[application classForScriptingClass:@"tab"] alloc] init];
    [[frontWindow tabs] addObject:newTab];
    frontWindow.currentTab = newTab;

    newTab.URL = url;

    if (activate) {
        [application activate];
    }
}

@end
