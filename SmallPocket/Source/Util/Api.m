//
//  Api.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "Api.h"

@implementation Api

//POST请求处理
+ (void)post:(NSString *)path
  parameters:(NSDictionary *)params
  completion:(void (^)(id data, NSError *err))cBlock
{
    [self post:path withId:nil parameters:params completion:cBlock];
}
//POST请求处理（带ID）
+ (void)post:(NSString *)path
      withId:(NSNumber *)dataId
  parameters:(NSDictionary *)params
  completion:(void (^)(id data, NSError *err))cBlock
{
    [self post:path withId:dataId parameters:params formDataBlock:nil completion:cBlock];
}

//POST请求处理(上传文件)
+ (void)post:(NSString *)path
  parameters:(NSDictionary *)params
formDataBlock:(void (^)(id<AFMultipartFormData> formData))fBlock
  completion:(void (^)(id data, NSError *err))cBlock
{
    [self post:path withId:nil parameters:params formDataBlock:fBlock completion:cBlock];
}

//POST请求处理(上传文件,带ID)
+ (void)post:(NSString *)path
      withId:(NSNumber *)dataId
  parameters:(NSDictionary *)params
formDataBlock:(void (^)(id<AFMultipartFormData> formData))fBlock
  completion:(void (^)(id data, NSError *err))cBlock{
    NSString *url = [Util getAPIUrl:path withId:dataId];
    AFHTTPRequestOperationManager *manager = [self initManger];
    [manager POST:url
       parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    if (fBlock) {
        fBlock(formData);
    }
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) { 
              cBlock(responseObject, nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [self failureMessage:operation error:error];
              cBlock(nil, error);
          }];
}

//设置网络操作
+ (AFHTTPRequestOperationManager *)initManger
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    [manager.requestSerializer setValue:[Util getAppSession] forHTTPHeaderField:@"app_session"];
    [manager.requestSerializer setTimeoutInterval:REQUEST_TIME_OUT];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"text/json", nil]];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    return manager;
}

//出错信息显示
+ (void)failureMessage:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    YLog(@"error:%@", error);
    NSString *message = @"网络或者服务有异常";
    [TSMessage showNotificationInViewController:[TSMessage defaultViewController]
                                          title:message
                                       subtitle:nil
                                          image:[UIImage imageNamed:@"icon_warning.png"]
                                           type:TSMessageNotificationTypeError
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}
@end
