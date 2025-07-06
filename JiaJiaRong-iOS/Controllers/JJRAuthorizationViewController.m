//
//  JJRAuthorizationViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/6.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAuthorizationViewController.h"
#import "JJRNetworkService.h"
#import "JJRUserManager.h"
#import "JJRResultViewController.h"
#import <Masonry/Masonry.h>

@interface JJRAuthorizationViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *amountContainerView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *expectedLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *organizationLabel;
@property (nonatomic, strong) UITextView *agreementTextView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSDictionary *authorityData;
@property (nonatomic, strong) NSString *agreementContent;

@end

@implementation JJRAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.title = @"个人信息授权书";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建渐变背景
    [self setupGradientBackground];
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // 创建内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 创建授权信息卡片
    [self setupModalView];
    
    // 设置约束
    [self setupConstraints];
}

- (void)setupGradientBackground {
    // 创建渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    
    // 设置渐变颜色 (对应uni-app的渐变色)
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:38.0/255.0 green:63.0/255.0 blue:237.0/255.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:48.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:0.6].CGColor,
        (id)[UIColor colorWithRed:48.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:0.0].CGColor
    ];
    
    // 设置渐变方向 (从上到下)
    gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)setupModalView {
    // 主卡片容器
    self.modalView = [[UIView alloc] init];
    self.modalView.backgroundColor = [UIColor colorWithRed:254.0/255.0 green:250.0/255.0 blue:246.0/255.0 alpha:1.0];
    self.modalView.layer.cornerRadius = 12;
    self.modalView.layer.shadowColor = [UIColor colorWithRed:54.0/255.0 green:127.0/255.0 blue:255.0/255.0 alpha:0.15].CGColor;
    self.modalView.layer.shadowOffset = CGSizeMake(0, 2);
    self.modalView.layer.shadowRadius = 5;
    self.modalView.layer.shadowOpacity = 1.0;
    [self.contentView addSubview:self.modalView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"确认个人信息授权书";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithRed:61.0/255.0 green:61.0/255.0 blue:61.0/255.0 alpha:1.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.modalView addSubview:self.titleLabel];
    
    // 额度容器背景
    self.amountContainerView = [[UIView alloc] init];
    [self.modalView addSubview:self.amountContainerView];
    
    // 背景图片 - 使用渐变背景替代
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:0.1];
    self.backgroundImageView.layer.cornerRadius = 12;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.amountContainerView addSubview:self.backgroundImageView];
    
    // 预计授信额度标签
    self.expectedLabel = [[UILabel alloc] init];
    self.expectedLabel.text = @"预计授信额度(元)";
    self.expectedLabel.font = [UIFont systemFontOfSize:14];
    self.expectedLabel.textColor = [UIColor blackColor];
    self.expectedLabel.textAlignment = NSTextAlignmentCenter;
    [self.amountContainerView addSubview:self.expectedLabel];
    
    // 金额标签
    self.amountLabel = [[UILabel alloc] init];
    self.amountLabel.text = @"0";
    self.amountLabel.font = [UIFont boldSystemFontOfSize:40];
    self.amountLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    [self.amountContainerView addSubview:self.amountLabel];
    
    // 机构数量标签
    self.organizationLabel = [[UILabel alloc] init];
    self.organizationLabel.text = @"预计0家机构可提供服务（以实际匹配为准）";
    self.organizationLabel.font = [UIFont systemFontOfSize:14];
    self.organizationLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    self.organizationLabel.textAlignment = NSTextAlignmentCenter;
    [self.modalView addSubview:self.organizationLabel];
    
    // 协议内容
    self.agreementTextView = [[UITextView alloc] init];
    self.agreementTextView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:246.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.agreementTextView.layer.cornerRadius = 12;
    self.agreementTextView.font = [UIFont systemFontOfSize:14];
    self.agreementTextView.textColor = [UIColor blackColor];
    self.agreementTextView.editable = NO;
    self.agreementTextView.text = @"加载中...";
    [self.modalView addSubview:self.agreementTextView];
    
    // 确认按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"同意" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.confirmButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.confirmButton.layer.cornerRadius = 25;
    [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.modalView addSubview:self.confirmButton];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.modalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.right.equalTo(self.contentView).inset(15);
        make.bottom.equalTo(self.contentView).offset(-50);
        make.height.mas_greaterThanOrEqualTo(635); // 对应uni-app的1270rpx
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modalView).offset(27.5);
        make.left.right.equalTo(self.modalView).inset(15);
        make.height.mas_equalTo(25);
    }];
    
    [self.amountContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(22.5);
        make.centerX.equalTo(self.modalView);
        make.width.mas_equalTo(210); // 对应uni-app的420rpx
        make.height.mas_equalTo(141); // 对应uni-app的282rpx
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.amountContainerView);
    }];
    
    [self.expectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountContainerView).offset(30);
        make.centerX.equalTo(self.amountContainerView);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expectedLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.amountContainerView);
    }];
    
    [self.organizationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountContainerView.mas_bottom).offset(14);
        make.left.right.equalTo(self.modalView).inset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.agreementTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.organizationLabel.mas_bottom).offset(14);
        make.left.right.equalTo(self.modalView).inset(15);
        make.height.mas_equalTo(285); // 对应uni-app的570rpx
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreementTextView.mas_bottom).offset(18);
        make.left.right.equalTo(self.modalView).inset(15);
        make.height.mas_equalTo(49); // 对应uni-app的98rpx
        make.bottom.equalTo(self.modalView).offset(-27.5);
    }];
}

