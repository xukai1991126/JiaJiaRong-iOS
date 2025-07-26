//
//  LoanAssessmentStepView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "LoanAssessmentStepView.h"
#import "JJRLoanAssessmentViewModel.h"
#import "LoanAssessmentStepIndicatorView.h"
#import "LoanAssessmentStep1View.h"
#import "LoanAssessmentStep2View.h"
#import "LoanAssessmentStep3View.h"
#import "LoanAssessmentStep4View.h"
#import "JJRRealNameAuthViewController.h"

@interface LoanAssessmentStepView () <JJRLoanAssessmentViewModelDelegate>

@property (nonatomic, strong) JJRLoanAssessmentViewModel *viewModel;

// UI组件
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) LoanAssessmentStepIndicatorView *stepIndicator;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *contentContainer;

// 步骤Views
@property (nonatomic, strong) LoanAssessmentStep1View *step1View;
@property (nonatomic, strong) LoanAssessmentStep2View *step2View;
@property (nonatomic, strong) LoanAssessmentStep3View *step3View;
@property (nonatomic, strong) LoanAssessmentStep4View *step4View;

@end

@implementation LoanAssessmentStepView

- (instancetype)initWithViewModel:(JJRLoanAssessmentViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        _viewModel.delegate = self;
        [self setupUI];
        [self updateCurrentStep];
    }
    return self;
}

#pragma mark - Setup UI

- (void)setupUI {
    // 返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    // 步骤指示器
    self.stepIndicator = [[LoanAssessmentStepIndicatorView alloc] init];
    [self addSubview:self.stepIndicator];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FONT_BOLD(20);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    // 副标题
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = FONT_REGULAR(16);
    self.subtitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.subtitleLabel];
    
    // 内容容器
    self.contentContainer = [[UIView alloc] init];
    [self addSubview:self.contentContainer];
    
    // 创建各步骤Views
    [self setupStepViews];
    
    // 设置约束
    [self setupConstraints];
}

- (void)setupStepViews {
    self.step1View = [[LoanAssessmentStep1View alloc] initWithViewModel:self.viewModel];
    self.step2View = [[LoanAssessmentStep2View alloc] initWithViewModel:self.viewModel];
    self.step3View = [[LoanAssessmentStep3View alloc] initWithViewModel:self.viewModel];
    self.step4View = [[LoanAssessmentStep4View alloc] initWithViewModel:self.viewModel];
    
    [self.contentContainer addSubview:self.step1View];
    [self.contentContainer addSubview:self.step2View];
    [self.contentContainer addSubview:self.step3View];
    [self.contentContainer addSubview:self.step4View];
    
    // 初始隐藏所有步骤
    self.step1View.hidden = YES;
    self.step2View.hidden = YES;
    self.step3View.hidden = YES;
    self.step4View.hidden = YES;
    
    // 设置步骤Views约束
    NSArray *stepViews = @[self.step1View, self.step2View, self.step3View, self.step4View];
    for (UIView *stepView in stepViews) {
        [stepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentContainer);
        }];
    }
}

- (void)setupConstraints {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(STATUS_BAR_HEIGHT + 20);
        make.left.equalTo(self).offset(20);
        make.width.height.mas_equalTo(44);
    }];
    
    [self.stepIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(120);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_bottom).offset(40);
        make.left.right.equalTo(self).inset(20);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self).inset(20);
    }];
    
    [self.contentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(40);
        make.left.right.bottom.equalTo(self);
    }];
}

#pragma mark - Actions

- (void)backButtonTapped {
    if ([self.viewModel isFirstStep]) {
        // 第一步，退出页面
        UIViewController *currentVC = [self findViewController];
        if (currentVC) {
            [currentVC.navigationController popViewControllerAnimated:YES];
        }
    } else {
        // 其他步骤，回到上一步
        [self.viewModel goToPreviousStep];
    }
}

#pragma mark - JJRLoanAssessmentViewModelDelegate

- (void)viewModelDidUpdateStep {
    [self updateCurrentStep];
}

- (void)viewModelDidCompleteAssessment {
    // 评估完成，跳转到实名认证页面
    NSLog(@"评估完成！跳转到实名认证页面");
    
    UIViewController *currentVC = [self findViewController];
    if (currentVC) {
        JJRRealNameAuthViewController *realNameAuthVC = [[JJRRealNameAuthViewController alloc] init];
        realNameAuthVC.hidesBottomBarWhenPushed = YES;
        [currentVC.navigationController pushViewController:realNameAuthVC animated:YES];
    }
}

#pragma mark - Private Methods

- (void)updateCurrentStep {
    // 更新标题和副标题
    self.titleLabel.text = [self.viewModel titleForCurrentStep];
    self.subtitleLabel.text = [self.viewModel subtitleForCurrentStep];
    
    // 更新步骤指示器
    [self.stepIndicator updateWithCurrentStep:self.viewModel.currentStep];
    
    // 隐藏所有步骤View
    self.step1View.hidden = YES;
    self.step2View.hidden = YES;
    self.step3View.hidden = YES;
    self.step4View.hidden = YES;
    
    // 显示当前步骤View
    switch (self.viewModel.currentStep) {
        case LoanAssessmentStepAmount:
            self.step1View.hidden = NO;
            [self.step1View updateDisplay];
            break;
        case LoanAssessmentStepCredit:
            self.step2View.hidden = NO;
            [self.step2View updateDisplay];
            break;
        case LoanAssessmentStepAsset:
            self.step3View.hidden = NO;
            [self.step3View updateDisplay];
            break;
        case LoanAssessmentStepIncome:
            self.step4View.hidden = NO;
            [self.step4View updateDisplay];
            break;
    }
}

- (UIViewController *)findViewController {
    UIResponder *responder = self;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end 