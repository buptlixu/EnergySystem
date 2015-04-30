//
//  ESSearchResultTabBarViewController.m
//  EnergySystem
//
//  Created by tseg on 15-3-26.
//  Copyright (c) 2015年 tseg. All rights reserved.
//

#import "ESSearchResultTabBarViewController.h"

@interface ESSearchResultTabBarViewController ()
{
    NSArray *_data;
}
@end

@implementation ESSearchResultTabBarViewController

@synthesize scDataModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self translateKPI];
    NSString *url = [self generateURLString];
    NSLog(@"%@",url);
    
    [self getSearchResultFromServer:url];//从服务器端查询数据，在方法中已将结果存入_data
    
    if ([self.viewControllers[0] isKindOfClass:[ESSearchResultViewController class]]) {
        ESSearchResultViewController *srv =
                                (ESSearchResultViewController *)self.viewControllers[0];
        srv.data = _data;
    }
    
    if ([self.viewControllers[1] isKindOfClass:[ESSearchResultChartViewController class]]) {
        ESSearchResultChartViewController *srcv =
                                (ESSearchResultChartViewController *)self.viewControllers[1];
        srcv.data = _data;
    }
}

#warning 与数据库对应，列出所有kpi值
- (void) translateKPI
{
    if ([self.scDataModel.kpi isEqualToString:@"机房空调耗电"]
                    || [self.scDataModel.kpi isEqualToString:@"基站空调耗电"]) {
        
        self.scDataModel.kpi = [NSString stringWithFormat:@"%@",@"air_conditioner_en=1"];
        self.scDataModel.sort_target = [NSString stringWithFormat:@"%@",@"air_conditioner_en"];
        
    } else if ([self.scDataModel.kpi isEqualToString:@"机房照明耗电"]
                    || [self.scDataModel.kpi isEqualToString:@"基站照明耗电"]) {
        
        self.scDataModel.kpi = [NSString stringWithFormat:@"%@",@"lighting_en=1"];
        self.scDataModel.sort_target = [NSString stringWithFormat:@"%@",@"lighting_en"];
        
    } else if ([self.scDataModel.kpi isEqualToString:@"机房主设备耗电"]
                    || [self.scDataModel.kpi isEqualToString:@"基站主设备耗电"]) {

        self.scDataModel.kpi = [NSString stringWithFormat:@"%@",@"device_en=1"];
        self.scDataModel.sort_target = [NSString stringWithFormat:@"%@",@"device_en"];
    }
}

- (NSString *)generateURLString
{
    NSMutableString *url = [[NSMutableString alloc] init];
    extern NSDictionary *userInfoDictionary;
    NSNumber *userID = [userInfoDictionary objectForKey:@"uid"];
    
    [url appendFormat:@"%@%@uid=%d",
                    serverHttpUrl,UserSettingAction,[userID intValue]];
    [url appendFormat:@"&province=%@",self.scDataModel.province];
    
    if (self.scDataModel.city != nil) {
        [url appendFormat:@"&city=%@",self.scDataModel.city];
    }
    
    if (self.scDataModel.county != nil) {
        [url appendFormat:@"&county=%@",self.scDataModel.county];
    }
    [url appendFormat:@"&placeType=%@",self.scDataModel.placeType];
    [url appendFormat:@"&%@",self.scDataModel.kpi];
    
    //时间粒度：如果为天，则显示地区前7天的数据；
    //如果为小时，则显示地区当前最多24小时的数据，即当天的数据
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

//warning "目前为测试阶段的数据，时间设定为指定内容，实际应用时需切换为当前时间"
    NSDate *start = [dateFormatter dateFromString:@"2012-04-06"];
    NSDate *end = [[NSDate alloc] init];
    
    if ([self.scDataModel.time isEqualToString:@"日"]) {
        end = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:start];
    } else if ([self.scDataModel.time isEqualToString:@"小时"]) {
        end = [NSDate dateWithTimeInterval:60*60*24 sinceDate:start];
    }
    
    self.scDataModel.startDate = [dateFormatter stringFromDate:start];
    self.scDataModel.endDate = [dateFormatter stringFromDate:end];
    

//XB实现以当前日期为起点的查询，但数据库为空，因此继续使用之前代码
//    //获取当前时间，赋给localDate
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSDate *date = [NSDate date];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localDate = [date  dateByAddingTimeInterval: interval];
//    NSLog(@"当前时间 localDate = %@",localDate);
//    
//    NSDate *before = [[NSDate alloc] init];//记录日期起点
//    if ([self.scDataModel.time isEqualToString:@"日"])
//    {
//        before = [NSDate dateWithTimeInterval:-60*60*24*7 sinceDate:localDate];//显示7天前，使用负数，sinceDate赋值为当前值
//    }
//    else if ([self.scDataModel.time isEqualToString:@"小时"])
//    {
//        before = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:localDate];
//    }
//    self.scDataModel.startDate = [dateFormatter stringFromDate:before];
//    self.scDataModel.endDate = [dateFormatter stringFromDate:localDate];
    
    
    //排序信息，以当前选择的KPI作为排序指标
    if (self.scDataModel.sort != nil) {
        if ([self.scDataModel.sort isEqualToString:@"升序"]) {
            self.scDataModel.sort = @"asc";
        } else {
            self.scDataModel.sort = @"desc";
        }
        
        [url appendFormat:@"&sort=%@",self.scDataModel.sort];
        [url appendFormat:@"&sort_target=%@",self.scDataModel.sort_target];
    }
    
    [url appendFormat:@"&startDate=%@",self.scDataModel.startDate];
    [url appendFormat:@"&endDate=%@",self.scDataModel.endDate];
    
    return url;
}

- (void)getSearchResultFromServer:(NSString *)urlAsString//传入参数为生成好的url查询语句
{
    urlAsString = [urlAsString
                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    if ([tmpData length] > 0) {
        NSDictionary *resultData = [NSJSONSerialization JSONObjectWithData:tmpData
                                                                   options:NSJSONReadingMutableLeaves
                                                                     error:nil];
        NSDictionary *_tmpData = [[NSDictionary alloc] init];
        
        NSNumber *status = [resultData objectForKey:@"status"];
        if ([status intValue] == 200) {
            if ([self.scDataModel.placeType isEqualToString:@"机房"]) {
                
                _tmpData = [resultData objectForKey:@"room_data"];
                _data = [_tmpData objectForKey:@"data"];
                
            } else if ([self.scDataModel.placeType isEqualToString:@"基站"]) {
                
                _tmpData = [resultData objectForKey:@"site_data"];
                _data = [_tmpData objectForKey:@"data"];
            }
            
            [_data retain];
        }
        NSLog(@"当前有%d个数据",[_data count]);
    }
}

@end
