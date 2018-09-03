//
//  ViewController.m
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/8/29.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import "ViewController.h"
#import "YXAlertVC/YXAlertVC.h"

@interface ViewController () <YXAlertVCDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)click:(id)sender {

    YXAlertVC * yxVC = [[YXAlertVC alloc] init];

#pragma mark - method two
    yxVC.delegate = self;
    
    // 设置界面跳转的时候上一层页面不释放 ..
    yxVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:yxVC animated:YES completion:nil];
    
#pragma mark - method one
//    yxVC.caseOneBlock = ^(NSDictionary *photoDic) {
//
//        NSLog(@"block photo info is %@",photoDic);
//
//    };
//
//    /*
//     if we're in the real pre-commit handler we can't actually add any new fences due to CA restriction
//     
//     ... 
//     */
//    yxVC.caseTwoBlock = ^(NSString *travelNumberStr, NSString *referencesManStr) {
//
//        NSLog(@"block input msg is %@ || %@",travelNumberStr,referencesManStr);
//
//    };
}

#pragma mark - yxAlertVC delegate
- (void)yxAlertVC:(YXAlertVC *)alertVC clickAtphotoDic:(NSDictionary *)photoDic {
    
    NSLog(@"delegate photo info is %@",photoDic);
    
}

- (void)yxAlertVC:(YXAlertVC *)alertVC clickAtTravelNumberStr:(NSString *)travelNumberStr referencesManStr:(NSString *)referencesManStr {
    
    NSLog(@"delegate input msg is %@ || %@",travelNumberStr,referencesManStr);

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    
}

@end
