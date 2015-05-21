//
//  ESTitleDetailViewController.m
//  EnergySystem
//
//  Created by tseg on 15-3-4.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESTitleDetailViewController.h"

@interface ESTitleDetailViewController ()

@end

@implementation ESTitleDetailViewController

@synthesize name = _name;
@synthesize pTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    NSLog(@"%@",self.name);
    _data = [[NSMutableArray alloc] init];
    
    //查询标题详情
    [self loadTitleDetailInfoFromDB];
    [pTableView setDataSource:self];
    [pTableView setDelegate:self];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg.png"]];
}

- (void) loadTitleDetailInfoFromDB
{
    NSString *querySQL =[NSString stringWithFormat:
                                @"SELECT * FROM TITLETABLE WHERE NAME = '%@'",self.name];
    NSString *querySQLWarn =[NSString stringWithFormat: @"SELECT * FROM WARNTITLETABLE WHERE NAME = '%@'",self.name];
    
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    sqlite3_stmt *stmt, *stmtWarn;
    
    if ([sqlUtil open])//打开本地数据库，下一句if为执行查询表语句
    {
        //   XB不能确定点击的是普通查询标题还是告警查询标题，但非1即2(其中并没有考虑SQL语句执行失败的情况)
#warning XB查不到结果也算查询成功？返回值都是SQLITE_OK
        if (sqlite3_prepare_v2(sqlUtil.db, [querySQL UTF8String], -1, &stmt, nil) == SQLITE_OK &&
            sqlite3_prepare_v2(sqlUtil.db, [querySQLWarn UTF8String], -1, &stmtWarn, nil) == SQLITE_OK)
        {
            //从TITLETABLE表中查询
            
                while (sqlite3_step(stmt) == SQLITE_ROW)
                {
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,1)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,2)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,3)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,4)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,5)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,6)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,7)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,8)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,9)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,10)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmt,11)]];
                    warnOrNot = NO;//while只会执行一遍
                }
                //从WARNTITLETABLE表中查询
                while (sqlite3_step(stmtWarn) == SQLITE_ROW)
                {
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmtWarn,1)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmtWarn,2)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmtWarn,3)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmtWarn,4)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmtWarn,5)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmtWarn,6)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmtWarn,7)]];
                    [_data addObject:[[NSString alloc]
                                      initWithUTF8String:(char *)sqlite3_column_text(stmtWarn,8)]];
                    warnOrNot = YES;
                }
        }
    }
    else
    {
        NSLog(@"数据库打开失败");
    }
    [sqlUtil close];
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
    static NSString *CellIdentifier = @"titleDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    switch (row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"标题名称："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"类型："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"省："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", @"市："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 4:
            //XB根据标识判断cell的标签内容
            cell.textLabel.text = [NSString stringWithFormat:@"%@", warnOrNot ? @"告警类型：" : @"区县："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 5:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", warnOrNot ? @"时间粒度：" : @"机楼："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 6:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", warnOrNot ? @"起始时间：" : @"机房："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 7:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", warnOrNot ? @"终止时间：" : @"基站："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 8:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"KPI："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 9:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"时间："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
        case 10:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",@"排序："];
            cell.textLabel.text = [cell.textLabel.text
                                        stringByAppendingString:[_data objectAtIndex:row]];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resultView"]) {
        if ([segue.destinationViewController isKindOfClass:[ESSearchResultTabBarViewController class]])
        {
            ESSearchResultTabBarViewController *viewController =
                            (ESSearchResultTabBarViewController *)segue.destinationViewController;
            if(warnOrNot == NO)
            {
                ESSearchCondtionDataModel *dataModel = [[ESSearchCondtionDataModel alloc] init];
                dataModel.placeType  =  [_data objectAtIndex:1];
                dataModel.province   =  [_data objectAtIndex:2];
                dataModel.city       =  [_data objectAtIndex:3];
                dataModel.county     =  [_data objectAtIndex:4];
                dataModel.building   =  [_data objectAtIndex:5];
                dataModel.room       =  [_data objectAtIndex:6];
                dataModel.site       =  [_data objectAtIndex:7];
                dataModel.kpi        =  [_data objectAtIndex:8];
                dataModel.time       =  [_data objectAtIndex:9];
                dataModel.sort       =  [_data objectAtIndex:10];
                
                viewController.scDataModel = dataModel;
            }
            else//XB对不同查询进行不同处理
            {
                ESWarnSearchConditionDataModel *warnDataModel = [[ESWarnSearchConditionDataModel alloc] init];
                warnDataModel.placeType  =  [_data objectAtIndex:1];
                warnDataModel.province   =  [_data objectAtIndex:2];
                warnDataModel.city       =  [_data objectAtIndex:3];
                warnDataModel.alertType     =  [_data objectAtIndex:4];
                warnDataModel.granularity  =  [_data objectAtIndex:5];
                warnDataModel.startDate      =  [_data objectAtIndex:6];
                warnDataModel.endDate       =  [_data objectAtIndex:7];
                
                viewController.wscDataModel = warnDataModel;
            }
        }
    }
}

- (void)dealloc {
    [pTableView release];
    [super dealloc];
}
@end
