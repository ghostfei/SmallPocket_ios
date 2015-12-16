//
//  BaseModel.h
//  SmallPocket
//
//  Created by ghostfei on 15/11/16.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Util.h"

@interface BaseModel : JSONModel
@property(nonatomic, copy) NSString<Optional> *sp_id;
@end
