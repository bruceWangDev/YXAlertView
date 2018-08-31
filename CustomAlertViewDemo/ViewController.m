//
//  ViewController.m
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/8/29.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import "ViewController.h"
#import "YXAlertView/YXAlertView.h"

@interface ViewController () <YXAlertViewDeleagte>

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];

}

#pragma mark - yxAlertView delegate
- (void)yxAlertView:(YXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
    switch (buttonIndex) {
        case 3333:
            NSLog(@"拍照");
            break;
        case 4444:
            NSLog(@"相册");
            break;
        case 5555:
            NSLog(@"确定");
            break;
        case 6666:
            NSLog(@"取消");
            break;
        case 9999:
            /*
             想直接通过 block 获取键盘上的文字
             另外，YXAlertView 的 show 和 dismiss 感觉有点问题
             removeFromSuperview 不起作用 .. 
             */
            NSLog(@"键盘直接Go");
            break;
        default:
            break;
    }
}

- (IBAction)click:(id)sender {

    YXAlertView * alert = [[YXAlertView alloc] initWithTitle:@"填写出差凭证"
                                                    subTitle:@"选择方式"];
    alert.delegate = self;
    [alert show];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    
}

@end
