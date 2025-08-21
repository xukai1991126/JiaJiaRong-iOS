//
//  JJRAIAdviceCardView.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRAIAdviceCardView.h"
#import "JJRAILoanAdvice.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface JJRAIAdviceCardView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *recommendedBadge;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *termLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *monthlyPaymentLabel;
@property (nonatomic, strong) UILabel *confidenceLabel;
@property (nonatomic, strong) UIView *advantagesContainer;
@property (nonatomic, strong) UIButton *detailsButton;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation JJRAIAdviceCardView

- (instancetype)initWithAdvice:(JJRAILoanAdvice *)advice {
    if (self = [super initWithFrame:CGRectZero]) {
        NSLog(@"🛠️ 初始化JJRAIAdviceCardView，金额：%@", advice.recommendedAmount);
        self.advice = advice;
        [self setupUI];
        [self updateContent];
        NSLog(@"✅ JJRAIAdviceCardView初始化完成");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSLog(@"🎨 设置JJRAIAdviceCardView UI");
    self.backgroundColor = [UIColor clearColor];
    
    // 容器视图
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 16;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 4);
    self.containerView.layer.shadowOpacity = 0.15;
    self.containerView.layer.shadowRadius = 12;
    [self addSubview:self.containerView];
    
    // 推荐标签
    self.recommendedBadge = [[UILabel alloc] init];
    self.recommendedBadge.text = @"🏆 AI推荐";
    self.recommendedBadge.font = [UIFont boldSystemFontOfSize:12];
    self.recommendedBadge.textColor = [UIColor whiteColor];
    self.recommendedBadge.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.recommendedBadge.textAlignment = NSTextAlignmentCenter;
    self.recommendedBadge.layer.cornerRadius = 12;
    self.recommendedBadge.clipsToBounds = YES;
    self.recommendedBadge.hidden = YES;
    [self.containerView addSubview:self.recommendedBadge];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    [self.containerView addSubview:self.titleLabel];
    
    // 金额
    self.amountLabel = [[UILabel alloc] init];
    self.amountLabel.font = [UIFont boldSystemFontOfSize:26];
    self.amountLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    self.amountLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.amountLabel];
    
    // 期限
    self.termLabel = [[UILabel alloc] init];
    self.termLabel.font = [UIFont systemFontOfSize:14];
    self.termLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.termLabel.textAlignment = NSTextAlignmentLeft;
    [self.containerView addSubview:self.termLabel];
    
    // 利率
    self.rateLabel = [[UILabel alloc] init];
    self.rateLabel.font = [UIFont systemFontOfSize:14];
    self.rateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.rateLabel.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.rateLabel];
    
    // 月还款
    self.monthlyPaymentLabel = [[UILabel alloc] init];
    self.monthlyPaymentLabel.font = [UIFont boldSystemFontOfSize:18];
    self.monthlyPaymentLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    self.monthlyPaymentLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.monthlyPaymentLabel];
    
    // 可信度
    self.confidenceLabel = [[UILabel alloc] init];
    self.confidenceLabel.font = [UIFont systemFontOfSize:12];
    self.confidenceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.confidenceLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.confidenceLabel];
    
    // 优势容器
    self.advantagesContainer = [[UIView alloc] init];
    [self.containerView addSubview:self.advantagesContainer];
    
    // 详情按钮
    self.detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.detailsButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.detailsButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    self.detailsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.detailsButton.layer.borderColor = [UIColor colorWithHexString:@"#FF772C"].CGColor;
    self.detailsButton.layer.borderWidth = 1.0;
    self.detailsButton.layer.cornerRadius = 20;
    [self.detailsButton addTarget:self action:@selector(detailsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.detailsButton];
    
    // 选择按钮
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setTitle:@"选择此方案" forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.selectButton.layer.cornerRadius = 20;
    [self.selectButton addTarget:self action:@selector(selectButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.selectButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).inset(6);
    }];
    
    // 第一行：标题 + 推荐标签
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-100);
    }];
    
    [self.recommendedBadge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.containerView).offset(-16);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(24);
    }];
    
    // 第二行：金额（突出显示）
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.lessThanOrEqualTo(self.containerView).offset(-16);
    }];
    
    // 第三行：期限 + 利率（左右分布）
    [self.termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountLabel.mas_bottom).offset(12);
        make.left.equalTo(self.containerView).offset(16);
        make.width.lessThanOrEqualTo(@120);
    }];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termLabel);
        make.right.equalTo(self.containerView).offset(-16);
        make.left.greaterThanOrEqualTo(self.termLabel.mas_right).offset(16);
    }];
    
    // 第四行：月还款（居中突出）
    [self.monthlyPaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.termLabel.mas_bottom).offset(12);
        make.centerX.equalTo(self.containerView);
    }];
    
    // 第五行：可信度
    [self.confidenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthlyPaymentLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self.containerView);
    }];
    
    // 第六行：优势（简化显示）
    [self.advantagesContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confidenceLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self.containerView).inset(16);
        make.height.mas_equalTo(30);
    }];
    
    // 第七行：按钮
    [self.detailsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.advantagesContainer.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(36);
        make.bottom.equalTo(self.containerView).offset(-16);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailsButton);
        make.right.equalTo(self.containerView).offset(-16);
        make.left.equalTo(self.detailsButton.mas_right).offset(12);
        make.height.mas_equalTo(36);
    }];
}

