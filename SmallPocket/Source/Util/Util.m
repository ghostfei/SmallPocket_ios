//
//  Util.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "Util.h"

@implementation Util
+ (id)createVCFromStoryboard:(NSString *)identifier{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

//生成API完整地址
+ (NSString *)getAPIUrl:(NSString *)path{
    return [Util getAPIUrl:path withId:nil];
}

//生成API完整地址（带ID参数）
+ (NSString *)getAPIUrl:(NSString *)path withId:(NSNumber *)idValue{
    NSString *url;
    if (idValue == nil) {
        url = [NSString stringWithFormat:@"%@%@", DEFAULT_API_URL, path];
    } else {
        url = [NSString stringWithFormat:@"%@%@/%@", DEFAULT_API_URL, path, idValue];
    }
    YLog(@"APIUrl:%@", url);
    return url;
}

#pragma mark 加载动画 系统
+ (void)startActiciView:(UIView *)view
{ 
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    
}

+ (void)stopActiciView:(UIView *)view
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:YES];
        });
    });
}
+ (void)startActiciView{
    [self startActiciView:nil];
}
+ (void)stopActiciView{
    [self stopActiciView:nil];
}


//设置MJRefreshFooter
+ (MJRefreshFooter *)getMJFooterTarget:(id)target action:(SEL)action
{
    MJRefreshAutoNormalFooter *footer =
    [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    
    footer.refreshingTitleHidden = YES;
    /*
     [footer setTitle:@"" forState:MJRefreshStateIdle];
     [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
     [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
     */
    return footer;
}

//设置MJRefreshHeader
+ (MJRefreshHeader *)getMJHeaderTarget:(id)target action:(SEL)action
{
    MJRefreshNormalHeader *header =
    [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    /*
     [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
     [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
     [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
     */
    return header;
}

//创建搜索条
+ (UISearchBar *)createSearchBar:(CGRect)frame
                        delegate:(id)delegate
                     placeholder:(NSString *)placeholder
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    ;
    searchBar.delegate = delegate;
    //[searchBar sizeToFit];
    [searchBar setPlaceholder:placeholder];
    
    __block UITextField *searchField;
    [[[searchBar.subviews lastObject] subviews]
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         if ([obj isKindOfClass:[UITextField class]]) {
             searchField = obj;
             *stop = YES;
         }
     }];
    
    searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchField.backgroundColor = UIColorFromRGB(0xdce1e8);
    //    searchField.textColor = [UIColor whiteColor];
    
    return searchBar;
}

//设置日期格式化对象
+ (NSDateFormatter *)getDateFormatter{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return df;
}

//将日期转化成字符串
+ (NSString *)dateToString:(NSDate *)date{
    NSString *dateStr = @"";
    if (date) {
        dateStr = [[Util getDateFormatter] stringFromDate:date];
    }
    
    return dateStr;
}

//将字符串转化成日期
+ (NSDate *)stringToDate:(NSString *)date{
    return [[Util getDateFormatter] dateFromString:date];
}
//标记删除数据
+ (void)remarkDeleteAll:(NSString *)className where:(NSDictionary *)where;
{
    Class class = NSClassFromString(className);
    NSMutableDictionary *allWhere = [[NSMutableDictionary alloc] initWithDictionary:where];
    [allWhere setObject:@0 forKey:@"is_deleted"];
    NSArray *objects = [class where:allWhere]; //清空原有数据
    for (NSManagedObject *object in objects) {
        [object setValue:@1 forKey:@"is_deleted"];
        [object save];
    }
}
//显示提示信息
+ (void)showHintMessage:(NSString *)message
{
    [Util showHintMessage:message afterDelay:2.f];
}

//显示提示信息（指定显示时间）
+ (void)showHintMessage:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    // UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    // UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    // NSLog(@"window:%@,view:%@",window,window.rootViewController.view);
    UIViewController *topController =
    [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:topController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}
+(NSString *)getDeveiceToken{
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:K_DeviceToken];
    if (token == nil || token.length == 0) {
        token = @"暂无";
    }
    NSLog(@"util token=%@",token);
    return token;
}

@end
