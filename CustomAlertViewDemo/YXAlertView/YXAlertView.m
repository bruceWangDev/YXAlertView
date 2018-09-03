//
//  YXAlertView.m
//  CustomAlertViewDemo
//
//  Created by 王元雄 on 2018/8/29.
//  Copyright © 2018年 a developer. All rights reserved.
//

#import "YXAlertView.h"
#import <ionicons.h>

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define FONT_22 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:22.f] : [UIFont systemFontOfSize:19.f]

#define FONT_18 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:18.f] : [UIFont systemFontOfSize:15.f]

#define MAIN_COLOR ColorRGBA(118, 216, 206, 1)

#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

@interface YXAlertView () <UITextFieldDelegate>

@property (nonatomic,weak) UILabel * titleLabel;

@property (nonatomic,weak) UILabel * subTitleLabel;

@property (nonatomic,strong) NSMutableArray * btnArr;

@property (nonatomic,weak) UIButton * uploadBtn;

@property (nonatomic,weak) UIButton * writeBtn;

@property (nonatomic,weak) UIButton * cameraBtn;

@property (nonatomic,weak) UIButton * photoAlbumBtn;

@property (nonatomic,weak) UITextField * travelNumberTF;

@property (nonatomic,weak) UITextField * referencesManTF;

@property (nonatomic,weak) UIButton * ensureBtn;

@property (nonatomic,weak) UIButton * cancelBtn;

@property (nonatomic,weak) UIView * bgView1;

@property (nonatomic,weak) UIView * bgView2;

@end

@implementation YXAlertView

#pragma mark - 创建UI
- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle {
    
    self = [super init];
    if (self) {
        
        [self creatUIWithTitle:title
                      subTitle:subTitle];
    }
    
    return self;
}

- (void)creatUIWithTitle:(NSString *)title
                subTitle:(NSString *)subTitle {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.5f;
    
    _btnArr = [NSMutableArray arrayWithCapacity:2];
    
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                         20,
                                                                         SCREEN_WIDTH - 40,
                                                                         40)];
        titleLabel.text = title;
        titleLabel.font = FONT_22;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 4,
                                                             SCREEN_WIDTH - 20,
                                                             0.5f)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    
    if (!_subTitleLabel) {
        UILabel * subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                            _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 10,
                                                                            SCREEN_WIDTH - 60,
                                                                            40)];
        subTitleLabel.text = subTitle;
        subTitleLabel.font = FONT_18;
        subTitleLabel.textColor = [UIColor blackColor];
        subTitleLabel.textAlignment = NSTextAlignmentLeft;
        subTitleLabel.backgroundColor = [UIColor clearColor];
        

        [self addSubview:subTitleLabel];
        _subTitleLabel = subTitleLabel;
    }
    
    // 创建 简易 segment
    for (int i = 0; i < 2; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10 + i * ((SCREEN_WIDTH - 40)/ 2 + 5),
                                                                       _subTitleLabel.frame.origin.y + _subTitleLabel.frame.size.height,
                                                                       (SCREEN_WIDTH - 40)/ 2 - 5,
                                                                       40)];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button setImage:[IonIcons imageWithIcon:ion_ios_checkmark_outline
                                            size:20
                                           color:[UIColor blackColor]] forState:UIControlStateNormal];
        [button setImage:[IonIcons imageWithIcon:ion_ios_checkmark_outline
                                            size:20
                                           color:ColorRGBA(61, 160, 246, 1)] forState:UIControlStateHighlighted];
        [button setImage:[IonIcons imageWithIcon:ion_ios_checkmark
                                            size:20
                                           color:ColorRGBA(61, 160, 246, 1)] forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        [button addTarget:self action:@selector(conversion:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            // 默认选中
            button.selected = YES;
            button.tag = 1111;
            [button setTitle:@"上传凭证" forState: UIControlStateNormal];
            _uploadBtn = button;
        }
        
        if (i == 1) {
            
            button.tag = 2222;
            [button setTitle:@"填写凭证信息" forState: UIControlStateNormal];
            _writeBtn = button;
        }
        
        [self addSubview:button];
        [_btnArr addObject:button];
    }
    
    /*
     同时创建两种事件，但是默认将第二种隐藏 ..
     bgView1 对应 第一种
     bgView2 对应 第二种
     */
    
    [self creatSecondCase];

    [self creatFirstCase];
    
    [_bgView1 setHidden:NO];
    [_bgView2 setHidden:YES];
}

