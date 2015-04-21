//
//  ESSeachInfoViewController.m
//  EnergySystem
//
//  Created by tseg on 15-1-15.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESSeachInfoViewController.h"

@interface ESSeachInfoViewController ()

@end

@implementation ESSeachInfoViewController

@synthesize pTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //_data = [[NSArray alloc] initWithObjects:@"1",@"2",nil];
    
    pTableView.hidden = YES;
    [pTableView setDelegate:self];
    [pTableView setDataSource:self];
    
	// Do any additional setup after loading the view.
        
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
    static NSString *CellIdentifier = @"roomCell";
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
    } else if (tableView.center.x == self.countyText.center.x &&
               tableView.center.y == self.countyText.center.y) {
        self.countyText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.buildingText.center.x &&
               tableView.center.y == self.buildingText.center.y) {
        self.buildingText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.roomText.center.x &&
              tableView.center.y == self.roomText.center.y) {
        self.roomText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.kpiText.center.x &&
               tableView.center.y == self.kpiText.center.y) {
        self.kpiText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.timeText.center.x &&
               tableView.center.y == self.timeText.center.y) {
        self.timeText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.orderText.center.x &&
               tableView.center.y == self.orderText.center.y) {
        self.orderText.text = cell.textLabel.text;
    }
    
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
    
    if (sender == self.provinceBtn) {
        //省份为空，获取新的省级信息
        pTableView.frame = CGRectMake(self.provinceText.frame.origin.x, self.provinceText.frame.origin.y + self.provinceText.frame.size.height, 0.75*self.provinceText.frame.size.width, 4*self.provinceText.frame.size.height);
        pTableView.center = self.provinceText.center;
        NSLog(@"provinceBtn");
    } else if (sender == self.cityBtn) {
        NSLog(@"cityBtn");
        pTableView.center = self.cityText.center;
        urlAsString = [urlAsString stringByAppendingString:@"&province="];
        urlAsString = [urlAsString stringByAppendingString:self.provinceText.text];

    } else if (sender == self.countyBtn) {
        NSLog(@"countyBtn");
        pTableView.center = self.countyText.center;
        urlAsString = [urlAsString stringByAppendingString:@"&province="];
        urlAsString = [urlAsString stringByAppendingString:self.provinceText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&city="];
        urlAsString = [urlAsString stringByAppendingString:self.cityText.text];
    } else if (sender == self.buildingBtn) {
        pTableView.center = self.buildingText.center;
        urlAsString = [urlAsString stringByAppendingString:@"&province="];
        urlAsString = [urlAsString stringByAppendingString:self.provinceText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&city="];
        urlAsString = [urlAsString stringByAppendingString:self.cityText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&country="];
        urlAsString = [urlAsString stringByAppendingString:self.countyText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&type="];
        urlAsString = [urlAsString stringByAppendingString:@"机楼"];
    } else if (sender == self.roomBtn) {
        pTableView.center = self.roomText.center;
        urlAsString = [urlAsString stringByAppendingString:@"&province="];
        urlAsString = [urlAsString stringByAppendingString:self.provinceText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&city="];
        urlAsString = [urlAsString stringByAppendingString:self.cityText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&country="];
        urlAsString = [urlAsString stringByAppendingString:self.countyText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&type="];
        urlAsString = [urlAsString stringByAppendingString:@"机房"];
        urlAsString = [urlAsString stringByAppendingString:@"&building="];
        urlAsString = [urlAsString stringByAppendingString:self.buildingText.text];
    }
    
    

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

- (IBAction)getStaticConfigList:(id)sender
{
    if (sender == self.kpiBtn) {
        pTableView.center = self.kpiText.center;
        _data = [[NSArray alloc] initWithObjects:@"机房总耗电",@"机房空调耗电",@"机房照明耗电",@"机房主设备耗电",@"机房插座耗电",@"机房室内温度",@"机房室外温度",@"机房室内湿度",@"机房室外湿度", nil];
        [_data retain];
    } else if (sender == self.timeBtn) {
        pTableView.center = self.timeText.center;
        _data = [[NSArray alloc] initWithObjects:@"日",@"小时", nil];
        [_data retain];
    } else if (sender == self.orderBtn) {
        pTableView.center = self.orderText.center;
        _data = [[NSArray alloc] initWithObjects:@"升序",@"降序", nil];
        [_data retain];
    }
    
    [pTableView reloadData];
    pTableView.hidden = NO;
}

- (IBAction)saveSearchCondition:(id)sender
{
    UIAlertView *inputNameAlert = [[UIAlertView alloc] initWithTitle:@"标题名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    [inputNameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [inputNameAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        ESRoomSearchCondition *rsc = [[ESRoomSearchCondition alloc] init];
        UITextField *textView = [alertView textFieldAtIndex:0];
        extern NSDictionary *userInfoDictionary;
        
        rsc.uid = [userInfoDictionary objectForKey:@"uid"];
        rsc.name = textView.text;
        rsc.province = self.provinceText.text;
        rsc.city = self.cityText.text;
        rsc.couty = self.countyText.text;
        rsc.building = self.buildingText.text;
        rsc.room = self.roomText.text;
        rsc.kpi = self.kpiText.text;
        rsc.time = self.timeText.text;
        rsc.order = self.orderText.text;
        
        //将当前设置的查询条件作为标题存入数据库，通过标题管理功能执行查询操作
        [self insertSearchConditionIntoDB:rsc];
        
        //segue to mainView
//        [self goToMainView];
        [self performSegueWithIdentifier:@"mainNavCon" sender:self];
    }
    
}

- (void)insertSearchConditionIntoDB:(ESRoomSearchCondition *)rsc
{
    //open db
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    if ([sqlUtil open]) {
        NSString *insertSQL = @"INSERT INTO TITLETABLE VALUES";
        NSString *appendSQL = [NSString stringWithFormat:@" (%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[rsc.uid intValue],rsc.name,@"机房",rsc.province,rsc.city,rsc.couty,rsc.building,rsc.room,@"",rsc.kpi,rsc.time,rsc.order];
       
        [self dbCreateTable];
        insertSQL = [insertSQL stringByAppendingString:appendSQL];
        
        if (![sqlUtil execSQL:insertSQL]) {
            NSLog(@"INSERT ERROR");
            //目前阶段将插入操作失败全部视为命名重复
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
    //查询config表是否已建立
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS TITLETABLE (USERID INTEGER,NAME TEXT,TYPE TEXT,PROVINCE TEXT,CITY TEXT,COUNTY TEXT,BUILDING TEXT,ROOM TEXT,SITE TEXT,KPI TEXT,TIME TEXT,ORDERINFO TEXT)";
    
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    if ([sqlUtil open]) {
        [sqlUtil execSQL:sqlCreateTable];
        [sqlUtil close];
    } else {
        NSLog(@"数据库打开失败");
    }
    
    [sqlUtil release];
}

- (void)goToMainView
{
    [self performSegueWithIdentifier:@"mainView" sender:self];
}

- (void)dealloc {
    [_provinceBtn release];
    
    //[_tableView release];
    [_provinceText release];
    [_cityText release];
    [_cityBtn release];
    [_countyText release];
    [_buildingText release];
    [_buildingText release];
    [_roomText release];
    [_countyBtn release];
    [_buildingBtn release];
    [_roomBtn release];
    [_kpiBtn release];
    [_timeBtn release];
    [_orderBtn release];
    [_kpiText release];
    [_timeText release];
    [_orderText release];
    [pTableView release];
    [super dealloc];
}
@end