#pragma mark - Data Loading

- (void)loadData {
    [self loadAuthorityNumber];
    [self loadAgreementContent];
}

- (void)loadAuthorityNumber {
    [JJRNetworkService showLoading];
    
    [[JJRNetworkService sharedInstance] getAuthorityNumberWithSuccess:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        
        if ([response[@"code"] integerValue] == 200) {
            self.authorityData = response[@"data"];
            [self updateAuthorityUI];
        } else {
            [self showToast:@"获取授权信息失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [self showToast:@"网络错误，请重试"];
    }];
}

- (void)loadAgreementContent {
    [[JJRNetworkService sharedInstance] getAuthorizationAgreementWithAppId:@"JJR" 
                                                                     aupage:@1 
                                                                    success:^(NSDictionary *response) {
        if ([response[@"code"] integerValue] == 200) {
            self.agreementContent = response[@"data"][@"content"];
            [self updateAgreementUI];
        } else {
            [self showToast:@"获取协议内容失败"];
        }
    } failure:^(NSError *error) {
        [self showToast:@"获取协议内容失败"];
    }];
}

- (void)updateAuthorityUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *amount = self.authorityData[@"amount"] ?: @"0";
        NSString *merchantNum = self.authorityData[@"merchantNum"] ?: @"0";
        
        self.amountLabel.text = amount;
        self.organizationLabel.text = [NSString stringWithFormat:@"预计%@家机构可提供服务（以实际匹配为准）", merchantNum];
    });
}

- (void)updateAgreementUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.agreementContent) {
            // 将HTML内容转换为富文本
            NSData *data = [self.agreementContent dataUsingEncoding:NSUTF8StringEncoding];
            NSAttributedString *attributedString = [[NSAttributedString alloc] 
                initWithData:data 
                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                         NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} 
                documentAttributes:nil 
                error:nil];
            
            if (attributedString) {
                self.agreementTextView.attributedText = attributedString;
            } else {
                self.agreementTextView.text = self.agreementContent;
            }
        }
    });
}

#pragma mark - Actions

- (void)confirmButtonTapped {
    [JJRNetworkService showLoading];
    
    [[JJRNetworkService sharedInstance] submitMerchantApplyWithSuccess:^(NSDictionary *response) {
        [JJRNetworkService hideLoading];
        
        if ([response[@"code"] integerValue] == 200) {
            // 更新用户信息
            JJRUserManager *userManager = [JJRUserManager sharedManager];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:userManager.userInfo];
            userInfo[@"authority"] = @YES;
            [userManager updateUserInfo:userInfo];
            
            [self showToast:@"授权成功"];
            
            // 延迟跳转到结果页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self navigateToResult];
            });
        } else {
            [self showToast:response[@"msg"] ?: @"授权失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [self showToast:@"网络错误，请重试"];
    }];
}

- (void)navigateToResult {
    JJRResultViewController *resultVC = [[JJRResultViewController alloc] init];
    resultVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark - Helper

- (void)showToast:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

@end 