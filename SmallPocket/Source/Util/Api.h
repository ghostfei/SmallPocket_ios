//
//  Api.h
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"

@interface Api : NSObject

+ (void) post:(NSString *)path parameters:(NSDictionary*) params completion:(void (^)(id data, NSError *err)) cBlock;
+ (void) post:(NSString *)path withId:(NSNumber *)dataId parameters:(NSDictionary*) params completion:(void (^)(id data, NSError *err)) cBlock;
+ (void) post:(NSString *)path parameters:(NSDictionary*) params formDataBlock:(void (^)(id <AFMultipartFormData> formData))fBlock completion:(void (^)(id data, NSError *err)) cBlock;
@end
