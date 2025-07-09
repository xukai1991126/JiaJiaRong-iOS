//
//  JJRShouquanshuViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRShouquanshuViewController.h"
#import "JJRButton.h"
#import "JJRApplyFormViewController.h"
#import "WebViewController.h"

@interface JJRShouquanshuViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIView *agreementContainer;
@property (nonatomic, strong) UIButton *agreementCheckbox;
@property (nonatomic, strong) UIView *agreementTextContainer;
@property (nonatomic, strong) JJRButton *agreeButton;

@end

@implementation JJRShouquanshuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"授权书";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-200);
    }];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"个人征信查询授权书";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    // 内容
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.text = @"本人授权佳佳融平台查询本人的个人征信信息，用于风险评估和信用评估。\n\n本人承诺提供的所有信息真实、准确、完整，如有虚假信息，本人承担相应法律责任。\n\n本人同意佳佳融平台在业务需要时向相关机构查询、验证本人的身份信息、信用信息等。\n\n本授权书自签署之日起生效，有效期至业务关系终止。";
    self.contentTextView.font = [UIFont systemFontOfSize:14];
    self.contentTextView.textColor = [UIColor colorWithHexString:@"#666666"];
    self.contentTextView.editable = NO;
    self.contentTextView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.contentTextView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.contentTextView];
    
    // 协议容器
    self.agreementContainer = [[UIView alloc] init];
    [self.view addSubview:self.agreementContainer];
    
    self.agreementCheckbox = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreementCheckbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141_unselect"] forState:UIControlStateNormal];
    [self.agreementCheckbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141"] forState:UIControlStateSelected];
    [self.agreementCheckbox addTarget:self action:@selector(agreementCheckboxTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.agreementContainer addSubview:self.agreementCheckbox];
    
    // 创建协议文本容器
    self.agreementTextContainer = [[UIView alloc] init];
    [self.agreementContainer addSubview:self.agreementTextContainer];
    
    // 创建"我已阅读并同意"文本
    UILabel *agreementPrefixLabel = [[UILabel alloc] init];
    agreementPrefixLabel.text = @"我已阅读并同意";
    agreementPrefixLabel.font = [UIFont systemFontOfSize:14];
    agreementPrefixLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.agreementTextContainer addSubview:agreementPrefixLabel];
    
    // 个人征信查询授权书按钮
    UIButton *authorizationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [authorizationButton setTitle:@" 《个人征信查询授权书》" forState:UIControlStateNormal];
    [authorizationButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    authorizationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [authorizationButton addTarget:self action:@selector(authorizationAgreementTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.agreementTextContainer addSubview:authorizationButton];
    
    // 设置协议文本容器内部约束
    [agreementPrefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.agreementTextContainer);
        make.height.mas_equalTo(20);
    }];
    
    [authorizationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreementPrefixLabel.mas_right).offset(0);
        make.centerY.equalTo(self.agreementTextContainer);
        make.height.mas_equalTo(20);
        make.right.lessThanOrEqualTo(self.agreementTextContainer);
    }];
    
    // 同意按钮
    self.agreeButton = [[JJRButton alloc] initWithTitle:@"同意并继续" type:JJRButtonTypePrimary];
    [self.agreeButton setCornerRadius:23];
    WeakSelf
    [self.agreeButton setClickAction:^(JJRButton *button) {
        StrongSelf
        [strongSelf agreeButtonTapped];
    }];
    [self.view addSubview:self.agreeButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
        make.height.mas_equalTo(400);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [self.agreementContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view).inset(20);
        make.height.mas_equalTo(30);
    }];
    
    [self.agreementCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.agreementContainer);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.agreementTextContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreementCheckbox.mas_right).offset(10);
        make.right.centerY.equalTo(self.agreementContainer);
        make.height.mas_equalTo(20);
    }];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreementContainer.mas_bottom).offset(10);
        make.left.right.equalTo(self.view).inset(20);
        make.height.mas_equalTo(44);
    }];
}

- (void)agreementCheckboxTapped {
    self.agreementCheckbox.selected = !self.agreementCheckbox.selected;
}

- (void)authorizationAgreementTapped {
    NSLog(@"🎯 个人征信查询授权书被点击");
    [self handleAgreement:@"authorization" title:@"个人征信查询授权书"];
}

- (void)handleAgreement:(NSString *)type title:(NSString *)title {
    NSLog(@"🎯 打开协议页面: %@", title);
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.agreementType = type;
    webVC.title = title;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)agreeButtonTapped {
    if (!self.agreementCheckbox.selected) {
        [self showToast:@"请先同意授权书"];
        return;
    }
    
    // 跳转到申请表单页面
    JJRApplyFormViewController *formVC = [[JJRApplyFormViewController alloc] init];
    formVC.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
    [self.navigationController pushViewController:formVC animated:YES];
}

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
