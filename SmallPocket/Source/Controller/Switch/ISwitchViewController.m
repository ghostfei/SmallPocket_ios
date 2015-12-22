//
//  ISwitchViewController.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "ISwitchViewController.h"
#import "OpenApps.h"

@interface ISwitchViewController ()

@end

@implementation ISwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"切换";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSArray *array = [OpenApps where:@{}];
    [array enumerateObjectsUsingBlock:^(OpenApps *app, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"app.name=%@ and app.id=%@",app.name,app.id);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
