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
    
    // 担保资质声明
    UILabel *qualificationLabel = [[UILabel alloc] init];
    qualificationLabel.text = @"融资担保资质声明";
    qualificationLabel.font = [UIFont boldSystemFontOfSize:16];
    qualificationLabel.textColor = [UIColor blackColor];
    qualificationLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:qualificationLabel];
    
    UILabel *qualificationDescLabel = [[UILabel alloc] init];
    qualificationDescLabel.text = @"本平台为持牌融资担保服务机构，依法依规开展融资担保业务。严格遵循国家金融监管要求，为中小微企业和个人客户提供专业、安全、透明的担保服务。所有业务均在金融监管部门备案监督，担保资金由第三方银行托管，客户权益受法律保护。";
    qualificationDescLabel.font = [UIFont systemFontOfSize:14];
    qualificationDescLabel.textColor = [UIColor grayColor];
    qualificationDescLabel.textAlignment = NSTextAlignmentLeft;
    qualificationDescLabel.numberOfLines = 0;
    [self.contentView addSubview:qualificationDescLabel];
    
    // 业务说明
    UILabel *businessLabel = [[UILabel alloc] init];
    businessLabel.text = @"业务范围说明";
    businessLabel.font = [UIFont boldSystemFontOfSize:16];
    businessLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    businessLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:businessLabel];
    
    UILabel *businessDescLabel = [[UILabel alloc] init];
    businessDescLabel.text = @"我们专注于为客户提供融资担保服务，包括银行贷款担保、信用增进服务等。通过专业的风险评估和担保服务，帮助客户获得更优质的融资条件。我们不是放贷机构，不直接放贷，而是作为第三方担保机构为客户提供增信服务。";
    businessDescLabel.font = [UIFont systemFontOfSize:14];
    businessDescLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    businessDescLabel.textAlignment = NSTextAlignmentLeft;
    businessDescLabel.numberOfLines = 0;
    [self.contentView addSubview:businessDescLabel];
    
    // 风险提示
    UILabel *riskLabel = [[UILabel alloc] init];
    riskLabel.text = @"重要提示";
    riskLabel.font = [UIFont boldSystemFontOfSize:16];
    riskLabel.textColor = [UIColor redColor];
    riskLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:riskLabel];
    
    UILabel *riskDescLabel = [[UILabel alloc] init];
    riskDescLabel.text = @"融资担保服务存在一定风险，请客户根据自身实际情况谨慎申请。担保费用公开透明，无任何隐性收费。如有疑问或需要帮助，请及时联系我们的客服团队。";
    riskDescLabel.font = [UIFont systemFontOfSize:14];
    riskDescLabel.textColor = [UIColor redColor];
    riskDescLabel.textAlignment = NSTextAlignmentLeft;
    riskDescLabel.numberOfLines = 0;
    [self.contentView addSubview:riskDescLabel];

    // 创建协议按钮
    [self createAgreementButtonWithTitle:@"融资担保服务协议" type:@"user" tag:100];
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
    
    // 获取担保资质声明、业务说明和重要提示标签
    UILabel *qualificationLabel = nil;
    UILabel *qualificationDescLabel = nil;
    UILabel *businessLabel = nil;
    UILabel *businessDescLabel = nil;
    UILabel *riskLabel = nil;
    UILabel *riskDescLabel = nil;
    
    for (UIView *subview in self.contentView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            if ([label.text isEqualToString:@"融资担保资质声明"]) {
                qualificationLabel = label;
            } else if ([label.text containsString:@"本平台为持牌融资担保服务机构"]) {
                qualificationDescLabel = label;
            } else if ([label.text isEqualToString:@"业务范围说明"]) {
                businessLabel = label;
            } else if ([label.text containsString:@"我们专注于为客户提供融资担保服务"]) {
                businessDescLabel = label;
            } else if ([label.text isEqualToString:@"重要提示"]) {
                riskLabel = label;
            } else if ([label.text containsString:@"融资担保服务存在一定风险"]) {
                riskDescLabel = label;
            }
        }
    }
    
    // 设置担保资质声明约束
    if (qualificationLabel) {
        [qualificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.appInfoView.mas_bottom).offset(30);
            make.left.right.equalTo(self.contentView).inset(15);
        }];
    }
    
    if (qualificationDescLabel) {
        [qualificationDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qualificationLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView).inset(15);
        }];
    }
    
    // 设置业务说明约束
    if (businessLabel) {
        [businessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qualificationDescLabel.mas_bottom).offset(20);
            make.left.right.equalTo(self.contentView).inset(15);
        }];
    }
    
    if (businessDescLabel) {
        [businessDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(businessLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView).inset(15);
        }];
    }
    
    // 设置重要提示约束
    if (riskLabel) {
        [riskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(businessDescLabel.mas_bottom).offset(20);
            make.left.right.equalTo(self.contentView).inset(15);
        }];
    }
    
    if (riskDescLabel) {
        [riskDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(riskLabel.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView).inset(15);
        }];
    }
    
    // 协议区域
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (riskDescLabel) {
            make.top.equalTo(riskDescLabel.mas_bottom).offset(20);
        } else {
            make.top.equalTo(self.appInfoView.mas_bottom);
        }
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
