//
//  ESWarnSearchInfoViewController.h
//  EnergySystem
//
//  Created by 徐冰 on 15/4/30.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESSqliteUtil.h"
#import "ESConstants.h"
#import "ESWarnSearchConditionDataModel.h"

@interface ESWarnSearchInfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *_data;
}
@property (retain, nonatomic) IBOutlet UITableView *pTableView;
@property (retain, nonatomic) IBOutlet UITextField *provinceText;
@property (retain, nonatomic) IBOutlet UITextField *cityText;
@property (retain, nonatomic) IBOutlet UITextField *placeTypeText;
@property (retain, nonatomic) IBOutlet UITextField *alertTypeText;
@property (retain, nonatomic) IBOutlet UITextField *granularityText;
@property (retain, nonatomic) IBOutlet UITextField *startDateText;
@property (retain, nonatomic) IBOutlet UITextField *endDateText;
@property (retain, nonatomic) IBOutlet UIButton *provinceBtn;
@property (retain, nonatomic) IBOutlet UIButton *cityBtn;
@property (retain, nonatomic) IBOutlet UIButton *placeTypeBtn;
@property (retain, nonatomic) IBOutlet UIButton *alertTypeBtn;
@property (retain, nonatomic) IBOutlet UIButton *granularityBtn;
@property (retain, nonatomic) UIDatePicker *datePicker;
- (IBAction)getConfigList:(id)sender;
- (IBAction)getStaticConfigList:(id)sender;
- (IBAction)saveSearchConditionIntoDB:(id)sender;
- (IBAction)setDate:(id)sender;

@end