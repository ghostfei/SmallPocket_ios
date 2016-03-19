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
    
    NSString *_key;
}


@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = @"搜索";

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
        Apps *app = _dataArray[indexPath.row];
    cell = [tableView  dequeueReusableCellWithIdentifier:@"SquareListCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.zanBtn.tag = cell.downBtn.tag = indexPath.row+1000;
    
    [cell setContent:app];
    [cell.zanBtn addTarget:self action:@selector(zanAc:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downBtn addTarget:self action:@selector(downAc:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Apps *app = _dataArray[indexPath.row];
    CGSize infoSize = [app.desc boundingRectWithSize:CGSizeMake(tableView.frame.size.width-85, 1000)		 options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    return 44+infoSize.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Apps *app = _dataArray[indexPath.row];
    NSDictionary *param = @{@"name":app.name,@"url":app.url};
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
     
    NSMutableDictionary *ddic = [[NSMutableDictionary alloc]initWithDictionary:@{@"aid":app.id}];
    NSDictionary *dic = [app dictionaryWithValuesForKeys:@[@"createtime",@"url",@"name",@"desc",@"icon"]];
    [ddic addEntriesFromDictionary:dic];
    
    OpenApps *openApp = [OpenApps findOrCreate:ddic];
    openApp.openTime = [[NSDate new]timeIntervalSinceReferenceDate];
    [app save];
    
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
}

#pragma mark
-(void)zanAc:(UIButton *)btn{
    NSString *udid = [Util getDeveiceToken];
    Apps *app = _dataArray[btn.tag-1000];
    NSNumber *like = @1;
    if ([app.approvestatus isEqual:@1]) {
        like = @0;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_LIKE_ACTION parameters:@{@"udid":udid,@"aid":app.id,@"like":like} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status"]integerValue] == 200) {
            [TSMessage showNotificationWithTitle:dic[@"msg"] type:TSMessageNotificationTypeSuccess];
            
            app.approvestatus = like;
            [app save];
            
            [self searchAction:_searchBar.text];
        }else{
            [Util showHintMessage:dic[@"msg"]];
        }
    }];
}

-(void)downAc:(UIButton *)btn{
    NSString *udid =[Util getDeveiceToken];
    Apps *app = _dataArray[btn.tag-1000];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_DOWN_ACTION parameters:@{@"udid":udid,@"aid":app.id} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic=%@",dic);
        if ([dic[@"status"]integerValue] == 200) {
            [self searchAction:_searchBar.text];
            
            app.downstatus = @1;
            [app save];
            
            [TSMessage showNotificationWithTitle:dic[@"msg"] type:TSMessageNotificationTypeSuccess];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_LIKE_REFRESH object:nil];
        }else{
            [Util showHintMessage:dic[@"msg"]];
        }
    }];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchAction:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark loaddata
-(void)reloadData{
    [_dataArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",_key];
    [_dataArray addObjectsFromArray:[Apps where:predicate order:@{@"sort":@"DESC"}]];
    NSLog(@"_dataArray.count:%ld", _dataArray.count);
    [self.tableView reloadData];
}
-(void)searchAction:(NSString *)key{
    _key = key;
    NSString *udid = [Util getDeveiceToken];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_SEARCH_ACTION parameters:@{@"keyword":key,@"udid":udid} completion:^(id data, NSError *err) {
        _hud.hidden = YES;
        if (err) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"json=%@",dic);
        NSArray *result = dic[@"data"];
//        [self.tableView reloadData];
        for (NSDictionary *dic in result) {
            Apps *app = [Apps findOrCreate:dic];
            [app save];
        }
        [self reloadData];
    }];
}


@end
