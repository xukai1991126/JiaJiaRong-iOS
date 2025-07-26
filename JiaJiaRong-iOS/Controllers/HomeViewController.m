//
//  
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "HomeHeaderView.h"
#import "HomeMainCardView.h"
#import "HomeTestimonialView.h"
#import "HomeNoticeView.h"
#import "JJRUserManager.h"
#import "LoginViewController.h"
#import "JJRApplyFormViewController.h"
#import "JJRLoanAssessmentViewController.h"
#import "JJRIdCardViewController.h"
#import "JJRAuthorizationViewController.h"
#import "JJRResultViewController.h"
#import "WebViewController.h"

@interface HomeViewController () <JJRBaseViewModelDelegate, HomeMainCardViewDelegate>

@property (nonatomic, strong) HomeViewModel *viewModel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) HomeHeaderView *headerView;
@property (nonatomic, strong) HomeMainCardView *mainCardView;
@property (nonatomic, strong) HomeTestimonialView *testimonialView;
@property (nonatomic, strong) HomeNoticeView *noticeView;

@end

@implementation HomeViewController

- (BOOL)requiresLogin {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];
    [self setupUI];
    [self loadData];
    [self updateUIWithViewModel]; // 初始化时更新UI
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    // 更新登录按钮状态
    BOOL isLoggedIn = [[JJRUserManager sharedManager] isLoggedIn];
    [self.viewModel updateLoginButtonTitleWithLoginStatus:isLoggedIn];
    
    [self.viewModel fetchUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    // 停止自动滚动
    [self.testimonialView stopAutoScroll];
}

#pragma mark - Setup

- (void)setupViewModel {
    self.viewModel = [[HomeViewModel alloc] init];
    self.viewModel.delegate = self;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    // 内容容器
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 设置背景渐变
    [self setupGradientBackground];
    
    // 创建各个组件
    [self setupHeaderView];
    [self setupMainCardView];
    [self setupTestimonialView];
    [self setupNoticeView];
    
    // 设置约束
    [self setupConstraints];
}

- (void)setupGradientBackground {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = [UIScreen mainScreen].bounds;
    gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#F2582B"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1" alpha:0.0].CGColor
    ];
    gradientLayer.locations = @[@0.0, @0.5, @1.0];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = self.view.bounds;
    [backgroundView.layer addSublayer:gradientLayer];
    [self.view insertSubview:backgroundView atIndex:0];
}

- (void)setupHeaderView {
    self.headerView = [[HomeHeaderView alloc] init];
    [self.contentView addSubview:self.headerView];
}

- (void)setupMainCardView {
    self.mainCardView = [[HomeMainCardView alloc] init];
    self.mainCardView.delegate = self;
    [self.contentView addSubview:self.mainCardView];
}

- (void)setupTestimonialView {
    self.testimonialView = [[HomeTestimonialView alloc] init];
    [self.contentView addSubview:self.testimonialView];
}

- (void)setupNoticeView {
    self.noticeView = [[HomeNoticeView alloc] init];
    [self.contentView addSubview:self.noticeView];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(200);
    }];
    
    [self.mainCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(-30);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(280);
    }];
    
    [self.testimonialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainCardView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(140);
    }];
    
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testimonialView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)loadData {
    [self.viewModel loadInitialData];
}

#pragma mark - Data Update

- (void)updateUIWithViewModel {
    // 更新头部视图
    [self.headerView updateWithFeatureData:self.viewModel.featureData];
    
    // 更新主卡片视图
    self.mainCardView.maxAmount = self.viewModel.maxAmount;
    self.mainCardView.maxPeriod = self.viewModel.maxPeriod;
    self.mainCardView.rateInfo = self.viewModel.rateInfo;
    self.mainCardView.combinedInfo = self.viewModel.combinedInfo;
    self.mainCardView.loginButtonTitle = self.viewModel.loginButtonTitle;
    self.mainCardView.showProtocolCheckbox = self.viewModel.showProtocolCheckbox;
    self.mainCardView.protocolChecked = self.viewModel.protocolChecked;
    [self.mainCardView updateCardContent];
    
    // 更新用户证明视图
    [self.testimonialView updateWithTestimonialData:self.viewModel.testimonialData];
    
    // 如果页面可见，启动自动滚动
    if (self.viewIfLoaded && self.view.window) {
        [self.testimonialView startAutoScroll];
    }
}

#pragma mark - JJRBaseViewModelDelegate

- (void)viewModelDidStartLoading {
    // 可以添加加载指示器
}

- (void)viewModelDidFinishLoading {
    // 隐藏加载指示器
}

- (void)viewModelDidFailWithError:(NSError *)error {
    NSLog(@"获取数据失败: %@", error);
    [JJRToastTool showToast:@"获取数据失败"];
}

- (void)viewModelDidUpdateData {
    [self updateUIWithViewModel];
}

#pragma mark - HomeMainCardViewDelegate

- (void)mainCardViewDidTapLoginButton {
    NSLog(@"🎯 登录按钮被点击");
    
    // 检查登录状态
    if (![[JJRUserManager sharedManager] isLoggedIn]) {
        NSLog(@"🎯 用户未登录，跳转到登录页面");
        [self navigateToLogin];
        return;
    }
    
    // 用户已登录，检查协议勾选
    if (!self.viewModel.protocolChecked && self.viewModel.showProtocolCheckbox) {
        [JJRToastTool showToast:@"请同意并勾选协议"];
        return;
    }
    
    NSLog(@"🎯 用户已登录，进入申请表单页面");
    [self navigateToForm];
}

- (void)mainCardViewDidToggleProtocol:(BOOL)checked {
    NSLog(@"🎯 协议勾选状态: %@", checked ? @"已勾选" : @"未勾选");
    self.viewModel.protocolChecked = checked;
}

- (void)mainCardViewDidTapServiceAgreement {
    NSLog(@"🎯 服务协议被点击");
    [self handleAgreement:@"user" title:@"服务协议"];
}

- (void)mainCardViewDidTapPrivacyAgreement {
    NSLog(@"🎯 隐私协议被点击");
    [self handleAgreement:@"privacy" title:@"隐私协议"];
}

#pragma mark - Actions

- (void)handleAgreement:(NSString *)type title:(NSString *)title {
    NSLog(@"🎯 打开协议页面: %@", title);
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.agreementType = type;
    webVC.title = title;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)handleUserFlow {
    // 根据用户状态跳转不同页面
    // 这里暂时使用假数据，实际应该从网络获取用户状态
        [self navigateToForm];
}

#pragma mark - Navigation

- (void)navigateToLogin {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)navigateToForm {
    JJRLoanAssessmentViewController *assessmentVC = [[JJRLoanAssessmentViewController alloc] init];
    assessmentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:assessmentVC animated:YES];
}

- (void)navigateToIDCard {
    JJRIdCardViewController *idCardVC = [[JJRIdCardViewController alloc] init];
    idCardVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:idCardVC animated:YES];
}

- (void)navigateToAuthorization {
    JJRAuthorizationViewController *authVC = [[JJRAuthorizationViewController alloc] init];
    authVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authVC animated:YES];
}

- (void)navigateToResult {
    JJRResultViewController *resultVC = [[JJRResultViewController alloc] init];
    resultVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resultVC animated:YES];
}

@end
