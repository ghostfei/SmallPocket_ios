//
//  LikeIndexCollVC.h
//  SmallPocket
//
//  Created by ghostfei on 15/11/18.
//  Copyright © 2015年 ghostfei. All rights reserved.
//


#import <UIKit/UIKit.h> 
#import "LeftVC.h"
//@protocol GimeMeLikeTypeDelegate
//
//-(void)giveMeLikeType:(NSString *)type;
//
//@end

@interface LikeIndexCollVC : UICollectionViewController<GimeMeLikeTypeDelegate>
@property (nonatomic,weak) LeftVC *leftVc;
//@property(assign,nonatomic) id<GimeMeLikeTypeDelegate> delegate;
@end
