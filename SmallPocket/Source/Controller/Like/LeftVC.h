//
//  LeftVC.h
//  SmallPocket
//
//  Created by ghostfei on 15/11/28.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <UIKit/UIKit.h>  

@protocol GimeMeLikeTypeDelegate

-(void)giveMeLikeType:(NSString *)type;

@end

@interface LeftVC : UITableViewController
@property(assign,nonatomic) id<GimeMeLikeTypeDelegate> delegate;

@end
