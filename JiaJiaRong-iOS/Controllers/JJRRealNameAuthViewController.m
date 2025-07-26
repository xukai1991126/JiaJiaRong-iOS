//
//  JJRRealNameAuthViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRRealNameAuthViewController.h"
#import "JJRRealNameAuthViewModel.h"
#import "RealNameAuthAmountCardView.h"
#import "RealNameAuthFormView.h"
#import "JJRCityPickerViewController.h"
#import "JJRNetworkService.h"

@interface JJRRealNameAuthViewController () <RealNameAuthFormViewDelegate>

@property (nonatomic, strong) JJRRealNameAuthViewModel *viewModel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) RealNameAuthAmountCardView *amountCardView;
@property (nonatomic, strong) RealNameAuthFormView *formView;

@end

@implementation JJRRealNameAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupGradientBackground];
    [self setupViewModel];
    [self setupUI];
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
    self.viewModel = [[JJRRealNameAuthViewModel alloc] init];
}

- (void)setupUI {
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    // 内容容器
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 额度卡片
    self.amountCardView = [[RealNameAuthAmountCardView alloc] initWithViewModel:self.viewModel];
    [self.contentView addSubview:self.amountCardView];
    
    // 表单视图
    self.formView = [[RealNameAuthFormView alloc] initWithViewModel:self.viewModel];
    self.formView.delegate = self;
    [self.contentView addSubview:self.formView];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.amountCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(STATUS_BAR_HEIGHT + 60);
        make.left.right.equalTo(self.contentView).inset(20);
    }];
    
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountCardView.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView).inset(20);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
}

#pragma mark - RealNameAuthFormViewDelegate

- (void)formViewDidTapCitySelection {
    [self showCitySelection];
}

- (void)formViewDidTapSubmit {
    // 提交实名认证
    NSLog(@"提交实名认证");
    // TODO: 实现提交逻辑
}

#pragma mark - City Selection

- (void)showCitySelection {
    // 获取热门城市数据
    [[JJRNetworkService sharedInstance] getHotCitiesWithSuccess:^(NSDictionary *responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                JJRCityPickerViewController *cityPicker = [[JJRCityPickerViewController alloc] init];
                cityPicker.hotCities = responseObject[@"data"];
                cityPicker.currentCityName = self.viewModel.cityName;
                cityPicker.modalPresentationStyle = UIModalPresentationPageSheet;
                
                // 设置选择回调
                __weak typeof(self) weakSelf = self;
                cityPicker.citySelectedBlock = ^(NSString *cityName, NSString *cityCode) {
                    weakSelf.viewModel.cityName = cityName;
                    weakSelf.viewModel.cityCode = cityCode;
                    [weakSelf.formView updateCityDisplay];
                };
                
                [self presentViewController:cityPicker animated:YES completion:nil];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"获取城市数据失败: %@", error);
        [JJRToastTool showToast:@"获取城市数据失败"];
    }];
}

@end 