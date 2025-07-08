//
//  JJRApplyRecordViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRApplyRecordViewController.h"
#import "JJRNetworkService.h"
#import "JJRRepaymentPlanViewController.h"

@interface JJRApplyRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *applyRecords;
@property (nonatomic, strong) NSArray *statusTexts;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation JJRApplyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self fetchApplyRecords];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"申请记录";
    
    // 状态文本
    self.statusTexts = @[@"", @"放款中", @"放款成功", @"放款失败"];
    
    // 表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    // 加载指示器
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingView.center = self.view.center;
    [self.view addSubview:self.loadingView];
    
    // 空状态视图
    self.emptyView = [[UIView alloc] init];
    [self.view addSubview:self.emptyView];
    
    UIImageView *emptyImageView = [[UIImageView alloc] init];
    emptyImageView.image = [UIImage systemImageNamed:@"doc.text"];
    emptyImageView.tintColor = [UIColor lightGrayColor];
    [self.emptyView addSubview:emptyImageView];
    
    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.text = @"暂无数据";
    emptyLabel.font = [UIFont systemFontOfSize:16];
    emptyLabel.textColor = [UIColor lightGrayColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:emptyLabel];
    
    // 修改tableView约束，左右各15pt间距
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(self.emptyView);
        make.width.height.mas_equalTo(80);
    }];
    
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(emptyImageView.mas_bottom).offset(20);
    }];
    
    self.emptyView.hidden = YES;
}

- (void)setupData {
    self.applyRecords = @[];
}

- (void)fetchApplyRecords {
    [self.loadingView startAnimating];
    
    [[JJRNetworkService sharedInstance] getApplyRecordWithSuccess:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
            self.applyRecords = response[@"data"] ?: @[];
            [self updateUI];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
            [self showAlert:@"获取申请记录失败"];
        });
    }];
}

