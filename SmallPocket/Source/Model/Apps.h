//
//  Apps.h
//  
//
//  Created by ghostfei on 15/12/27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ObjectiveRecord.h"
 

@interface Apps : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *createtime;
@property (nullable, nonatomic, retain) NSString *modifytime;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSNumber *sort;
@property (nullable, nonatomic, retain) NSNumber *likenum;
@property (nullable, nonatomic, retain) NSNumber *downnum;
@property (nullable, nonatomic, retain) NSString *tel;
@property (nullable, nonatomic, retain) NSNumber *atid;
@property (nullable, nonatomic, retain) NSNumber *is_del;
@property (nullable, nonatomic, retain) NSNumber *is_deleted;
@property (nullable, nonatomic, retain) NSNumber *downstatus;
@property (nullable, nonatomic, retain) NSNumber *approvestatus;

@end

 
