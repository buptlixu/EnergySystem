//
//  ESTitleManageViewController.m
//  EnergySystem
//
//  Created by tseg on 15-3-4.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESTitleManageViewController.h"

@interface ESTitleManageViewController()
{
    NSString *_name;
}

@end

@implementation ESTitleManageViewController

@synthesize pTableView;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    //加载数据库中的标题
    _names = [[NSMutableArray alloc] init];
    _provinces = [[NSMutableArray alloc] init];
    _cities = [[NSMutableArray alloc] init];
    _types = [[NSMutableArray alloc] init];
    _warnOrNot = [[NSMutableArray alloc] init];
    
    
    [self loadTitleTable];
    [pTableView setDataSource:self];
    [pTableView setDelegate:self];
//    [self.pTableView scrollRectToVisible:CGRectMake(0, 0, self.pTableView.contentSize.width, self.pTableView.contentSize.height) animated:YES];
}

- (void)loadTitleTable
{
    NSLog(@"TITLEMANAGEVIEW");
    extern NSDictionary *userInfoDictionary;
    NSNumber *userID = [userInfoDictionary objectForKey:@"uid"];

    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    sqlite3_stmt *stmt;
    
    if ([sqlUtil open]) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT USERID,NAME,TYPE,PROVINCE,CITY FROM TITLETABLE WHERE USERID = %d",[userID intValue]];
        if (sqlite3_prepare_v2(sqlUtil.db, [querySQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                [_names addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,1)]];
                [_types addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,2)]];
                [_provinces addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,3)]];
                [_cities addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,4)]];
                [_warnOrNot addObject:[[NSString alloc] initWithFormat:@"NO"]];
            }
        }
        
        //XB打开能耗告警表格
#warning 为什么已经没有数据了执行结果还是SQLITE_OK
        querySQL = [NSString stringWithFormat:@"SELECT USERID,NAME,TYPE,PROVINCE,CITY FROM WARNTITLETABLE WHERE USERID = %d", [userID intValue]];
        if (sqlite3_prepare_v2(sqlUtil.db, [querySQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                [_names addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,1)]];
                [_types addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,2)]];
                [_provinces addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,3)]];
                [_cities addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,4)]];
                [_warnOrNot addObject:[[NSString alloc] initWithFormat:@"YES"]];
            }
        }
        
        [sqlUtil close];
    } else {
        NSLog(@"数据库打开失败");
        [sqlUtil close];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"titleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    // Configure cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [_names objectAtIndex:row];
    cell.detailTextLabel.text = [_types objectAtIndex:row];
    
//  XB判断是告警还是普通查询以配不同图标
    if ([[_warnOrNot objectAtIndex:row]  isEqual: @"YES"]) {
        cell.imageView.image = [UIImage imageNamed:@"warn.png"];
    }
    else {
        if ([[_types objectAtIndex:row]  isEqual: @"机房"]) {
            cell.imageView.image = [UIImage imageNamed:@"room.png"];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"base_station.png"];
        }
    }
    
    cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@"、"];
    cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:[_provinces objectAtIndex:row]];
    cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:@"、"];
    cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:[_cities objectAtIndex:row]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //删除数据库中的数据
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM TITLETABLE WHERE NAME = '%@'",[_names objectAtIndex:indexPath.row]];
        
        ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
        
        if ([sqlUtil open]) {
            if (![sqlUtil execSQL:deleteSQL]) {
                NSLog(@"DELETE ERROR");
            }
        //  XB无法确定删除的是哪张表,但非1即2
            else {
                deleteSQL = [NSString stringWithFormat:@"DELETE FROM WARNTITLETABLE WHERE NAME = '%@'", [_names objectAtIndex:indexPath.row]];
                if (![sqlUtil execSQL:deleteSQL]) {
                    NSLog(@"DELETE ERROR");
                }
            }
            
            [sqlUtil close];
        }
        
        //删除数据操作
        [_names removeObjectAtIndex:indexPath.row];
        [_types removeObjectAtIndex:indexPath.row];
        [_provinces removeObjectAtIndex:indexPath.row];
        [_cities removeObjectAtIndex:indexPath.row];
        
        //刷新列表
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"titleDetail"]) {
        ESTitleDetailViewController *titleDetail = (ESTitleDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.pTableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.pTableView cellForRowAtIndexPath:indexPath];
        titleDetail.name = cell.textLabel.text;
    }
}

- (void)dealloc {
    [pTableView release];
    [super dealloc];
}
@end