- (void)updateUI {
    if (self.applyRecords.count == 0) {
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.applyRecords.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; // 每个section只有一行，这样可以实现cell间距
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ApplyRecordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 15;
        cell.layer.masksToBounds = YES;
        
        // 状态视图
        UIView *statusView = [[UIView alloc] init];
        statusView.tag = 100;
        [cell.contentView addSubview:statusView];
        
        UIImageView *statusImageView = [[UIImageView alloc] init];
        statusImageView.tag = 101;
        [statusView addSubview:statusImageView];
        
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.tag = 102;
        statusLabel.font = [UIFont systemFontOfSize:14];
        [statusView addSubview:statusLabel];
        
        // 还款计划按钮
        UIButton *repaymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        repaymentButton.tag = 103;
        [repaymentButton setTitle:@"查询还款计划" forState:UIControlStateNormal];
        [repaymentButton setTitleColor:[UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        repaymentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:repaymentButton];
        
        // 金额信息视图
        UIView *amountView = [[UIView alloc] init];
        amountView.tag = 104;
        amountView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        amountView.layer.cornerRadius = 12;
        [cell.contentView addSubview:amountView];
        
        // 贷款金额
        UIView *loanAmountView = [[UIView alloc] init];
        loanAmountView.tag = 105;
        [amountView addSubview:loanAmountView];
        
        UILabel *loanAmountTitleLabel = [[UILabel alloc] init];
        loanAmountTitleLabel.tag = 106;
        loanAmountTitleLabel.text = @"贷款金额(元)";
        loanAmountTitleLabel.font = [UIFont systemFontOfSize:12];
        loanAmountTitleLabel.textColor = [UIColor lightGrayColor];
        loanAmountTitleLabel.textAlignment = NSTextAlignmentCenter;
        [loanAmountView addSubview:loanAmountTitleLabel];
        
        UILabel *loanAmountLabel = [[UILabel alloc] init];
        loanAmountLabel.tag = 107;
        loanAmountLabel.font = [UIFont boldSystemFontOfSize:18];
        loanAmountLabel.textColor = [UIColor colorWithRed:225.0/255.0 green:80.0/255.0 blue:0.0/255.0 alpha:1.0];
        loanAmountLabel.textAlignment = NSTextAlignmentCenter;
        [loanAmountView addSubview:loanAmountLabel];
        
        // 月利率
        UIView *rateView = [[UIView alloc] init];
        rateView.tag = 108;
        [amountView addSubview:rateView];
        
        UILabel *rateTitleLabel = [[UILabel alloc] init];
        rateTitleLabel.tag = 109;
        rateTitleLabel.text = @"月利率";
        rateTitleLabel.font = [UIFont systemFontOfSize:12];
        rateTitleLabel.textColor = [UIColor lightGrayColor];
        rateTitleLabel.textAlignment = NSTextAlignmentCenter;
        [rateView addSubview:rateTitleLabel];
        
        UILabel *rateLabel = [[UILabel alloc] init];
        rateLabel.tag = 110;
        rateLabel.font = [UIFont boldSystemFontOfSize:18];
        rateLabel.textColor = [UIColor colorWithRed:225.0/255.0 green:80.0/255.0 blue:0.0/255.0 alpha:1.0];
        rateLabel.textAlignment = NSTextAlignmentCenter;
        [rateView addSubview:rateLabel];
        
        // 分隔线
        UIView *separatorLine = [[UIView alloc] init];
        separatorLine.tag = 111;
        separatorLine.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
        [amountView addSubview:separatorLine];
        
        // 信息标签
        UILabel *applicantLabel = [[UILabel alloc] init];
        applicantLabel.tag = 112;
        applicantLabel.font = [UIFont systemFontOfSize:12];
        applicantLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
        [cell.contentView addSubview:applicantLabel];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.tag = 113;
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
        [cell.contentView addSubview:timeLabel];
        
        UILabel *remarkLabel = [[UILabel alloc] init];
        remarkLabel.tag = 114;
        remarkLabel.font = [UIFont systemFontOfSize:12];
        remarkLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
        remarkLabel.numberOfLines = 0;
        [cell.contentView addSubview:remarkLabel];
        
        // 设置约束
        [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(cell.contentView).offset(15);
            make.height.mas_equalTo(30);
        }];
        
        [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(statusView);
            make.width.height.mas_equalTo(20);
        }];
        
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusImageView.mas_right).offset(8);
            make.centerY.equalTo(statusView);
        }];
        
        [repaymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(statusView);
        }];
        
        [amountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(statusView.mas_bottom).offset(12);
            make.left.right.equalTo(cell.contentView).inset(15);
            make.height.mas_equalTo(80);
        }];
        
        [loanAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(amountView);
            make.right.equalTo(amountView.mas_centerX);
        }];
        
        [loanAmountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loanAmountView).offset(12);
            make.left.right.equalTo(loanAmountView);
        }];
        
        [loanAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(loanAmountTitleLabel.mas_bottom).offset(8);
            make.left.right.equalTo(loanAmountView);
        }];
        
        [rateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(amountView);
            make.left.equalTo(amountView.mas_centerX);
        }];
        
        [rateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rateView).offset(12);
            make.left.right.equalTo(rateView);
        }];
        
        [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rateTitleLabel.mas_bottom).offset(8);
            make.left.right.equalTo(rateView);
        }];
        
        [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(amountView);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(40);
        }];
        
        [applicantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(amountView.mas_bottom).offset(12);
            make.left.right.equalTo(cell.contentView).inset(15);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(applicantLabel.mas_bottom).offset(8);
            make.left.right.equalTo(cell.contentView).inset(15);
        }];
        
        [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom).offset(8);
            make.left.right.equalTo(cell.contentView).inset(15);
            make.bottom.equalTo(cell.contentView).offset(-15);
        }];
    }
    
    // 配置数据
    NSDictionary *record = self.applyRecords[indexPath.section]; // 改为section索引
    
    UIImageView *statusImageView = [cell.contentView viewWithTag:101];
    UILabel *statusLabel = [cell.contentView viewWithTag:102];
    UIButton *repaymentButton = [cell.contentView viewWithTag:103];
    UILabel *loanAmountLabel = [cell.contentView viewWithTag:107];
    UILabel *rateLabel = [cell.contentView viewWithTag:110];
    UILabel *applicantLabel = [cell.contentView viewWithTag:112];
    UILabel *timeLabel = [cell.contentView viewWithTag:113];
    UILabel *remarkLabel = [cell.contentView viewWithTag:114];
    
    // 设置状态
    NSInteger status = [record[@"stat"] integerValue];
    statusLabel.text = self.statusTexts[status];
    
    // 设置状态颜色和图标
    UIColor *statusColor;
    NSString *imageName;
    switch (status) {
        case 1:
            statusColor = [UIColor colorWithRed:12.0/255.0 green:89.0/255.0 blue:205.0/255.0 alpha:1.0];
            imageName = @"img_e37ba6e8d5cb";
            break;
        case 2:
            statusColor = [UIColor colorWithRed:82.0/255.0 green:205.0/255.0 blue:12.0/255.0 alpha:1.0];
            imageName = @"img_fa2686883e60";
            break;
        case 3:
            statusColor = [UIColor colorWithRed:240.0/255.0 green:2.0/255.0 blue:2.0/255.0 alpha:1.0];
            imageName = @"img_8e0b3be1e1de";
            break;
        default:
            statusColor = [UIColor blackColor];
            imageName = @"img_e37ba6e8d5cb"; // 默认使用放款中图片
            break;
    }
    
    statusLabel.textColor = statusColor;
    statusImageView.image = [UIImage imageNamed:imageName];
    // 不需要设置tintColor，因为使用的是彩色图片
    
    // 设置还款计划按钮
    repaymentButton.hidden = (status != 2);
    [repaymentButton addTarget:self action:@selector(repaymentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    repaymentButton.tag = indexPath.section; // 改为section索引
    
    // 设置金额信息
    loanAmountLabel.text = [NSString stringWithFormat:@"%@", record[@"loanAmount"]];
    rateLabel.text = [NSString stringWithFormat:@"%@", record[@"loanRate"]];
    
    // 设置其他信息
    applicantLabel.text = [NSString stringWithFormat:@"申请人员：%@", record[@"idName"] ?: @""];
    timeLabel.text = [NSString stringWithFormat:@"申请时间：%@", record[@"createTime"] ?: @""];
    remarkLabel.text = [NSString stringWithFormat:@"备注：%@", record[@"productRemark"] ?: @""];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 动态计算cell高度
    // 顶部状态区域: 30 + 15(top) = 45
    // 金额区域: 80 + 12(top) = 92
    // 申请人员: 20 + 12(top) = 32
    // 申请时间: 20 + 8(top) = 28
    // 备注: 20 + 8(top) = 28
    // 底部间距: 15
    // 总计: 45 + 92 + 32 + 28 + 28 + 15 = 240
    return 240;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // 每个section都有15pt的间距，包括第一个
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01; // 防止系统默认footer高度
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

#pragma mark - Actions

- (void)repaymentButtonTapped:(UIButton *)sender {
    NSDictionary *record = self.applyRecords[sender.tag]; // sender.tag现在是section索引
    NSString *loanNo = record[@"loanNo"];
    
    JJRRepaymentPlanViewController *vc = [[JJRRepaymentPlanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helper

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

