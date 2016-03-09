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

@interface LikeIndexVC (){
    NSMutableArray *_dataArray;
    NSArray *_typeArray;
    
    MBProgressHUD *_hud;
    
    NSString *_type;
}

@end

@implementation LikeIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KEY_BGCOLOR_BLACK;
    
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
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:_scrollView.frame];
    bgView.image = [UIImage imageNamed:@"bg"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.clipsToBounds = YES;
    [self.view addSubview:bgView];
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    _type = @"0";
    _dataArray = [[NSMutableArray alloc]init];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"downapp_noti" object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDel)];
    [self.scrollView addGestureRecognizer:tap];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideDel];
}
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
            _typeScroll.contentSize = CGSizeMake(80, _typeArray.count*35);
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
    [self loadData];
}
#pragma mark 创建主UI
-(void)initUI{
    [self.view bringSubviewToFront:self.scrollView];
    for (UIView *vi in _scrollView.subviews) {
        [vi removeFromSuperview];
    }
    
    __block NSInteger tempH=0,tempW=0,totalW=0;
    
    [_dataArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx % 4 == 0 && idx != 0) {
            tempH += 1;
            tempW = 0;
        }
        if (HH>567) {
            if (idx % 20 == 0 && idx != 0) {
                NSInteger count = idx/20;
                totalW = W*count;
                tempH = 0;
            }
        }else{
            if (idx % 16 == 0 && idx != 0) {
                NSInteger count = idx/16;
                totalW = W*count;
                tempH = 0;
            }
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
            [img setImage:[UIImage imageNamed:dic[@"icon"]]];
        }else{
            [img setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:dic[@"icon"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(vi.frame.size.width-30, 0, 30, 30)];
            //        delBtn.backgroundColor = [UIColor redColor];
            delBtn.tag = idx-10000;
            delBtn.hidden = YES;
            [delBtn setImage:[UIImage imageNamed:@"delApp"] forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(delAc:) forControlEvents:UIControlEventTouchUpInside];
            [vi addSubview:delBtn];
            [vi bringSubviewToFront:delBtn];
        }
        UILabel *la = [[UILabel alloc]init ];//WithFrame:CGRectMake(0, vi.frame.size.height-30, W/4-10, 30)];
        if (HH > 666) {
            la.frame = CGRectMake(0, vi.frame.size.height-30, W/4-10, 30);
        }else if (HH<667 && HH>567){
            la.frame = CGRectMake(0, vi.frame.size.height-25, W/4-10, 30);
        }else{
            la.frame = CGRectMake(0, vi.frame.size.height-5, W/4-10, 30);
        }
        la.text = dic[@"name"];
        la.textColor = [UIColor whiteColor];
        la.font = [UIFont systemFontOfSize:13];
        la.textAlignment = NSTextAlignmentCenter;
        [vi addSubview:la];
        
        [_scrollView addSubview:vi];
        tempW ++;
    }];
}
#pragma mark 加载数据
-(void)loadData{
    [_dataArray removeAllObjects];
    NSDictionary *bdic = @{@"udid":[Util getDeveiceToken],@"type":_type};
    
    [Util startActiciView:self.view];
    [Api post:API_LIKE_LIST parameters:bdic completion:^(id data, NSError *err) {
        
        [Util stopActiciView:self.view];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        _dataArray = dic[@"data"];
        self.navigationItem.title = [NSString stringWithFormat:@"喜欢(%ld)",_dataArray.count];
        
        [_dataArray addObject:@{@"icon":@"like_add",@"name":@"添加应用"}];
        NSLog(@"data=%@",_dataArray);
        if (HH>567) {
            if (_dataArray.count > 20) {
                NSInteger count = _dataArray.count/20;
                count = count +1;
                self.scrollView.contentSize = CGSizeMake(W*count, 0);
            }else{
                self.scrollView.contentSize = CGSizeMake(W, 0);
            }
        }else{
            if (_dataArray.count > 16) {
                NSInteger count = _dataArray.count/16;
                count = count +1;
                self.scrollView.contentSize = CGSizeMake(W*count, 0);
            }else{
                self.scrollView.contentSize = CGSizeMake(W, 0);
            }
        }
        [self initUI];
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
    NSDictionary *dic = [_dataArray objectAtIndex:(btn.tag+10000)];
    NSLog(@"dic=%@",dic);
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Api post:API_DELACTION parameters:@{@"aid":dic[@"aid"],@"udid":udid} completion:^(id data, NSError *err) {
        [_hud hide:YES];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        YLog(@"json=%@",dic);
        if ([dic[@"status"]integerValue ] == 200) {
            [Util showHintMessage:@"删除成功"];
        }else{
            [Util showHintMessage:@"网络异常"];
        }
        [self loadData];
        
    }];
}
#pragma mark
-(void)goWeb:(UITapGestureRecognizer *)tap{
    NSInteger tag = [tap view].tag;
    if (tag == _dataArray.count - 1) {
        [self addAc];
    }else{
        [self hideDel];
        NSLog(@"tag=%ld",tag);
        OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
        
        NSDictionary *dic = [_dataArray objectAtIndex:tag];
        
        OpenApps *app = [OpenApps findOrCreate:dic];
        app.openTime = [[NSDate new]timeIntervalSinceReferenceDate];
        [app save];
        
        NSDictionary *param = @{@"name":app.name,@"url":app.url};
        webview.param = param;
        [self.navigationController pushViewController:webview animated:YES];
    }
}
#pragma mark
-(void)searchAc{
    SearchVC *searchVc = [Util createVCFromStoryboard:@"SearchVC"];
    [self.navigationController pushViewController:searchVc animated:YES];
}
-(void)addAc{
    [self.navigationController pushViewController:[Util createVCFromStoryboard:@"SquareListVC"] animated:YES];
}
@end
