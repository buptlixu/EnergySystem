//
//  ESConstants.h
//  EnergySystem
//
//  Created by tseg on 14-8-27.
//  Copyright (c) 2014年 tseg. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ESDBNAME
#define ESDBNAME @"esdb"
#endif

#ifndef HUDSLEEPSECONDS
#define HUDSLEEPSECONDS 2
#endif

#ifndef NETWORKTIMEOUT
#define NETWORKTIMEOUT 60.0f
#endif

NSUserDefaults *userInfoSettings;
NSDictionary *userInfoDictionary;
BOOL firstLogin;

//这里应该设计成一个单例模式
static NSString *serverHttpUrl = @"http://10.108.217.190:8080/EnergySystem/";
static NSString *loginAction   = @"Login_UserBasicAction.action?name=";
static NSString *configAction  = @"Configuration_UserBasicAction.action?companyId=";
static NSString *UserSettingAction = @"UserSetting_UserQueryAction.action?";
static NSString *GetDataAction = @"GetData_UserQueryAction.action?";
static NSString *configFilePath = @"resources/downloads/";
static NSString *GetBaojingInfoAction = @"GetBaojingInfo_UserQueryAction.action?";
@interface ESConstants : NSObject

@end
