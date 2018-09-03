//
//  YXAlertVC.m
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/9/3.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import "YXAlertVC.h"
#import "YXAlertView.h"

#import "ImagePickerTool.h"

@interface YXAlertVC () <YXAlertViewDeleagte, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) YXAlertView * alertView;

@property (nonatomic, strong) NSDictionary * photoData;

@end

@implementation YXAlertVC

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor orangeColor];
    
    [self show];
}

- (void)show {
    
    [self creatUI];
    
    [self registrationNote];
}

- (void)dismiss {
    
    [_alertView dismiss];

    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [weakSelf.alertView removeFromSuperview];

        [self dismissViewControllerAnimated:YES completion:nil];

    });
}

- (void)creatUI {
    
    YXAlertView * alertView = [[YXAlertView alloc] initWithTitle:@"填写出差凭证"
                                                        subTitle:@"选择方式"];
    alertView.delegate = self;
    
    [alertView show];
    _alertView = alertView;
    
    __weak typeof(self) weakSelf = self;
    alertView.caseFirBlock = ^(NSInteger buttonTag) {
    
        switch (buttonTag) {
                
                // 相机
            case 3333: {
                
                if ([ImagePickerTool isHaveCamera] && [ImagePickerTool isHaveCameraPermission]) {
                    
                    [weakSelf creatIamgePickerVC:3333];
                    
                } else {
                    
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                    message:@"应用相机权限受限，请在iPhone的“设置-隐私-相机”选项中，允许 brucewangdev 访问您的相机"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"add 跳转权限设置界面");
                    }];
                    [alert addAction:action];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
                
            }   break;
                
                // 相册
            case 4444: {
                
                /*
                  [discovery] errors encountered while discovering extensions: Error Domain=PlugInKit Code=13 "query cancelled" UserInfo={NSLocalizedDescription=query cancelled}
                 */
                if ([ImagePickerTool isHavePhotoPermission]) {
                    
                    [weakSelf creatIamgePickerVC:4444];

                }
                
            }    break;
                
                // 确定
            case 5555: {
                
                if (weakSelf.photoData.count != 0) {
                    
                    [weakSelf dismiss];
                    
                    if (weakSelf.caseOneBlock) {
                     
                        weakSelf.caseOneBlock(weakSelf.photoData);
                        
                    }
                    
                }
                
            }
                break;
                
                // cancel
            case 6666: {
                
                [weakSelf dismiss];
                
            }  break;
                
            default:
                
                NSLog(@"YXAlertView error");
                
                break;
        }
    };
    
    alertView.caseSedBlock = ^(NSInteger buttonTag, NSString *travelNumberStr, NSString *referencesManStr) {
      
        switch (buttonTag) {
                
            case 5555: {
                
                if (travelNumberStr.length > 0 || referencesManStr.length > 0) {
                    
                    [weakSelf dismiss];
                    
                    if (weakSelf.caseTwoBlock) {
                        
                        weakSelf.caseTwoBlock(travelNumberStr, referencesManStr);
                        
                    }
                }
                
            }   break;
                
            case 6666: {
                
                [weakSelf dismiss];
                
            }   break;
                
            default:
                break;
        }
    };
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
        
        CGRect tempRect = weakSelf.alertView.frame;
        tempRect.origin.y = weakSelf.view.bounds.size.height - h - 10.0f - weakSelf.alertView.frame.size.height;
        weakSelf.alertView.frame = tempRect;
        
    }];
}

- (void)keboardHide:(NSNotification *)note {
    
    CGFloat duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        
        CGRect tempRect = weakSelf.alertView.frame;
        tempRect.origin.y = weakSelf.view.bounds.size.height / 4;
        weakSelf.alertView.frame = tempRect;
        
    }];
}

#pragma mark - yxAlertView delegate
- (void)yxAlertView:(YXAlertView *)alertView clickButtonAtTag:(NSInteger)buttonTag {
    
    switch (buttonTag) {
            
            // 相机
        case 3333: {
            
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
            
            // 相册这地方也需要进行权限的判断
            if ([ImagePickerTool isHavePhotoPermission]) {
                
                [self creatIamgePickerVC:4444];
                
            }
            
        }    break;
            
            // 确定
        case 5555: {
        
            if (_photoData.count != 0) {
                
                [self dismiss];
                
                if ([self.delegate respondsToSelector:@selector(yxAlertVC:
                                                                clickAtphotoDic:)]) {
                    
                    [self.delegate yxAlertVC:self
                             clickAtphotoDic:_photoData];
                    
                }
                
            }
            
        }
            break;
            
            // cancel
        case 6666: {
            
            [self dismiss];
            
        }  break;
            
        default:
            
            NSLog(@"YXAlertView error");
            
            break;
    }
}

- (void)yxAlertView:(YXAlertView *)alertView clickButtonAtTag:(NSInteger)buttonTag travelNumberStr:(NSString *)travelNumberStr referencesManStr:(NSString *)referencesManStr {
    
    switch (buttonTag) {
            
        case 5555: {
            
            if (travelNumberStr.length > 0 || referencesManStr.length > 0) {

                [self dismiss];

                if ([self.delegate respondsToSelector:@selector(yxAlertVC:
                                                                clickAtTravelNumberStr:
                                                                referencesManStr:)]) {
                    
                    [self.delegate yxAlertVC:self
                      clickAtTravelNumberStr:travelNumberStr
                            referencesManStr:referencesManStr];
                    
                }
            }
            
        }   break;
            
        case 6666: {
            
            [self dismiss];
            
        }   break;
            
        default:
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
    
    /*
     Warning: Attempt to present <UIImagePickerController: 0x104868e00> on <YXAlertVC: 0x104717750> whose view is not in the window hierarchy!
     
     I didn't think of a solution ..
     */
    [self presentViewController:imagePickerVC animated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    NSLog(@"相机取消了");
    
    [self hide];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    _photoData = info;
    
    [self hide];
    
}

- (void)hide {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
