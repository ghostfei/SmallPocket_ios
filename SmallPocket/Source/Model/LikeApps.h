//
//  LikeApps.h
//  
//
//  Created by pf on 16/3/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ObjectiveRecord.h"


@interface LikeApps : NSManagedObject
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *aid;
@property (nullable, nonatomic, retain) NSNumber *atid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSString *createtime;
@property (nullable, nonatomic, retain) NSNumber *addtime;
@property (nullable, nonatomic, retain) NSString *url;
@end
 
