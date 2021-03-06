//
//  PopupViewController.h
//  LoveCountdown
//
//  Created by Admin on 7/1/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "InAppPurchaseObserver.h"

@interface PopupViewController : BaseViewController <InAppPurchaseObserverDelegate>
{
    BOOL isProcessingPurchase;
}

- (IBAction)onYesPlease:(id)sender;
- (IBAction)onRestore:(id)sender;
- (IBAction)onNoThanks:(id)sender;

- (void)showScreen:(UIView*)parentView;
- (void)hideScreen;

@end
