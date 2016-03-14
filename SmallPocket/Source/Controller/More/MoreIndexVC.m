//
//  MoreIndexVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "MoreIndexVC.h"
#import "UploadAppVC.h"
#import "Util.h"

@interface MoreIndexVC ()

@end

@implementation MoreIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"更多";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = barBack;
    self.tableView.scrollEnabled = NO;
    
    [self showVersion];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0 && indexPath.row == 0) {
        [self.navigationController pushViewController:[Util createVCFromStoryboard:@"AboutUsVC"] animated:YES];
    }
    if (indexPath.section ==1 && indexPath.row == 0) {
        [self.navigationController pushViewController:[Util createVCFromStoryboard:@"OpinionVC"] animated:YES];
    }
    if (indexPath.section ==2 && indexPath.row == 0) {
        [self.navigationController pushViewController:[Util createVCFromStoryboard:@"UploadAppVC"] animated:YES];
    }
    if (indexPath.section ==3 && indexPath.row == 1) {
        [Util showHintMessage:@"敬请期待"];
    }
    
}

-(void)showVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *ver = [infoDic objectForKey:@"CFBundleShortVersionString"];
    ver = [NSString stringWithFormat:@"V%@_%@",ver,[infoDic objectForKey:@"CFBundleVersion"]];
    _verLabel.text = ver;

}
@end
