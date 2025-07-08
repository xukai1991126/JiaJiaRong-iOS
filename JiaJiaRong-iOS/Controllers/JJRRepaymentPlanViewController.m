//
//  JJRRepaymentPlanViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRRepaymentPlanViewController.h"
#import "JJRRepaymentPlanModel.h"
#import "JJRNetworkService.h"

@interface JJRRepaymentPlanViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<JJRRepaymentPlanModel *> *plans;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *summaryView;
@property (nonatomic, strong) UILabel *totalAmountLabel;
@property (nonatomic, strong) UILabel *paidAmountLabel;
@property (nonatomic, strong) UILabel *remainingAmountLabel;

@end

@implementation JJRRepaymentPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)setupUI {
    self.title = @"还款计划";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    // 汇总视图
    [self setupSummaryView];
    
    // 表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RepaymentPlanCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryView.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // 下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
}

- (void)setupSummaryView {
    self.summaryView = [[UIView alloc] init];
    self.summaryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.summaryView];
    
    [self.summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    // 总金额
    UILabel *totalTitleLabel = [[UILabel alloc] init];
    totalTitleLabel.text = @"总金额";
    totalTitleLabel.font = [UIFont systemFontOfSize:12];
    totalTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    totalTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.summaryView addSubview:totalTitleLabel];
    
    self.totalAmountLabel = [[UILabel alloc] init];
    self.totalAmountLabel.text = @"0.00";
    self.totalAmountLabel.font = [UIFont boldSystemFontOfSize:18];
    self.totalAmountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.totalAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self.summaryView addSubview:self.totalAmountLabel];
    
    [totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryView).offset(15);
        make.left.equalTo(self.summaryView);
        make.width.equalTo(self.summaryView).multipliedBy(0.33);
        make.height.mas_equalTo(15);
    }];
    
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.summaryView);
        make.width.equalTo(self.summaryView).multipliedBy(0.33);
        make.height.mas_equalTo(25);
    }];
    
    // 已还金额
    UILabel *paidTitleLabel = [[UILabel alloc] init];
    paidTitleLabel.text = @"已还金额";
    paidTitleLabel.font = [UIFont systemFontOfSize:12];
    paidTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    paidTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.summaryView addSubview:paidTitleLabel];
    
    self.paidAmountLabel = [[UILabel alloc] init];
    self.paidAmountLabel.text = @"0.00";
    self.paidAmountLabel.font = [UIFont boldSystemFontOfSize:18];
    self.paidAmountLabel.textColor = [UIColor colorWithHexString:@"#34C759"];
    self.paidAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self.summaryView addSubview:self.paidAmountLabel];
    
    [paidTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryView).offset(15);
        make.centerX.equalTo(self.summaryView);
        make.width.equalTo(self.summaryView).multipliedBy(0.33);
        make.height.mas_equalTo(15);
    }];
    
    [self.paidAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paidTitleLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.summaryView);
        make.width.equalTo(self.summaryView).multipliedBy(0.33);
        make.height.mas_equalTo(25);
    }];
    
    // 剩余金额
    UILabel *remainingTitleLabel = [[UILabel alloc] init];
    remainingTitleLabel.text = @"剩余金额";
    remainingTitleLabel.font = [UIFont systemFontOfSize:12];
    remainingTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    remainingTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.summaryView addSubview:remainingTitleLabel];
    
    self.remainingAmountLabel = [[UILabel alloc] init];
    self.remainingAmountLabel.text = @"0.00";
    self.remainingAmountLabel.font = [UIFont boldSystemFontOfSize:18];
    self.remainingAmountLabel.textColor = [UIColor colorWithHexString:@"#FF3B30"];
    self.remainingAmountLabel.textAlignment = NSTextAlignmentCenter;
    [self.summaryView addSubview:self.remainingAmountLabel];
    
    [remainingTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.summaryView).offset(15);
        make.right.equalTo(self.summaryView);
        make.width.equalTo(self.summaryView).multipliedBy(0.33);
        make.height.mas_equalTo(15);
    }];
    
    [self.remainingAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remainingTitleLabel.mas_bottom).offset(5);
        make.right.equalTo(self.summaryView);
        make.width.equalTo(self.summaryView).multipliedBy(0.33);
        make.height.mas_equalTo(25);
    }];
}

- (void)loadData {
    [JJRNetworkService showLoading];
    
    [[JJRNetworkService sharedInstance] getRepaymentPlanWithSuccess:^(NSDictionary *responseObject) {
        [JJRNetworkService hideLoading];
        [self.refreshControl endRefreshing];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *plans = [NSMutableArray array];
            
            for (NSDictionary *dict in data) {
                JJRRepaymentPlanModel *plan = [JJRRepaymentPlanModel mj_objectWithKeyValues:dict];
                [plans addObject:plan];
            }
            
            self.plans = [plans copy];
            [self updateSummary];
            [self.tableView reloadData];
        } else {
            [self showToast:responseObject[@"msg"] ?: @"加载失败"];
        }
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [self.refreshControl endRefreshing];
        [self showToast:@"网络错误，请重试"];
    }];
}

