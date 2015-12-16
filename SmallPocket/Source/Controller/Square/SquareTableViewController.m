//
//  SquareTableViewController.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SquareTableViewController.h"
#import "Util.h"
#import "SearchVC.h"

#import "SquareListCell.h"
#import "SquareListHeaderCell.h"

@interface SquareTableViewController (){
    NSMutableArray *_dataArray;
    NSMutableArray *_sliderArray;
    
    NSInteger _page;
    NSInteger _limit;
    
    MBProgressHUD *_hud;
}

@end

@implementation SquareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"广场";
    
    _dataArray = [[NSMutableArray alloc]init];
    _sliderArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadData];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.header = [Util getMJHeaderTarget:self action:@selector(loadNewData)];
    self.tableView.footer = [Util getMJFooterTarget:self action:@selector(loadMoreData)];
    
    UIBarButtonItem *rbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_search_select"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAc)];
    self.navigationItem.rightBarButtonItem = rbi;
}
- (void)loadNewData {
    _page = 1;
    [self loadData];
}
- (void)loadMoreData {
    _page += 1;
    [self loadData];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SquareListHeaderCell *headerCell;
    SquareListCell *cell;
    
    if (indexPath.row == 0) {
        headerCell = [tableView  dequeueReusableCellWithIdentifier:@"SquareListHeaderCell"];
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [headerCell setContent:_sliderArray];
        return headerCell;
    }else{
        NSDictionary *dic = _dataArray[indexPath.row-1];
        cell = [tableView  dequeueReusableCellWithIdentifier:@"SquareListCell"];
        
        cell.tag = cell.zanBtn.tag = cell.downBtn.tag = indexPath.row;
        
        [cell setContent:dic];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }else{
        return 66;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)loadData{
    [self loadSlider];
    
    NSDictionary *bdic = @{@"udid":@"asdasdad",@"page":[NSString stringWithFormat:@"%ld",_page]};
    [Api post:API_APPS_LIST parameters:bdic completion:^(id data, NSError *err) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status"]intValue] == 200) {
            NSArray *results = dic[@"data"];
            
            if (_page == 1) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:results];
            //            YLog(@"array=%@",_dataArray);
            [self.tableView reloadData];
        }
    }];
}
-(void)loadSlider{
    [Api post:API_ADV_LIST parameters:@{@"type":@2} completion:^(id data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _sliderArray = dic[@"data"];
        [self.tableView reloadData];
    }];
}


#pragma mark
-(void)zanAc:(UIButton *)btn{
    NSDictionary *dic = _dataArray[btn.tag];
    NSNumber *like = @1;
    if ([dic[@"approvestatus"]integerValue]==1) {
        like = @0;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_LIKE_ACTION parameters:@{@"udid":@"asdasdad",@"aid":dic[@"id"],@"like":like} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status"]integerValue] == 200) {
            [TSMessage showNotificationWithTitle:dic[@"msg"] subtitle:nil type:TSMessageNotificationTypeSuccess];
            [self loadData];
        }
    }];
}

-(void)downAc:(UIButton *)btn{
    NSDictionary *dic = _dataArray[btn.tag];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_DOWN_ACTION parameters:@{@"udid":@"asdasdad",@"aid":dic[@"id"]} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status"]integerValue] == 200) {
            [TSMessage showNotificationWithTitle:dic[@"msg"] subtitle:nil type:TSMessageNotificationTypeSuccess];
            [self loadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"downapp_noti" object:nil];
        }
    }];
}
-(void)searchAc{
    SearchVC *searchVc = [Util createVCFromStoryboard:@"SearchVC"];
    [self.navigationController pushViewController:searchVc animated:YES];
}
@end
