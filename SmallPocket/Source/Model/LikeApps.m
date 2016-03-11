//
//  LikeApps+CoreDataProperties.m
//  
//
//  Created by ghostfei on 16/3/12.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LikeApps.h"

@implementation LikeApps
@dynamic aid;
@dynamic createtime;
@dynamic desc;
@dynamic icon;
@dynamic name;
@dynamic addtime;
@dynamic url;
@dynamic atid;
@dynamic modifytime;

+ (NSString *)primaryKey {
    return @"aid";
}
@end
