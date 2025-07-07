//
//  JJRBankCardListViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRBankCardListViewController.h"
#import "JJRBankCardAddViewController.h"
#import "JJRNetworkService.h"
#import "JJRBankCardModel.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>
#import <QuartzCore/QuartzCore.h>

@interface JJRBankCardListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *attentionView;
@property (nonatomic, strong) UILabel *attentionLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *listTitleLabel;
@property (nonatomic, strong) UILabel *listCountLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *addBankView;
@property (nonatomic, strong) UILabel *addBankLabel;
@property (nonatomic, strong) CAShapeLayer *addBankBorderLayer; // 添加虚线边框层

@property (nonatomic, strong) NSMutableArray<JJRBankCardModel *> *bankList;
@property (nonatomic, assign) BOOL showDelete;
@property (nonatomic, strong) UIBarButtonItem *deleteButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *confirmButton;

@end

@implementation JJRBankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchBankList];
}

- (void)setupNavigationBar {
    self.title = @"银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 删除银行卡按钮
    self.deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"删除银行卡" style:UIBarButtonItemStylePlain target:self action:@selector(onDeleteMode)];
    self.deleteButton.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.41 alpha:1.0];
    
    // 取消按钮
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelDelete)];
    self.cancelButton.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.41 alpha:1.0];
    
    // 确定按钮
    self.confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onBatchDelete)];
    self.confirmButton.tintColor = [UIColor colorWithRed:0.118 green:0.392 blue:0.937 alpha:1.0];
    
    [self updateNavigationBar];
}

- (void)updateNavigationBar {
    if (self.bankList.count > 0) {
        if (self.showDelete) {
            self.navigationItem.rightBarButtonItems = @[self.confirmButton, self.cancelButton];
        } else {
            self.navigationItem.rightBarButtonItem = self.deleteButton;
        }
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setupUI {
    // 注意提示框
    self.attentionView = [[UIView alloc] init];
    self.attentionView.backgroundColor = [UIColor colorWithRed:0.996 green:0.957 blue:0.918 alpha:1.0]; // #fef4ea
    [self.view addSubview:self.attentionView];
    
    self.attentionLabel = [[UILabel alloc] init];
    self.attentionLabel.text = @"当前填写的手机号需与银行预留手机号保持一致，否则会导致申请失败，如绑卡失败，请绑定新的银行卡";
    self.attentionLabel.textColor = [UIColor colorWithRed:0.89 green:0.584 blue:0.329 alpha:1.0]; // #e39554
    self.attentionLabel.font = [UIFont systemFontOfSize:12]; // 24rpx -> 12pt
    self.attentionLabel.numberOfLines = 0;
    [self.attentionView addSubview:self.attentionLabel];
    
    // 内容区域
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    
    // 列表标题
    self.listTitleLabel = [[UILabel alloc] init];
    self.listTitleLabel.text = @"本地银行卡";
    self.listTitleLabel.font = [UIFont systemFontOfSize:16]; // 32rpx -> 16pt
    self.listTitleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.listTitleLabel];
    
    // 数量标签
    self.listCountLabel = [[UILabel alloc] init];
    self.listCountLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.41 alpha:1.0]; // #666769
    self.listCountLabel.font = [UIFont systemFontOfSize:12]; // 24rpx -> 12pt
    [self.contentView addSubview:self.listCountLabel];
    
    // 表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.tableView];
    
    // 添加银行卡按钮
    self.addBankView = [[UIView alloc] init];
    self.addBankView.backgroundColor = [UIColor colorWithRed:0.929 green:0.953 blue:1.0 alpha:1.0]; // #edf3ff
    self.addBankView.layer.cornerRadius = 15; // 30rpx -> 15pt
    
    // 创建虚线边框层
    self.addBankBorderLayer = [CAShapeLayer layer];
    self.addBankBorderLayer.strokeColor = [UIColor colorWithRed:0.855 green:0.886 blue:0.925 alpha:1.0].CGColor; // #dae2ec
    self.addBankBorderLayer.lineWidth = 1.0; // 2rpx -> 1pt
    self.addBankBorderLayer.lineDashPattern = @[@5, @3]; // 虚线样式
    self.addBankBorderLayer.fillColor = [UIColor clearColor].CGColor;
    [self.addBankView.layer addSublayer:self.addBankBorderLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddBank)];
    [self.addBankView addGestureRecognizer:tap];
    [self.contentView addSubview:self.addBankView];
    
    // 添加图标
    UIImageView *addIcon = [[UIImageView alloc] init];
    addIcon.image = [UIImage systemImageNamed:@"plus"];
    addIcon.tintColor = [UIColor colorWithRed:0.118 green:0.392 blue:0.937 alpha:1.0]; // #1e64ef
    [self.addBankView addSubview:addIcon];
    
    self.addBankLabel = [[UILabel alloc] init];
    self.addBankLabel.text = @"添加银行卡";
    self.addBankLabel.textColor = [UIColor colorWithRed:0.118 green:0.392 blue:0.937 alpha:1.0]; // #1e64ef
    self.addBankLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    [self.addBankView addSubview:self.addBankLabel];
    
    // 添加图标和标签的约束
    [addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addBankView);
        make.right.equalTo(self.addBankLabel.mas_left).offset(-5);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.addBankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.addBankView);
    }];
    
    // 初始化数据
    self.bankList = [NSMutableArray array];
    self.showDelete = NO;
}

