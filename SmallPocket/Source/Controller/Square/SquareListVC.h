//
//  SquareListVC.h
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareListVC : UIViewController
@property (strong,nonatomic) NSMutableArray *apps;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (weak, nonatomic) IBOutlet UIPageControl *pageC;
//@property (strong, nonatomic) IBOutlet UIScrollView *advScroll;

@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UIScrollView *typeScroll;
@end
