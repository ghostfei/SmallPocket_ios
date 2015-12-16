//
//  SquareListHeaderCell.h
//  SmallPocket
//
//  Created by ghostfei on 15/12/12.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareListHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *page;
-(void)setContent:(NSArray *)array;
@end
