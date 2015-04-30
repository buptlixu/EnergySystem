//
//  ESSqliteUtil.m
//  EnergySystem
//
//  Created by tseg on 14-8-27.
//  Copyright (c) 2014年 tseg. All rights reserved.
//

#import "ESSqliteUtil.h"
#import "ESConstants.h"

@implementation ESSqliteUtil

@synthesize db = _db;

-(BOOL)open
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *databasePath = [documents stringByAppendingPathComponent:ESDBNAME];
    
    if (sqlite3_open([databasePath UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"打开数据库失败");
        NSLog(@"errorCode = %d",sqlite3_open([databasePath UTF8String],&_db));
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)close
{
    if (sqlite3_close(_db) != SQLITE_OK) {
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)execSQL:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"执行失败 %@", sql);
        return NO;
    } else {
        return YES;
    }
}

@end
