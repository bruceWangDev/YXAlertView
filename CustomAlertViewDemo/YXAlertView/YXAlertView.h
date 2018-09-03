//
//  YXAlertView.h
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/8/29.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import <UIKit/UIKit.h>

// first  case block
typedef void(^CaseFirBlock)(NSInteger buttonTag);

// second case block
typedef void(^CaseSedBlock)(NSInteger buttonTag, NSString * travelNumberStr, NSString * referencesManStr);

@class YXAlertView;

@protocol YXAlertViewDeleagte <NSObject>

@optional

// first  case delagate
- (void)yxAlertView:(YXAlertView *)alertView clickButtonAtTag:(NSInteger)buttonTag;

// second case delagate 
- (void)yxAlertView:(YXAlertView *)alertView clickButtonAtTag:(NSInteger)buttonTag
                                              travelNumberStr:(NSString *)travelNumberStr
                                             referencesManStr:(NSString *)referencesManStr;

@end

@interface YXAlertView : UIView

// by block
@property (nonatomic, copy) CaseFirBlock caseFirBlock;

@property (nonatomic, copy) CaseSedBlock caseSedBlock;

// by delegate
@property (nonatomic, weak) id <YXAlertViewDeleagte> delegate;

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle;

- (void)show;

- (void)dismiss;

@end
