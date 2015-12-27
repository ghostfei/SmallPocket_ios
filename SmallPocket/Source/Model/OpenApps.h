//
//  OpenApps.h
//  
//
//  Created by ghostfei on 15/12/23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ObjectiveRecord.h"


@interface OpenApps : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *aid;
@property (nullable, nonatomic, retain) NSDate *createtime;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nonatomic) double openTime;

@end
 
 
