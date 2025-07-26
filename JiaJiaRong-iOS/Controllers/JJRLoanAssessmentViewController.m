//
//  JJRLoanAssessmentViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRLoanAssessmentViewController.h"
#import "JJRLoanAssessmentViewModel.h"
#import "LoanAssessmentStepView.h"

@interface JJRLoanAssessmentViewController ()

@property (nonatomic, strong) JJRLoanAssessmentViewModel *viewModel;
@property (nonatomic, strong) LoanAssessmentStepView *stepView;

@end

@implementation JJRLoanAssessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"额度评估";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupGradientBackground];
    [self setupViewModel];
    [self setupStepView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Setup

- (void)setupGradientBackground {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#F2582B"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1" alpha:0.0].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)setupViewModel {
    self.viewModel = [[JJRLoanAssessmentViewModel alloc] init];
}

- (void)setupStepView {
    self.stepView = [[LoanAssessmentStepView alloc] initWithViewModel:self.viewModel];
    [self.view addSubview:self.stepView];
    
    [self.stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end 