- (void)setupConstraints {
    [self.attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
    }];
    
    [self.attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.attentionView).inset(15); // 30rpx -> 15pt
        make.left.right.equalTo(self.attentionView).inset(20); // 40rpx -> 20pt
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.attentionView.mas_bottom).offset(20); // 40rpx -> 20pt
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom); // 让contentView填充剩余空间
    }];
    
    [self.listTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(15); // 30rpx -> 15pt
    }];
    
    [self.listCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listTitleLabel);
        make.left.equalTo(self.listTitleLabel.mas_right).offset(15); // 30rpx -> 15pt
    }];
    
    [self.addBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(15); // 30rpx -> 15pt
        make.bottom.equalTo(self.contentView).offset(-20); // 距离底部20pt
        make.height.mas_equalTo(75); // 150rpx -> 75pt
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listTitleLabel.mas_bottom).offset(15); // 30rpx -> 15pt
        make.left.right.equalTo(self.contentView).inset(15); // 30rpx -> 15pt
        make.bottom.equalTo(self.addBankView.mas_top).offset(-15); // 距离添加按钮15pt
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 更新虚线边框路径
    if (self.addBankBorderLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.addBankView.bounds cornerRadius:15];
        self.addBankBorderLayer.path = path.CGPath;
        self.addBankBorderLayer.frame = self.addBankView.bounds;
    }
}

#pragma mark - Actions

- (void)onDeleteMode {
    self.showDelete = YES;
    [self updateNavigationBar];
    [self.tableView reloadData];
}

- (void)onCancelDelete {
    self.showDelete = NO;
    // 清除所有选择状态
    for (JJRBankCardModel *bankCard in self.bankList) {
        bankCard.selected = NO;
    }
    [self updateNavigationBar];
    [self.tableView reloadData];
}

