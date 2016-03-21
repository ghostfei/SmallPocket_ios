//
//  LikeIndexVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/12/23.
//  Copyright © 2015年 ghostfei. All rights reserved.
//
#define W self.view.frame.size.width
#define HH self.view.frame.size.height
#define H (self.view.frame.size.height-113)
#import "LikeIndexVC.h"
#import "Util.h"
#import "OpenWebAppVC.h"
#import "OpenApps.h"
#import "SearchVC.h"
#import "LikeApps.h"
#import "AppType.h"

@interface LikeIndexVC ()<UIScrollViewDelegate>{
    NSMutableArray *_dataArray;
    NSArray *_typeArray;
    
    MBProgressHUD *_hud;
    
    NSNumber *_type;
    
    UIPageControl *_pageControl;
    BOOL _first;
}

@end

@implementation LikeIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KEY_BGCOLOR_BLACK;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDel)];
    [self.scrollView addGestureRecognizer:tap];
    
    //下级页面的返回
    UIBarButtonItem *backbar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backbar;
    
    UIBarButtonItem *rbi_search = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_search_select"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAc)];
    UIBarButtonItem *rbi_add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAc)];
    self.navigationItem.rightBarButtonItems = @[rbi_add,rbi_search];
    
    UIBarButtonItem *lbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left_type"] style:UIBarButtonItemStylePlain target:self action:@selector(showType)];
    self.navigationItem.leftBarButtonItem = lbi;
    
    self.scrollView.pagingEnabled = YES;
    self.typeScroll.scrollEnabled = YES;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:_scrollView.frame];
    bgView.image = [UIImage imageNamed:@"bg"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.clipsToBounds = YES;
    [self.view addSubview:bgView];
    
    _type = @0;
    _dataArray = [[NSMutableArray alloc]init];
    //    _typeArray = [[NSMutableArray alloc]init];
    _first = YES;
    
    [self initPageControl];
    [self reloadData];
    if (_first) {
        [self refreshData];
        _first = NO;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:NOTIFY_LIKE_REFRESH object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideDel];
}
#pragma mark pagecontrol
-(void)initPageControl{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-86, self.view.frame.size.width, 37)];
    [self.view addSubview:_pageControl];
    
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    [self.view bringSubviewToFront:_pageControl];
}
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
    [self reloadData];
}
#pragma page跟随advScroll滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)typeScroll1{
    _typeView.hidden = YES;
    CGPoint offset=typeScroll1.contentOffset;
    CGRect bounds=self.view.frame;
    NSLog(@"offset=%lf w=%lf",offset.x,bounds.size.width);
    [_pageControl setCurrentPage:(offset.x+30)/bounds.size.width];
}
#pragma mark 创建主UI
-(void)createGridCell{
    [self.view bringSubviewToFront:self.scrollView];
    for (UIView *vi in _scrollView.subviews) {
        [vi removeFromSuperview];
    }
    
    __block NSInteger tempH=0,tempW=0,totalW=0;
    
    [_dataArray enumerateObjectsUsingBlock:^(LikeApps *app, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx % 4 == 0 && idx != 0) {
            tempH += 1;
            tempW = 0;
        }
        if (idx % 16 == 0 && idx != 0) {
            NSInteger count = idx/16;
            totalW = W*count;
            tempH = 0;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goWeb:)];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDel:)];
        longTap.minimumPressDuration = 1.0;
        
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(tempW*(W-20)/4+13+totalW, tempH*H/5+10, (W-50)/4, (H-60)/5)];
        vi.backgroundColor = [UIColor clearColor];
        vi.userInteractionEnabled = YES;
        [vi addGestureRecognizer:tap];
        [vi addGestureRecognizer:longTap];
        vi.tag = idx;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(vi.frame.size.width/2-25, 9, 50, 50)];
        img.layer.cornerRadius = 5;
        img.layer.masksToBounds = YES;
        [vi addSubview:img];
        if (idx == _dataArray.count - 1) {
            [img setImage:[UIImage imageNamed:app.icon]];
        }else{
            [img setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:app.icon]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(vi.frame.size.width-30, 0, 30, 30)];
            delBtn.tag = idx-10000;
            delBtn.hidden = YES;
            [delBtn setImage:[UIImage imageNamed:@"delApp"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(delAc:) forControlEvents:UIControlEventTouchUpInside];
            [vi addSubview:delBtn];
            [vi bringSubviewToFront:delBtn];
        }
        UILabel *la = [[UILabel alloc]init ];//WithFrame:CGRectMake(0, vi.frame.size.height-30, W/4-10, 30)];
        if (HH>=567){
            la.frame = CGRectMake(0, vi.frame.size.height-16, W/4-10, 30);
        }else{
            la.frame = CGRectMake(0, vi.frame.size.height-5, W/4-10, 30);
        }
        la.text = app.name;
        la.textColor = [UIColor whiteColor];
        la.font = [UIFont systemFontOfSize:13];
        la.textAlignment = NSTextAlignmentCenter;
        [vi addSubview:la];
        
        [_scrollView addSubview:vi];
        tempW ++;
    }];
}
#pragma mark 加载数据
-(void)reloadData{
    //清空数据
    [_dataArray removeAllObjects];
    LikeApps *noapp = [LikeApps find:@{@"aid":@0}];
    [noapp delete];
    //判断查询type
    NSDictionary *param = nil;
    if(![_type isEqual:@0]){
        param = @{@"atid":_type};
    }
    NSLog(@"type=%@",_type);
    [_dataArray addObjectsFromArray:[LikeApps where:param order:@{@"addtime":@"DESC"}]];
    LikeApps *addApp = [LikeApps findOrCreate:@{@"icon":@"like_add",@"name":@"添加应用",@"addtime":@0}];
    [_dataArray addObject:addApp];
    NSInteger count = _dataArray.count -1;
    
    NSString *title = self.navigationItem.title;
    if (title.length == 0) {
        title = @"全部";
    }else{
        title = [title substringToIndex:2];
        NSLog(@"title=%@",title);
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",title,count];
    
    _pageControl.numberOfPages = ceil(count/16.0);
    
    if (count > 16) {
        NSInteger pageCount = count/16;
        pageCount = pageCount +1;
        self.scrollView.contentSize = CGSizeMake(W*pageCount, 0);
    }else{
        self.scrollView.contentSize = CGSizeMake(W, 0);
    }
    YLog(@"self.apps.count:%ld", count);
    [self createGridCell];
}
-(void)refreshData{
    NSDictionary *bdic = @{@"udid":[Util getDeveiceToken],@"type":_type};
//    [Util startActiciView:self.view];
    _hud = [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
    [Api post:API_LIKE_LIST parameters:bdic completion:^(id data, NSError *err) {
//        [Util stopActiciView:self.view];
        [_hud hide:YES];
        if (err) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = dic[@"data"];
        NSLog(@"array=%ld",array.count);
        if (array.count == 0) {
            NSString *first = [[NSUserDefaults standardUserDefaults]objectForKey:KFIRSTLOAD];
            if (![first isEqualToString:@"nofirst"]) {
                NSLog(@"first load");
                first = @"nofirst";
                [[NSUserDefaults standardUserDefaults]setObject:first forKey:KFIRSTLOAD];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [self refreshData];
                return;
            }
        }
        for (NSDictionary *appDic in array) {
            LikeApps *app = [LikeApps findOrCreate:appDic];
            app.addtime = [NSNumber numberWithInteger:[[Util stringToDate:app.createtime] timeIntervalSinceReferenceDate]];
//            YLog(@"app.createtime=%@ and addtime=%@",app.createtime,app.addtime);
            [app save];
        }
        [self refreshType];
        [self reloadData];
    }];
}
#pragma mark 删除相关
-(void)hideDel{
    _typeView.hidden = YES;
    for (int i=0; i<_dataArray.count; i++) {
        UIButton *btn = [self.view viewWithTag:i-10000];
        btn.hidden = YES;
    }
}
-(void)showDel:(UILongPressGestureRecognizer *)longtap{
    if(longtap.state == UIGestureRecognizerStateBegan){
        for (int i=0; i<_dataArray.count; i++) {
            UIButton *btn = [self.view viewWithTag:i-10000];
            btn.hidden = NO;
        }
    }
}
-(void)delAc:(UIButton *)btn{
    NSString *udid = [Util getDeveiceToken];
    LikeApps *app = [_dataArray objectAtIndex:(btn.tag+10000)];
    NSLog(@"dic=%@",app);
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_DELACTION parameters:@{@"aid":app.aid,@"udid":udid} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YLog(@"json=%@",dic);
        if ([dic[@"status"]integerValue ] == 200) {
//            [Util showHintMessage:@"删除成功"];
            [app delete];
            [app save];
        }else{
            [Util showHintMessage:@"网络异常"];
        }
        [self reloadData];
        
    }];
}
#pragma mark 进入web
-(void)goWeb:(UITapGestureRecognizer *)tap{
    NSInteger tag = [tap view].tag;
    if (tag == _dataArray.count - 1) {
        [self addAc];
    }else{
        [self hideDel];
        NSLog(@"tag=%ld",tag);
        OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
        
        LikeApps *app = [_dataArray objectAtIndex:tag];
        NSMutableDictionary *ddic = [[NSMutableDictionary alloc]initWithDictionary:@{@"aid":app.aid}];
        NSDictionary *dic = [app dictionaryWithValuesForKeys:@[@"createtime",@"url",@"name",@"desc",@"icon"]];
        [ddic addEntriesFromDictionary:dic];
        
        OpenApps *openApp = [OpenApps findOrCreate:ddic];
        openApp.openTime = [[NSDate new]timeIntervalSinceReferenceDate];
        [openApp save];
        
        NSDictionary *param = @{@"name":app.name,@"url":app.url};
        webview.param = param;
        [self.navigationController pushViewController:webview animated:YES];
    }
}
#pragma mark 右上角按钮
-(void)searchAc{
    SearchVC *searchVc = [Util createVCFromStoryboard:@"SearchVC"];
    [self.navigationController pushViewController:searchVc animated:YES];
}
-(void)addAc{
    [self.navigationController pushViewController:[Util createVCFromStoryboard:@"SquareListVC"] animated:YES];
}
@end
