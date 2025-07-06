//
//  JJRBankCardListViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBankCardListViewController.h"
#import <YYKit/YYKit.h>
#import "JJRBankCardListView.h"
#import "JJRBankCardAddViewController.h"
#import "JJRNetworkService.h"
#import "JJRToast.h"
#import <Masonry/Masonry.h>

@interface JJRBankCardListViewController ()

@property (nonatomic, strong) JJRBankCardListView *bankCardListView;

@end

@implementation JJRBankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
    [self loadBankCards];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBankCards];
}

- (void)setupUI {
    self.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加银行卡按钮
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addBankCard)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.bankCardListView = [[JJRBankCardListView alloc] init];
    [self.view addSubview:self.bankCardListView];
    
    __weak typeof(self) weakSelf = self;
    self.bankCardListView.deleteBankCardBlock = ^(JJRBankCardModel *bankCard) {
        [weakSelf deleteBankCard:bankCard];
    };
    
    self.bankCardListView.selectBankCardBlock = ^(JJRBankCardModel *bankCard) {
        [weakSelf selectBankCard:bankCard];
    };
}

- (void)setupConstraints {
    [self.bankCardListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadBankCards {
    [JJRNetworkService showLoading];
    
    [[JJRNetworkService sharedInstance] getBankCardListWithSuccess:^(id responseObject) {
        [JJRNetworkService hideLoading];
        NSArray *bankCards = [JJRBankCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.bankCardListView updateBankCards:bankCards];
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:error.localizedDescription];
    }];
}

- (void)addBankCard {
    JJRBankCardAddViewController *addVC = [[JJRBankCardAddViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)deleteBankCard:(JJRBankCardModel *)bankCard {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除这张银行卡吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self confirmDeleteBankCard:bankCard];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)confirmDeleteBankCard:(JJRBankCardModel *)bankCard {
    [JJRNetworkService showLoading];
    
    NSDictionary *params = @{
        @"cardId": bankCard.cardId
    };
    
    [[JJRNetworkService sharedInstance] deleteBankCardWithCardId:params[@"cardId"] success:^(id responseObject) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:@"删除成功"];
        [self loadBankCards];
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:error.localizedDescription];
    }];
}

- (void)selectBankCard:(JJRBankCardModel *)bankCard {
    // 这里可以根据业务需求处理银行卡选择逻辑
    [JJRToast showToast:[NSString stringWithFormat:@"已选择%@", bankCard.bankName]];
}

@end 
