//
//  LikeIndexCollVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/18.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "LikeIndexCollVC.h"
#import "LikeItemCollectionCell.h"
#import "SearchVC.h"
#import "OpenWebAppVC.h"
#import "OpenApps.h"

#import "Util.h"

@interface LikeIndexCollVC (){
    NSArray *_dataArray;
    
    MBProgressHUD *_hud; 
    
    NSString *_type;
}

@end

@implementation LikeIndexCollVC

static NSString * const reuseIdentifier = @"LikeCell";

 
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"喜欢";

    self.collectionView.backgroundColor = KEY_BGCOLOR_BLACK;
    self.collectionView.pagingEnabled = YES;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left_type"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeft)];
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    UIBarButtonItem *rbi = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_search_select"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAc)];
    self.navigationItem.rightBarButtonItem = rbi;
    
    _type = @"0";
    _leftVc.delegate = self;
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"downapp_noti" object:nil];
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger num=0;
    if (_dataArray.count%4 == 0) {
        num = _dataArray.count/4;
    }else{
        num = _dataArray.count/4+1;
    }
    NSLog(@"num=%ld",num);
    return num;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (_dataArray.count>3) {
//        return 4;
//    }else{
        return _dataArray.count;
//    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *la in self.collectionView.subviews) {
        if ([la isKindOfClass:[UILabel class]]) {
            [la removeFromSuperview];
        }
    }
    
    LikeItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikeCell" forIndexPath:indexPath];
    NSDictionary *dic =_dataArray[indexPath.row];
    cell.imgView.clipsToBounds = YES;
    cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.imgView setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:dic[@"icon"]]] placeholderImage:[UIImage imageNamed:@"default_app"]];
    cell.name.text  = dic[@"name"];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    NSDictionary *dic =_dataArray[indexPath.row];
    NSLog(@"dic=%@",dic);
    OpenApps *app = [OpenApps findOrCreate:dic];
    app.openTime = [[NSDate new]timeIntervalSinceReferenceDate];
    [app save];
    
    NSDictionary *param = @{@"name":dic[@"name"],@"url":dic[@"url"]};
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
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
            [self.collectionView addSubview:la];
        }
            [self.collectionView reloadData];
    }];
}
-(void)giveMeLikeType:(NSString *)type{
    _type = type;
    [self loadData];
    NSLog(@"_type=%@",_type);
}
-(void)showLeft{
    [self.navigationController pushViewController:[Util createVCFromStoryboard:@"LeftVC"] animated:YES];
}
-(void)searchAc{
    SearchVC *searchVc = [Util createVCFromStoryboard:@"SearchVC"];
    [self.navigationController pushViewController:searchVc animated:YES];
}
@end
