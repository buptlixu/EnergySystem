//
//  ESWarnSearchConditionDataModel.h
//  EnergySystem
//
//  Created by 徐冰 on 15/4/30.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESWarnSearchConditionDataModel : NSObject

@property (strong,nonatomic) NSNumber *uid;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *province;
@property (strong,nonatomic) NSString *city;
@property (strong,nonatomic) NSString *placeType;
@property (strong,nonatomic) NSString *alertType;
@property (strong,nonatomic) NSString *granularity;
@property (strong,nonatomic) NSString *startDate;
@property (strong,nonatomic) NSString *endDate;

@end
