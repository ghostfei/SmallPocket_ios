//
//  LikeApps+CoreDataProperties.h
//  
//
//  Created by ghostfei on 16/3/12.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ObjectiveRecord.h"

@interface LikeApps: NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *aid;
@property (nullable, nonatomic, retain) NSDate *createtime;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) double addtime;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSNumber *atid;
@property (nullable, nonatomic, retain) NSDate *modifytime;

@end
