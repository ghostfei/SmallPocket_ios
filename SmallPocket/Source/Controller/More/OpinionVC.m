//
//  OpinionVC.m
//  SmallPocket
//
//  Created by pf on 15/12/16.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "OpinionVC.h"
#import "Util.h"

@interface OpinionVC (){
    MBProgressHUD *_hud;
}

@end

@implementation OpinionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"吐槽-建议";
    _textView.delegate = self;
    [_textView becomeFirstResponder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAc)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

-(void)saveAc{
    [self endEdit];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_OPINION_ACTION parameters:@{@"content":_textView.text} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       if ([dic[@"status"]intValue] == 200) {
           [self.navigationController popViewControllerAnimated:YES];
       }else{
           [self.view makeToast:@"未知错误"];
       }
    }];
}
-(void)endEdit{
    [self.view endEditing:YES];
}
@end
