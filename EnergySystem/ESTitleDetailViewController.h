//
//  ESTitleDetailViewController.h
//  EnergySystem
//
//  Created by tseg on 15-3-4.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESSqliteUtil.h"
#import "ESSearchResultTabBarViewController.h"
#import "ESSearchResultViewController.h"
#import "ESWarnSearchConditionDataModel.h"

@interface ESTitleDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSString *_name;
    NSMutableArray *_data;
    BOOL warnOrNot;
}

@property (retain, nonatomic) IBOutlet UITableView *pTableView;
@property (strong,nonatomic) NSString *name;

@end