- (void)refreshData {
    [self loadData];
}

- (void)updateSummary {
    CGFloat totalAmount = 0;
    CGFloat paidAmount = 0;
    
    for (JJRRepaymentPlanModel *plan in self.plans) {
        totalAmount += [plan.totalAmount floatValue];
        if ([plan.status isEqualToString:@"paid"]) {
            paidAmount += [plan.totalAmount floatValue];
        }
    }
    
    CGFloat remainingAmount = totalAmount - paidAmount;
    
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2f", totalAmount];
    self.paidAmountLabel.text = [NSString stringWithFormat:@"%.2f", paidAmount];
    self.remainingAmountLabel.text = [NSString stringWithFormat:@"%.2f", remainingAmount];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.plans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepaymentPlanCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    // 清除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    JJRRepaymentPlanModel *plan = self.plans[indexPath.row];
    
    // 创建卡片视图
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 8;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 4;
    [cell.contentView addSubview:cardView];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(15);
        make.top.bottom.equalTo(cell.contentView).inset(5);
    }];
    
    // 期数
    UILabel *periodLabel = [[UILabel alloc] init];
    periodLabel.text = [NSString stringWithFormat:@"第%@期", plan.period];
    periodLabel.font = [UIFont boldSystemFontOfSize:16];
    periodLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [cardView addSubview:periodLabel];
    
    [periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(cardView).offset(15);
        make.width.equalTo(cardView).multipliedBy(0.3);
        make.height.mas_equalTo(20);
    }];
    
    // 到期日期
    UILabel *dueDateLabel = [[UILabel alloc] init];
    dueDateLabel.text = [NSString stringWithFormat:@"到期日期：%@", plan.dueDate];
    dueDateLabel.font = [UIFont systemFontOfSize:12];
    dueDateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:dueDateLabel];
    
    [dueDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(periodLabel.mas_bottom).offset(8);
        make.left.equalTo(cardView).offset(15);
        make.right.equalTo(cardView).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    // 本金
    UILabel *principalLabel = [[UILabel alloc] init];
    principalLabel.text = [NSString stringWithFormat:@"本金：%@元", plan.principal];
    principalLabel.font = [UIFont systemFontOfSize:14];
    principalLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:principalLabel];
    
    [principalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dueDateLabel.mas_bottom).offset(8);
        make.left.equalTo(cardView).offset(15);
        make.width.equalTo(cardView).multipliedBy(0.5);
        make.height.mas_equalTo(20);
    }];
    
    // 利息
    UILabel *interestLabel = [[UILabel alloc] init];
    interestLabel.text = [NSString stringWithFormat:@"利息：%@元", plan.interest];
    interestLabel.font = [UIFont systemFontOfSize:14];
    interestLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:interestLabel];
    
    [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dueDateLabel.mas_bottom).offset(8);
        make.right.equalTo(cardView).offset(-15);
        make.width.equalTo(cardView).multipliedBy(0.5);
        make.height.mas_equalTo(20);
    }];
    
    // 总金额
    UILabel *totalAmountLabel = [[UILabel alloc] init];
    totalAmountLabel.text = [NSString stringWithFormat:@"总金额：%@元", plan.totalAmount];
    totalAmountLabel.font = [UIFont boldSystemFontOfSize:16];
    totalAmountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [cardView addSubview:totalAmountLabel];
    
    [totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(principalLabel.mas_bottom).offset(8);
        make.left.equalTo(cardView).offset(15);
        make.right.equalTo(cardView).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    // 状态标签
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = plan.statusText;
    statusLabel.font = [UIFont systemFontOfSize:12];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.backgroundColor = [self getStatusColor:plan.status];
    statusLabel.layer.cornerRadius = 10;
    statusLabel.clipsToBounds = YES;
    [cardView addSubview:statusLabel];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(15);
        make.right.equalTo(cardView).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    return cell;
}

- (UIColor *)getStatusColor:(NSString *)status {
    if ([status isEqualToString:@"paid"]) {
        return [UIColor colorWithHexString:@"#34C759"];
    } else if ([status isEqualToString:@"overdue"]) {
        return [UIColor colorWithHexString:@"#FF3B30"];
    } else if ([status isEqualToString:@"pending"]) {
        return [UIColor colorWithHexString:@"#FF9500"];
    } else {
        return [UIColor colorWithHexString:@"#999999"];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJRRepaymentPlanModel *plan = self.plans[indexPath.row];
    // 跳转到详情页面
    [self showPlanDetail:plan];
}

- (void)showPlanDetail:(JJRRepaymentPlanModel *)plan {
    // 显示还款计划详情
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"还款详情"
                                                                   message:[NSString stringWithFormat:@"期数：第%@期\n到期日期：%@\n本金：%@元\n利息：%@元\n总金额：%@元\n状态：%@", plan.period, plan.dueDate, plan.principal, plan.interest, plan.totalAmount, plan.statusText]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showToast:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

@end 