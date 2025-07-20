//
//  JJRAILoanAdvisorViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAILoanAdvisorViewController.h"
#import "JJRAILoanAdvisorViewModel.h"
#import "JJRAILoanAdvice.h"
#import "JJRAIQuickInputView.h"
#import "JJRAIAnalysisProgressView.h"
#import "JJRAIResultViewController.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSInteger, JJRAIAdvisorState) {
    JJRAIAdvisorStateInput = 0,     // 输入用户信息
    JJRAIAdvisorStateAnalyzing      // AI分析中
    // JJRAIAdvisorStateResults     // 不再需要，直接跳转页面
};

@interface JJRAILoanAdvisorViewController () <JJRAIQuickInputViewDelegate>

@property (nonatomic, strong) JJRAILoanAdvisorViewModel *viewModel;
@property (nonatomic, assign) JJRAIAdvisorState currentState;

// UI组件
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 输入阶段
@property (nonatomic, strong) JJRAIQuickInputView *quickInputView;
@property (nonatomic, strong) UIButton *analyzeButton;

// 分析阶段
@property (nonatomic, strong) JJRAIAnalysisProgressView *progressView;

// 结果阶段 - 现在直接跳转到新页面，不需要这些属性了
// @property (nonatomic, strong) UIView *resultsContainer;
// @property (nonatomic, strong) UILabel *resultsTitle;
// @property (nonatomic, strong) UIButton *restartButton;

@end

@implementation JJRAILoanAdvisorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];
    [self setupUI];
    [self setupObservers];
    [self setState:JJRAIAdvisorStateInput];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"贷款顾问";
    
    NSLog(@"🔄 viewWillAppear - 当前状态：%ld", (long)self.currentState);
    
    // 只有在非输入状态时才重置（说明从其他页面返回）
    if (self.currentState != JJRAIAdvisorStateInput) {
        NSLog(@"🔄 从其他状态返回，重置为输入状态并清空选择");
        [self setState:JJRAIAdvisorStateInput];
        
        // 确保所有UI组件都正确显示
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } else {
        NSLog(@"🔄 已经是输入状态，无需重置");
    }
    
    NSLog(@"✅ viewWillAppear 完成");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupViewModel {
    self.viewModel = [[JJRAILoanAdvisorViewModel alloc] init];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    
    // 设置渐变背景
    [self setupGradientBackground];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
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
    }];
    
    // 简化的用户输入视图
    [self setupQuickInputView];
    
    // 分析进度视图
    [self setupProgressView];
    
    // 结果视图 - 不再需要，直接跳转到新页面
    // [self setupResultsView];
}

- (void)setupGradientBackground {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = [UIScreen mainScreen].bounds;
    gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#F2582B"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1" alpha:0.0].CGColor
    ];
    gradientLayer.locations = @[@0.0, @0.4, @1.0];
    
    UIView *backgroundView = [[UIView alloc] init];
    [backgroundView.layer addSublayer:gradientLayer];
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupQuickInputView {
    // 简化的提示标签
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"选择您的基本情况，获取专属贷款建议";
    hintLabel.font = [UIFont systemFontOfSize:16];
    hintLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:hintLabel];
    
    self.quickInputView = [[JJRAIQuickInputView alloc] init];
    self.quickInputView.delegate = self;
    self.quickInputView.hidden = NO;  // 默认显示
    [self.contentView addSubview:self.quickInputView];
    
    // 分析按钮
    self.analyzeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.analyzeButton setTitle:@"开始AI智能分析" forState:UIControlStateNormal];
    [self.analyzeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.analyzeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.analyzeButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.analyzeButton.layer.cornerRadius = 25;
    self.analyzeButton.hidden = NO;  // 默认显示
    self.analyzeButton.alpha = 0.6;
    self.analyzeButton.enabled = NO;
    
    [self.analyzeButton addTarget:self action:@selector(analyzeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.analyzeButton];
    
    // 设置约束
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(100); // 增加顶部间距避免与导航栏重叠
        make.left.right.equalTo(self.contentView).inset(20);
    }];
    
    [self.quickInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(16);
        make.height.mas_equalTo(400); // 设置固定高度
    }];
    
    [self.analyzeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quickInputView.mas_bottom).offset(24);
        make.left.right.equalTo(self.contentView).inset(32);
        make.height.mas_equalTo(50);
    }];
}



