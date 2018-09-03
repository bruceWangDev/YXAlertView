//
//  YXAlertVC.h
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/9/3.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import <UIKit/UIKit.h>

// case block 1
typedef void(^CaseOneBlock)(NSDictionary * photoDic);

// case block 2
typedef void(^CaseTwoBlock)(NSString * travelNumberStr, NSString * referencesManStr);

@class YXAlertVC;

@protocol YXAlertVCDelegate <NSObject>

@optional

// case delagate 1
- (void)yxAlertVC:(YXAlertVC *)alertVC clickAtphotoDic:(NSDictionary *)photoDic;

// case delagate 2
- (void)yxAlertVC:(YXAlertVC *)alertVC clickAtTravelNumberStr:(NSString *)travelNumberStr
                                       referencesManStr:(NSString *)referencesManStr;

@end

@interface YXAlertVC : UIViewController

@property (nonatomic, copy) CaseOneBlock caseOneBlock;

@property (nonatomic, copy) CaseTwoBlock caseTwoBlock;

@property (nonatomic, weak) id <YXAlertVCDelegate> delegate;

@end
