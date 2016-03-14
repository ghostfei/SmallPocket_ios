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
#import "AppType.h"
#import "SearchVC.h"
#import "OpenWebAppVC.h"

#import "SquareListCell.h"
#import "SquareListHeaderCell.h"

@interface SquareListVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_sliderArray;
    
    NSInteger _page;
    NSInteger _limit;
    
    MBProgressHUD *_hud;
    NSArray *_typeArray;
    
    NSNumber *_type;
    
    NSInteger currentIndex;
    NSInteger PAGENUM;
    UIScrollView *_advScroll;
    UIPageControl *_pageControl;
    
    BOOL _firstLoad;
    
    NSTimer *_playTime;
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
    _type = @0;
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
    
    [self reloadData];
    if (_firstLoad) {
        [self loadNewData];
        _firstLoad = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_playTime invalidate];
    _typeView.hidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)typeScroll{
    if (typeScroll.contentOffset.y!=0) {
        _typeView.hidden = YES;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        SquareListHeaderCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"SquareListHeaderCell"];
        headCell.advScroll.pagingEnabled=YES;
        headCell.advScroll.scrollEnabled=YES;
        headCell.advScroll.showsHorizontalScrollIndicator=NO;
        
        NSInteger imgNum = _sliderArray.count;//可以动态获取
        if (imgNum>0) {
            headCell.advScroll.contentSize = CGSizeMake(_sliderArray.count*headCell.frame.size.width, 100);
            for (int i=0; i<imgNum; i++) {
                NSDictionary *imgDic = _sliderArray[i];//image name url
                UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(i*ScreenW, 0, ScreenW, 100)];
                [imgview setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:imgDic[@"image"]]] placeholderImage:[UIImage imageNamed:@"adv_default"]];
                imgview.contentMode = UIViewContentModeScaleAspectFill;
                imgview.clipsToBounds = YES;
                imgview.tag = i;
                imgview.userInteractionEnabled = YES;
                [headCell.advScroll addSubview:imgview];
                UITapGestureRecognizer *urlClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goWeb:)];
                [imgview addGestureRecognizer:urlClick];
            }
        }else{
            UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
            [imgview setImage:[UIImage imageNamed:@"adv_default"]];
            [headCell.advScroll addSubview:imgview];
        }
        
        PAGENUM =imgNum;
        
        //定义PageController 设定总页数，当前页，定义当控件被用户操作时,要触发的动作。    _page.numberOfPages = PAGENUM;
        headCell.pageControll.currentPage = 0;
        [headCell.pageControll addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        
        //使用NSTimer实现定时触发滚动控件滚动的动作。
        currentIndex = 0;
        
        [_playTime invalidate];
        _playTime = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
        
        _advScroll = headCell.advScroll;
        _pageControl = headCell.pageControll;
        
        return headCell;
    }else{
        SquareListCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"SquareListCell"];
        NSInteger index = indexPath.row - 1;
        
        Apps *app = self.apps[index];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.zanBtn.tag = cell.downBtn.tag = index+1000;
        
        [cell setContent:app];
        [cell.zanBtn addTarget:self action:@selector(zanAc:) forControlEvents:UIControlEventTouchUpInside];
        [cell.downBtn addTarget:self action:@selector(downAc:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }else{
        NSInteger index = indexPath.row - 1;
        Apps *app = self.apps[index];
        CGSize infoSize = [app.desc boundingRectWithSize:CGSizeMake(tableView.frame.size.width-85, 1000)		 options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        return 44+infoSize.height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark loaddata
-(void)reloadData{
    [self.apps removeAllObjects];
    
    NSDictionary *param = nil;
    if(![_type isEqual:@0]){
        param = @{@"atid":_type};
    }

    [self.apps addObjectsFromArray:[Apps where:param order:@{@"sort":@"DESC"} limit:[NSNumber numberWithInteger:_limit * _page]]];
    NSLog(@"self.apps.count:%ld", self.apps.count);
    [self.tableView reloadData];
}
- (void)loadNewData {
    _page = 1;
    [self refreshData];
}
- (void)loadMoreData {
    _page += 1;
    [self refreshData];
}
-(void)refreshData{
    NSString *udid = [Util getDeveiceToken];
    NSDictionary *bdic = @{@"udid":udid,@"page":[NSString stringWithFormat:@"%ld",_page],@"type":_type,@"limit":[NSString stringWithFormat:@"%ld",_limit]};
//    NSLog(@"bdic=%@",bdic);
    _hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [Api post:API_APPS_LIST parameters:bdic completion:^(id data, NSError *err) {
        [_hud hide:YES];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (err) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        YLog(@"dic=%@",dic);
        if ([dic[@"status"]intValue] == 200 || [dic[@"status"]intValue] == 201) {
            NSArray *results = dic[@"data"];
            if (_page == 1) {
                NSArray *array = [Apps where:nil];
                [array enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    Apps *app = [Apps find:dic];
                    [app delete];
                }];
            }
            if (results.count < _limit) {
                [self.tableView.footer noticeNoMoreData];
            }
            for(NSDictionary *dic in results){
                Apps *app = [Apps findOrCreate:dic];
                [app save];
            };
            [self refreshType];
            if (_page !=1) {
                [self reloadData];
            }else{
                [self loadSlider];
            }
            
        }
    }];
}
-(void)loadSlider{
    [Api post:API_ADV_LIST parameters:@{@"type":@"2"} completion:^(NSData *data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _sliderArray = dic[@"data"];
        NSLog(@"slider=%@",dic);
        [self reloadData];
    }];
}

#pragma mark typeview
#pragma mark 侧栏分类
-(void)refreshType{
    [Api post:API_TYPE_LIST parameters:nil completion:^(id data, NSError *err) {
        if (err) {
            return ;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        YLog(@"json=%@",dic);
        if ([dic[@"status"]intValue] == 200) {
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:@[@{@"id":@0,@"name":@"全部",@"father":@"0"}]];
            [tempArray addObjectsFromArray:(NSArray *)dic[@"data"]];
            [tempArray enumerateObjectsUsingBlock:^(NSDictionary *type, NSUInteger idx, BOOL * _Nonnull stop) {
                AppType *types = [AppType findOrCreate:type];
                [types save];
            }];
        }
    }];
}
-(void)showType{
    if (_typeView.hidden) {
        _typeView.hidden = NO;
        [self.view bringSubviewToFront:_typeView];
        [self reloadType];
    }else{
        _typeView.hidden = YES;
    }
}
-(void)reloadType{
    CGFloat w = 60;
    for (UIView *vi in _typeScroll.subviews) {
        [vi removeFromSuperview];
    }
    _typeArray = [AppType where:nil];
    
    _typeScroll.contentSize = CGSizeMake(w, _typeArray.count*35);
    [_typeArray enumerateObjectsUsingBlock:^(AppType *type, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, idx*31, w, 30)];
        btn.tag = idx;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:type.name forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(choseType:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(2, idx*31+30, w-4, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.6;
        [_typeScroll addSubview:line];
        [_typeScroll addSubview:btn];
    }];
}
-(void)choseType:(UIButton *)btn{
    _typeView.hidden = YES;
    AppType *type = _typeArray[btn.tag];
    _type =type.id;
    self.navigationItem.title = type.name;
    [self loadNewData];
}

-(void)zanAc:(UIButton *)btn{
    NSString *udid = [Util getDeveiceToken];
    Apps *app = self.apps[btn.tag-1000];
    NSNumber *like = @1;
    if ([app.approvestatus isEqual:@1]) {
        like = @0;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_LIKE_ACTION parameters:@{@"udid":udid,@"aid":app.id,@"like":like} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"status"]integerValue] == 200) {
            app.approvestatus = like;
            app.addtime = [NSDate new];
            [app save];
            
            btn.enabled = NO;
            [btn setImage:[UIImage imageNamed:@"s_like_ed"] forState:UIControlStateNormal];
            
            [TSMessage showNotificationWithTitle:dic[@"msg"] type:TSMessageNotificationTypeSuccess];
        }else{
            [Util showHintMessage:dic[@"msg"]];
        }
    }];
}

