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
@end
