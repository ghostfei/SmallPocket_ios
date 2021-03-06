//
//  Util.h
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import <TSMessageView.h> 
#import <JSONModel.h>
#import <MBProgressHUD.h>
#import <UIView+Toast.h>
#import "MJRefresh.h"
#import "CoreDataManager.h"
#import "ObjectiveRecord.h"

#import "Api.h"

typedef NS_ENUM(NSInteger,viewType){
    LikeViewType,
    SquareViewType
};

//自定义输出log
#ifdef DEBUG
#define YLog(format,...) NSLog(@"%s%d line "format,__func__,__LINE__,##__VA_ARGS__);
#else
#define YLog(...);
#endif

#define DEFAULT_API_URL @"http://120.24.159.129/SmallPocket/"
//#define DEFAULT_API_URL @"http://127.0.0.1:8888/SmallPocket/"
#define REQUEST_TIME_OUT 20 //网络请求 超时时间

#define KUMENG_TOKEN @"5672872e67e58e5f0e001a36"
#define K_DeviceToken @"K_DeviceToken"
#define ScreenW self.view.frame.size.width

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define API_LIKE_LIST @"api.php/Apps/likeList"  //喜欢列表
#define API_APPS_LIST @"api.php/Apps/appList" //应用列表
#define API_TYPE_LIST @"api.php/Type/typeList" //分类列表
#define API_LIKE_ACTION @"api.php/Apps/like" //点赞
#define API_DOWN_ACTION @"api.php/Apps/down" //下载
#define API_ADV_LIST @"api.php/Adv/advList" //精选或轮播
#define API_OPINION_ACTION @"api.php/Opinion/addOpinion" //吐槽
#define API_UPLOADAPP_ACTION @"api.php/Apps/upApp" //长传应用
#define API_SEARCH_ACTION @"api.php/Apps/search" //搜索
#define API_DELACTION @"api.php/Apps/delApp" //删除应用
#define API_PROTOCOL @"api.php/Index/aboutUs" //应用协议


#define NOTIFY_LIKE_REFRESH @"NOTIFY_LIKE_REFRESH"

#define KEY_BGCOLOR_BLACK [UIColor blackColor]
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
@interface Util : NSObject
+ (id)createVCFromStoryboard:(NSString *)identifier;

+ (NSString *)getAPIUrl:(NSString *)path;
+ (NSString *)getAPIUrl:(NSString *)path withId:(NSNumber *)idValue;

#pragma mark 加载动画 系统
+ (void)startActiciView:(UIView *)view;
+ (void)stopActiciView:(UIView *)view;
+ (void)startActiciView;
+ (void)stopActiciView;

#pragma mark fresh
+(MJRefreshFooter *) getMJFooterTarget:(id)target action:(SEL)action;
+(MJRefreshHeader *) getMJHeaderTarget:(id)target action:(SEL)action;

+ (UISearchBar *)createSearchBar:(CGRect)frame delegate:(id)delegate
                     placeholder:(NSString *)placeholder;

#pragma mark date
+ (NSDateFormatter *)getDateFormatter;

//将日期转化成字符串
+ (NSString *)dateToString:(NSDate *)date;

//将字符串转化成日期
+ (NSDate *)stringToDate:(NSString *)date;
+ (void)remarkDeleteAll:(NSString *)className where:(NSDictionary *)where;
+ (void)showHintMessage:(NSString *)message;

+(NSString *)getDeveiceToken;
@end