- (void)creatFirstCase {
    
    [_bgView2 setHidden:YES];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                             _writeBtn.frame.origin.y + _writeBtn.frame.size.height + 10,
                                                             SCREEN_WIDTH - 40,
                                                             90)];
    
    for (int i = 0; i < 2; i++) {
    
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i * ((SCREEN_WIDTH - 40)/ 2 + 5),
                                                                       0,
                                                                       (SCREEN_WIDTH - 40)/ 2 - 5,
                                                                       40)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3.0f;
        button.layer.borderColor = [UIColor darkTextColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(caseOneClick:) forControlEvents:UIControlEventTouchUpInside];

        if (i == 0) {
            button.tag = 3333;
            [button setTitle:@"拍照" forState: UIControlStateNormal];
            _cameraBtn = button;
        }
        if (i == 1) {
            button.tag = 4444;
            [button setTitle:@"相册" forState: UIControlStateNormal];
            _photoAlbumBtn = button;
        }
        [view addSubview:button];
    }
    _bgView1 = view;
    [self creatLastBtn:1];
}

- (void)creatSecondCase {
    
    [_bgView1 setHidden:YES];

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                             _writeBtn.frame.origin.y + _writeBtn.frame.size.height + 10,
                                                             SCREEN_WIDTH - 40,
                                                             140)];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0 + i * 50,
                                                                    90,
                                                                    40)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(90,
                                                                                0 + i * 50,
                                                                                SCREEN_WIDTH - 40 - 90,
                                                                                40)];
        textField.backgroundColor = [UIColor whiteColor];
        
        textField.placeholder = @"必填一项";
        
        textField.layer.masksToBounds = YES;
        textField.layer.cornerRadius = 3.0f;
        textField.layer.borderColor = [UIColor darkTextColor].CGColor;
        textField.layer.borderWidth = 0.5f;
        
        textField.clearsOnBeginEditing = YES;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyGo;

        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        leftView.backgroundColor = [UIColor clearColor];
        textField.leftView = leftView;
        
        if (i == 0) {
            label.text = @"出行编号";
            _travelNumberTF = textField;
        }
        if (i == 1) {
            label.text = @"证明人";
            _referencesManTF = textField;
        }
        [view addSubview:label];
        [view addSubview:textField];
    }
    _bgView2 = view;
    [self creatLastBtn:2];
}

