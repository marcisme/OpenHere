//
//  Browser.h
//  OpenHere
//
//  Created by Marc Schwieterman on 8/13/16.
//  Copyright © 2016 Marc Schwieterman. All rights reserved.
//

@protocol Browser <NSObject>

NS_ASSUME_NONNULL_BEGIN
- (void)openURL:(NSString*) url inNewWindow:(BOOL) openInNewWindow activateInNewWindow:(BOOL) activateInNewWindow activateInExistingWindow:(BOOL) activateInExistingWindow;
NS_ASSUME_NONNULL_END

@end
