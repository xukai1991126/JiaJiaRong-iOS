//
//  HomeMainCardView.m
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "HomeMainCardView.h"

@interface HomeMainCardView ()

@property (nonatomic, strong) UIView *cardContainer;
@property (nonatomic, strong) UILabel *amountTitleLabel;
@property (nonatomic, strong) UILabel *amountValueLabel;
@property (nonatomic, strong) UILabel *combinedInfoLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIView *protocolView;
@property (nonatomic, strong) UIButton *protocolCheckbox;
@property (nonatomic, strong) UIView *protocolTextView;

@end

@implementation HomeMainCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self updateCardContent]; // 初始化时更新内容
    }
    return self;
}

- (void)setupUI {
    // 卡片容器
    self.cardContainer = [[UIView alloc] init];
    self.cardContainer.backgroundColor = [UIColor whiteColor];
    self.cardContainer.layer.cornerRadius = 16;
    self.cardContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardContainer.layer.shadowOpacity = 0.1;
    self.cardContainer.layer.shadowRadius = 8;
    [self addSubview:self.cardContainer];
    
    // 金额标题
    self.amountTitleLabel = [[UILabel alloc] init];
    self.amountTitleLabel.text = @"最高可借担保度（元）";
    self.amountTitleLabel.font = FONT_REGULAR(14);
    self.amountTitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.amountTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardContainer addSubview:self.amountTitleLabel];
    
    // 金额数值
    self.amountValueLabel = [[UILabel alloc] init];
    self.amountValueLabel.font = FONT_BOLD(42);
    self.amountValueLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    self.amountValueLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardContainer addSubview:self.amountValueLabel];
    
    // 合并信息标签（利率+期限）
    self.combinedInfoLabel = [[UILabel alloc] init];
    self.combinedInfoLabel.text = @"年化利率7.24%起，最高可分36期"; // 设置初始文本
    self.combinedInfoLabel.font = FONT_REGULAR(14);
    self.combinedInfoLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.combinedInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardContainer addSubview:self.combinedInfoLabel];
    
    // 登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = FONT_BOLD(16);
    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.loginButton.layer.cornerRadius = 23;
    [self.loginButton addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.cardContainer addSubview:self.loginButton];
    
    // 协议区域
    self.protocolView = [[UIView alloc] init];
    [self.cardContainer addSubview:self.protocolView];
    
    // 协议复选框
    self.protocolCheckbox = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.protocolCheckbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141_unselect"] forState:UIControlStateNormal];
    [self.protocolCheckbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141"] forState:UIControlStateSelected];
    [self.protocolCheckbox addTarget:self action:@selector(protocolCheckboxTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.protocolView addSubview:self.protocolCheckbox];
    
    // 协议文本区域
    self.protocolTextView = [[UIView alloc] init];
    [self.protocolView addSubview:self.protocolTextView];
    
    // 协议文本
    UILabel *protocolPrefixLabel = [[UILabel alloc] init];
    protocolPrefixLabel.text = @"本人已阅读并同意";
    protocolPrefixLabel.font = FONT_REGULAR(12);
    protocolPrefixLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.protocolTextView addSubview:protocolPrefixLabel];
    
    UIButton *privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [privacyButton setTitle:@" 《隐私协议》" forState:UIControlStateNormal];
    [privacyButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    privacyButton.titleLabel.font = FONT_REGULAR(12);
    [privacyButton addTarget:self action:@selector(privacyAgreementTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.protocolTextView addSubview:privacyButton];
    
    // 设置约束
    [self.cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).inset(20);
    }];
    
    [self.amountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardContainer).offset(40);
        make.centerX.equalTo(self.cardContainer);
        make.height.equalTo(@14);
    }];
    
    [self.amountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountTitleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.cardContainer);
        make.height.equalTo(@42);
    }];
    
    [self.combinedInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountValueLabel.mas_bottom).offset(12);
        make.centerX.equalTo(self.cardContainer);
        make.height.equalTo(@14);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.combinedInfoLabel.mas_bottom).offset(14);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.height.mas_equalTo(46);
    }];
    
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(14);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.bottom.equalTo(self.cardContainer).offset(-10);
        make.height.mas_equalTo(24);
    }];
    
    [self.protocolCheckbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.protocolView);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.protocolTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.protocolCheckbox.mas_right).offset(8);
        make.right.centerY.equalTo(self.protocolView);
        make.height.equalTo(self.protocolView); // 保证高度一致
    }];
    
    [protocolPrefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.protocolTextView);
    }];
    
    [privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(protocolPrefixLabel.mas_right);
        make.centerY.equalTo(self.protocolTextView);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@60); // 增加最小宽度，保证可点
    }];
}

- (void)updateCardContent {
    self.amountValueLabel.text = self.maxAmount ?: @"200,000.00";
    
    // 合并利率和期限信息
    NSString *rateText = self.rateInfo ?: @"年化利率7.24%起";
    NSString *periodText = self.maxPeriod ?: @"最高可分36期";
    self.combinedInfoLabel.text = [NSString stringWithFormat:@"%@，%@", rateText, periodText];
    
    [self.loginButton setTitle:self.loginButtonTitle ?: @"本机号码一键登录" forState:UIControlStateNormal];
    
    self.protocolView.hidden = !self.showProtocolCheckbox;
    self.protocolCheckbox.selected = self.protocolChecked;
    
    // 更新约束以适应协议区域的显示/隐藏
    if (self.showProtocolCheckbox) {
        [self.protocolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(24);
        }];
    } else {
        [self.protocolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

#pragma mark - Actions

- (void)loginButtonTapped {
    if ([self.delegate respondsToSelector:@selector(mainCardViewDidTapLoginButton)]) {
        [self.delegate mainCardViewDidTapLoginButton];
    }
}

- (void)protocolCheckboxTapped {
    self.protocolChecked = !self.protocolChecked;
    self.protocolCheckbox.selected = self.protocolChecked;
    
    if ([self.delegate respondsToSelector:@selector(mainCardViewDidToggleProtocol:)]) {
        [self.delegate mainCardViewDidToggleProtocol:self.protocolChecked];
    }
}

- (void)privacyAgreementTapped {
    if ([self.delegate respondsToSelector:@selector(mainCardViewDidTapPrivacyAgreement)]) {
        [self.delegate mainCardViewDidTapPrivacyAgreement];
    }
}

@end 
