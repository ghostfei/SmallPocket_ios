//
//  AppType.m
//  
//
//  Created by pf on 16/3/14.
//
//

#import "AppType.h"

@implementation AppType
@dynamic id;
@dynamic sort;
@dynamic father;
@dynamic name;

+(NSString *)primaryKey{
    return @"id";
}

@end
