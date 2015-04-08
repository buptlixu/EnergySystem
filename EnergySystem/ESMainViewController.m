//
//  ESMainViewController.m
//  EnergySystem
//
//  Created by tseg on 14-8-27.
//  Copyright (c) 2014年 tseg. All rights reserved.
//

#import "ESMainViewController.h"


@interface ESMainViewController ()

@end

@implementation ESMainViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_page_bg.png"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Configuration Info"]) {
        
    } else if ([segue.identifier isEqualToString:@"searchConfig"]) {
        NSLog(@"%@",@"searchConfig");
    }

}

- (IBAction)logout:(id)sender {
    
    [self performSegueWithIdentifier:@"loginView" sender:self];
}

@end
