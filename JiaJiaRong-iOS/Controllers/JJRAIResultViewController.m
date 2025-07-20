//
//  JJRAIResultViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAIResultViewController.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface JJRAIResultViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *resultCard;

@end

@implementation JJRAIResultViewController

- (instancetype)initWithLoanAdvice:(JJRAILoanAdvice *)advice {
    if (self = [super init]) {
        self.loanAdvice = advice;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"AI智能推荐";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    
    // 设置渐变背景
    [self setupGradientBackground];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.mas_greaterThanOrEqualTo(700); // 增加最小高度
    }];
    
    [self createResultCard];
}

- (void)setupGradientBackground {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#FF8C42"].CGColor,
        (id)[UIColor colorWithHexString:@"#FF6B35"].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 更新渐变背景的frame
    for (CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.view.bounds;
            break;
        }
    }
}

- (void)createResultCard {
    // 主卡片容器
    self.resultCard = [[UIView alloc] init];
    self.resultCard.backgroundColor = [UIColor whiteColor];
    self.resultCard.layer.cornerRadius = 20;
    self.resultCard.layer.shadowColor = [UIColor blackColor].CGColor;
    self.resultCard.layer.shadowOffset = CGSizeMake(0, 4);
    self.resultCard.layer.shadowOpacity = 0.15;
    self.resultCard.layer.shadowRadius = 12;
    [self.contentView addSubview:self.resultCard];
    
    // AI推荐标签
    UILabel *aiLabel = [[UILabel alloc] init];
    aiLabel.text = @"🎯 AI智能推荐方案";
    aiLabel.font = [UIFont boldSystemFontOfSize:24];
    aiLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    aiLabel.textAlignment = NSTextAlignmentCenter;
    [self.resultCard addSubview:aiLabel];
    
    // 贷款类型
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.text = [self titleForLoanType:self.loanAdvice.loanType];
    typeLabel.font = [UIFont boldSystemFontOfSize:18];
    typeLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.resultCard addSubview:typeLabel];
    
    // 贷款金额 - 大字显示
    UILabel *amountLabel = [[UILabel alloc] init];
    CGFloat amount = self.loanAdvice.recommendedAmount ? [self.loanAdvice.recommendedAmount doubleValue] : 50000.0;
    amountLabel.text = [NSString stringWithFormat:@"¥%.0f", amount];
    amountLabel.font = [UIFont boldSystemFontOfSize:48];
    amountLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [self.resultCard addSubview:amountLabel];
    
    // 信息列表容器
    UIView *infoContainer = [[UIView alloc] init];
    infoContainer.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    infoContainer.layer.cornerRadius = 12;
    [self.resultCard addSubview:infoContainer];
    
    // 期限信息
    UIView *termRow = [self createInfoRowWithTitle:@"贷款期限" 
                                             value:[NSString stringWithFormat:@"%ld个月", (long)self.loanAdvice.recommendedTerm]];
    [infoContainer addSubview:termRow];
    
    // 利率信息  
    UIView *rateRow = [self createInfoRowWithTitle:@"年化利率" 
                                             value:[NSString stringWithFormat:@"%.2f%%", [self.loanAdvice.interestRate doubleValue]]];
    [infoContainer addSubview:rateRow];
    
    // 月还款信息
    UIView *monthlyRow = [self createInfoRowWithTitle:@"月还金额" 
                                                value:[NSString stringWithFormat:@"¥%.0f", [self.loanAdvice.monthlyPayment doubleValue]]];
    [infoContainer addSubview:monthlyRow];
    
    // 匹配度信息
    UIView *confidenceRow = [self createInfoRowWithTitle:@"方案匹配度" 
                                                   value:[NSString stringWithFormat:@"%.0f%%", self.loanAdvice.confidence * 100]];
    [infoContainer addSubview:confidenceRow];
    
    // 申请按钮
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyButton setTitle:@"立即申请此方案" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    applyButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    applyButton.layer.cornerRadius = 28;
    [applyButton addTarget:self action:@selector(applyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.resultCard addSubview:applyButton];
    
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"重新分析" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    backButton.layer.borderColor = [UIColor colorWithHexString:@"#FF772C"].CGColor;
    backButton.layer.borderWidth = 1.5;
    backButton.layer.cornerRadius = 25;
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.resultCard addSubview:backButton];
    
    // 设置约束
    [self.resultCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(100); // 增加顶部间距避免导航栏
        make.left.right.equalTo(self.contentView).inset(20);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-40);
    }];
    
    [aiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultCard).offset(30);
        make.left.right.equalTo(self.resultCard).inset(20);
    }];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aiLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self.resultCard).inset(20);
    }];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self.resultCard).inset(20);
    }];
    
    [infoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self.resultCard).inset(20);
    }];
    
    // 信息行约束
    UIView *lastRow = nil;
    NSArray *rows = @[termRow, rateRow, monthlyRow, confidenceRow];
    for (UIView *row in rows) {
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(infoContainer).inset(16);
            make.height.mas_equalTo(50);
            if (lastRow) {
                make.top.equalTo(lastRow.mas_bottom);
            } else {
                make.top.equalTo(infoContainer).offset(16);
            }
            if (row == rows.lastObject) {
                make.bottom.equalTo(infoContainer).offset(-16);
            }
        }];
        lastRow = row;
    }
    
    [applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoContainer.mas_bottom).offset(30);
        make.left.right.equalTo(self.resultCard).inset(20);
        make.height.mas_equalTo(56);
    }];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyButton.mas_bottom).offset(16);
        make.left.right.equalTo(self.resultCard).inset(20);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.resultCard).offset(-30);
    }];
}

- (UIView *)createInfoRowWithTitle:(NSString *)title value:(NSString *)value {
    UIView *rowView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [rowView addSubview:titleLabel];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = value;
    valueLabel.font = [UIFont boldSystemFontOfSize:16];
    valueLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    valueLabel.textAlignment = NSTextAlignmentRight;
    [rowView addSubview:valueLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(rowView);
        make.width.lessThanOrEqualTo(@150);
    }];
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(rowView);
        make.left.greaterThanOrEqualTo(titleLabel.mas_right).offset(8);
    }];
    
    return rowView;
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
            return @"💰 优质贷款";
    }
}

#pragma mark - Actions

- (void)applyButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请确认" 
                                                                   message:@"确定要申请此贷款方案吗？我们将为您安排专属客服联系。" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmApplication];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)confirmApplication {
    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"申请成功" 
                                                                          message:@"您的贷款申请已提交，专属客服将在24小时内联系您！" 
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [successAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:successAlert animated:YES completion:nil];
}

- (void)backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@end 