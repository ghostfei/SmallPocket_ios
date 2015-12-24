//
//  SquareListVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SquareListVC.h"
#import "Util.h"
#import "SearchVC.h"

#import "SquareListCell.h"
#import "SquareListHeaderCell.h"

@interface SquareListVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_dataArray;
    NSArray *_sliderArray;
    
    NSInteger _page;
    NSInteger _limit;
    
    MBProgressHUD *_hud;
    NSArray *_typeArray;
    
    NSString *_type;
}

@end

@implementation SquareListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"广场";
    
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    _limit = 20;
    _type = @"0";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self loadData];
    self.tableView.header = [Util getMJHeaderTarget:self action:@selector(loadNewData)];
    self.tableView.footer = [Util getMJFooterTarget:self action:@selector(loadMoreData)];
    
    UIBarButtonItem *rbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_search_select"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAc)];
    self.navigationItem.rightBarButtonItem = rbi;
    
    UIBarButtonItem *lbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left_type"] style:UIBarButtonItemStylePlain target:self action:@selector(showType)];
    self.navigationItem.leftBarButtonItem = lbi;
    
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBar;
    
    self.scrollView.scrollEnabled = YES;
    
    [self loadSlider];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y!=0) {
        _typeView.hidden = YES;
    }
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.zanBtn.tag = cell.downBtn.tag = indexPath.row-1;
        
        [cell setContent:dic];
        [cell.zanBtn addTarget:self action:@selector(zanAc:) forControlEvents:UIControlEventTouchUpInside];
        [cell.downBtn addTarget:self action:@selector(downAc:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }else{
        NSDictionary *dic = _dataArray[indexPath.row-1];
        NSString *desc = dic[@"desc"];
        CGSize size = CGSizeMake(self.view.frame.size.width-80, 1000);
        CGSize infoSize = [desc sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        return 44+infoSize.height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)loadData{
    NSString *udid = [[NSUserDefaults standardUserDefaults]objectForKey:K_DeviceToken];
    NSDictionary *bdic = @{@"udid":@"12",@"page":[NSString stringWithFormat:@"%ld",_page],@"type":_type};
    [Api post:API_APPS_LIST parameters:bdic completion:^(id data, NSError *err) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YLog(@"dic=%@",dic);
        if ([dic[@"status"]intValue] == 200 || [dic[@"status"]intValue] == 201) {
            NSArray *results = dic[@"data"];
            
            if (results.count < _limit) {
                [self.tableView.footer noticeNoMoreData];
            } 
            
            if (_page == 1) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:results];
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
-(void)showType{
    if (_typeView.hidden) {
        _typeView.hidden = NO;
        [self loadType];
    }else{
        _typeView.hidden = YES;
    }
}
-(void)loadType{
    for (UIView *vi in _scrollView.subviews) {
        [vi removeFromSuperview];
    }
    
    [Api post:API_TYPE_LIST parameters:nil completion:^(id data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YLog(@"json=%@",dic);
        if ([dic[@"status"]intValue] == 200) {
            _typeArray = dic[@"data"];
            _scrollView.contentSize = CGSizeMake(80, _typeArray.count*35);
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:_typeArray];
            [tempArray insertObject:@{@"name":@"全部",@"id":@"0"} atIndex:0];
            
            [tempArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, idx*31, 80, 30)];
                btn.tag = idx;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, idx*31+30, 80, 1)];
                line.backgroundColor = [UIColor lightGrayColor];
                [_scrollView addSubview:line];
                [_scrollView addSubview:btn];
            }];
            
        }
    }];
}

-(void)choseType:(UIButton *)btn{
    _typeView.hidden = YES;
    if (btn.tag == 0) {
        _type = @"0";
    }else{
        NSDictionary *dic = _typeArray[btn.tag-1];
        _type = dic[@"id"];
    }
    [self loadData];
}
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
            [self loadData];
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
