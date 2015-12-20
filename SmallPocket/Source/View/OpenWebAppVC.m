//
//  OpenWebAppVC.m
//
//
//  Created by ghostfei on 15/11/19.
//
//

#import "OpenWebAppVC.h"
#import "Util.h"

@interface OpenWebAppVC ()<UIWebViewDelegate> {
    MBProgressHUD *_hud;
}
@end

@implementation OpenWebAppVC

- (void)viewDidLoad {
    [super viewDidLoad]; 
//    [self.navigationController setNavigationBarHidden:YES];
    self.navigationItem.title = _param[@"name"];
    
    [self loadData];
//    [_closeBtn addTarget:self action:@selector(backAc) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.hidden = YES;
    
    _webView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *RTap = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showBar:)];
    RTap.direction = UISwipeGestureRecognizerDirectionRight;
    [_webView addGestureRecognizer:RTap];
} 

-(void)loadData{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_param[@"url"]]]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_hud hide:YES];
}
-(void)backAc{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showBar:(UISwipeGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
