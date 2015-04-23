//
//  ESSearchMainViewController.m
//  EnergySystem
//
//  Created by 徐冰 on 15/4/8.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESSearchMainViewController.h"

@interface ESSearchMainViewController ()

@end

@implementation ESSearchMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"general_bg.png"]];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:];
//    self.navigationItem.leftBarButtonItem = leftButton;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
