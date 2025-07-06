//
//  JJRBankCardAddViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBankCardAddViewController.h"
#import <YYKit/YYKit.h>
#import "JJRBankCardAddView.h"
#import "JJRNetworkService.h"
#import "JJRToast.h"
#import <Masonry/Masonry.h>

@interface JJRBankCardAddViewController ()

@property (nonatomic, strong) JJRBankCardAddView *bankCardAddView;

@end

@implementation JJRBankCardAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.title = @"添加银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bankCardAddView = [[JJRBankCardAddView alloc] init];
    [self.view addSubview:self.bankCardAddView];
    
    __weak typeof(self) weakSelf = self;
    self.bankCardAddView.addBankCardBlock = ^(NSString *cardNumber, NSString *cardHolder, NSString *idNumber, NSString *phone) {
        [weakSelf addBankCard:cardNumber cardHolder:cardHolder idNumber:idNumber phone:phone];
    };
}

- (void)setupConstraints {
    [self.bankCardAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addBankCard:(NSString *)cardNumber 
         cardHolder:(NSString *)cardHolder 
           idNumber:(NSString *)idNumber 
              phone:(NSString *)phone {
    
    if (!cardNumber || cardNumber.length == 0) {
        [JJRToast showToast:@"请输入银行卡号"];
        return;
    }
    
    if (cardNumber.length < 16 || cardNumber.length > 19) {
        [JJRToast showToast:@"请输入正确的银行卡号"];
        return;
    }
    
    if (!cardHolder || cardHolder.length == 0) {
        [JJRToast showToast:@"请输入持卡人姓名"];
        return;
    }
    
    if (!idNumber || idNumber.length == 0) {
        [JJRToast showToast:@"请输入身份证号"];
        return;
    }
    
    if (idNumber.length != 18) {
        [JJRToast showToast:@"请输入正确的身份证号"];
        return;
    }
    
    if (!phone || phone.length == 0) {
        [JJRToast showToast:@"请输入手机号"];
        return;
    }
    
    if (phone.length != 11) {
        [JJRToast showToast:@"请输入正确的手机号"];
        return;
    }
    
    [JJRNetworkService showLoading];
    
    NSDictionary *params = @{
        @"cardNumber": cardNumber,
        @"cardHolder": cardHolder,
        @"idNumber": idNumber,
        @"phone": phone
    };
    
    [[JJRNetworkService sharedInstance] addBankCardWithParams:params success:^(id responseObject) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:@"银行卡添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:error.localizedDescription];
    }];
}

@end 
