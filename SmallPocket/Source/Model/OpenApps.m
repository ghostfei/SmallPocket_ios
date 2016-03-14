//
//  OpenApps.m
//  
//
//  Created by ghostfei on 16/3/12.
//
//

#import "OpenApps.h"

@implementation OpenApps

@dynamic aid;
@dynamic createtime;
@dynamic desc;
@dynamic icon;
@dynamic name;
@dynamic openTime;
@dynamic url;

+ (NSString *)primaryKey {
    return @"aid";
}
@end
