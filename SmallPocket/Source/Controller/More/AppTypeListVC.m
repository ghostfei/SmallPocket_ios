//
//  AppTypeListVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/12/16.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "AppTypeListVC.h"
#import "Util.h"

@interface AppTypeListVC (){
    NSMutableArray *_dataArray;
}

@end

@implementation AppTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"选择类型";
    [self loadData];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = _dataArray[indexPath.row];
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"selecttypecell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selecttypecell"];
    }
    cell.textLabel.text = dic[@"name"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"select_type_noti" object:@{@"name":dic[@"name"],@"id":dic[@"id"]}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadData{
    [Api post:API_TYPE_LIST parameters:nil completion:^(id data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YLog(@"json=%@",dic);
        if ([dic[@"status"]intValue] == 200) {
            _dataArray = dic[@"data"];
            [self.tableView reloadData];
        }
    }];
}
@end
