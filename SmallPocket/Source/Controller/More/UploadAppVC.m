//
//  UploadAppVC.m
//  SmallPocket
//
//  Created by ghostfei on 15/12/6.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "UploadAppVC.h"
#import "Util.h"
#import "AppTypeListVC.h"
#import "OpenWebAppVC.h"


@interface UploadAppVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    MBProgressHUD *_hud;
    
    NSData *_imgData;
    NSString *_typeId;
}

@end

@implementation UploadAppVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提交应用";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAc)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseIcon)];
    _iconImg.userInteractionEnabled = YES;
    [_iconImg addGestureRecognizer:tap];
    
    _url.text = @"http://www.";
    
    UITapGestureRecognizer *tapEnd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tapEnd];
    
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = barBack;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(choseType:) name:@"select_type_noti" object:nil];
    
    [_checkImg setImage:[UIImage imageNamed:@"icon_uncheckin"]];
    _checkImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *checkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkAc)];
    [_checkImg addGestureRecognizer:checkTap];
}
-(void)choseType:(NSNotificationCenter *)noti{
    NSDictionary *dic = [noti valueForKey:@"object"];
    _type.text = dic[@"name"];
    _typeId = dic[@"id"];
}
-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

#pragma mark
- (void)choseIcon {
    [self endEdit];
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"照片选取" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从照相机选取" otherButtonTitles:@"从图库选取", nil];
    [as showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc]init];
    photoPicker.allowsEditing=YES;
    photoPicker.delegate = self;
    if (buttonIndex == 0) {
        //相机
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:photoPicker animated:YES completion:^{
            
        }];
    }else if (buttonIndex == 1) {
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:photoPicker animated:YES completion:^{
            
        }];
    }
}
#pragma mark -  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *tempImg=[info objectForKey:UIImagePickerControllerEditedImage];
    YLog(@"crame=%@",tempImg);
    _imgData = UIImageJPEGRepresentation(tempImg, 0.5);//
    //    UIImageView *userImg = (UIImageView *)[self.view viewWithTag:1000];
    //    [userImg setImage:tempImg];
    
    [_iconImg setImage:tempImg];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveAc{
    if (_imgData ==nil) {
        [Util showHintMessage:@"请上传应用图片"];
        return;
    }
    if (_name.text.length == 0) {
        [Util showHintMessage:@"请输入应用名"];
        return;
    }
    if (_url.text.length == 0) {
        [Util showHintMessage:@"请输入下载地址"];
        return;
    }
    if (_tel.text.length == 0) {
        [Util showHintMessage:@"请输入电话"];
        return;
    }
    if (_publisher.text.length == 0) {
        [Util showHintMessage:@"请输入发布者"];
        return;
    }
    if (_typeId.length == 0) {
        [Util showHintMessage:@"请选择类型"];
        return;
    }
    if ([_checkImg.image isEqual:[UIImage imageNamed:@"icon_checkin"]]) {
        [self endEdit];
        NSDictionary *dic = @{@"name":_name.text,
                              @"desc":_desc.text,
                              @"url":_url.text,
                              @"tel":_tel.text,
                              @"publisher":_publisher.text,
                              @"type":_typeId};
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Api post:API_UPLOADAPP_ACTION
       parameters:dic formDataBlock:^(id<AFMultipartFormData> formData) {
           [formData appendPartWithFileData:_imgData
                                       name:@"icon"
                                   fileName:@"icon.jpg"
                                   mimeType:@"image/jpeg"];
       } completion:^(id data, NSError *err) {
           [_hud hide:YES];
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSLog(@"dic=%@",dic[@"msg"]);
           if ([dic[@"status"]intValue] == 200) {
               [self.navigationController popViewControllerAnimated:YES];
           }else{
               [Util showHintMessage:dic[@"msg"]];
           }
       }];
    }else{
        [Util showHintMessage:@"请确认已经同意我们的使用协议"];
    }
}
-(void)endEdit{
    [self.view endEditing:YES];
}
- (IBAction)goType:(id)sender {
    AppTypeListVC *typeVC = [Util createVCFromStoryboard:@"AppTypeListVC"];
    [self.navigationController pushViewController:typeVC animated:YES];
}
-(void)checkAc{
    NSLog(@"勾选协议");
    if ([_checkImg.image isEqual:[UIImage imageNamed:@"icon_uncheckin"]]) {
        _checkImg.image = [UIImage imageNamed:@"icon_checkin"];
    }else{
        _checkImg.image = [UIImage imageNamed:@"icon_uncheckin"];
    }
}
- (IBAction)goProtocol:(id)sender {
    OpenWebAppVC *webview = [Util createVCFromStoryboard:@"OpenWebAppVC"];
    NSDictionary *param = @{@"name":@"服务协议",@"url":[NSString stringWithFormat:@"%@%@",DEFAULT_API_URL,API_PROTOCOL]};
    webview.type = @1;
    webview.param = param;
    [self.navigationController pushViewController:webview animated:YES];
}
@end
