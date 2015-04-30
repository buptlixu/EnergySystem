//
//  ESNetworkProtocal.h
//  EnergySystem
//
//  Created by tseg on 14-11-4.
//  Copyright (c) 2014年 tseg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ESAlertView.h"

@protocol ESDataManageProtocal <NSObject>

- (void)getUserConfigInfoDelegate:(NSMutableData *) data;

- (void)loginDelegate:(NSString *) password
                       :(NSString *) username
                       :(NSDictionary *) result;

//XB未使用- (BOOL)storeConfigInfoToDBDelegate:(NSDictionary *) data :(ESAlertView *)alertView;

- (BOOL)goToMainViewWithFirstLoginDelegate;

- (void)getConfigInfoFromDBDelegate:(NSMutableArray *) data;

- (void)getConfigInfoFromDBDelegate:(NSMutableArray *) data
                                   :(NSString *) querySQL
                                   :(int) colIndex;
//XB未使用- (void)loadConfigInfo:(NSString *) path;

@end
