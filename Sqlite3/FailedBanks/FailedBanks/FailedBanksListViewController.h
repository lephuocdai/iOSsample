//
//  FailedBanksListViewController.h
//  FailedBanks
//
//  Created by レー フックダイ on 4/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailedBanksListViewController : UITableViewController {
    NSArray *_failedBankInfos;
}

@property (nonatomic, retain) NSArray *failedBankInfos;


@end
