//
//  ESNetworkDelegate.m
//  EnergySystem
//
//  Created by tseg on 14-11-4.
//  Copyright (c) 2014年 tseg. All rights reserved.
//

#import "ESDataManageDelegate.h"

@implementation ESDataManageDelegate

- (void) loginDelegate:(NSString *) username
                        :(NSString *) password
                        :(NSMutableDictionary *) result
{
    
    NSString *urlAsString = [[NSString alloc] initWithString:serverHttpUrl];
    
    urlAsString = [urlAsString stringByAppendingString:loginAction];
    urlAsString = [urlAsString stringByAppendingString:username];
    urlAsString = [urlAsString stringByAppendingString:@"&pw="];
    urlAsString = [urlAsString stringByAppendingString:password];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:NETWORKTIMEOUT];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    //发送同步Http信息，进行登录验证
    NSURLResponse *response = nil;
    NSError *connectionError = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:&response
                                                     error:&connectionError];
    
    [result setValue:data forKey:@"data"];
    [result setValue:connectionError forKey:@"connectionError"];
    
    //内存过度释放？？NSString类型此处不需要释放
    //[urlAsString release];
}

- (void) getUserConfigInfoDelegate:(NSMutableData *) data
{
    //根据用户登录后返回的companyId，向服务器发送请求，获取该用户权限内的静态配置信息
    extern NSDictionary *userInfoDictionary;
    NSNumber *companyIdNSInt = [userInfoDictionary objectForKey:@"companyId"];
    NSString *companyIdNSString = [companyIdNSInt stringValue];
    
    NSString *urlAsString = [[NSString alloc] initWithString:serverHttpUrl];
    urlAsString = [urlAsString stringByAppendingString:configAction];
    urlAsString = [urlAsString stringByAppendingString:companyIdNSString];
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:NETWORKTIMEOUT];
    [urlRequest setHTTPMethod:@"POST"];
    
    //发送同步Http信息
    NSURLResponse *response = nil;
    NSError *connectionError = nil;
    NSData *tmpData = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:&response
                                                        error:&connectionError];
    [data appendData:tmpData];
}

//未使用
//- (BOOL) storeConfigInfoToDBDelegate:(NSDictionary *)data
//                                    :(ESAlertView *)alertView
//{
//    //开启数据库
//    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
//    if ([sqlUtil open]) {
//        
//        //ESUserConfigInfo类
//        ESUserConfigInfo *configData = [[ESUserConfigInfo alloc] init];
//        configData.userid = [userInfoDictionary objectForKey:@"uid"];
//        
//        //首先清空当前表内属于此用户的配置数据
//        NSString *deleteSQL = [NSString  stringWithFormat:@"DELETE FROM CONFIG WHERE USERID = %d",
//                               [configData.userid intValue]];
//        [sqlUtil execSQL:deleteSQL];
//        
//        //更新此用户的配置信息
//        //解析rooms数据，插入到数据库esdb的表config中
//        NSArray *rooms = [data objectForKey:@"rooms"];
//        NSArray *sites = [data objectForKey:@"sites"];
//        NSString *insertSQL = @"INSERT INTO CONFIG (USERID,PROVINCE,CITY,COUNTY,BUILDING,ROOM,TYPE) VALUES";
//        NSString *appendSQL = nil;
//        NSString *fullSQL = nil;
//        
//        alertView.progressView.progress = 0;
//        int len = [rooms count];
//        len = len + [sites count];
//        
//        for (int i = 0; i < [rooms count]; ++i) {
//            
//            [configData setRoomValue:rooms[i]];
//            
//            //构建insert语句
//            appendSQL = [NSString stringWithFormat:@" (%d,'%@','%@','%@','%@','%@',1)",[configData.userid intValue],configData.province,configData.city,configData.county,configData.building,configData.room];
//            
//            fullSQL = [insertSQL stringByAppendingString:appendSQL];
//            
//            if (![sqlUtil execSQL:fullSQL]) {
//                return NO;
//            }
//            
//            [alertView performSelectorOnMainThread:@selector(updateLoadingProgress:) withObject:[NSNumber numberWithFloat:(float)i/len] waitUntilDone:YES];
//            
//        }
//        
//        //解析sites数据，插入到数据库esdb的表config中
//        insertSQL = @"INSERT INTO CONFIG (USERID,PROVINCE,CITY,COUNTY,BUILDING,SITE,TYPE) VALUES";
//        
//        for (int i = 0; i < [sites count]; ++i) {
//            
//            [configData setSiteValue:sites[i]];
//            
//            //构建insert语句
//            appendSQL = [NSString stringWithFormat:@" (%d,'%@','%@','%@','%@','%@',2)",[configData.userid intValue],configData.province,configData.city,configData.county,configData.building,configData.site];
//           
//            fullSQL = [insertSQL stringByAppendingString:appendSQL];
//            
//            //NSLog(@"%@",fullSQL);
//            if (![sqlUtil execSQL:fullSQL]) {
//                return NO;
//            }
//            
//            [alertView performSelectorOnMainThread:@selector(updateLoadingProgress:) withObject:[NSNumber numberWithFloat:(float)(i + [rooms count])/len] waitUntilDone:YES];
//            
//        }
//        
//        [alertView performSelectorOnMainThread:@selector(finishedProgress:) withObject:[NSString stringWithFormat:@"更新完成"] waitUntilDone:YES];
//        
//        [configData release];
//    } else {
//        return NO;
//    }
//    
//    [sqlUtil close];
//    [sqlUtil release];
//
//    return YES;
//}

