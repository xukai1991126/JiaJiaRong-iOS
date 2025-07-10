//
//  JJRAboutUsViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAboutUsViewController.h"
#import "JJRNetworkService.h"
#import "JJRAppInfoModel.h"
#import "JJRAPIDefines.h"
#import "WebViewController.h"
#import <objc/runtime.h>

@interface JJRAboutUsViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *appInfoView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *appDescLabel;
@property (nonatomic, strong) UIView *agreementView;
@property (nonatomic, strong) JJRAppInfoModel *appInfo;

@end

@implementation JJRAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupUI];
    [self fetchAppInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 确保状态栏样式更新
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 浅色背景使用深色状态栏文字
    return UIStatusBarStyleDefault;
}

- (void)setupNavigationBar {
    // 设置导航栏为白色背景
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        // 隐藏导航栏下面的分隔线
        appearance.shadowColor = [UIColor clearColor];
        appearance.shadowImage = [[UIImage alloc] init];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        // 隐藏导航栏下面的分隔线
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupUI {
    self.title = @"关于我们";
    // 设置背景色：#F7F7F7 (与uni-app一致)
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 应用信息区域 (与uni-app的.about-apps一致)
    self.appInfoView = [[UIView alloc] init];
    [self.contentView addSubview:self.appInfoView];
    
    // Logo图片 (使用app_icon)
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage imageNamed:@"app_icon"];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.appInfoView addSubview:self.logoImageView];
    
    // 应用名称
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.text = @""; // 从API获取
    self.appNameLabel.font = [UIFont boldSystemFontOfSize:15]; // 30rpx -> 15pt (与uni-app一致)
    self.appNameLabel.textColor = [UIColor blackColor];
    self.appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.appInfoView addSubview:self.appNameLabel];
    
    // 应用描述
    self.appDescLabel = [[UILabel alloc] init];
    self.appDescLabel.text = @""; // 从API获取
    self.appDescLabel.font = [UIFont boldSystemFontOfSize:15]; // 30rpx -> 15pt (与uni-app一致)
    self.appDescLabel.textColor = [UIColor colorWithRed:61.0/255.0 green:61.0/255.0 blue:61.0/255.0 alpha:1.0]; // #3D3D3D (与uni-app一致)
    self.appDescLabel.textAlignment = NSTextAlignmentLeft;
    self.appDescLabel.numberOfLines = 0;
    [self.appInfoView addSubview:self.appDescLabel];
    
    // 协议区域
    self.agreementView = [[UIView alloc] init];
    [self.contentView addSubview:self.agreementView];
    
    // 创建协议按钮
    [self createAgreementButtonWithTitle:@"用户服务协议" type:@"user" tag:100];
    [self createAgreementButtonWithTitle:@"个人信息授权书" type:@"authorization" tag:101];
    [self createAgreementButtonWithTitle:@"隐私服务协议" type:@"privacy" tag:102];
    
    // 设置约束
    [self setupConstraints];
}

- (void)createAgreementButtonWithTitle:(NSString *)title type:(NSString *)type tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt (与uni-app一致)
    [button setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.tag = tag;
    [button addTarget:self action:@selector(agreementButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // 存储type信息
    objc_setAssociatedObject(button, "agreementType", type, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.agreementView addSubview:button];
    
    // 添加底部分隔线 (与uni-app一致)
    if (tag < 102) { // 最后一个不添加分隔线
        UIView *separatorLine = [[UIView alloc] init];
        separatorLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]; // #ebebeb (与uni-app一致)
        [button addSubview:separatorLine];
        
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(button).offset(-17.5); // 35rpx / 2 -> 17.5pt
            make.left.right.equalTo(button);
            make.height.mas_equalTo(1); // 2rpx -> 1pt (与uni-app一致)
        }];
    }
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 应用信息区域 (padding: 100rpx 30rpx 0 -> 50pt 15pt 0)
    [self.appInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(50); // 100rpx -> 50pt
        make.left.right.equalTo(self.contentView).inset(15); // 30rpx -> 15pt
    }];
    
    // Logo (160rpx -> 80pt)
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appInfoView);
        make.centerX.equalTo(self.appInfoView);
        make.width.height.mas_equalTo(80); // 160rpx -> 80pt
    }];
    
    // 应用名称 (margin: 16rpx 0 60rpx -> 8pt 0 30pt)
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(8); // 16rpx -> 8pt
        make.left.right.equalTo(self.appInfoView);
    }];
    
    // 应用描述 (margin-bottom: 60rpx -> 30pt)
    [self.appDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appNameLabel.mas_bottom).offset(30); // 60rpx -> 30pt
        make.left.right.equalTo(self.appInfoView);
        make.bottom.equalTo(self.appInfoView).offset(-30); // 60rpx -> 30pt
    }];
    
    // 协议区域
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appInfoView.mas_bottom);
        make.left.right.equalTo(self.contentView).inset(16); // 32rpx -> 16pt
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    // 设置协议按钮约束
    UIButton *prevButton = nil;
    for (int i = 100; i <= 102; i++) {
        UIButton *button = [self.agreementView viewWithTag:i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (prevButton) {
                make.top.equalTo(prevButton.mas_bottom);
            } else {
                make.top.equalTo(self.agreementView);
            }
            make.left.right.equalTo(self.agreementView);
            make.height.mas_equalTo(67); // 32rpx + 35rpx -> 16pt + 17.5pt * 2 ≈ 67pt
            
            if (i == 102) { // 最后一个按钮
                make.bottom.equalTo(self.agreementView);
            }
        }];
        prevButton = button;
    }
}

#pragma mark - Network

- (void)fetchAppInfo {
    NSLog(@"📡 开始获取应用信息...");
    
    NSDictionary *params = @{
        @"appId": @"JJR",
        @"ios": @(YES)
    };
    
    [[JJRNetworkService sharedInstance] POST:@"/app/info" params:params success:^(NSDictionary *responseObject) {
        NSLog(@"✅ 应用信息获取成功: %@", responseObject);
        
        NSDictionary *data = responseObject[@"data"] ?: @{};
        JJRAppInfoModel *appInfo = [[JJRAppInfoModel alloc] init];
        appInfo.appName = data[@"appName"] ?: @"";
        appInfo.appText = data[@"appText"] ?: @"";
        
        self.appInfo = appInfo;
        [self updateUI];
        
    } failure:^(NSError *error) {
        NSLog(@"❌ 获取应用信息失败: %@", error.localizedDescription);
        NSString *errorMessage = error.localizedDescription;
        if (!errorMessage || errorMessage.length == 0) {
            errorMessage = @"获取应用信息失败";
        }
        [JJRToastTool showError:errorMessage];
    }];
}

#pragma mark - UI Updates

- (void)updateUI {
    if (!self.appInfo) {
        return;
    }
    
    self.appNameLabel.text = self.appInfo.appName;
    self.appDescLabel.text = self.appInfo.appText;
}



#pragma mark - Actions

- (void)agreementButtonTapped:(UIButton *)sender {
    NSString *type = objc_getAssociatedObject(sender, "agreementType");
    NSString *title = sender.titleLabel.text;
    
    NSLog(@"🔗 点击协议: %@ (type: %@)", title, type);
    
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.agreementType = type;
    webVC.title = title;
    [self.navigationController pushViewController:webVC animated:YES];
}

@end 
