//
//  BigDaysViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/1/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import <RevMobAds/RevMobAds.h>

@interface BigDaysViewController : BaseViewController <UITableViewDataSource, RevMobAdsDelegate, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *daysTable;
@property (nonatomic, strong) IBOutlet UILabel *lblBigDays;

@property (nonatomic, strong) IBOutlet UIView *bannerView;
@property (nonatomic, strong) RevMobBannerView *adView;

- (IBAction)onPlus:(id)sender;

- (void)sortDataByDate;
- (NSArray*)sortArrayByDate:(NSArray*)array;

@end