- (void)onBatchDelete {
    NSArray *selectedList = [self.bankList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
    if (selectedList.count == 0) {
        [self showToast:@"请选择要删除的银行卡"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" 
                                                                   message:@"仅删除本平台绑定状态\n已绑定在第三方的银行卡不受影响" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.showDelete = NO;
        [self onCancelDelete];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteBanks];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)onAddBank {
    JJRBankCardAddViewController *addVC = [[JJRBankCardAddViewController alloc] init];
    addVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - Network

- (void)fetchBankList {
    [[JJRNetworkService sharedInstance] POST:JJR_BANK_CARD_LIST params:@{} success:^(NSDictionary *responseObject) {
        NSLog(@"✅ 银行卡列表数据: %@", responseObject);
        
        NSArray *dataArray = responseObject[@"data"] ?: @[];
        [self.bankList removeAllObjects];
        
        for (NSDictionary *item in dataArray) {
            JJRBankCardModel *bankCard = [[JJRBankCardModel alloc] init];
            bankCard.cardId = [item[@"id"] stringValue]; // 确保ID转换为字符串
            bankCard.bankNo = item[@"bankNo"];
            bankCard.bankName = item[@"bankName"];
            bankCard.cardType = item[@"cardType"];
            bankCard.bankLogo = item[@"bankLogo"];
            bankCard.bankCode = item[@"bankType"]; // API返回的是bankType
            bankCard.selected = NO;
            [self.bankList addObject:bankCard];
            
            NSLog(@"📱 银行卡信息: %@ - %@ - %@", bankCard.bankName, bankCard.cardType, bankCard.bankNo);
        }
        
        NSLog(@"🔄 银行卡列表更新，共%ld张卡", (long)self.bankList.count);
        [self updateUI];
    } failure:^(NSError *error) {
        NSLog(@"❌ 获取银行卡列表失败: %@", error.localizedDescription);
        [self showToast:@"获取银行卡列表失败"];
    }];
}

- (void)deleteBanks {
    NSArray *selectedList = [self.bankList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
    NSMutableArray *ids = [NSMutableArray array];
    for (JJRBankCardModel *bankCard in selectedList) {
        [ids addObject:bankCard.cardId];
    }
    
    NSDictionary *params = @{@"idList": ids};
    
    [[JJRNetworkService sharedInstance] POST:JJR_BANK_CARD_DELETE params:params success:^(NSDictionary *responseObject) {
        [self showToast:@"删除成功"];
        [self fetchBankList];
        self.showDelete = NO;
        [self updateNavigationBar];
    } failure:^(NSError *error) {
        [self showToast:@"删除失败"];
    }];
}

#pragma mark - UI Updates

- (void)updateUI {
    self.listCountLabel.text = [NSString stringWithFormat:@"共%ld张", (long)self.bankList.count];
    
    // 显示/隐藏列表标题
    self.listTitleLabel.hidden = self.bankList.count == 0;
    self.listCountLabel.hidden = self.bankList.count == 0;
    
    [self updateNavigationBar];
    [self.tableView reloadData];
}

- (void)showToast:(NSString *)message {
    // 简单的Toast实现
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:toast animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankList.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90; // 75pt卡片高度 + 15pt间距
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BankCardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupBankCardCell:cell];
    }
    
    [self configureBankCardCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)setupBankCardCell:(UITableViewCell *)cell {
    // 卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor colorWithRed:0.961 green:0.965 blue:0.973 alpha:1.0]; // #f5f6f8
    cardView.layer.cornerRadius = 15; // 30rpx -> 15pt
    cardView.tag = 100;
    [cell.contentView addSubview:cardView];
    
    // 银行Logo
    UIImageView *bankLogo = [[UIImageView alloc] init];
    bankLogo.layer.cornerRadius = 30; // 60rpx -> 30pt
    bankLogo.clipsToBounds = YES;
    bankLogo.backgroundColor = [UIColor lightGrayColor];
    bankLogo.tag = 101;
    [cardView addSubview:bankLogo];
    
    // 银行信息容器
    UIView *bankInfo = [[UIView alloc] init];
    bankInfo.tag = 102;
    [cardView addSubview:bankInfo];
    
    // 银行名称
    UILabel *bankNameLabel = [[UILabel alloc] init];
    bankNameLabel.font = [UIFont systemFontOfSize:14]; // 28rpx -> 14pt
    bankNameLabel.textColor = [UIColor colorWithRed:0.208 green:0.224 blue:0.275 alpha:1.0]; // #353946
    bankNameLabel.tag = 103;
    [bankInfo addSubview:bankNameLabel];
    
    // 卡类型
    UILabel *cardTypeLabel = [[UILabel alloc] init];
    cardTypeLabel.font = [UIFont systemFontOfSize:12]; // 24rpx -> 12pt
    cardTypeLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.41 alpha:1.0]; // #666769
    cardTypeLabel.tag = 104;
    [bankInfo addSubview:cardTypeLabel];
    
    // 银行卡号
    UILabel *bankNumLabel = [[UILabel alloc] init];
    bankNumLabel.font = [UIFont systemFontOfSize:12]; // 24rpx -> 12pt
    bankNumLabel.textColor = [UIColor colorWithRed:0.208 green:0.224 blue:0.275 alpha:1.0]; // #353946
    bankNumLabel.tag = 105;
    [bankInfo addSubview:bankNumLabel];
    
    // 复选框（删除模式时显示）
    UIButton *checkbox = [UIButton buttonWithType:UIButtonTypeCustom];
    checkbox.tag = 106;
    [checkbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141_unselect"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"img_2a5bf1c39141"] forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:checkbox];
    
    // 设置约束
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView);
        make.left.right.equalTo(cell.contentView);
        make.bottom.equalTo(cell.contentView).offset(-15); // 30rpx -> 15pt
        make.height.mas_equalTo(75); // 150rpx -> 75pt
    }];
    
    [bankLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView);
        make.left.equalTo(cardView).offset(15); // 30rpx -> 15pt
        make.width.mas_equalTo(100); // 200rpx -> 100pt
        make.height.mas_equalTo(30); // 60rpx -> 30pt
    }];
    
    [bankInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(16);
        make.left.equalTo(bankLogo.mas_right).offset(10); // 20rpx -> 10pt
        make.right.equalTo(cardView).offset(-60);
    }];
    
    [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bankInfo);
        make.height.mas_equalTo(20);
    }];
    
    [bankNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankNameLabel.mas_bottom).offset(5);
        make.left.right.equalTo(bankInfo);
        make.height.mas_equalTo(16);
    }];
    
    [checkbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardView);
        make.right.equalTo(cardView).offset(-15); // 30rpx -> 15pt
        make.width.height.mas_equalTo(24);
    }];
}

