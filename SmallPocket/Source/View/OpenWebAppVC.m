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
    
    _webView.userInteractionEnabled = YES; 
    
    if (![_type isEqual:@1]) {//type=1 使用协议
        UIBarButtonItem *pre = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_pre"] style:UIBarButtonItemStylePlain target:self action:@selector(goPre)];
        UIBarButtonItem *next = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_next"] style:UIBarButtonItemStylePlain target:self action:@selector(goNext)];
    
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_home"] style:UIBarButtonItemStylePlain target:self action:@selector(backAc)];
        self.navigationItem.leftBarButtonItems = @[pre,next];
        self.navigationItem.rightBarButtonItem = back;
    }
} 

-(void)loadData{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_param[@"url"]]]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [_hud hide:YES];
}
-(void)backAc{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goPre{
    [_webView goBack];
}
-(void)goNext{
    [_webView goForward];
}

@end
