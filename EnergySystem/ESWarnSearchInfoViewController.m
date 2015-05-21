//
//  ESWarnSearchInfoViewController.m
//  EnergySystem
//
//  Created by 徐冰 on 15/4/30.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESWarnSearchInfoViewController.h"

@interface ESWarnSearchInfoViewController ()

@end

@implementation ESWarnSearchInfoViewController

@synthesize pTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [pTableView setDataSource:self];
    [pTableView setDelegate:self];
    pTableView.hidden = YES;
//    self.startDateText.tag = 100;
//    self.endDateText.tag = 100;
//    self.granularityText.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg.png"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"siteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [_data objectAtIndex:row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView.center.x == self.provinceText.center.x &&
        tableView.center.y == self.provinceText.center.y) {
        self.provinceText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.cityText.center.x &&
               tableView.center.y == self.cityText.center.y) {
        self.cityText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.placeTypeText.center.x &&
               tableView.center.y == self.placeTypeText.center.y) {
        self.placeTypeText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.alertTypeText.center.x &&
               tableView.center.y == self.alertTypeText.center.y) {
        self.alertTypeText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.granularityText.center.x &&
              tableView.center.y == self.granularityText.center.y) {
        self.granularityText.text = cell.textLabel.text;
    } /*else if (tableView.center.x == self.startDateText.center.x &&
              tableView.center.y == self.startDateText.center.y) {
        self.startDateText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.endDateText.center.x &&
               tableView.center.y == self.endDateText.center.y) {
        self.endDateText.text = cell.textLabel.text;
    }*/
    
    tableView.hidden = YES;
}

- (IBAction)getConfigList:(id)sender
{
    
    extern NSDictionary *userInfoDictionary;
    NSNumber *companyIdNSInt = [userInfoDictionary objectForKey:@"companyId"];
    NSString *companyIdNSString = [companyIdNSInt stringValue];
    
    NSString *urlAsString = [[NSString alloc] initWithString:serverHttpUrl];
    urlAsString = [urlAsString stringByAppendingString:configAction];
    urlAsString = [urlAsString stringByAppendingString:companyIdNSString];
    
    BOOL flag = FALSE;
    if (sender == self.provinceBtn) {
        //省份为空，获取新的省级信息
        pTableView.frame = CGRectMake(self.provinceText.frame.origin.x, self.provinceText.frame.origin.y + self.provinceText.frame.size.height, 0.75*self.provinceText.frame.size.width, 4*self.provinceText.frame.size.height);
        pTableView.center = self.provinceText.center;
        flag = TRUE;
    } else if (sender == self.cityBtn) {
        if (self.provinceText.text.length != 0) {
            pTableView.center = self.cityText.center;
            urlAsString = [urlAsString stringByAppendingString:@"&province="];
            urlAsString = [urlAsString stringByAppendingString:self.provinceText.text];
            flag = TRUE;
        }
    }
    
    if (flag)
    {
        urlAsString = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",urlAsString);
        NSURL *url = [NSURL URLWithString:urlAsString];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setTimeoutInterval:NETWORKTIMEOUT];
        [urlRequest setHTTPMethod:@"POST"];
        
        //发送同步Http信息
        NSURLResponse *response = nil;
        NSError *connectionError = nil;
        NSData *tmpData = [NSURLConnection sendSynchronousRequest:urlRequest
                                                returningResponse:&response
                                                            error:&connectionError];
        if ([tmpData length] > 0) {
            NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:tmpData
                                                                       options:kNilOptions error:nil];
            NSNumber *status = [resultData objectForKey:@"status"];
            if ([status intValue] == 200) {
                _data = [resultData objectForKey:@"name"];
                [_data retain];
                [pTableView reloadData];
            }
        }
        
        pTableView.hidden = NO;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"警告"
                                  message:@"请先选择上级信息！"
                                  delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
}

- (IBAction)getStaticConfigList:(id)sender
{
    if (sender == self.placeTypeBtn) {
        pTableView.center = self.placeTypeText.center;
        _data = [[NSArray alloc] initWithObjects:@"机房", @"基站", nil];
        [_data retain];
    } else if (sender == self.alertTypeBtn) {
        pTableView.center = self.alertTypeText.center;
        _data = [[NSArray alloc] initWithObjects:@"总能耗", @"PUE", @"室内温度", @"室内湿度", nil];
        [_data retain];
    } else if (sender == self.granularityBtn) {
        pTableView.center = self.granularityText.center;
        _data = [[NSArray alloc] initWithObjects:@"小时" ,@"日", @"月",nil];
        [_data retain];
    }
    
    [pTableView reloadData];
    pTableView.hidden = NO;
}

