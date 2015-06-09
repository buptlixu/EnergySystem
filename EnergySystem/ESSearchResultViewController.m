//
//  ESSearchResultViewController.m
//  EnergySystem
//
//  Created by tseg on 15-3-24.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESSearchResultViewController.h"

@interface ESSearchResultViewController ()
{
    NSArray *_data;
}
@end

@implementation ESSearchResultViewController

@synthesize data = _data;
@synthesize pTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [pTableView setDataSource:self];
    [pTableView setDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([_data count] == 0) {
        [self performSelectorOnMainThread:
                    @selector(showNoDataAlert) withObject:nil waitUntilDone:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_data objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"resultDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];

    if ([[_data objectAtIndex:section] count] == 4)//告警信息展示
    {
        switch (row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"日期：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"time"]];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"地点：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"location"]];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"数值：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"value"]];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"级别：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"level"]];
                break;
        }
    
    }
    else
    {
        switch (row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"日期：",
                                       [[_data objectAtIndex:section]
                                                    objectForKey:@"date"]];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"地点：",
                                       [[_data objectAtIndex:section]
                                                    objectForKey:@"location"]];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"总能耗：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"sum"]];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"主设备能耗：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"primaryDevice"]];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"空调能耗：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"cooling"]];
                break;
            case 5:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"照明：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"lighting"]];
                break;
            case 6:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"插座：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"SMPS"]];
                break;
            case 7:
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@",@"其他：",
                                       [[_data objectAtIndex:section]
                                        objectForKey:@"other"]];
                break;
            default:
                break;
        }
    }

    return cell;
}

-(void)showNoDataAlert
{
    UIAlertView *noDataAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:@"没有数据" delegate:self
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [noDataAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    [_data release];
    [pTableView release];
    [super dealloc];
}
@end
