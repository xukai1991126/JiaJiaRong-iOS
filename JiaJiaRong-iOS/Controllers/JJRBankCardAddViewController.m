//
//  JJRBankCardAddViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBankCardAddViewController.h"
#import "JJRNetworkService.h"
#import "WebViewController.h"
#import <YYKit/YYKit.h>
#import "ZJGeneraMacros.h"

@interface JJRBankCardAddViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 注意提示框
@property (nonatomic, strong) UIView *attentionView;
@property (nonatomic, strong) UILabel *attentionLabel;

// 标题区域
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

// 表单区域
@property (nonatomic, strong) UIView *formView;
@property (nonatomic, strong) UIView *bankNoFormItem;
@property (nonatomic, strong) UILabel *bankNoLabel;
@property (nonatomic, strong) UITextField *bankNoTextField;
@property (nonatomic, strong) UIView *mobileFormItem;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UITextField *mobileTextField;

// 底部区域
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIButton *checkboxButton;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *submitButton;

// 数据
@property (nonatomic, assign) BOOL checked;

@end

@implementation JJRBankCardAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.title = @"新增银行卡";
    self.view.backgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1.0]; // #f7f7f7
}

- (void)setupUI {
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 注意提示框
    self.attentionView = [[UIView alloc] init];
    self.attentionView.backgroundColor = [UIColor colorWithRed:0.996 green:0.957 blue:0.918 alpha:1.0]; // #fef4ea
    [self.contentView addSubview:self.attentionView];
    
    self.attentionLabel = [[UILabel alloc] init];
    self.attentionLabel.text = @"当前填写的手机号需与银行预留手机号保持一致，否则会导致申请失败，如绑卡失败，请绑定新的银行卡";
    self.attentionLabel.textColor = [UIColor colorWithRed:0.89 green:0.584 blue:0.329 alpha:1.0]; // #e39554
    self.attentionLabel.font = [UIFont systemFontOfSize:12]; // 24rpx -> 12pt
    self.attentionLabel.numberOfLines = 0;
    [self.attentionView addSubview:self.attentionLabel];
    
    // 标题区域
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"添加银行卡";
    self.titleLabel.font = [UIFont systemFontOfSize:16]; // 32rpx -> 16pt
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = @"该银行卡号用于放款和后续还款，不支持信用卡";
    self.subtitleLabel.font = [UIFont systemFontOfSize:12]; // 24rpx -> 12pt
    self.subtitleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]; // #666
    self.subtitleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.subtitleLabel];
    
    // 表单区域
    self.formView = [[UIView alloc] init];
    self.formView.backgroundColor = [UIColor whiteColor];
    self.formView.layer.cornerRadius = 10; // 20rpx -> 10pt
    [self.contentView addSubview:self.formView];
    
    // 银行卡号表单项
    self.bankNoFormItem = [[UIView alloc] init];
    [self.formView addSubview:self.bankNoFormItem];
    
    self.bankNoLabel = [[UILabel alloc] init];
    self.bankNoLabel.text = @"银行卡号";
    self.bankNoLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    self.bankNoLabel.textColor = [UIColor blackColor];
    [self.bankNoFormItem addSubview:self.bankNoLabel];
    
    self.bankNoTextField = [[UITextField alloc] init];
    self.bankNoTextField.placeholder = @"请输入借记卡/储蓄卡号";
    self.bankNoTextField.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    self.bankNoTextField.textAlignment = NSTextAlignmentRight;
    self.bankNoTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.bankNoTextField.borderStyle = UITextBorderStyleNone;
    [self.bankNoFormItem addSubview:self.bankNoTextField];
    
    // 分隔线
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1.0]; // #ececec
    [self.formView addSubview:separatorLine];
    
    // 预留手机号表单项
    self.mobileFormItem = [[UIView alloc] init];
    [self.formView addSubview:self.mobileFormItem];
    
    self.mobileLabel = [[UILabel alloc] init];
    self.mobileLabel.text = @"预留手机号";
    self.mobileLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    self.mobileLabel.textColor = [UIColor blackColor];
    [self.mobileFormItem addSubview:self.mobileLabel];
    
    self.mobileTextField = [[UITextField alloc] init];
    self.mobileTextField.placeholder = @"请输入银行卡预留手机号";
    self.mobileTextField.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    self.mobileTextField.textAlignment = NSTextAlignmentRight;
    self.mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTextField.borderStyle = UITextBorderStyleNone;
    [self.mobileFormItem addSubview:self.mobileTextField];
    
    // 底部区域
    self.footerView = [[UIView alloc] init];
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerView];
    
    // 协议区域
    self.protocolView = [[UIView alloc] init];
    [self.footerView addSubview:self.protocolView];
    
    self.checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkboxButton setImage:[UIImage imageNamed:@"img_2a5bf1c39141_unselect"] forState:UIControlStateNormal];
    [self.checkboxButton setImage:[UIImage imageNamed:@"img_2a5bf1c39141"] forState:UIControlStateSelected];
    [self.checkboxButton addTarget:self action:@selector(handleProtocolCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.protocolView addSubview:self.checkboxButton];
    
    self.protocolLabel = [[UILabel alloc] init];
    self.protocolLabel.font = [UIFont systemFontOfSize:12]; // 24rpx -> 12pt
    self.protocolLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]; // #999999
    self.protocolLabel.numberOfLines = 0;
    [self.protocolView addSubview:self.protocolLabel];
    
    // 设置协议文本
    NSMutableAttributedString *protocolText = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意"];
    NSAttributedString *agreementText = [[NSAttributedString alloc] initWithString:@"《用户服务协议》" 
                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.231 green:0.31 blue:0.871 alpha:1.0]}]; // #3b4fde
    [protocolText appendAttributedString:agreementText];
    self.protocolLabel.attributedText = protocolText;
    
    // 添加协议点击手势
    UITapGestureRecognizer *protocolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAgreementTap)];
    self.protocolLabel.userInteractionEnabled = YES;
    [self.protocolLabel addGestureRecognizer:protocolTap];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"绑定银行卡" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    self.submitButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"]; // #3B4FDE
    self.submitButton.layer.cornerRadius = 25; // 圆形按钮，高度的一半
    [self.submitButton addTarget:self action:@selector(handleSubmitBankCard) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.submitButton];
    
    // 初始化数据
    self.checked = NO;
    
    // 设置表单项约束
    [self setupFormConstraints:separatorLine];
}

