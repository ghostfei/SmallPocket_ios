//
//  SquareListVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SquareListVC.h"
#import "Util.h"
#import "Apps.h"
#import "SearchVC.h"

#import "SquareListCell.h"
#import "SquareListHeaderCell.h"

@interface SquareListVC ()<UITableViewDelegate,UITableViewDataSource>{
    //    NSMutableArray *self.apps;
    NSArray *_sliderArray;
    
    NSInteger _page;
    NSInteger _limit;
    
    MBProgressHUD *_hud;
    NSArray *_typeArray;
    
    NSString *_type;
    
    NSInteger currentIndex;
    NSInteger PAGENUM;
    
    BOOL _firstLoad;
}

@end

@implementation SquareListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"广场";
    
    self.apps = [[NSMutableArray alloc]init];
    _sliderArray = [[NSArray alloc]init];
    _page = 1;
    _limit = 20;
    _type = @"0";
    _firstLoad = YES;
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.header = [Util getMJHeaderTarget:self action:@selector(loadNewData)];
    self.tableView.footer = [Util getMJFooterTarget:self action:@selector(loadMoreData)];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIBarButtonItem *rbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_search_select"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAc)];
    self.navigationItem.rightBarButtonItem = rbi;
    
    UIBarButtonItem *lbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left_type"] style:UIBarButtonItemStylePlain target:self action:@selector(showType)];
    self.navigationItem.leftBarButtonItem = lbi;
    
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBar;
    
    self.typeScroll.scrollEnabled = YES;
    
    [self loadSlider];
    //    [self reinitData];
    if (_firstLoad) {
        [self loadData];
        _firstLoad = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _typeView.hidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)typeScroll{
    if (typeScroll.contentOffset.y!=0) {
        _typeView.hidden = YES;
    }
}
- (void)loadNewData {
    _page = 1;
    [self loadSlider];
    [self loadData];
}
- (void)loadMoreData {
    _page += 1;
    [self loadData];
}
#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//        [self addAdv];
    _advScroll.pagingEnabled=YES;
    _advScroll.scrollEnabled=NO;
    _advScroll.showsHorizontalScrollIndicator=NO;
    
    NSInteger imgNum = _sliderArray.count;//可以动态获取
    if (imgNum>0) {
        for (int i=0; i<imgNum; i++) {
            NSDictionary *imgDic = _sliderArray[i];//image name url
            UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(i*ScreenW, 0, ScreenW, 100)];
            [imgview setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:imgDic[@"image"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            imgview.contentMode = UIViewContentModeScaleAspectFill;
            imgview.clipsToBounds = YES;
            [_advScroll addSubview:imgview];
        }
    }else{
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
        [imgview setImage:[UIImage imageNamed:@"placeholder"]];
        [_advScroll addSubview:imgview];
    }
    
    PAGENUM =imgNum;
    
    //定义PageController 设定总页数，当前页，定义当控件被用户操作时,要触发的动作。    _page.numberOfPages = PAGENUM;
    _pageC.currentPage = 0;
    _pageC.currentPageIndicatorTintColor=[UIColor greenColor];
    _pageC.pageIndicatorTintColor=[UIColor whiteColor];
    [_pageC addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    //使用NSTimer实现定时触发滚动控件滚动的动作。
    currentIndex = 0;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    
    return _advScroll;
//    return _advView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SquareListCell *cell;
    
    NSDictionary *dic = self.apps[indexPath.row];
    cell = [tableView  dequeueReusableCellWithIdentifier:@"SquareListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.zanBtn.tag = cell.downBtn.tag = indexPath.row-1;
    
    [cell setContent:dic];
    [cell.zanBtn addTarget:self action:@selector(zanAc:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downBtn addTarget:self action:@selector(downAc:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.apps[indexPath.row];
    NSString *desc = dic[@"desc"];
    CGSize size = CGSizeMake(self.view.frame.size.width-80, 1000);
    CGSize infoSize = [desc sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    return 44+infoSize.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)loadData{
    NSString *udid = [Util getDeveiceToken];
    NSDictionary *bdic = @{@"udid":udid,@"page":[NSString stringWithFormat:@"%ld",_page],@"type":_type,@"limit":[NSString stringWithFormat:@"%ld",_limit]};
    NSLog(@"bdic=%@",bdic);
    
    [Api post:API_APPS_LIST parameters:bdic completion:^(id data, NSError *err) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        YLog(@"dic=%@",dic);
        if ([dic[@"status"]intValue] == 200 || [dic[@"status"]intValue] == 201) {
            NSArray *results = dic[@"data"];
            if (_page == 1) {
                [self.apps removeAllObjects];
                //                [Util remarkDeleteAll:@"Apps" where:nil];
            }
            if (results.count < _limit) {
                [self.tableView.footer noticeNoMoreData];
            }
            
            [results enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                Apps *app = [Apps findOrCreate:dic];
                app.is_deleted = @0;
                [app save];
            }];
            
            [self.apps addObjectsFromArray:results];
            [self.tableView reloadData];
            
            
        }
    }];
}
-(void)loadSlider{
    [Api post:API_ADV_LIST parameters:@{@"type":@"2"} completion:^(NSData *data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _sliderArray = dic[@"data"];
                NSLog(@"slider=%@",dic);

//        [self addAdv];
        [self.tableView reloadData];
    }];
}

#pragma mark typeview
-(void)showType{
    if (_typeView.hidden) {
        _typeView.hidden = NO;
        [self.view bringSubviewToFront:_typeView];
        [self loadType];
    }else{
        _typeView.hidden = YES;
    }
}
-(void)loadType{
    for (UIView *vi in _typeScroll.subviews) {
        [vi removeFromSuperview];
    }
    
    [Api post:API_TYPE_LIST parameters:nil completion:^(id data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YLog(@"json=%@",dic);
        if ([dic[@"status"]intValue] == 200) {
            _typeArray = dic[@"data"];
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:_typeArray];
            [tempArray insertObject:@{@"name":@"全部",@"id":@"0"} atIndex:0];
            
            _typeScroll.contentSize = CGSizeMake(80, tempArray.count*35);
            
            [tempArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, idx*31, 80, 30)];
                btn.tag = idx;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, idx*31+30, 80, 1)];
                line.backgroundColor = [UIColor lightGrayColor];
                line.alpha = 0.6;
                [_typeScroll addSubview:line];
                [_typeScroll addSubview:btn];
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
    [self loadNewData];
}
-(void)zanAc:(UIButton *)btn{
    NSString *udid = [Util getDeveiceToken];
    NSDictionary *dic = self.apps[btn.tag];
    NSNumber *like = @1;
    if ([dic[@"approvestatus"]integerValue]==1) {
        like = @0;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_LIKE_ACTION parameters:@{@"udid":udid,@"aid":dic[@"id"],@"like":like} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status"]integerValue] == 200) {
            [TSMessage showNotificationWithTitle:dic[@"msg"] subtitle:nil type:TSMessageNotificationTypeSuccess];
            btn.enabled = NO;
            [btn setImage:[UIImage imageNamed:@"s_like_ed"] forState:UIControlStateNormal];
            [btn setNeedsDisplay];
            //            _page = 1;
            //            [self loadData];
        }else{
            [Util showHintMessage:dic[@"msg"]];
        }
    }];
}

-(void)downAc:(UIButton *)btn{
    NSDictionary *dic = self.apps[btn.tag];
    NSString *udid = [Util getDeveiceToken];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_DOWN_ACTION parameters:@{@"udid":udid,@"aid":dic[@"id"]} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic=%@",dic);
        if ([dic[@"status"]integerValue] == 200) {
            [TSMessage showNotificationWithTitle:dic[@"msg"] subtitle:nil type:TSMessageNotificationTypeSuccess];
            
            btn.enabled = NO;
            [btn setImage:[UIImage imageNamed:@"s_down_ed"] forState:UIControlStateNormal];
            [btn setNeedsDisplay];
            //            _page = 1;
            //            [self loadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"downapp_noti" object:nil];
        }else{
            [Util showHintMessage:dic[@"msg"]];
        }
        
    }];
}
-(void)searchAc{
    SearchVC *searchVc = [Util createVCFromStoryboard:@"SearchVC"];
    [self.navigationController pushViewController:searchVc animated:YES];
}
#pragma mark 滚图的动画效果
-(void)addAdv{
    _advScroll.pagingEnabled=YES;
    _advScroll.scrollEnabled=NO;
    _advScroll.showsHorizontalScrollIndicator=NO;
    
    NSInteger imgNum = _sliderArray.count;//可以动态获取
    if (imgNum>0) {
    for (int i=0; i<imgNum; i++) {
        NSDictionary *imgDic = _sliderArray[i];//image name url
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(i*ScreenW, 0, ScreenW, 100)];
        [imgview setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:imgDic[@"image"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds = YES;
        [_advScroll addSubview:imgview];
    }
    }else{
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
        [imgview setImage:[UIImage imageNamed:@"placeholder"]];
        [_advScroll addSubview:imgview];
    }
    
    PAGENUM =imgNum;
    
    //定义PageController 设定总页数，当前页，定义当控件被用户操作时,要触发的动作。    _page.numberOfPages = PAGENUM;
    _pageC.currentPage = 0;
    _pageC.currentPageIndicatorTintColor=[UIColor greenColor];
    _pageC.pageIndicatorTintColor=[UIColor whiteColor];
    [_pageC addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    //使用NSTimer实现定时触发滚动控件滚动的动作。
    currentIndex = 0;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}
-(void)pageTurn:(UIPageControl *)aPageControl{
    NSInteger whichPage = aPageControl.currentPage;
    NSLog(@"whichPage=%ld",whichPage);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_advScroll setContentOffset:CGPointMake(self.view.frame.size.width * whichPage, 0.0f) animated:YES];
    [UIView commitAnimations];
    _pageC.currentPage=whichPage;
}
#pragma page跟随typeScroll滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)typeScroll1{
    CGPoint offset=typeScroll1.contentOffset;
    CGRect bounds=typeScroll1.frame;
    [_pageC setCurrentPage:offset.x/bounds.size.width];
    currentIndex=_pageC.currentPage;
}
#pragma mark 定时滚动
-(void)scrollTimer{
    currentIndex ++;
    if (currentIndex == PAGENUM) {
        currentIndex = 0;
    }
    _pageC.currentPage=currentIndex;
    [_advScroll scrollRectToVisible:CGRectMake(currentIndex * self.view.frame.size.width, 0, self.view.frame.size.width, 100) animated:YES];
}

@end
