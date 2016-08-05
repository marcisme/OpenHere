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
    SafariTechnologyPreviewApplication* application = [SBApplication applicationWithBundleIdentifier:@"com.apple.SafariTechnologyPreview"];
    SafariTechnologyPreviewWindow* frontWindow = [[application windows] firstObject];
    SafariTechnologyPreviewTab* newTab = [[[application classForScriptingClass:@"tab"] alloc] init];
    [[frontWindow tabs] addObject:newTab];
    frontWindow.currentTab = newTab;
    newTab.URL = url;
    [application activate];
}

@end
