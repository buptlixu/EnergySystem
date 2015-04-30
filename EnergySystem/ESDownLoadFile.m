//
//  ESDownLoadFile.m
//  EnergySystem
//
//  Created by tseg on 15-1-6.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESDownLoadFile.h"

@implementation ESDownLoadFile

@synthesize delegate = _delegate;

- (id) initWithESAlertView:(ESAlertView *) alertView
{
    [alertView addProgressInfoOnAlertView];
    _alertView = alertView;
    return self;
}

- (void)downloadFile:(NSString *) fileName
{
    _fileName = [fileName mutableCopy];
    _path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    _path = [_path stringByAppendingPathComponent:_fileName];
    [_path retain];

    NSLog(@"%@",_path);
    
    NSString *url = [serverHttpUrl copy];
    url = [url stringByAppendingString:configFilePath];
    url = [url stringByAppendingString:fileName];
    
    NSURL *nsurl = [NSURL URLWithString:url];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nsurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] init];
    
    _progressView.progress = 0;
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
    _totalLength = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    [self updateProgress];
}

//XB未使用
//- (void)connectionDidFinishLoading:(NSURLConnection *) connection
//{
//    NSLog(@"loading finish");
//    [_data writeToFile:_path atomically:YES];
//    [self performSelectorInBackground:@selector(loadConfigInfo) withObject:nil];
//}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error.localizedDescription);
}

- (void) updateProgress
{
    if (_data.length == _totalLength) {
         [_alertView updateMessage:@"正在加载..."];
        
    } else {
        [_alertView updateProgress:(float)_data.length/_totalLength];
    }
}

- (void) showESAlert
{
    [_alertView show];
}

//XB未使用
//- (void) loadConfigInfo
//{
//    NSError *error = [[NSError alloc] init];
//    _cfgFileContent = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:&error];
//    NSData *contentData = [[NSData alloc] init];
//    contentData = [_cfgFileContent dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:contentData options:kNilOptions error:nil];
//    _delegate = [[ESDataManageDelegate alloc] init];
//    [self.delegate storeConfigInfoToDBDelegate:resultData:_alertView];
//}


@end
