//
//  OpenWebAppVC.h
//  
//
//  Created by ghostfei on 15/11/19.
//
//

#import <UIKit/UIKit.h>

@interface OpenWebAppVC : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (retain,nonatomic) NSNumber *type;
@property (nonatomic,strong) NSDictionary *param; 
@end