- (void)setupFormConstraints:(UIView *)separatorLine {
    // 银行卡号表单项约束
    [self.bankNoFormItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.formView);
        make.height.mas_equalTo(57.5); // 115rpx -> 57.5pt
    }];
    
    [self.bankNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankNoFormItem);
        make.left.equalTo(self.bankNoFormItem).offset(15); // 30rpx -> 15pt
        make.width.mas_equalTo(87.5); // 175rpx -> 87.5pt
    }];
    
    [self.bankNoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankNoFormItem);
        make.left.equalTo(self.bankNoLabel.mas_right);
        make.right.equalTo(self.bankNoFormItem).offset(-15); // 30rpx -> 15pt
    }];
    
    // 分隔线
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNoFormItem.mas_bottom);
        make.left.right.equalTo(self.formView);
        make.height.mas_equalTo(0.5); // 1rpx -> 0.5pt
    }];
    
    // 预留手机号表单项约束
    [self.mobileFormItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separatorLine.mas_bottom);
        make.left.right.equalTo(self.formView);
        make.bottom.equalTo(self.formView);
        make.height.mas_equalTo(57.5); // 115rpx -> 57.5pt
    }];
    
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mobileFormItem);
        make.left.equalTo(self.mobileFormItem).offset(15); // 30rpx -> 15pt
        make.width.mas_equalTo(87.5); // 175rpx -> 87.5pt
    }];
    
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mobileFormItem);
        make.left.equalTo(self.mobileLabel.mas_right);
        make.right.equalTo(self.mobileFormItem).offset(-15); // 30rpx -> 15pt
    }];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    [self.attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.attentionView).inset(15); // 30rpx -> 15pt
        make.left.right.equalTo(self.attentionView).inset(20); // 40rpx -> 20pt
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.attentionView.mas_bottom).offset(15); // 30rpx -> 15pt
        make.left.equalTo(self.contentView).offset(15); // 30rpx -> 15pt
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15); // 30rpx -> 15pt
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(15); // 30rpx -> 15pt
        make.left.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    // 底部区域约束
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(120+kBottomSafeAreaHeight); // 根据内容调整高度
    }];
    
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView).offset(15); // 30rpx -> 15pt
        make.centerX.equalTo(self.footerView);
        make.left.greaterThanOrEqualTo(self.footerView).offset(20);
        make.right.lessThanOrEqualTo(self.footerView).offset(-20);
    }];
    
    [self.checkboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.protocolView);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkboxButton);
        make.left.equalTo(self.checkboxButton.mas_right).offset(5);
        make.right.equalTo(self.protocolView);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.protocolView.mas_bottom).offset(13.5); // 27rpx -> 13.5pt
        make.centerX.equalTo(self.footerView);
        make.left.mas_equalTo(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(50); // 98rpx -> 49pt
        make.bottom.lessThanOrEqualTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
    }];
}

