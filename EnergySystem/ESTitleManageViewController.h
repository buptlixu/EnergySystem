//
//  ESTitleManageViewController.h
//  EnergySystem
//
//  Created by tseg on 15-3-4.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ESUpdateConfigFile.h"
#import "ESSqliteUtil.h"
#import "ESConstants.h"
#import "ESTitleDetailViewController.h"

@interface ESTitleManageViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_data;
    NSMutableArray *_names;
    NSMutableArray *_types;
    NSMutableArray *_provinces;
    NSMutableArray *_cities;
    NSMutableArray *_warnOrNot;
}
@property (retain, nonatomic) IBOutlet UITableView *pTableView;

@end
