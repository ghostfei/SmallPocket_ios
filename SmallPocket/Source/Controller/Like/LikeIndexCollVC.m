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

#import "Util.h"

@interface LikeIndexCollVC (){
    NSArray *dataArray;
    
    MBProgressHUD *_hud; 
    
    NSString *_type;
}

@end

@implementation LikeIndexCollVC

static NSString * const reuseIdentifier = @"LikeCell";

 
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"喜欢";
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
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
    if (dataArray.count%3!=0) {
        num = dataArray.count/3+1;
    }else{
        num = dataArray.count/3;
    }
    return num;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (dataArray.count>=3) {
        return 3;
    }
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LikeItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic =dataArray[indexPath.row];
    [cell.imgView setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:dic[@"icon"]]] placeholderImage:[UIImage imageNamed:@"default_app"]];
    cell.name.text  = dic[@"name"];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    NSDictionary *dic =dataArray[indexPath.row];
    NSLog(@"dic=%@",dic);
    NSDictionary *param = @{@"name":dic[@"name"],@"url":dic[@"url"]};
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
} 
-(void)loadData{
    NSDictionary *bdic = @{@"udid":@"asdasdad",@"type":_type};
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Util startActiciView:self.view];
    [Api post:API_LIKE_LIST parameters:bdic completion:^(id data, NSError *err) {
//        [_hud hide:YES];
        [Util stopActiciView:self.view];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                YLog(@"json=%@",dic);
        if ([dic[@"status"]intValue] == 200) {
            dataArray = dic[@"data"];
            //            YLog(@"array=%@",dataArray);
            [self.collectionView reloadData];
        }
    }];
}
-(void)giveMeLikeType:(NSString *)type{
    _type = type;
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
