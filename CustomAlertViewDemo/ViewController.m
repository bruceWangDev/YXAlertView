//
//  ViewController.m
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/8/29.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import "ViewController.h"
#import "YXAlertView/YXAlertView.h"

#import <AVFoundation/AVFoundation.h>

#import "ImagePickerTool.h"

@interface ViewController () <YXAlertViewDeleagte, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) YXAlertView * yxAlert;

@property (nonatomic, assign) BOOL isFlag; // NO - case 1

@end

@implementation ViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    _isFlag = NO;
    
    [self registrationNote];

}

#pragma mark - note
- (void)registrationNote {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

/*
 note.info 里有键盘原始 frame、目标 frame、动画 duration，计算出键盘目标 y，判断是否挡住输入框，挡住就上移 view
 
 notw show is NSConcreteNotification 0x604000454670 {name = UIKeyboardWillShowNotification; userInfo = {
 UIKeyboardAnimationCurveUserInfoKey = 7;
 UIKeyboardAnimationDurationUserInfoKey = "0.25";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 333}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 978.5}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 645.5}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 812}, {375, 333}}";
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 479}, {375, 333}}";
 UIKeyboardIsLocalUserInfoKey = 1;
 }}
 notw hide is NSConcreteNotification 0x60400025f860 {name = UIKeyboardWillHideNotification; userInfo = {
 UIKeyboardAnimationCurveUserInfoKey = 7;
 UIKeyboardAnimationDurationUserInfoKey = "0.25";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 333}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 645.5}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 978.5}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 479}, {375, 333}}";
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 812}, {375, 333}}";
 UIKeyboardIsLocalUserInfoKey = 1;
 }}

 */
- (void)keboardShow:(NSNotification *)note {
    
    CGRect rect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat h = rect.size.height;
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
       
        CGRect tempRect = weakSelf.yxAlert.frame;
        tempRect.origin.y = weakSelf.view.bounds.size.height - h - 10.0f - weakSelf.yxAlert.frame.size.height;
        weakSelf.yxAlert.frame = tempRect;

    }];
}

- (void)keboardHide:(NSNotification *)note {
    
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        
        CGRect tempRect = weakSelf.yxAlert.frame;
        tempRect.origin.y = weakSelf.view.bounds.size.height / 4;
        weakSelf.yxAlert.frame = tempRect;
        
    }];
}

#pragma mark - yxAlertView delegate
- (void)yxAlertView:(YXAlertView *)alertView clickedButtonAtTag:(NSInteger)buttonTag travelNumberStr:(NSString *)travelNumberStr referencesManStr:(NSString *)referencesManStr {
    
    NSLog(@"delegate travelNumberStr is %@ - referencesManStr is %@",travelNumberStr,referencesManStr);
    
    if (travelNumberStr.length > 0 || referencesManStr.length > 0) {
        
        _isFlag = YES;
        
    }
    
    switch (buttonTag) {
        
        // 相机
        case 3333: {
            
//            [_yxAlert dismiss];
            
            // 在这个地方把 _yxAlert 推到界面的最下层
//            [self.view sendSubviewToBack:_yxAlert];
            _yxAlert.hidden = YES;
            
            if ([ImagePickerTool isHaveCamera] && [ImagePickerTool isHaveCameraPermission]) {

                [self creatIamgePickerVC:3333];

            } else {

                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                message:@"应用相机权限受限，请在iPhone的“设置-隐私-相机”选项中，允许 brucewangdev 访问您的相机"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"add 跳转权限设置界面");
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }   break;
            
        // 相册
        case 4444: {
            
//            [_yxAlert dismiss];
            _yxAlert.hidden = YES;

            [self creatIamgePickerVC:4444];
            
        }    break;
            
        // 确定
        case 5555:
        // 键盘 go
        case 9999:
            
            if (_isFlag == YES) {
             
                if (travelNumberStr.length > 0 || referencesManStr.length > 0) {
                    
                    [_yxAlert dismiss];
                    
                }
                
            } else {
                
                if (YES) {
                    
                    [_yxAlert dismiss];
                    
                }
                
            }
            
            break;
        
        // cancel
        case 6666:
            
            [_yxAlert dismiss];
            
            break;
            
        default:
            
            NSLog(@"YXAlertView error");
            
            break;
    }
}

#pragma imagePicker
- (void)creatIamgePickerVC:(NSInteger)tag {
    
    UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
    
    if (tag == 3333) {

        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;

    } else {
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    }
    
    imagePickerVC.delegate = self;
    
    [self presentViewController:imagePickerVC animated:YES completion:^{
    
        if (tag == 3333) {

            NSLog(@"调用相机成功");

        } else {
            
            NSLog(@"调用相册成功");
            
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{

        weakSelf.isFlag = NO;

    }];
    NSLog(@"info s %@",info);
    
    // 把_yxAlert重新推回到视图的最上层
//    [self.view bringSubviewToFront:_yxAlert];
    _yxAlert.hidden = NO;
    
}

- (IBAction)click:(id)sender {

    YXAlertView * yxAlert = [[YXAlertView alloc] initWithTitle:@"填写出差凭证"
                                                    subTitle:@"选择方式"];
    yxAlert.delegate = self;
    
    yxAlert.callBlock = ^(NSInteger buttonTag, NSString *travelNumberStr, NSString *referencesManStr) {
        NSLog(@"callBlock buttonTag is %ld",buttonTag);
        NSLog(@"callBlock travelNumberStr is %@",travelNumberStr);
        NSLog(@"callBlock referencesManStr is %@",referencesManStr);
    };
    
    [yxAlert show];
    _yxAlert = yxAlert;
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    
}

@end
