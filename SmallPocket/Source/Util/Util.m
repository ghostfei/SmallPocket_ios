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
@end
