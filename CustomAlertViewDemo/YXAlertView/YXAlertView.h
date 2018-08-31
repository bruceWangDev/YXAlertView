//
//  YXAlertView.h
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/8/29.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Two textFiled text for callback of the second case
 */
typedef void(^CallBlock) (NSInteger buttonTag, NSString * travelNumberStr, NSString * referencesManStr);

@class YXAlertView;

@protocol YXAlertViewDeleagte <NSObject>

@optional

- (void)yxAlertView:(YXAlertView *)alertView clickedButtonAtTag:(NSInteger)buttonTag
                                                travelNumberStr:(NSString *)travelNumberStr
                                               referencesManStr:(NSString *)referencesManStr;

@end

@interface YXAlertView : UIView

// by block
@property (nonatomic, strong) CallBlock callBlock;

// by delegate
@property (nonatomic, weak) id <YXAlertViewDeleagte> delegate;

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle;

- (void)show;

- (void)dismiss;

@end
