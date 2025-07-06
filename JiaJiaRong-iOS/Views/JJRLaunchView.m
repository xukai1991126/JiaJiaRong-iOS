//
//  JJRLaunchView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRLaunchView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import <pop/pop.h>

@interface JJRLaunchView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIView *updateDialogView;
@property (nonatomic, strong) UIView *updateBackgroundView;

@end

@implementation JJRLaunchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
    
    // Logo图片
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"launch_logo"];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.logoImageView];
    
    // 应用名称
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.text = @"家家融";
    self.appNameLabel.font = [UIFont boldSystemFontOfSize:32];
    self.appNameLabel.textColor = [UIColor whiteColor];
    self.appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.appNameLabel];
    
    // 版本号
    self.versionLabel = [[UILabel alloc] init];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", version];
    self.versionLabel.font = [UIFont systemFontOfSize:14];
    self.versionLabel.textColor = [UIColor whiteColor];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.alpha = 0.8;
    [self addSubview:self.versionLabel];
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingIndicator.hidesWhenStopped = YES;
    [self addSubview:self.loadingIndicator];
}

- (void)setupConstraints {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-60);
        make.width.height.mas_equalTo(120);
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.appNameLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self).inset(20);
    }];
    
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-100);
        make.width.height.mas_equalTo(40);
    }];
}

- (void)startLaunchAnimation {
    // 初始状态
    self.logoImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.logoImageView.alpha = 0;
    self.appNameLabel.alpha = 0;
    self.versionLabel.alpha = 0;
    
    // Logo动画
    POPSpringAnimation *logoScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    logoScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    logoScaleAnimation.springBounciness = 10;
    logoScaleAnimation.springSpeed = 5;
    
    POPBasicAnimation *logoAlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    logoAlphaAnimation.toValue = @(1.0);
    logoAlphaAnimation.duration = 0.5;
    
    [self.logoImageView pop_addAnimation:logoScaleAnimation forKey:@"logoScale"];
    [self.logoImageView pop_addAnimation:logoAlphaAnimation forKey:@"logoAlpha"];
    
    // 文字动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        POPBasicAnimation *appNameAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        appNameAnimation.toValue = @(1.0);
        appNameAnimation.duration = 0.5;
        [self.appNameLabel pop_addAnimation:appNameAnimation forKey:@"appNameAlpha"];
        
        POPBasicAnimation *versionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        versionAnimation.toValue = @(0.8);
        versionAnimation.duration = 0.5;
        [self.versionLabel pop_addAnimation:versionAnimation forKey:@"versionAlpha"];
    });
    
    // 开始加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingIndicator startAnimating];
    });
    
    // 模拟启动完成
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingIndicator stopAnimating];
        
        // 淡出动画
        POPBasicAnimation *fadeOutAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        fadeOutAnimation.toValue = @(0.0);
        fadeOutAnimation.duration = 0.5;
        fadeOutAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            if (self.launchCompleted) {
                self.launchCompleted();
            }
        };
        [self pop_addAnimation:fadeOutAnimation forKey:@"fadeOut"];
    });
}

- (void)showUpdateDialog:(NSString *)version content:(NSString *)content forceUpdate:(BOOL)force {
    // 背景遮罩
    self.updateBackgroundView = [[UIView alloc] init];
    self.updateBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.updateBackgroundView];
    
    [self.updateBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 更新对话框
    self.updateDialogView = [[UIView alloc] init];
    self.updateDialogView.backgroundColor = [UIColor whiteColor];
    self.updateDialogView.layer.cornerRadius = 12;
    self.updateDialogView.clipsToBounds = YES;
    [self.updateBackgroundView addSubview:self.updateDialogView];
    
    [self.updateDialogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.updateBackgroundView);
        make.left.right.equalTo(self.updateBackgroundView).inset(40);
        make.height.mas_equalTo(280);
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"发现新版本";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.updateDialogView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updateDialogView).offset(20);
        make.left.right.equalTo(self.updateDialogView).inset(20);
        make.height.mas_equalTo(25);
    }];
    
    // 版本号
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = [NSString stringWithFormat:@"版本 %@", version];
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = [UIColor colorWithHexString:@"#007AFF"];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.updateDialogView addSubview:versionLabel];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self.updateDialogView).inset(20);
        make.height.mas_equalTo(20);
    }];
    
    // 更新内容
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.text = content;
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.textColor = [UIColor colorWithHexString:@"#666666"];
    contentTextView.editable = NO;
    contentTextView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    contentTextView.layer.cornerRadius = 8;
    [self.updateDialogView addSubview:contentTextView];
    
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.updateDialogView).inset(20);
        make.height.mas_equalTo(120);
    }];
    
    // 按钮容器
    UIView *buttonContainer = [[UIView alloc] init];
    [self.updateDialogView addSubview:buttonContainer];
    
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.updateDialogView).offset(-20);
        make.left.right.equalTo(self.updateDialogView).inset(20);
        make.height.mas_equalTo(44);
    }];
    
    if (force) {
        // 强制更新只显示更新按钮
        UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
        [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        updateButton.titleLabel.font = [UIFont systemFontOfSize:16];
        updateButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
        updateButton.layer.cornerRadius = 22;
        [updateButton addTarget:self action:@selector(updateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttonContainer addSubview:updateButton];
        
        [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(buttonContainer);
        }];
    } else {
        // 可选更新显示两个按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"稍后再说" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        cancelButton.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        cancelButton.layer.cornerRadius = 22;
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttonContainer addSubview:cancelButton];
        
        UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
        [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        updateButton.titleLabel.font = [UIFont systemFontOfSize:16];
        updateButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
        updateButton.layer.cornerRadius = 22;
        [updateButton addTarget:self action:@selector(updateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttonContainer addSubview:updateButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(buttonContainer);
            make.width.equalTo(buttonContainer).multipliedBy(0.45);
        }];
        
        [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(buttonContainer);
            make.width.equalTo(buttonContainer).multipliedBy(0.45);
        }];
    }
    
    // 显示动画
    self.updateDialogView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.updateDialogView.alpha = 0;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.springBounciness = 10;
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.toValue = @(1.0);
    alphaAnimation.duration = 0.3;
    
    [self.updateDialogView pop_addAnimation:scaleAnimation forKey:@"scale"];
    [self.updateDialogView pop_addAnimation:alphaAnimation forKey:@"alpha"];
}

- (void)updateButtonClicked {
    // 跳转到App Store
    NSString *appStoreURL = @"https://apps.apple.com/app/id123456789";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL] options:@{} completionHandler:nil];
}

- (void)cancelButtonClicked {
    // 隐藏更新对话框
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.toValue = @(0.0);
    alphaAnimation.duration = 0.3;
    alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self.updateBackgroundView removeFromSuperview];
        self.updateBackgroundView = nil;
        self.updateDialogView = nil;
    };
    [self.updateBackgroundView pop_addAnimation:alphaAnimation forKey:@"fadeOut"];
}

@end 