//
//  ESSearchResultChartViewController.m
//  EnergySystem
//
//  Created by tseg on 15-3-25.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESSearchResultChartViewController.h"

@interface ESSearchResultChartViewController ()
{
    NSArray *_data;
    UUChart *_chartLineView;
    UUChart *_chartBarView;
}
@end

@implementation ESSearchResultChartViewController

@synthesize data=_data;
@synthesize pTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.pTableView setDataSource:self];
    [self.pTableView setDelegate:self];
}

- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    NSMutableArray *_xDate = [[NSMutableArray alloc] init];
    NSLog(@"%d",[_data count]);
    NSLog(@"%@",[[_data objectAtIndex:0] objectForKey:@"date"]);
    
    for (int i = 0; i < [_data count]; ++i)
    {
        id tempDate = [[_data objectAtIndex:i] objectForKey:@"date"];
        NSRange dateRange = NSMakeRange(5, 5);
        NSString *xLabel = [[tempDate description] substringWithRange:dateRange];
        [_xDate addObject:xLabel];
    }
    return _xDate;
#warning 目前无法数据库中没有以小时为单位的数据，因此横坐标只做日期处理
//当有小时为单位的数据是，用此进行判断即可
//    if (日为单位) {
//        dateRange = NSMakeRange(5, 5);
//    } else {
//        dateRange = NSMakeRange(11, 5);
//    }
    
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    NSMutableArray *_ySumData = [[NSMutableArray alloc] init];
    NSMutableArray *_yPriData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_data count]; ++i) {
        [_ySumData addObject:[[_data objectAtIndex:i] objectForKey:@"sum"]];
        [_yPriData addObject:[[_data objectAtIndex:i] objectForKey:@"primaryDevice"]];
    }
    return @[_ySumData,_yPriData];
}

- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"chartCell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier
                                                             forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleSubtitle
                        reuseIdentifier:CellIdentifier];
    }
    
    NSInteger section = [indexPath section];
    
    CGRect chartFrame = CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y,
                                   cell.frame.size.width/1.1,cell.frame.size.height/1.1);
    if (section == 0) {
        _chartLineView = [[UUChart alloc] initwithUUChartDataFrame:chartFrame
                                                        withSource:self
                                                         withStyle:UUChartLineStyle];
        [_chartLineView showInView:cell.contentView];
    } else {
        _chartBarView = [[UUChart alloc] initwithUUChartDataFrame:chartFrame
                                                       withSource:self
                                                        withStyle:UUChartBarStyle];
        [_chartBarView showInView:cell.contentView];
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    
    return  screenFrame.size.height/2.8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 1) {
//        return 30.0f;
//    } else {
//        return UITableViewAutomaticDimension;
//    }
#warning XB为什么没有办法显示顶部
    if (section == 0) {
        return 90.0f;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section ? @"柱状图":@"折线图";
}

- (void)dealloc {
    [pTableView release];
    [super dealloc];
}
@end