- (void)configureBankCardCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    JJRBankCardModel *bankCard = self.bankList[indexPath.row];
    
    UIView *cardView = [cell.contentView viewWithTag:100];
    UIImageView *bankLogo = [cardView viewWithTag:101];
    UILabel *bankNameLabel = [cardView viewWithTag:103];
    UILabel *cardTypeLabel = [cardView viewWithTag:104];
    UILabel *bankNumLabel = [cardView viewWithTag:105];
    UIButton *checkbox = [cardView viewWithTag:106];
    
    // 设置银行Logo
    // 先清除之前的图片和背景
    bankLogo.image = nil;
    bankLogo.backgroundColor = [UIColor lightGrayColor]; // 默认占位色
    bankLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    if (bankCard.bankLogo && bankCard.bankLogo.length > 0) {
        // 使用异步加载网络图片
        NSURL *logoURL = [NSURL URLWithString:bankCard.bankLogo];
        if (logoURL) {
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:logoURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data && !error) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            bankLogo.image = image;
                            bankLogo.backgroundColor = [UIColor clearColor];
                        });
                    }
                }
            }];
            [task resume];
        }
    }
    
    // 银行名称和卡类型
    NSString *bankNameText = bankCard.bankName ?: @"未知银行";
    NSString *cardTypeText = bankCard.cardType ? [NSString stringWithFormat:@"(%@)", bankCard.cardType] : @"";
    
    NSMutableAttributedString *bankNameAttr = [[NSMutableAttributedString alloc] initWithString:bankNameText];
    if (cardTypeText.length > 0) {
        NSAttributedString *cardTypeAttr = [[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:cardTypeText] 
                                                                           attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.4 green:0.4 blue:0.41 alpha:1.0],
                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:12]}];
        [bankNameAttr appendAttributedString:cardTypeAttr];
    }
    bankNameLabel.attributedText = bankNameAttr;
    
    // 银行卡号
    bankNumLabel.text = bankCard.bankNo ?: @"";
    
    // 复选框状态
    checkbox.selected = bankCard.selected;
    checkbox.hidden = !self.showDelete;
}

- (void)checkboxTapped:(UIButton *)sender {
    UIView *cardView = sender.superview;
    UITableViewCell *cell = (UITableViewCell *)cardView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath) {
        JJRBankCardModel *bankCard = self.bankList[indexPath.row];
        bankCard.selected = !bankCard.selected;
        sender.selected = bankCard.selected;
    }
}

@end 
