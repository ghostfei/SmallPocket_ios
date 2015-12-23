//
//  LikeIndexVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/12/23.
//  Copyright © 2015年 ghostfei. All rights reserved.
//
#define W self.view.frame.size.width
#define H (self.view.frame.size.height-113)
#import "LikeIndexVC.h"
#import "Util.h"
#import "OpenWebAppVC.h"
#import "OpenApps.h"

@interface LikeIndexVC (){
    NSArray *_dataArray;
    
    MBProgressHUD *_hud;
    
    NSString *_type;
}

@end

@implementation LikeIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KEY_BGCOLOR_BLACK;

    self.navigationItem.title = @"喜欢";
    
    UIBarButtonItem *backbar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backbar;
    self.tableView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    
    _type = @"0";
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"downapp_noti" object:nil];
}
-(void)initUI{
    for (UIView *vi in _scrollView.subviews) {
        [vi removeFromSuperview];
    }
    
    if (_dataArray.count==0) {
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
        la.text = @"这里将显示您已添加喜欢的应用";
        la.textColor = [UIColor grayColor];
        la.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:la];
        return;
    } 
    
    __block NSInteger tempH=0,tempW=0,totalW=0;
    
    [_dataArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx % 4 == 0 && idx != 0) {
            tempH += 1;
            tempW = 0;
        }
        if (idx % 20 == 0 && idx != 0) {
            NSInteger count = idx/20;
            totalW = W*count;
            tempH = 0;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goWeb:)];
        
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(tempW*(W-20)/4+13+totalW, tempH*H/5+10, (W-50)/4, (H-60)/5)];
        vi.backgroundColor = [UIColor clearColor];
        vi.userInteractionEnabled = YES;
        [vi addGestureRecognizer:tap];
        vi.tag = idx;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(vi.frame.size.width/2-25, 10, 50, 50)];
        [img setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:dic[@"icon"]]] placeholderImage:[UIImage imageNamed:@""]];
        [vi addSubview:img];
        
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, vi.frame.size.height-30, W/4-10, 30)];
        la.text = dic[@"name"];
        la.textAlignment = NSTextAlignmentCenter;
        [vi addSubview:la];
        
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(vi.frame.size.width-30, 0, 30, 30)];
        //        delBtn.backgroundColor = [UIColor redColor];
        delBtn.tag = idx;
        //        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        //        [delBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [delBtn setImage:[UIImage imageNamed:@"delApp"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delAc:) forControlEvents:UIControlEventTouchUpInside];
//        [vi addSubview:delBtn];
//        [vi bringSubviewToFront:delBtn];
        
        [_scrollView addSubview:vi];
        tempW ++;
    }];
}
-(void)loadData{
    NSDictionary *bdic = @{@"udid":@"12",@"type":_type};
    
    [Util startActiciView:self.view];
    [Api post:API_LIKE_LIST parameters:bdic completion:^(id data, NSError *err) {
        
        [Util stopActiciView:self.view];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        _dataArray = dic[@"data"];
        if (_dataArray.count==0) {
            UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
            la.text = @"这里将展示您已选为喜欢的应用";
            la.textColor = [UIColor grayColor];
            la.textAlignment = NSTextAlignmentCenter;
            [self.scrollView addSubview:la];
        }
        YLog(@"count=%ld",_dataArray.count);
        if (_dataArray.count > 20) {
            NSInteger count = _dataArray.count/20;
            count = count +1;
            self.scrollView.contentSize = CGSizeMake(W*count, 0);
        }else{
            self.scrollView.contentSize = CGSizeMake(W, 0);
        }
        [self initUI];
        [self.tableView reloadData];

    }];
}
-(void)delAc:(UIButton *)btn{
}

-(void)goWeb:(UITapGestureRecognizer *)tap{
    NSInteger tag = [tap view].tag;
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    NSDictionary *dic = [_dataArray objectAtIndex:tag];
    OpenApps *app =[OpenApps find:dic];
    app.openTime = [[NSDate new]timeIntervalSinceReferenceDate];
    [app save];
    
    NSDictionary *param = @{@"name":app.name,@"url":app.url};
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
}
@end
