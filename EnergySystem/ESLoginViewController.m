//
//  ESViewController.m
//  EnergySystem
//
//  Created by tseg on 14-8-25.
//  Copyright (c) 2014年 tseg. All rights reserved.
//

#import "ESLoginViewController.h"

@interface ESLoginViewController ()

@end

@implementation ESLoginViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //加载NSUserDefaults中保存的用户名密码
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_page_bg.png"]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self loadSavedUserInfo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载已保存的用户信息
- (void)loadSavedUserInfo
{
    extern NSUserDefaults *userInfoSettings;
    userInfoSettings = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userInfoSettings stringForKey:@"username"];
    NSString *passWord = [userInfoSettings stringForKey:@"password"];
    
    if (userName && ![userName isEqualToString:@""]) {
        self.userName.text = userName;
    }
    if (passWord && ![passWord isEqualToString:@""]) {
        self.passWord.text = passWord;
    }
    if ([userInfoSettings boolForKey:@"saveButton"]) {
        [self.saveUserNameButton setSelected:YES];
        [self.saveUserNameButton setBackgroundImage:[UIImage imageNamed:@"savePW"] forState:UIControlStateNormal];
    }
    else
    {
        [self.saveUserNameButton setSelected:NO];
        [self.saveUserNameButton setBackgroundImage:[UIImage imageNamed:@"notSavePW"] forState:UIControlStateNormal];
    }
}

- (IBAction)dismissKeyboardTapBackground:(UIControl *)sender
{
    [self.passWord resignFirstResponder];
    [self.loginButton resignFirstResponder];
}

- (IBAction)userNameTextFieldDidEndOnExit:(id)sender
{
    //将密码输入框作为第一响应器，即转到密码输入框
    [self.passWord becomeFirstResponder];
}

- (IBAction)passWordTextFieldDidEndOnExit:(id)sender
{
    //隐藏键盘，并模拟触发点击登录按钮事件
    [sender resignFirstResponder];
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (IBAction)checkBoxButton:(id)sender//XB根据当前状态对勾选框进行图形更改
{
    
    if (self.saveUserNameButton.selected) {
        [self.saveUserNameButton setSelected:NO];
        [self.saveUserNameButton setBackgroundImage:[UIImage imageNamed:@"NotSavePW"] forState:UIControlStateNormal];
        
    } else {
        [self.saveUserNameButton setSelected:YES];
        [self.saveUserNameButton setBackgroundImage:[UIImage imageNamed:@"savePW"] forState:UIControlStateNormal];
    }
    
}

//保存最近一次登录的用户的用户名密码
- (void)saveUserInfoInNSUserDefaults
{
    [userInfoSettings removeObjectForKey:@"username"];
    [userInfoSettings removeObjectForKey:@"password"];
    
    [userInfoSettings setObject:self.userName.text forKey:@"username"];
    [userInfoSettings setObject:self.passWord.text forKey:@"password"];
    [userInfoSettings setBool:self.saveUserNameButton.selected forKey:@"saveButton"];
    
    [userInfoSettings synchronize];
}

//移除已保存的用户名密码
- (void)removeUserInfoInNSUserDefaults
{
    [userInfoSettings removeObjectForKey:@"username"];
    [userInfoSettings removeObjectForKey:@"password"];
    [userInfoSettings setBool:self.saveUserNameButton.selected forKey:@"saveButton"];
    
    [userInfoSettings synchronize];

}

- (IBAction)loginStartOn:(UIButton *)sender
{
    //利用HUD，在登录时进行提示
    MBProgressHUD *loginHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:loginHUD];
    
    //判断用户名密码是否为空
    if ([self.userName.text isEqualToString:@""] || [self.passWord.text isEqualToString:@""]) {
        loginHUD.labelText = @"用户名密码不能为空";
        loginHUD.mode = MBProgressHUDModeCustomView;
        [loginHUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        }];
    } else {
        //保存用户名密码
        if (self.saveUserNameButton.selected) {
            [self saveUserInfoInNSUserDefaults];
        } else {
            [self removeUserInfoInNSUserDefaults];
        }
        loginHUD.labelText = @"登录中...";
        [loginHUD showWhileExecuting:@selector(login) onTarget:self withObject:nil animated:YES];
    }
    
    [loginHUD release];
    
////    服务器未开启时使用，进行正常登录跳转
//    if ([self.delegate goToMainViewWithFirstLoginDelegate]){
//        [self performSelectorOnMainThread:@selector(goToGuideView) withObject:nil waitUntilDone:FALSE];
//    } else {
//        [self performSelectorOnMainThread:@selector(goToMainView) withObject:nil waitUntilDone:FALSE];
//    }
}

//委托连接服务器端，验证用户名／密码
- (void)login
{
    ESDataManageDelegate *esDMDelegate = [[ESDataManageDelegate alloc] init];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    self.delegate = esDMDelegate;
    [self.delegate loginDelegate:self.userName.text :self.passWord.text :result];
    
    NSData *data = [result objectForKey:@"data"];
    NSError *connectionError = [result objectForKey:@"connectionError"];

    if ([data length] > 0 && connectionError == nil) {

        //解析JSON格式的数据为Dictionary
        userInfoDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [userInfoDictionary retain]; //保留userInfoDictionary，在ESMainViewController的getUserConfigInfo中使用
        
        NSNumber *status = [userInfoDictionary objectForKey:@"status"];
        if ([status intValue]== 200) {
            
            if ([self.delegate goToMainViewWithFirstLoginDelegate]){
                [self performSelectorOnMainThread:@selector(goToGuideView) withObject:nil waitUntilDone:FALSE];
            } else {
                [self performSelectorOnMainThread:@selector(goToMainView) withObject:nil waitUntilDone:FALSE];
            }
            
        } else if ([status intValue] == 400) {
            //用户名或密码错误
            [self performSelectorOnMainThread:@selector(showAlertLoginError) withObject:nil waitUntilDone:FALSE];
        }
    } else if (connectionError != nil) {
        //网络连接失败，请检查网络设置
        [self performSelectorOnMainThread:@selector(showHudMessage) withObject:nil waitUntilDone:YES];
    }

    //释放临时对象
    [result release];
    [esDMDelegate release];
    self.delegate = nil;
}

//提示用户名密码错误信息
- (void)showAlertLoginError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"登录失败"
                              message:@"用户名或密码错误，请重新输入"
                              delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

//提示网络连接失败信息，Block形式
- (void)showHudMessage
{
    
    MBProgressHUD *connectErrorHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:connectErrorHUD];

    connectErrorHUD.labelText = @"网络连接失败，请稍后再试";
    connectErrorHUD.mode=MBProgressHUDModeCustomView;
    [connectErrorHUD showAnimated:YES
              whileExecutingBlock:^{
                  sleep(HUDSLEEPSECONDS);
              }
                  completionBlock:^{
                      [connectErrorHUD removeFromSuperview];
                  }];
    
    [connectErrorHUD release];
}

- (void)goToMainView
{
    [self performSegueWithIdentifier:@"mainView" sender:self];
}

- (void)goToGuideView
{
    [self performSegueWithIdentifier:@"guideView" sender:self];
}

@end
