//
//  AdvTableViewController.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "AdvTableViewController.h"
#import "OpenWebAppVC.h"
#import "Util.h"

@interface AdvTableViewController (){
    MBProgressHUD *_hud;
    
    NSMutableArray *_dataArray;
}

@end

@implementation AdvTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"精选";
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    
    _dataArray = [[NSMutableArray alloc]init];
    
    [self loadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
//    NSDictionary *dic = _dataArray[indexPath.row];
//    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[Util getAPIUrl:dic[@"image"]]]];
//    UIImage *img = [UIImage imageWithData:imgData];

//    return (img.size.height*self.view.frame.size.width/img.size.width)/2;
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"advlist"];
    for (UIView *vi in cell.contentView.subviews) {
        [vi removeFromSuperview];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imgv.contentMode = UIViewContentModeScaleAspectFill;
    imgv.clipsToBounds = YES;
    [imgv setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:dic[@"image"]]] placeholderImage:[UIImage imageNamed:@"btn_back"]];
    [cell.contentView addSubview:imgv];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    NSDictionary *dic =_dataArray[indexPath.row];
    NSLog(@"dic=%@",dic);
    NSDictionary *param = @{@"name":dic[@"name"],@"url":dic[@"url"]};
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
}
-(void)loadData{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_ADV_LIST parameters:@{@"type":@"1"} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        if (err) {
            return ;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YLog(@"json=%@",json);
        _dataArray = json[@"data"];
        [self.tableView reloadData];
    }];
}
@end