- (void)creatLastBtn:(NSInteger)index {
    
    CGFloat y;
    if (index == 1) {
        
        y = _photoAlbumBtn.frame.origin.y + _photoAlbumBtn.frame.size.height + 10;
        
    } else if (index == 2) {
        
        y = _referencesManTF.frame.origin.y + _referencesManTF.frame.size.height + 10;
        
    } else {
        
        y = 0;
        NSLog(@"y error");
    }
    
    // 创建 确定 取消 按钮
    for (int i = 0; i < 2; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i * ((SCREEN_WIDTH - 40)/ 2 + 5),
                                                                       y,
                                                                       (SCREEN_WIDTH - 40)/ 2 - 5,
                                                                       40)];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3.0f;
        button.layer.borderWidth = 0.5f;
        
        if (i == 0) {
            
            button.tag = 5555;
            button.backgroundColor = ColorRGBA(61, 160, 246, 1);
            button.layer.borderColor = ColorRGBA(61, 160, 246, 1).CGColor;
            [button setTitle:@"确定" forState: UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _ensureBtn = button;
        }
        
        if (i == 1) {
            
            button.tag = 6666;
            button.backgroundColor = [UIColor whiteColor];
            button.layer.borderColor = [UIColor darkTextColor].CGColor;
            [button setTitle:@"取消" forState: UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _cancelBtn = button;
        }
        
        if (index == 1) {
            
            [button addTarget:self action:@selector(caseOneClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_bgView1 addSubview:button];
            
        } else {
            
            [button addTarget:self action:@selector(caseTwoClick:) forControlEvents:UIControlEventTouchUpInside];

            [_bgView2 addSubview:button];
        }
    }
    
    if (index == 1) {
        
        [self addSubview:_bgView1];
        self.frame = CGRectMake(10,
                                SCREENH_HEIGHT,
                                SCREEN_WIDTH - 20,
                                _bgView1.frame.origin.y + _bgView1.frame.size.height + 20);

    } else {
        
        [self addSubview:_bgView2];
        self.frame = CGRectMake(10,
                                SCREENH_HEIGHT,
                                SCREEN_WIDTH - 20,
                                _bgView2.frame.origin.y + _bgView2.frame.size.height + 20);

    }
}

// segment click
- (void)conversion:(UIButton *)btn {
    
    btn.selected = YES;
    
    for (UIButton * button in _btnArr) {
        if (button != btn) {
            button.selected = NO;
        }
    }
    
    // 点击按钮需要修改frame ..
    if (btn.tag == 1111) {
        
        [_travelNumberTF resignFirstResponder];
        [_referencesManTF resignFirstResponder];
        
        [_bgView1 setHidden:NO];
        [_bgView2 setHidden:YES];
        
        CGRect tempRect = self.frame;
        tempRect.size.height = _bgView1.frame.origin.y + _bgView1.frame.size.height + 20;
        self.frame = tempRect;
        
    } else if (btn.tag == 2222) {
        
        [_bgView2 setHidden:NO];
        [_bgView1 setHidden:YES];
        
        CGRect tempRect = self.frame;
        tempRect.size.height = _bgView2.frame.origin.y + _bgView2.frame.size.height + 20;
        self.frame = tempRect;
        
    } else {
        
        NSLog(@"error");
    }
}

#pragma mark - show and dismiss
- (void)show {
    
    /*
     在主线程中处理，否则在viewDidLoad方法中直接调用，会先加本视图，后加控制器的视图到UIWindow上
     导致本视图无法显示出来，这样处理后便会优先加控制器的视图到UIWindow上
     */
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//
//        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
//        for (UIWindow *window in frontToBackWindows) {
//
//            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
//            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
//            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
//
//            if(windowOnMainScreen && windowIsVisible && windowLevelNormal) {
//
//                [window addSubview:self];
//                break;
//            }
//        }
//    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    // 动画效果
    CGFloat alertY = self.frame.origin.y;

    alertY = SCREENH_HEIGHT / 4;
    
    __weak __typeof(self)weakSelf = self; // alone
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:1 initialSpringVelocity:6 options:UIViewAnimationOptionCurveLinear animations:^{
        
        CGRect tempRect = weakSelf.frame;
        tempRect.origin.y = alertY;
        weakSelf.frame = tempRect;

    } completion:^(BOOL finished) {

        NSLog(@"finish");
        
    }];
}

- (void)dismiss {
    
    __weak __typeof(self)weakSelf = self; // alone
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect tempRect = weakSelf.frame;
        tempRect.origin.y = SCREENH_HEIGHT;
        weakSelf.frame = tempRect;
        
    } completion:^(BOOL finished) {

        [weakSelf removeFromSuperview];
        
    }];
}



#pragma mark - delegate
- (void)caseOneClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(yxAlertView:
                                                    clickButtonAtTag:)]) {
        
        [self.delegate yxAlertView:self
                  clickButtonAtTag:btn.tag];
        
    }
    
    self.caseFirBlock(btn.tag);
        
}

- (void)caseTwoClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(yxAlertView:
                                                    clickButtonAtTag:
                                                    travelNumberStr:
                                                    referencesManStr:)]) {
        
        [self.delegate yxAlertView:self
                  clickButtonAtTag:btn.tag
                   travelNumberStr:_travelNumberTF.text
                  referencesManStr:_referencesManTF.text];
    }
    
    self.caseSedBlock(btn.tag, _travelNumberTF.text, _referencesManTF.text);
    
}

#pragma mark - textFiled delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_travelNumberTF resignFirstResponder];
    [_referencesManTF resignFirstResponder];
    
    return YES;
}

@end
