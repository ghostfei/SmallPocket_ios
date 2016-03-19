//
//  AppDelegate.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/3.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "AppDelegate.h"
#import "Util.h"

#import "AdvListVC.h"
#import "ISwitchVC.h"
#import "LikeIndexVC.h"
#import "SquareListVC.h"
#import "MoreIndexVC.h"
#import <UMengAnalytics-NO-IDFA/MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self _initUI];
    
    [MobClick startWithAppkey:KUMENG_TOKEN reportPolicy:BATCH   channelId:@""];//chinnelid==@"" AppStore
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self registPush];
    [self.window setRootViewController:self.tabbarVC];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    
    [NSThread sleepForTimeInterval:0.5];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    // Required
    //    [APService registerDeviceToken:deviceToken];
    //    YLog(@"[APService registrationID]=%@",[APService registrationID]);
    
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:K_DeviceToken];
    //    [[NSUserDefaults standardUserDefaults]setObject:[APService registrationID] forKey:K_registJPushId];
    [[NSUserDefaults standardUserDefaults]synchronize];
    YLog(@"devicetoken=%@",token); 
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    YLog(@"no device"); 
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    YLog(@"收到通知:%@",userInfo);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"turnonview" object:userInfo];
}
//ios7
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    YLog(@"收到通知:%@",userInfo);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"turnonview" object:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark 定制UI
-(void)_initUI{
    UIColor *navColor = [UIColor whiteColor]; // THEME_COLOR;
    [UINavigationBar appearance].tintColor = navColor;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary
                                               dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:@"songti" size:16]
                          forKey:NSFontAttributeName]; // Helvetica-Bold
    // HelveticaNeue-CondensedBlack
    [titleBarAttributes setValue:navColor forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    CGRect rect = CGRectMake(0, 0, SCREENWIDTH, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UINavigationBar appearance]setShadowImage:img];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"black_bg"] forBarMetrics:UIBarMetricsDefault];
    //设置导航条
    if ([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        //        [[UINavigationBar appearance] setBarTintColor:KEY_BGCOLOR_BLACK]; //修改导航条背景色
        //设置返回图标
        UIImage *backBtnIcon = [UIImage imageNamed:@"btn_back.png"];
        [UINavigationBar appearance].backIndicatorImage = backBtnIcon;
        [UINavigationBar appearance].backIndicatorTransitionMaskImage = backBtnIcon;
    }
    
    //定制navigation和tabbar
    UINavigationController *adv = [[UINavigationController alloc]initWithRootViewController:[Util createVCFromStoryboard:@"AdvListVC"]];
//    UINavigationController *iswitch = [[UINavigationController alloc]initWithRootViewController:[Util createVCFromStoryboard:@"ISwitchVC"]];
    UINavigationController *like =  [[UINavigationController alloc]initWithRootViewController: [Util createVCFromStoryboard:@"LikeIndexVC"]];//]@"LikeIndexCollVC"]];
//    UINavigationController *square = [[UINavigationController alloc]initWithRootViewController: [Util createVCFromStoryboard:@"SquareListVC"]];
    UINavigationController *more = [[UINavigationController alloc]initWithRootViewController:[Util createVCFromStoryboard:@"MoreIndexVC"]];
    
    self.tabbarVC = [[UITabBarController alloc]init];
//    self.tabbarVC.viewControllers = @[adv,iswitch,like,square,more];
    self.tabbarVC.viewControllers = @[adv,like,more];
    
    UITabBar *tabbar = self.tabbarVC.tabBar;
    [tabbar setShadowImage:img];
    [tabbar setBackgroundImage:[UIImage imageNamed:@"black_bg"]];
    [tabbar setBarTintColor:[UIColor groupTableViewBackgroundColor]];
    [tabbar setTintColor:[UIColor colorWithRed:73/255.0 green:194/255.0 blue:34/255.0 alpha:1]];
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{
    //                                                        NSForegroundColorAttributeName : UIColorFromRGB(0x787878)
    //                                                        } forState:UIControlStateNormal];
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{
    //                                                        NSForegroundColorAttributeName :UIColorFromRGB(0x787878)
    //                                                        } forState:UIControlStateSelected];
    
//    NSArray *tabicon = @[@"tabbar_adv",@"tabbar_switch",@"tabbar_like",@"tabbar_square",@"tabbar_more"];
//    NSArray *tabtitle = @[@"精选",@"切换",@"喜欢",@"广场",@"更多"];
    NSArray *tabicon = @[@"tabbar_adv",@"tabbar_like2",@"tabbar_more"];
    NSArray *tabtitle = @[@"精选",@"喜欢",@"更多"];
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [tabicon enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL * _Nonnull stop) {
        UITabBarItem *tabbarItem = [tabbar.items objectAtIndex:idx];
        tabbarItem.imageInsets = imageInsets;
        
//        if(idx == 1){
            tabbarItem.image = [[UIImage imageNamed:item]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            tabbarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",item]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        }
//        if (idx != 1) {
//            tabbarItem.imageInsets = UIEdgeInsetsMake(0, 0, -40, 0);
//            tabbarItem.title = tabtitle[idx];
//        }
    }];
    
    self.tabbarVC.selectedViewController = [self.tabbarVC.viewControllers objectAtIndex:1];//默认选中中间的tabbar
}

-(void)registPush{
    // Push register
    NSLog(@"SYSTEMVERSION=%f",SYSTEMVERSION);
    UIApplication *application = [UIApplication sharedApplication];
    if (SYSTEMVERSION >=8.0) {
        NSLog(@"do this");
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];//注册后必须监听
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
}

@end
