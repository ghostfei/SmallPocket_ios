//
//  SearchVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/29.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SearchVC.h"
#import "Util.h"
#import "SquareListCell.h"
#import "OpenWebAppVC.h"
#import "OpenApps.h"
@interface SearchVC (){
    NSMutableArray *_dataArray;
    MBProgressHUD *_hud;
}


@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"Search";

    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBar;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SquareListCell *cell;
        NSDictionary *dic = _dataArray[indexPath.row];
    cell = [tableView  dequeueReusableCellWithIdentifier:@"SquareListCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.zanBtn.tag = cell.downBtn.tag = indexPath.row;
    
    [cell setContent:dic];
    [cell.zanBtn addTarget:self action:@selector(zanAc:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downBtn addTarget:self action:@selector(downAc:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *desc = dic[@"desc"];
    CGSize size = CGSizeMake(self.view.frame.size.width-80, 1000);
    CGSize infoSize = [desc sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    return 44+infoSize.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataArray[indexPath.row];
    NSDictionary *param = @{@"name":dic[@"name"],@"url":dic[@"url"]};
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    
    NSMutableDictionary *ddic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    [ddic addEntriesFromDictionary:@{@"aid":dic[@"id"]}];
    
    OpenApps *app = [OpenApps findOrCreate:ddic];
    app.openTime = [[NSDate new]timeIntervalSinceReferenceDate];
    [app save];
    
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
}

#pragma mark
-(void)zanAc:(UIButton *)btn{
    NSString *udid = [[NSUserDefaults standardUserDefaults]objectForKey:K_DeviceToken];
    NSDictionary *dic = _dataArray[btn.tag];
    NSNumber *like = @1;
    if ([dic[@"approvestatus"]integerValue]==1) {
        like = @0;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_LIKE_ACTION parameters:@{@"udid":@"12",@"aid":dic[@"id"],@"like":like} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status"]integerValue] == 200) {
            [TSMessage showNotificationWithTitle:dic[@"msg"] subtitle:nil type:TSMessageNotificationTypeSuccess];
            [self searchAction:_searchBar.text];
        }
    }];
}

-(void)downAc:(UIButton *)btn{
    NSDictionary *dic = _dataArray[btn.tag];
    NSString *udid = [[NSUserDefaults standardUserDefaults]objectForKey:K_DeviceToken];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_DOWN_ACTION parameters:@{@"udid":@"12",@"aid":dic[@"id"]} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic=%@",dic);
        if ([dic[@"status"]integerValue] == 200) {
            [TSMessage showNotificationWithTitle:dic[@"msg"] subtitle:nil type:TSMessageNotificationTypeSuccess];
            [self searchAction:_searchBar.text];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"downapp_noti" object:nil];
        }
    }];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchAction:searchBar.text];
    [searchBar resignFirstResponder];
}


-(void)searchAction:(NSString *)key{
    [Api post:API_SEARCH_ACTION parameters:@{@"keyword":key,@"udid":@"12"} completion:^(id data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"json=%@",dic);
        _dataArray = dic[@"data"];
        [self.tableView reloadData];
    }];
}


@end