- (IBAction)saveSearchConditionIntoDB:(id)sender
{
    UIAlertView *inputNameAlert = [[UIAlertView alloc] initWithTitle:@"标题名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    [inputNameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [inputNameAlert show];
}

- (IBAction)setDate:(id)sender
{
    self.datePicker = [[UIDatePicker alloc]init];
    //XB 月粒度情况下应修改datePicker只显示年和月
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    //监听datePicker
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    //设置工具条frame
    toolbar.frame=CGRectMake(0, 0, 320, 44);
    //给工具条添加按钮
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    toolbar.items = @[item0, item1];
    
    if (sender == self.startDateText)
    {
        self.startDateText.inputView = self.datePicker ;
        self.startDateText.inputAccessoryView = toolbar;
    }
    else
    {
        self.endDateText.inputView = self.datePicker;
        self.endDateText.inputAccessoryView = toolbar;
    }
}

- (void) datePickerValueChanged:(UIDatePicker *)date
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    
//    if ([self.startDateText isFirstResponder]) {
//        if ([self.granularityText.text isEqualToString:@"小时"]) {
//            fomatter.dateFormat = @"yyyy-MM-dd";
//            self.startDateText.text = [fomatter stringFromDate:date.date];
//            self.endDateText.text = self.startDateText.text;
//        } else if([self.granularityText.text isEqualToString:@"日"]){
//            fomatter.dateFormat = @"yyyy-MM-dd";
//            self.startDateText.text = [fomatter stringFromDate:date.date];
//        } else if([self.granularityText.text isEqualToString:@"月"]){
//            fomatter.dateFormat = @"yyyy-MM";
//            self.startDateText.text = [fomatter stringFromDate:date.date];
//        }
//    } else {
//        self.endDateText.text = [fomatter stringFromDate:date.date];
//    }
    
    if ([self.granularityText.text isEqualToString:@"小时"] || [self.granularityText.text isEqualToString:@"日"])
    {
        fomatter.dateFormat = @"yyyy-MM-dd";
        if ([self.startDateText isFirstResponder])
        {
            self.startDateText.text = [fomatter stringFromDate:date.date];
            if ([self.granularityText.text isEqualToString:@"小时"])
            {
                self.endDateText.text = self.startDateText.text;
            }
        }
        else {
            self.endDateText.text = [fomatter stringFromDate:date.date];
        }
    }
    else if([self.granularityText.text isEqualToString:@"月"])
    {
        fomatter.dateFormat = @"yyyy-MM";
        if ([self.startDateText isFirstResponder]){
            self.startDateText.text = [fomatter stringFromDate:date.date];
        }
        else {
            self.endDateText.text = [fomatter stringFromDate:date.date];
        }
    }
}

- (void)doneClick
{
    if ([self.startDateText isFirstResponder]) {
        [self.startDateText resignFirstResponder];
    }else {
        [self.endDateText resignFirstResponder];
    }
            
}

- (IBAction)dismissKeyboardTapBackground:(UIControl *)sender
{
    [self.view endEditing:YES];
}

#warning UITextField 响应问题
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
////    if (textField.tag != 100) {
////        textField.inputView = nil;
////    }
//    return YES;
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //XB
        ESWarnSearchConditionDataModel *wsc = [[ESWarnSearchConditionDataModel alloc] init];
        UITextField *textView = [alertView textFieldAtIndex:0];
        extern NSDictionary *userInfoDictionary;
        
        wsc.uid = [userInfoDictionary objectForKey:@"uid"];
        wsc.name = textView.text;
        wsc.province = self.provinceText.text;
        wsc.city = self.cityText.text;
        wsc.placeType = self.placeTypeText.text;
        wsc.alertType = self.alertTypeText.text;
        wsc.granularity = self.granularityText.text;
        wsc.startDate = self.startDateText.text;
        wsc.endDate = self.endDateText.text;
        
        //将当前设置的查询条件作为标题存入数据库，通过标题管理功能执行查询操作
        [self insertSearchConditionIntoDB:wsc];
        
        //segue to mainView
        [self performSegueWithIdentifier:@"mainNavCon" sender:self];
    }
    
}

- (void)insertSearchConditionIntoDB:(ESWarnSearchConditionDataModel *)wsc
{
    //open db
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    
    if ([sqlUtil open]) {
        NSString *insertSQL = @"INSERT INTO WARNTITLETABLE VALUES";
        NSString *appendSQL = [NSString stringWithFormat:@" (%d,'%@','%@','%@','%@','%@','%@','%@','%@')",[wsc.uid intValue], wsc.name, wsc.placeType, wsc.province, wsc.city, wsc.alertType, wsc.granularity, wsc.startDate, wsc.endDate];
        
        [self dbCreateTable];
        insertSQL = [insertSQL stringByAppendingString:appendSQL];
        
        if (![sqlUtil execSQL:insertSQL]) {
            NSLog(@"INSERT ERROR");
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"警告"
                                      message:@"标题命名不可重复，存储失败！"
                                      delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
        }
    }
}

- (void)dbCreateTable
{
    //XB与正常查询条件内容相差较大，需要新建表
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS WARNTITLETABLE (USERID INTEGER,NAME TEXT,TYPE TEXT,PROVINCE TEXT,CITY TEXT,ALERTTYPE TEXT,GRANULARITY TEXT,STATEDATE TEXT,ENDDATE TEXT, PRIMARY KEY(NAME))";
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    if ([sqlUtil open]) {
        [sqlUtil execSQL:sqlCreateTable];
        [sqlUtil close];
    } else {
        NSLog(@"数据库打开失败");
    }
    
    [sqlUtil release];
}

- (void)dealloc
{
    [_provinceText release];
    [pTableView release];
    [_cityText release];
    [_placeTypeText release];
    [_alertTypeText release];
    [_startDateText release];
    [_granularityText release];
    [_endDateText release];
    [_provinceBtn release];
    [_cityBtn release];
    [_placeTypeBtn release];
    [_alertTypeBtn release];
    [_granularityBtn release];
    [_datePicker release];
    [_settingButton release];
    [super dealloc];
}

@end
