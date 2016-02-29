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
    
    NSArray *_dataArray;
}

@end

@implementation AdvTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"精选";
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
//    self.tableView.backgroundColor = KEY_BGCOLOR_BLACK;
    self.tableView.header = [Util getMJHeaderTarget:self action:@selector(loadData)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self loadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //去除提示字
    for (UIView *la in self.tableView.subviews) {
        if ([la isKindOfClass:[UILabel class]]) {
            [la removeFromSuperview];
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"advlist"];
    for (UIView *vi in cell.contentView.subviews) {
        [vi removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dic = _dataArray[indexPath.row];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width,120)];
    [cell.contentView addSubview:imgv];
    
    [imgv setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:dic[@"image"]]] placeholderImage:[UIImage imageNamed:@"btn_back"]];
    imgv.contentMode = UIViewContentModeScaleAspectFill;
    imgv.clipsToBounds = YES;
//    [imgv setNeedsDisplay];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150, cell.frame.size.width, 4)];
    line.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:line];
    
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
        [self.tableView.header endRefreshing];
        if (err) {
            return ;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YLog(@"json=%@",json);
        _dataArray = json[@"data"];
        if (_dataArray.count==0) {
            UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
            la.text = @"这里将显示为您精选的应用";
            la.textColor = [UIColor grayColor];
            la.textAlignment = NSTextAlignmentCenter;
            [self.tableView addSubview:la];
        }
        [self.tableView reloadData];
        
    }];
}
@end
