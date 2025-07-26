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
#import "JJRToastTool.h"
#import "JJRUserManager.h"
#import "JJRIdCardViewController.h"

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
    
    // 设置导航栏
    [self setupNavigationBar];
    [self setupGradientBackground];
    [self setupViewModel];
    [self setupUI];
}

- (void)setupNavigationBar {
    // 设置导航栏样式
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F2582B"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = YES;
    
    // 确保显示返回按钮
    self.navigationItem.hidesBackButton = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航栏并设置样式
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F2582B"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 恢复导航栏样式
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.titleTextAttributes = nil;
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
    
    // 在 viewDidLayoutSubviews 中更新 frame
    dispatch_async(dispatch_get_main_queue(), ^{
        gradientLayer.frame = self.view.bounds;
    });
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
        make.top.equalTo(self.contentView).offset(20);
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
    [self submitForm];
}

#pragma mark - Form Submission

- (void)submitForm {
    // 验证姓名信息
    if (!self.viewModel.realName || self.viewModel.realName.length == 0) {
        [JJRToastTool showToast:@"请填写正确的姓名"];
        return;
    }
    
    // 验证年龄信息
    if (!self.viewModel.age || self.viewModel.age.length == 0) {
        [JJRToastTool showToast:@"请填写正确的年龄"];
        return;
    }
    
    // 年龄范围校验
    NSInteger ageValue = [self.viewModel.age integerValue];
    if (ageValue < 18 || ageValue > 65) {
        [JJRToastTool showToast:@"年龄需在18-65岁之间"];
        return;
    }
    
    // 验证城市信息
    if (!self.viewModel.cityCode || self.viewModel.cityCode.length == 0) {
        [JJRToastTool showToast:@"请选择所在城市"];
        return;
    }
    
    // 显示担保额度说明确认弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"担保额度说明"
                                                                   message:@"本平台专注融资担保服务，不收取任何隐藏费用，所有费用均透明公开。最终担保额度以金融机构审批为准，您有权拒绝任何不合理的收费。确认继续申请担保额度吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performFormSubmission];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)performFormSubmission {
    // 构建提交参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cityCode"] = self.viewModel.cityCode;
    params[@"cityName"] = self.viewModel.cityName;
    params[@"realName"] = self.viewModel.realName;
    params[@"age"] = self.viewModel.age;
    params[@"gender"] = self.viewModel.isMale ? @"男" : @"女";
    params[@"maxAmount"] = self.viewModel.maxAmount;
    params[@"ios"] = @YES;
    
    // 显示loading
    [JJRNetworkService showLoading];
    
    // 提交表单 - 这里使用已有的网络接口
    [[JJRNetworkService sharedInstance] submitFormApplyWithParams:params success:^(NSDictionary *responseObject) {
        [JJRNetworkService hideLoading];
        if ([responseObject[@"code"] integerValue] == 0) {
            [JJRToastTool showSuccess:@"提交成功"];

             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 JJRIdCardViewController *qualificationVC = [[JJRIdCardViewController alloc] init];
                 qualificationVC.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:qualificationVC animated:YES];
             });
        } else {
            [JJRToastTool showError:responseObject[@"err"][@"msg"] ?: @"提交失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [self navigateToIDCard];
        return;
        
        NSString *errorMessage = error.localizedDescription;
        if (!errorMessage || errorMessage.length == 0) {
            errorMessage = @"提交失败，请重试";
        }
        [JJRToastTool showError:errorMessage];
    }];
}

- (void)navigateToIDCard {
    [JJRToastTool showSuccess:@"提交成功"];
    // 更新用户信息
    NSDictionary *userInfo = [[JJRUserManager sharedManager] userInfo];
    NSMutableDictionary *updatedUserInfo = [userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
    updatedUserInfo[@"realNameAuth"] = @YES;
    updatedUserInfo[@"realName"] = self.viewModel.realName;
    updatedUserInfo[@"age"] = self.viewModel.age;
    updatedUserInfo[@"gender"] = self.viewModel.isMale ? @"男" : @"女";
    updatedUserInfo[@"cityName"] = self.viewModel.cityName;
    updatedUserInfo[@"cityCode"] = self.viewModel.cityCode;
    [[JJRUserManager sharedManager] updateUserInfo:updatedUserInfo];
    
         // 同时保存到NSUserDefaults中，与token关联
     [[JJRUserManager sharedManager] saveUserDataToDefaults:@{
         @"realName": self.viewModel.realName ?: @"",
         @"age": self.viewModel.age ?: @"",
         @"gender": self.viewModel.isMale ? @"男" : @"女",
         @"cityName": self.viewModel.cityName ?: @"",
         @"cityCode": self.viewModel.cityCode ?: @""
     }];
    
    // 延迟跳转到资质初审页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        JJRIdCardViewController *idCardVC = [[JJRIdCardViewController alloc] init];
//        idCardVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:idCardVC animated:YES];
        JJRIdCardViewController *idCardVC = [[JJRIdCardViewController alloc] init];
        idCardVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:idCardVC animated:YES];

    });

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
