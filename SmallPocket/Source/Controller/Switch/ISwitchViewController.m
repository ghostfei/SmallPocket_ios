//
//  ISwitchViewController.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "ISwitchViewController.h"
#import "OpenApps.h"
#import "Util.h"
#import "OpenWebAppVC.h"

@interface ISwitchViewController (){
    NSArray *_opens;
}

@end

@implementation ISwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.view.backgroundColor = KEY_BGCOLOR_BLACK;
    
    UIBarButtonItem *backbar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backbar;
    
    self.scrollView.pagingEnabled = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"appear");
    [self loadData];
}
-(void)loadData{
    for (UIView *vi in _scrollView.subviews) {
        [vi removeFromSuperview];
    }
    
    _opens = [OpenApps where:@{} order:@{@"openTime":@"desc"} limit:@12];
    if (_opens.count==0) {
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
        la.text = @"这里将显示您最近打开的应用";
        la.textColor = [UIColor grayColor];
        la.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:la];
         self.navigationItem.title = @"切换";
        return;
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"切换(%ld)",_opens.count];
    }
    
    __block NSInteger tempH=0,tempW=0,totalW=0;
    
    if (_opens.count > 4) {
        NSInteger count = _opens.count/4;
        count = count +1;
        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH*count, 0);
    }else{
        self.scrollView.contentSize = CGSizeMake(SCREENWIDTH, 0);
    }
    
    
    [_opens enumerateObjectsUsingBlock:^(OpenApps *app, NSUInteger idx, BOOL * _Nonnull stop) {
        YLog(@"name=%@",app.name);

        if (idx % 2 == 0 && idx != 0) {
            tempH += 1;
            tempW = 0;
        }
        if (idx % 4 ==0 && idx != 0) {
            NSInteger count = idx/4;
            totalW = self.view.frame.size.width*count;
            tempH = 0;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goWeb:)];
        
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(tempW*SCREENWIDTH/2+14+totalW, tempH*(SCREENHEIGHT/2-67)+20, SCREENWIDTH/2-20, SCREENHEIGHT/2-87)];
        vi.backgroundColor = [UIColor whiteColor];
        vi.userInteractionEnabled = YES;
        [vi addGestureRecognizer:tap];
        vi.tag = idx;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH/2-20)/2-30, 50, 60, 60)];
        [img setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:app.icon]] placeholderImage:[UIImage imageNamed:@""]];
        [vi addSubview:img];
        
        UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT/2-87-40, SCREENWIDTH/2-20, 30)];
        la.text = app.name;
        la.textAlignment = NSTextAlignmentCenter;
        [vi addSubview:la];
        
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(vi.frame.size.width-30, 0, 30, 30)];
//        delBtn.backgroundColor = [UIColor redColor];
        delBtn.tag = idx;
//        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [delBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [delBtn setImage:[UIImage imageNamed:@"delApp"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delAc:) forControlEvents:UIControlEventTouchUpInside];
        [vi addSubview:delBtn];
        [vi bringSubviewToFront:delBtn];
        
        [_scrollView addSubview:vi];
        tempW ++;
    }];
}
-(void)delAc:(UIButton *)btn{
    OpenApps *app = [_opens objectAtIndex:btn.tag];
    [app delete];
    [app save];
    
    [self loadData];
}

-(void)goWeb:(UITapGestureRecognizer *)tap{
    NSInteger tag = [tap view].tag;
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    
    OpenApps *app = [_opens objectAtIndex:tag];
    app.openTime = [[NSDate new]timeIntervalSinceReferenceDate];
    [app save];
    
    NSDictionary *param = @{@"name":app.name,@"url":app.url};
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
}
@end
