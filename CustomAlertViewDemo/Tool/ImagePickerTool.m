//
//  ImagePickerTool.m
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/8/31.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import "ImagePickerTool.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation ImagePickerTool

+ (BOOL)isHaveCameraPermission {
    
    // 读取媒体类型
    NSString * mediaType = AVMediaTypeVideo;
    
    // 读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    /*
     AVAuthorizationStatusRestricted    没有授权进行照片数据访问
     AVAuthorizationStatusDenied        用户拒绝对应用程序授权
     */
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

+ (BOOL)isHaveCamera {
    
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];

}

+ (BOOL)isHaveFrontCamera {
    
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    
}

+ (BOOL)isHaveBehindCamera {
    
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    
}

@end
