//
//  Apps.m
//  
//
//  Created by ghostfei on 15/12/27.
//
//

#import "Apps.h"

@implementation Apps

@dynamic id;
@dynamic createtime;
@dynamic modifytime;
@dynamic name;
@dynamic icon;
@dynamic desc;
@dynamic url;
@dynamic sort;
@dynamic likenum;
@dynamic downnum;
@dynamic tel;
@dynamic atid;
@dynamic is_del; 
@dynamic approvestatus;
@dynamic downstatus;

+ (NSString *)primaryKey {
    return @"id";
}
@end
