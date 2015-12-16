//
//  LeftVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/28.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "LeftVC.h"
#import "Util.h"

#import "LikeIndexCollVC.h"

@interface LeftVC (){
    NSArray *dataArray;
    
    NSString *_type;
}

@end

@implementation LeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _type = @"0";
    [self loadData];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = dataArray[indexPath.row];
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"typecell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typecell"];
    }
    cell.textLabel.text = dic[@"name"];
    
    return cell;
}


-(void)loadData{
    [Api post:API_TYPE_LIST parameters:nil completion:^(id data, NSError *err) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                YLog(@"json=%@",dic);
        if ([dic[@"status"]intValue] == 200) {
            dataArray = dic[@"data"];
            [self.tableView reloadData];
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = dataArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _type = dic[@"id"];
    
    LikeIndexCollVC *likeVc = [Util createVCFromStoryboard:@"LikeIndexCollVC"];
    self.delegate = likeVc;
    [_delegate giveMeLikeType:_type];
//     [(DDMenuController *)self ];
}
@end
