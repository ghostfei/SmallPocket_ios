//
//  SquareListHeaderCell.h
//  SmallPocket
//
//  Created by ghostfei on 15/12/12.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareListHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *advScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControll;

-(void)initScroll:(NSArray *)images;
@end
