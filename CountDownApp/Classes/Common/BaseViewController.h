//
//  BaseViewController.h
//  CountDownApp
//
//  Created by FeltonWang on 9/30/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    BOOL isTabBar;
}

@property (nonatomic, retain) IBOutlet UIView *viewContents;

@end
