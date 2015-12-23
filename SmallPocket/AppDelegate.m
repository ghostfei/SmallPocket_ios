//
//  AppDelegate.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/3.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "AppDelegate.h"
#import "Util.h"
  
#import "AdvTableViewController.h"
#import "ISwitchViewController.h"
#import "LikeIndexCollVC.h"
#import "SquareTableViewController.h"
#import "MoreViewController.h"
#import "LeftVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self _initUI]; 
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.window setRootViewController:self.tabbarVC];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    (@"devicetoken=%@",token);
    
    // Required
    //    [APService registerDeviceToken:deviceToken];
    //    YLog(@"[APService registrationID]=%@",[APService registrationID]);
    
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:K_DeviceToken];
    //    [[NSUserDefaults standardUserDefaults]setObject:[APService registrationID] forKey:K_registJPushId];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    YLog(@"no device");
    //    [[NSUserDefaults standardUserDefaults]setObject:@"no device" forKey:K_registJPushId];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    [APService handleRemoteNotification:userInfo];
    YLog(@"收到通知:%@",userInfo);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"turnonview" object:userInfo];
}

//ios7
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    //    [APService handleRemoteNotification:userInfo];
    YLog(@"收到通知:%@",userInfo);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"turnonview" object:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark 定制UI
-(void)_initUI{
    UIColor *navColor = [UIColor blackColor]; // THEME_COLOR;
    [UINavigationBar appearance].tintColor = navColor; 
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary
                                               dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:@"songti" size:16]
                          forKey:NSFontAttributeName]; // Helvetica-Bold
    // HelveticaNeue-CondensedBlack
    [titleBarAttributes setValue:navColor forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"black_bg"] forBarMetrics:UIBarMetricsDefault];
    //设置导航条
    if ([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
//        [[UINavigationBar appearance] setBarTintColor:KEY_BGCOLOR_BLACK]; //修改导航条背景色
        //设置返回图标
        UIImage *backBtnIcon = [UIImage imageNamed:@"btn_back.png"];
        [UINavigationBar appearance].backIndicatorImage = backBtnIcon;
        [UINavigationBar appearance].backIndicatorTransitionMaskImage = backBtnIcon;
    }
    
    //定制navigation和tabbar
    UINavigationController *adv = [[UINavigationController alloc]initWithRootViewController:[Util createVCFromStoryboard:@"AdvTableViewController"]];
    UINavigationController *iswitch = [[UINavigationController alloc]initWithRootViewController:[Util createVCFromStoryboard:@"ISwitchViewController"]];
    UINavigationController *like =  [[UINavigationController alloc]initWithRootViewController: [Util createVCFromStoryboard:@"LikeIndexCollVC"]];
    UINavigationController *square = [[UINavigationController alloc]initWithRootViewController: [Util createVCFromStoryboard:@"SquareTableViewController"]];
    UINavigationController *more = [[UINavigationController alloc]initWithRootViewController:[Util createVCFromStoryboard:@"MoreViewController"]];
    
    self.tabbarVC = [[UITabBarController alloc]init];
    self.tabbarVC.viewControllers = @[adv,iswitch,like,square,more];
    
    UITabBar *tabbar = self.tabbarVC.tabBar;
//    [tabbar setBackgroundImage:[UIImage imageNamed:@"black_bg"]];
    [tabbar setBarTintColor:[UIColor groupTableViewBackgroundColor]];
    [tabbar setTintColor:[UIColor colorWithRed:73/255.0 green:194/255.0 blue:34/255.0 alpha:1]];
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{
    //                                                        NSForegroundColorAttributeName : UIColorFromRGB(0x787878)
    //                                                        } forState:UIControlStateNormal];
    //    [[UITabBarItem appearance] setTitleTextAttributes:@{
    //                                                        NSForegroundColorAttributeName :UIColorFromRGB(0x787878)
    //                                                        } forState:UIControlStateSelected];
    
    NSArray *tabicon = @[@"tabbar_adv",@"tabbar_switch",@"tabbar_like",@"tabbar_square",@"tabbar_more"];
    NSArray *tabtitle = @[@"精选",@"切换",@"喜欢",@"广场",@"更多"];
    //    int offset = 10;
    //    UIEdgeInsets imageInsets = UIEdgeInsetsMake(offset, 0, -5, 0);
    
    [tabicon enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL * _Nonnull stop) {
        UITabBarItem *tabbarItem = [tabbar.items objectAtIndex:idx];
        
        //        tabbarItem.imageInsets = imageInsets;
        
        tabbarItem.image = [[UIImage imageNamed:item]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        tabbarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",item]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        tabbarItem.title = tabtitle[idx];
    }];
    
    self.tabbarVC.selectedViewController = [self.tabbarVC.viewControllers objectAtIndex:2];//默认选中中间的tabbar
}

-(void)backAc{
    //    UINavigationController
}
@end
