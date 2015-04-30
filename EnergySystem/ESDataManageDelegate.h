//
//  ESNetworkDelegate.h
//  EnergySystem
//
//  Created by tseg on 14-11-4.
//  Copyright (c) 2014年 tseg. All rights reserved.
//
//此代理类执行所有需要与服务器端进行连接获取数据的方法
//需要实现的方法在ESDataManageProtocal中定义

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ESConstants.h"
#import "ESDataManageProtocal.h"
#import "ESUserConfigInfo.h"
#import "ESSqliteUtil.h"

@interface ESDataManageDelegate : NSObject <ESDataManageProtocal>

@end
