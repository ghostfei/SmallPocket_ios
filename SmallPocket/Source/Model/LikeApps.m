//
//  LikeApps.m
//  
//
//  Created by pf on 16/3/14.
//
//

#import "LikeApps.h"

@implementation LikeApps
@dynamic id;
@dynamic aid;
@dynamic atid;
@dynamic name;
@dynamic desc;
@dynamic icon;
@dynamic addtime;
@dynamic createtime;
@dynamic url;

+(NSString *)primaryKey{
    return @"id";
}
@end