- (BOOL)goToMainViewWithFirstLoginDelegate
{
    //查询数据库表Config中是否有此登录用户的USERID
    ESUserConfigInfo *configData = [[ESUserConfigInfo alloc] init];
    configData.userid = [userInfoDictionary objectForKey:@"uid"];
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) AS NUM FROM TITLETABLE WHERE USERID = %d",
                          [configData.userid intValue]];
    
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    sqlite3_stmt *stmt;
    
    int num = 0;
    if ([sqlUtil open]) {
        if (sqlite3_prepare_v2(sqlUtil.db, [querySQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                num = sqlite3_column_int(stmt,0);
            }
        }
        [sqlUtil close];
    } else {
        NSLog(@"数据库打开失败");
        [sqlUtil close];
    }
    
    [sqlUtil release];
    [configData release];
    
    if (num == 0) {
        firstLogin = YES;
        return YES;
    } else {
        firstLogin = NO;
        return NO;
    }
}

- (void)getConfigInfoFromDBDelegate:(NSMutableArray *) data
{
    ESUserConfigInfo *configData = [[ESUserConfigInfo alloc] init];
    configData.userid = [userInfoDictionary objectForKey:@"uid"];
    
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CONFIG WHERE USERID = %d AND TYPE = 1",
                          [configData.userid intValue]];
    
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    sqlite3_stmt *stmt;
    
    if ([sqlUtil open]) {
        if (sqlite3_prepare_v2(sqlUtil.db, [querySQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                [data addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,5)]];
            }
        }
        [sqlUtil close];
    } else {
        NSLog(@"数据库打开失败");
        [sqlUtil close];
    }

    [sqlUtil release];
    [configData release];
}

- (void)getConfigInfoFromDBDelegate:(NSMutableArray *) data
                                   :(NSString *) querySQL
                                   :(int) colIndex
{
    ESUserConfigInfo *configData = [[ESUserConfigInfo alloc] init];
    configData.userid = [userInfoDictionary objectForKey:@"uid"];
    
    //NSString *querySQL = [NSString stringWithFormat:@"SELECT DISTINCT PROVINCE FROM CONFIG WHERE USERID = %d",[configData.userid intValue]];
    
    ESSqliteUtil *sqlUtil = [[ESSqliteUtil alloc] init];
    sqlite3_stmt *stmt;
    
    if ([sqlUtil open]) {
        if (sqlite3_prepare_v2(sqlUtil.db, [querySQL UTF8String], -1, &stmt, nil) == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                [data addObject:[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(stmt,colIndex)]];
            }
        }
        [sqlUtil close];
    } else {
        NSLog(@"数据库打开失败");
        [sqlUtil close];
    }
    
    [sqlUtil release];
    [configData release];

}

//未使用到的方法
//- (void) loadConfigInfo:(NSString *)path
//{
//    //NSString *cfgFileContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"COMPLETED!");
//    //NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:[cfgFileContent dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
//    //[self storeConfigInfoToDBDelegate:resultData];
//}
@end
