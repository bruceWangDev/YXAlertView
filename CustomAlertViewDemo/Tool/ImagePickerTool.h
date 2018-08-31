//
//  ImagePickerTool.h
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/8/31.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePickerTool : NSObject

+ (BOOL)isHaveCameraPermission;

+ (BOOL)isHaveCamera;

+ (BOOL)isHaveFrontCamera;

+ (BOOL)isHaveBehindCamera;

@end
