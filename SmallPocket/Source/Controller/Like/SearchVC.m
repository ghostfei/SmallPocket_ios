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
@interface SearchVC (){
    UISearchBar *bar ;
    NSMutableArray *dataArray;
}


@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc]init];
    bar = [Util createSearchBar:CGRectMake(0, 0, self.view.frame.size.width - 18, 44) delegate:self placeholder:@"Search"];
    UIView *searchBarView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 44.0)];
    [searchBarView addSubview:bar];
    self.navigationItem.titleView = bar;

    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBar;
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
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SquareListCell *cell;
        NSDictionary *dic = dataArray[indexPath.row];
        cell = [tableView  dequeueReusableCellWithIdentifier:@"SquareListCell"];
        
        cell.tag = cell.zanBtn.tag = cell.downBtn.tag = indexPath.row;
        
        [cell setContent:dic];
        
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = dataArray[indexPath.row];
    NSDictionary *param = @{@"name":dic[@"name"],@"url":dic[@"url"]};
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchAction:searchBar.text];
    [searchBar resignFirstResponder];
}


-(void)searchAction:(NSString *)key{
    [Api post:API_SEARCH_ACTION parameters:@{@"keyword":key} completion:^(id data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"json=%@",dic);
        dataArray = dic[@"data"];
        [self.tableView reloadData];
    }];
}
@end
