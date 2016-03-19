//
//  AppType.h
//  
//
//  Created by pf on 16/3/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ObjectiveRecord.h"


@interface AppType : NSManagedObject
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *sort;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *father;

@end
