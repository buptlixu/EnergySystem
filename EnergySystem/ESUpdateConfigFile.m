//
//  ESUpdateConfigFile.m
//  EnergySystem
//
//  Created by tseg on 15-1-6.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESUpdateConfigFile.h"

@implementation ESUpdateConfigFile

- (void)getUserConfigInfo:(ESAlertView *) alertView
{
    _alertView = alertView;
    
    ESDataManageDelegate *configDelegate = [[ESDataManageDelegate alloc] init];
    NSMutableData *data = [[NSMutableData alloc] init];
    
    //[configDelegate performSelectorInBackground:@selector(getUserConfigInfoDelegate:) withObject:data];
    [configDelegate getUserConfigInfoDelegate:data];
    
    
    if ([data length] > 0) {
        
        //验证返回的配置文件MD5验证码
        extern NSDictionary *userInfoDictionary;
        NSNumber *companyIdNSInt = [userInfoDictionary objectForKey:@"companyId"];
        NSString *companyIdNSString = [companyIdNSInt stringValue];
        companyIdNSString = [companyIdNSString stringByAppendingString:@".cfg"];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
                          lastObject];
        path = [path stringByAppendingString:@"/"];
        path = [path stringByAppendingString:companyIdNSString];
        
        ESMD5Util *md5Util = [[ESMD5Util alloc] init];
        NSString *md5 = [md5Util generateFileMD5CheckCode:path];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if ([md5 isEqualToString:result]) {
            NSLog(@"配置文件已是最新");
            [_alertView finishedProgress:@"配置文件已是最新"];
        } else {
            NSLog(@"Downloading...");
            ESDownLoadFile *dlf = [[ESDownLoadFile alloc] initWithESAlertView:_alertView];
            [dlf performSelectorOnMainThread:@selector(downloadFile:)
                                  withObject:companyIdNSString
                               waitUntilDone:YES];
        }
        
        /*
         //解析JSON格式的数据,存入Sqlite本地
         NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
         [self.delegate storeConfigInfoToDBDelegate:resultData];
         */
    }
    
    [data release];
    [configDelegate release];
}

- (id) initWithESAlertView:(ESAlertView *)alertView
{
    _alertView = alertView;
    
    return self;
}

@end