-(void)downAc:(UIButton *)btn{
    Apps *app = self.apps[btn.tag-1000];
    NSString *udid = [Util getDeveiceToken];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_DOWN_ACTION parameters:@{@"udid":udid,@"aid":app.id} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic=%@",dic);
        if ([dic[@"status"]integerValue] == 200) {
            app.downstatus = @1;
            [app save];
            
            btn.enabled = NO;
            [btn setImage:[UIImage imageNamed:@"s_down_ed"] forState:UIControlStateNormal];
            
            [TSMessage showNotificationWithTitle:dic[@"msg"] type:TSMessageNotificationTypeSuccess];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_LIKE_REFRESH object:nil];
        }else{
            [Util showHintMessage:dic[@"msg"]];
        }
    }];
}
-(void)searchAc{
    SearchVC *searchVc = [Util createVCFromStoryboard:@"SearchVC"];
    [self.navigationController pushViewController:searchVc animated:YES];
}
#pragma mark -轮播
#pragma mark 滚图的动画效果
-(void)pageTurn:(UIPageControl *)aPageControl{
    NSInteger whichPage = aPageControl.currentPage;
    NSLog(@"whichPage=%ld",whichPage);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_advScroll setContentOffset:CGPointMake(self.view.frame.size.width * whichPage, 0.0f) animated:YES];
    [UIView commitAnimations];
    _pageControl.currentPage=whichPage;
}
#pragma page跟随advScroll滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)typeScroll1{
    CGPoint offset=typeScroll1.contentOffset;
    CGRect bounds=typeScroll1.frame;
    [_pageControl setCurrentPage:offset.x/bounds.size.width];
    currentIndex=_pageControl.currentPage;
}
#pragma mark 定时滚动
-(void)scrollTimer{
    currentIndex ++;
    if (currentIndex == PAGENUM) {
        currentIndex = 0;
    }
    _pageControl.currentPage=currentIndex;
    [_advScroll scrollRectToVisible:CGRectMake(currentIndex * self.view.frame.size.width, 0, self.view.frame.size.width, 100) animated:YES];
}
-(void)goWeb:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    NSDictionary *imgDic = _sliderArray[index];//image name url
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    NSDictionary *param = @{@"name":imgDic[@"name"],@"url":imgDic[@"url"]};
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
}
@end
