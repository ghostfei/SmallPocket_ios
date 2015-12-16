//
//  AppsModel.h
//  SmallPocket
//
//  Created by ghostfei on 15/11/16.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface AppsModel : BaseModel
@property(nonatomic, copy) NSString<Optional> *atid;
@property(nonatomic, copy) NSString<Optional> *createtime;
@property(nonatomic, copy) NSString<Optional> *desc;
@property(nonatomic, copy) NSString<Optional> *downnum;
@property(nonatomic, copy) NSString<Optional> *downstatus;
@property(nonatomic, copy) NSString<Optional> *approvestatus;
@property(nonatomic, copy) NSString<Optional> *icon;
@property(nonatomic, copy) NSString<Optional> *is_del;
@property(nonatomic, copy) NSString<Optional> *likenum;
@property(nonatomic, copy) NSString<Optional> *modifytime;
@property(nonatomic, copy) NSString<Optional> *name;
@property(nonatomic, copy) NSString<Optional> *tel;
@property(nonatomic, copy) NSString<Optional> *url;
@end