#pragma mark - Actions

- (void)handleProtocolCheck {
    self.checked = !self.checked;
    self.checkboxButton.selected = self.checked;
}

- (void)handleAgreementTap {
    // 跳转到协议页面
    NSLog(@"点击用户服务协议");
    [self showAgreementWithType:@"user" title:@"用户服务协议"];
}

- (void)handleSubmitBankCard {
    // 验证输入
    if (!self.bankNoTextField.text || self.bankNoTextField.text.length == 0) {
        [self showToast:@"请输入银行卡号"];
        return;
    }
    
    if (!self.mobileTextField.text || self.mobileTextField.text.length == 0) {
        [self showToast:@"请输入预留手机号"];
        return;
    }
    
    // 银行卡号格式验证（去掉空格后验证）
    NSString *cleanBankNo = [self.bankNoTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (cleanBankNo.length < 16 || cleanBankNo.length > 19) {
        [self showToast:@"请输入正确的银行卡号"];
        return;
    }
    
    // 手机号格式验证
    NSString *mobileRegex = @"^1[3-9]\\d{9}$";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    if (![mobilePredicate evaluateWithObject:self.mobileTextField.text]) {
        [self showToast:@"请输入正确预留手机号"];
        return;
    }
    
    if (!self.checked) {
        [self showToast:@"请同意用户服务协议"];
        return;
    }
    
    // 提交银行卡
    [self submitBankCard];
}

- (void)submitBankCard {
    // 去掉银行卡号中的空格
    NSString *cleanBankNo = [self.bankNoTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 加密手机号（这里需要实现和uni-app一样的加密逻辑）
    NSString *encryptedMobile = [self encryptMobile:self.mobileTextField.text];
    NSString *md5Mobile = [self encryptMobileMd5:self.mobileTextField.text];
    
    NSDictionary *params = @{
        @"bankNo": cleanBankNo,  // 使用去掉空格的银行卡号
        @"mobile": encryptedMobile,
        @"md5": md5Mobile
    };
    
    [[JJRNetworkService sharedInstance] POST:JJR_BANK_CARD_ADD params:params success:^(NSDictionary *responseObject) {
        // 正确处理API响应
        NSNumber *code = responseObject[@"code"];
        NSDictionary *err = responseObject[@"err"];
        
        if ([code intValue] == 0) {
            // 成功
            [self showToast:@"绑定成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 清空表单
                self.bankNoTextField.text = @"";
                self.mobileTextField.text = @"";
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            // 失败，显示服务器返回的错误信息
            NSString *errorMsg = err[@"msg"] ?: @"绑定失败，请重试";
            [self showToast:errorMsg];
        }
    } failure:^(NSError *error) {
        [self showToast:@"网络错误，请重试"];
    }];
}

#pragma mark - Helper Methods

- (NSString *)encryptMobile:(NSString *)mobile {
    // 这里应该使用和uni-app一样的加密方法
    // 暂时使用JJRNetworkService的加密方法
    return [JJRNetworkService encryptMobile:mobile];
}

- (NSString *)encryptMobileMd5:(NSString *)mobile {
    // 这里应该使用和uni-app一样的MD5加密方法
    return [JJRNetworkService encryptMobileMd5:mobile];
}

- (void)showToast:(NSString *)message {
    // 简单的Toast实现
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:toast animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)showAgreementWithType:(NSString *)type title:(NSString *)title {
    // 创建WebViewController来显示协议内容
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.agreementType = type;
    webVC.title = title;
    webVC.hidesBottomBarWhenPushed = YES;
    
    // 推送到导航控制器
    [self.navigationController pushViewController:webVC animated:YES];
}

@end 