- (void)setupProgressView {
    self.progressView = [[JJRAIAnalysisProgressView alloc] init];
    self.progressView.hidden = YES;
    [self.contentView addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(150);
        make.left.right.equalTo(self.contentView).inset(32);
        make.height.mas_equalTo(320); // 增加高度以容纳所有内容
    }];
}

/*
// 废弃的方法 - 现在直接跳转到新页面，不再需要在当前页面显示结果
- (void)setupResultsView {
    // 已废弃，现在使用 JJRAIResultViewController
}
*/

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewModelDidUpdateAdvices:)
                                                 name:@"JJRAILoanAdvisorViewModel_AdvicesUpdated"
                                               object:self.viewModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(analysisCompleted:)
                                                 name:@"JJRAIAnalysisCompleted"
                                               object:nil];
}

#pragma mark - State Management

- (void)setState:(JJRAIAdvisorState)state {
    self.currentState = state;
    
    // 隐藏所有视图
    self.quickInputView.hidden = YES;
    self.analyzeButton.hidden = YES;
    self.progressView.hidden = YES;
    
    // 根据状态显示相应视图
    switch (state) {
        case JJRAIAdvisorStateInput:
            [self showInputState];
            break;
        case JJRAIAdvisorStateAnalyzing:
            [self showAnalyzingState];
            break;
    }
    
    [self updateContentViewConstraints];
}

- (void)showInputState {
    NSLog(@"📱 显示输入状态");
    
    // 确保输入视图显示
    self.quickInputView.hidden = NO;
    self.analyzeButton.hidden = NO;
    
    // 🔧 重置选择框到初始状态
    [self.quickInputView resetToDefault];
    
    // 更新按钮状态
    self.analyzeButton.enabled = [self.quickInputView hasValidSelection];
    
    // 停止进度动画（如果正在运行）
    [self.progressView stopAnimation];
    
    // 🔧 简化布局更新
    [self updateContentViewConstraints];
    
    NSLog(@"✅ 输入状态显示完成：quickInputView.hidden=%@, analyzeButton.hidden=%@, analyzeButton.enabled=%@", 
          @(self.quickInputView.hidden), @(self.analyzeButton.hidden), @(self.analyzeButton.enabled));
}

- (void)showAnalyzingState {
    NSLog(@"🔄 切换到分析状态");
    
    // 确保进度视图显示
    self.progressView.hidden = NO;
    
    // 启动动画
    [self.progressView startAnimation];
    
    NSLog(@"✅ 进度视图已显示并开始动画");
}

- (void)showResultsState {
    // 这个方法现在不需要了，因为我们直接跳转到新页面
    NSLog(@"🎯 原来的结果状态方法（已废弃）");
}

- (void)updateContentViewConstraints {
    UIView *lastView = nil;
    
    switch (self.currentState) {
        case JJRAIAdvisorStateInput:
            lastView = self.analyzeButton;
            break;
        case JJRAIAdvisorStateAnalyzing:
            lastView = self.progressView;
            break;
    }
    
    if (lastView) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastView.mas_bottom).offset(40);
        }];
    }
}

#pragma mark - Navigation

- (void)showResultPage {
    if (self.viewModel.loanAdvices.count == 0) {
        NSLog(@"⚠️ 没有数据可以显示");
        return;
    }
    
    // 获取最佳建议
    JJRAILoanAdvice *bestAdvice = self.viewModel.loanAdvices.firstObject;
    
    // 🔧 重要：跳转前重置为输入状态，确保返回时页面正常显示
    [self setState:JJRAIAdvisorStateInput];
    NSLog(@"✅ 已重置为输入状态，准备跳转");
    
    // 创建结果页面
    JJRAIResultViewController *resultVC = [[JJRAIResultViewController alloc] initWithLoanAdvice:bestAdvice];
    
    // 跳转到结果页面
    [self.navigationController pushViewController:resultVC animated:YES];
    
    NSLog(@"🚀 已跳转到结果页面");
}

