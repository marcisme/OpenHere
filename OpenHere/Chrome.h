//
//  Chrome.h
//  OpenHere
//
//  Created by Marc Schwieterman on 8/13/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Browser.h"

@interface Chrome : NSObject<Browser>

NS_ASSUME_NONNULL_BEGIN
- (instancetype)initWithBundleIdentifier:( NSString*) bundleIdentifier;

- (void)openURL:(NSString*) url inNewWindow:(BOOL) openInNewWindow activateInNewWindow:(BOOL) activateInNewWindow activateInExistingWindow:(BOOL) activateInExistingWindow;
NS_ASSUME_NONNULL_END

@end
