//
//  ESSearchResultTabBarViewController.h
//  EnergySystem
//
//  Created by tseg on 15-3-26.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESConstants.h"
#import "ESSearchCondtionDataModel.h"
#import "ESWarnSearchConditionDataModel.h"
#import "ESSearchResultViewController.h"
#import "ESSearchResultChartViewController.h"

@interface ESSearchResultTabBarViewController : UITabBarController

@property (retain,nonatomic) ESSearchCondtionDataModel *scDataModel;
@property (retain,nonatomic) ESWarnSearchConditionDataModel *wscDataModel;

@end
