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

NS_ASSUME_NONNULL_BEGIN

@interface OpenApps : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *icon;

@end

NS_ASSUME_NONNULL_END
 
