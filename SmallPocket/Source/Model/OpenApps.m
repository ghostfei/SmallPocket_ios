//
//  OpenApps.m
//  
//
//  Created by ghostfei on 15/12/23.
//
//

#import "OpenApps.h"

@implementation OpenApps

// Insert code here to add functionality to your managed object subclass
@dynamic id;
@dynamic createTime;
@dynamic url;
@dynamic name;
@dynamic desc;
@dynamic icon;
@dynamic openTime;

+ (NSString *)primaryKey {
    return @"id";
}
@end