/*
#pragma mark - Display Results (已废弃)

// 以下所有方法都已废弃，现在使用 JJRAIResultViewController

- (UIView *)createSimpleResultCardWithAdvice:(JJRAILoanAdvice *)advice {
    NSLog(@"🎨 创建简单结果卡片");
    
    // 主容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 16;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 8;
    
    // AI推荐标签
    UILabel *recommendLabel = [[UILabel alloc] init];
    recommendLabel.text = @"🏆 AI智能推荐";
    recommendLabel.font = [UIFont boldSystemFontOfSize:12];
    recommendLabel.textColor = [UIColor whiteColor];
    recommendLabel.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    recommendLabel.textAlignment = NSTextAlignmentCenter;
    recommendLabel.layer.cornerRadius = 10;
    recommendLabel.clipsToBounds = YES;
    [cardView addSubview:recommendLabel];
    
    // 贷款类型标题
    UILabel *titleLabel = [[UILabel alloc] init];
    NSString *loanTitle = [self titleForLoanType:advice.loanType];
    titleLabel.text = loanTitle ?: @"💰 优质贷款"; // 防止nil
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    NSLog(@"🏷️ 设置标题: %@", titleLabel.text);
    [cardView addSubview:titleLabel];
    
    // 贷款金额
    UILabel *amountLabel = [[UILabel alloc] init];
    CGFloat amount = advice.recommendedAmount ? [advice.recommendedAmount doubleValue] : 50000.0;
    amountLabel.text = [NSString stringWithFormat:@"¥%.0f", amount];
    amountLabel.font = [UIFont boldSystemFontOfSize:28];
    amountLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    NSLog(@"💰 设置金额: %@", amountLabel.text);
    [cardView addSubview:amountLabel];
    
    // 期限信息
    UILabel *termLabel = [[UILabel alloc] init];
    termLabel.text = [NSString stringWithFormat:@"期限：%ld个月", (long)advice.recommendedTerm];
    termLabel.font = [UIFont systemFontOfSize:14];
    termLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    termLabel.textAlignment = NSTextAlignmentLeft;
    [cardView addSubview:termLabel];
    
    // 利率信息
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.text = [NSString stringWithFormat:@"利率：%.2f%%", [advice.interestRate doubleValue]];
    rateLabel.font = [UIFont systemFontOfSize:14];
    rateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    rateLabel.textAlignment = NSTextAlignmentRight;
    [cardView addSubview:rateLabel];
    
    // 月还款
    UILabel *monthlyLabel = [[UILabel alloc] init];
    monthlyLabel.text = [NSString stringWithFormat:@"月还款：¥%.0f", [advice.monthlyPayment doubleValue]];
    monthlyLabel.font = [UIFont boldSystemFontOfSize:16];
    monthlyLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    monthlyLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:monthlyLabel];
    
    // 选择按钮
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setTitle:@"选择此方案" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    selectButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    selectButton.layer.cornerRadius = 25;
    [selectButton addTarget:self action:@selector(selectAdviceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:selectButton];
    
    // 设置约束 - 使用更清晰的垂直布局
    [recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(16);
        make.right.equalTo(cardView).offset(-16);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(20);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(16);
        make.left.equalTo(cardView).offset(16);
        make.right.equalTo(recommendLabel.mas_left).offset(-12);
    }];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.centerX.equalTo(cardView);
    }];
    
    [termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(20);
        make.left.equalTo(cardView).offset(20);
        make.width.mas_equalTo(120);
    }];
    
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(20);
        make.right.equalTo(cardView).offset(-20);
        make.width.mas_equalTo(120);
    }];
    
    [monthlyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(termLabel.mas_bottom).offset(16);
        make.centerX.equalTo(cardView);
    }];
    
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthlyLabel.mas_bottom).offset(20);
        make.left.right.equalTo(cardView).inset(20);
        make.height.mas_equalTo(44);
        make.bottom.lessThanOrEqualTo(cardView).offset(-16);
    }];
    
    NSLog(@"✅ 简单结果卡片创建完成");
    return cardView;
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

- (void)selectAdviceButtonTapped:(UIButton *)sender {
    NSLog(@"✅ 用户选择了贷款方案");
    [self showAlert:@"成功" message:@"您已选择此贷款方案，我们将为您安排专属客服联系！"];
}

- (void)displayAdviceCards {
    NSLog(@"🔍 开始显示简单的建议结果");
    
    // 清除现有内容
    for (UIView *subview in self.resultsContainer.subviews) {
        if (subview != self.resultsTitle && subview != self.restartButton) {
            [subview removeFromSuperview];
        }
    }
    
    NSArray *advices = self.viewModel.loanAdvices;
    NSLog(@"📊 建议数量: %lu", (unsigned long)advices.count);
    
    if (advices.count == 0) {
        NSLog(@"⚠️ 没有建议数据！");
        return;
    }
    
    // 使用第一个最佳建议
    JJRAILoanAdvice *bestAdvice = advices.firstObject;
    NSLog(@"📋 显示建议：类型=%ld, 金额=%@, 期限=%ld, 利率=%@", 
          (long)bestAdvice.loanType, 
          bestAdvice.recommendedAmount, 
          (long)bestAdvice.recommendedTerm, 
          bestAdvice.interestRate);
    
    // 创建简单的结果视图
    UIView *resultCard = [self createSimpleResultCardWithAdvice:bestAdvice];
    [self.resultsContainer addSubview:resultCard];
    
    [resultCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultsTitle.mas_bottom).offset(24);
        make.left.right.equalTo(self.resultsContainer).inset(20);
        make.height.mas_greaterThanOrEqualTo(260); // 使用最小高度而不是固定高度
    }];
    
    // 重新分析按钮
    [self.restartButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultCard.mas_bottom).offset(32);
        make.centerX.equalTo(self.resultsContainer);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.resultsContainer).offset(-30);
    }];
    
    [self updateContentViewConstraints];
    NSLog(@"✅ 简单结果视图创建完成");
}


// 废弃的方法 - 现在在新页面处理重新分析
- (void)restartButtonTapped {
    // 已废弃
}
*/