- (void)updateContent {
    if (!self.advice) return;
    
    // 更新标题
    NSString *typeTitle = [self titleForLoanType:self.advice.loanType];
    self.titleLabel.text = typeTitle;
    
    // 更新金额
    self.amountLabel.text = [NSString stringWithFormat:@"¥%.0f", [self.advice.recommendedAmount doubleValue]];
    
    // 更新期限
    self.termLabel.text = [NSString stringWithFormat:@"期限: %ld个月", (long)self.advice.recommendedTerm];
    
    // 更新利率
    self.rateLabel.text = [NSString stringWithFormat:@"利率: %.2f%%", [self.advice.interestRate doubleValue]];
    
    // 更新月还款
    self.monthlyPaymentLabel.text = [NSString stringWithFormat:@"月还款: ¥%.0f", [self.advice.monthlyPayment doubleValue]];
    
    // 更新可信度
    self.confidenceLabel.text = [NSString stringWithFormat:@"匹配度 %.0f%%", self.advice.confidence * 100];
    
    // 更新推荐标签和背景
    self.recommendedBadge.hidden = !self.isRecommended;
    
    if (self.isRecommended) {
        self.containerView.backgroundColor = [UIColor colorWithHexString:@"#FFF8F4"]; // 浅橙色背景
        self.containerView.layer.borderColor = [UIColor colorWithHexString:@"#FF772C"].CGColor;
        self.containerView.layer.borderWidth = 2.0;
    } else {
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.containerView.layer.borderWidth = 0.0;
    }
    
    // 更新优势
    [self updateAdvantages];
}

- (void)updateAdvantages {
    // 清除现有视图
    for (UIView *subview in self.advantagesContainer.subviews) {
        [subview removeFromSuperview];
    }
    
    if (self.advice.advantages.count == 0) return;
    
    // 只显示第一个最重要的优势
    NSString *mainAdvantage = self.advice.advantages.firstObject;
    
    UILabel *advantageLabel = [[UILabel alloc] init];
    advantageLabel.text = [NSString stringWithFormat:@"✓ %@", mainAdvantage];
    advantageLabel.font = [UIFont systemFontOfSize:13];
    advantageLabel.textColor = [UIColor colorWithHexString:@"#00C851"];
    advantageLabel.textAlignment = NSTextAlignmentCenter;
    advantageLabel.numberOfLines = 1;
    [self.advantagesContainer addSubview:advantageLabel];
    
    [advantageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.advantagesContainer);
        make.left.right.lessThanOrEqualTo(self.advantagesContainer);
    }];
}

- (NSString *)titleForLoanType:(JJRAILoanType)loanType {
    switch (loanType) {
        case JJRAILoanTypePersonal:
            return @"💳 个人消费贷款";
        case JJRAILoanTypeMortgage:
            return @"🏠 房屋抵押贷款";
        case JJRAILoanTypeBusiness:
            return @"💼 经营贷款";
        case JJRAILoanTypeCredit:
            return @"⭐ 信用贷款";
        case JJRAILoanTypeInstallment:
            return @"📄 分期贷款";
        default:
            return @"💰 贷款方案";
    }
}

#pragma mark - Public Methods

- (void)updateWithAdvice:(JJRAILoanAdvice *)advice {
    self.advice = advice;
    [self updateContent];
}

- (void)setIsRecommended:(BOOL)isRecommended {
    _isRecommended = isRecommended;
    self.recommendedBadge.hidden = !isRecommended;
    
    if (isRecommended) {
        self.containerView.layer.borderWidth = 2.0;
        self.containerView.layer.borderColor = [UIColor colorWithHexString:@"#FF772C"].CGColor;
    } else {
        self.containerView.layer.borderWidth = 0.0;
    }
}

#pragma mark - Actions

- (void)detailsButtonTapped {
    if ([self.delegate respondsToSelector:@selector(adviceCardView:didRequestDetailsForAdvice:)]) {
        [self.delegate adviceCardView:self didRequestDetailsForAdvice:self.advice];
    }
}

- (void)selectButtonTapped {
    if ([self.delegate respondsToSelector:@selector(adviceCardView:didSelectAdvice:)]) {
        [self.delegate adviceCardView:self didSelectAdvice:self.advice];
    }
}

@end 
