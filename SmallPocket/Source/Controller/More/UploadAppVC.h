//
//  UploadAppVC.h
//  SmallPocket
//
//  Created by ghostfei on 15/12/6.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadAppVC : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UITextField *publisher;
@property (weak, nonatomic) IBOutlet UITextField *tel;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