#pragma mark - Actions

- (void)analyzeButtonTapped {
    NSLog(@"🚀 分析按钮被点击");
    
    if (![self.quickInputView hasValidSelection]) {
        [self showAlert:@"提示" message:@"请完成所有选项的选择"];
        return;
    }
    
    NSLog(@"✅ 输入验证通过，开始分析");
    NSLog(@"📊 用户资料: 收入=%@, 职业=%@", self.viewModel.userProfile.monthlyIncome, self.viewModel.userProfile.employmentType);
    
    [self setState:JJRAIAdvisorStateAnalyzing];
    
    // 开始AI分析
    [self.viewModel generateLoanAdvices];
    NSLog(@"🤖 AI分析已启动");
}

#pragma mark - JJRAIQuickInputViewDelegate

- (void)quickInputView:(JJRAIQuickInputView *)view didUpdateUserProfile:(JJRAIUserProfile *)profile {
    [self.viewModel updateUserProfile:profile];
    self.analyzeButton.enabled = [view hasValidSelection];
    
    // 更新按钮样式
    if (self.analyzeButton.enabled) {
        self.analyzeButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
        self.analyzeButton.alpha = 1.0;
    } else {
        self.analyzeButton.backgroundColor = [UIColor grayColor];
        self.analyzeButton.alpha = 0.6;
    }
}

// 移除了JJRAIAdviceCardViewDelegate相关方法，现在使用简单的按钮回调

#pragma mark - Notification Handlers

- (void)analysisCompleted:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"🎯 分析完成通知收到");
        
        // 强制隐藏进度视图
        self.progressView.hidden = YES;
        [self.progressView stopAnimation];
        
        // 确保有数据再跳转到结果页面
        if (self.viewModel.loanAdvices.count > 0) {
            NSLog(@"✅ 有数据，跳转到结果页面");
            [self showResultPage];
        } else {
            NSLog(@"⚠️ 分析完成但没有数据，等待ViewModel通知");
        }
    });
}

- (void)viewModelDidUpdateAdvices:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"✅ ViewModel数据已更新，建议数量: %lu", (unsigned long)self.viewModel.loanAdvices.count);
        
        // 强制隐藏进度视图
        self.progressView.hidden = YES;
        [self.progressView stopAnimation];
        
        // 跳转到结果页面
        [self showResultPage];
    });
}

#pragma mark - Helper Methods

/*
// 废弃的方法 - 申请流程现在在新页面处理
- (void)proceedWithAdvice:(JJRAILoanAdvice *)advice {
    // 已废弃
}
*/

/*
// 废弃的方法 - 详情展示现在在新页面处理
- (void)showAdviceDetails:(JJRAILoanAdvice *)advice {
    // 已废弃
}
*/

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end 
