//
//  ESSiteSearchInfoViewController.m
//  EnergySystem
//
//  Created by tseg on 15-3-5.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESSiteSearchInfoViewController.h"

@interface ESSiteSearchInfoViewController ()

@end

@implementation ESSiteSearchInfoViewController

@synthesize pTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [pTableView setDataSource:self];
    [pTableView setDelegate:self];
    pTableView.hidden = YES;
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
    } else if (tableView.center.x == self.countyText.center.x &&
               tableView.center.y == self.countyText.center.y) {
        self.countyText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.siteText.center.x &&
               tableView.center.y == self.siteText.center.y) {
        self.siteText.text = cell.textLabel.text;
    } else if (tableView.center.x == self.KPIText.center.x &&
               tableView.center.y == self.KPIText.center.y) {
        self.KPIText.text = cell.textLabel.text;
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
    } else if (sender == self.siteBtn) {
        pTableView.center = self.siteText.center;
        urlAsString = [urlAsString stringByAppendingString:@"&province="];
        urlAsString = [urlAsString stringByAppendingString:self.provinceText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&city="];
        urlAsString = [urlAsString stringByAppendingString:self.cityText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&country="];
        urlAsString = [urlAsString stringByAppendingString:self.countyText.text];
        urlAsString = [urlAsString stringByAppendingString:@"&type="];
        urlAsString = [urlAsString stringByAppendingString:@"基站"];
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
    if (sender == self.KPIBtn) {
        pTableView.center = self.KPIText.center;
        _data = [[NSArray alloc] initWithObjects:@"基站总耗电",@"基站空调耗电",@"基站照明耗电",@"基站主设备耗电",@"基站开关电源耗电",@"基站2G话务量耗电",@"基站3G话务量",@"基站2G数据业务流量",@"基站3G数据业务流量",@"基站室内温度",@"基站室外温度",@"基站室内湿度",@"基站室外湿度", nil];
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

- (IBAction)saveSearchConditionIntoDB:(id)sender
{
    UIAlertView *inputNameAlert = [[UIAlertView alloc] initWithTitle:@"标题名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    [inputNameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [inputNameAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        ESSiteSearchCondition *ssc = [[ESSiteSearchCondition alloc] init];
        UITextField *textView = [alertView textFieldAtIndex:0];
        extern NSDictionary *userInfoDictionary;
        
        ssc.uid = [userInfoDictionary objectForKey:@"uid"];
        ssc.name = textView.text;
        ssc.province = self.provinceText.text;
        ssc.city = self.cityText.text;
        ssc.couty = self.countyText.text;
        ssc.site = self.siteText.text;
        ssc.kpi = self.KPIText.text;
        ssc.time = self.timeText.text;
        ssc.order = self.orderText.text;
        
        //将当前设置的查询条件作为标题存入数据库，通过标题管理功能执行查询操作
        [self insertSearchConditionIntoDB:ssc];
        
        //segue to mainView
//        [self goToMainView];
        [self performSegueWithIdentifier:@"mainNavCon" sender:self];
    }
    
}

- (void)insertSearchConditionIntoDB:(ESSiteSearchCondition *)ssc
{
    //open db
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    if ([sqlUtil open]) {
        NSString *insertSQL = @"INSERT INTO TITLETABLE VALUES";
        NSString *appendSQL = [NSString stringWithFormat:@" (%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[ssc.uid intValue],ssc.name,@"基站",ssc.province,ssc.city,ssc.couty,@"",@"",ssc.site,ssc.kpi,ssc.time,ssc.order];
        
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

//- (void)goToMainView
//{
//    [self performSegueWithIdentifier:@"mainView" sender:self];
//}

- (void)dealloc {
    [_provinceText release];
    [pTableView release];
    [_cityText release];
    [_countyText release];
    [_siteText release];
    [_KPIText release];
    [_timeText release];
    [_orderText release];
    [_provinceBtn release];
    [_cityBtn release];
    [_countyBtn release];
    [_siteBtn release];
    [_KPIBtn release];
    [_timeBtn release];
    [_orderBtn release];
    [super dealloc];
}

@end
