//
//  JJRApplyRecordViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRApplyRecordViewController.h"
#import "JJRApplyRecordModel.h"
#import "JJRNetworkService.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface JJRApplyRecordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<JJRApplyRecordModel *> *records;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation JJRApplyRecordViewController

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
    self.title = @"申请记录";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    // 表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ApplyRecordCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = self.refreshControl;
}

- (void)loadData {
    [JJRNetworkService showLoading];
    
    [[JJRNetworkService sharedInstance] getApplyRecordWithSuccess:^(NSDictionary *responseObject) {
        [JJRNetworkService hideLoading];
        [self.refreshControl endRefreshing];
        
        if ([responseObject[@"code"] integerValue] == 200) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *records = [NSMutableArray array];
            
            for (NSDictionary *dict in data) {
                JJRApplyRecordModel *record = [JJRApplyRecordModel mj_objectWithKeyValues:dict];
                [records addObject:record];
            }
            
            self.records = [records copy];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyRecordCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    // 清除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    JJRApplyRecordModel *record = self.records[indexPath.row];
    
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
    
    // 申请编号
    UILabel *applyNoLabel = [[UILabel alloc] init];
    applyNoLabel.text = [NSString stringWithFormat:@"申请编号：%@", record.applyNo];
    applyNoLabel.font = [UIFont systemFontOfSize:14];
    applyNoLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:applyNoLabel];
    
    [applyNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(cardView).offset(15);
        make.right.equalTo(cardView).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    // 申请金额
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = [NSString stringWithFormat:@"申请金额：%@元", record.amount];
    amountLabel.font = [UIFont boldSystemFontOfSize:16];
    amountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [cardView addSubview:amountLabel];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyNoLabel.mas_bottom).offset(10);
        make.left.equalTo(cardView).offset(15);
        make.right.equalTo(cardView).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    // 借款期限
    UILabel *periodLabel = [[UILabel alloc] init];
    periodLabel.text = [NSString stringWithFormat:@"借款期限：%@", record.period];
    periodLabel.font = [UIFont systemFontOfSize:14];
    periodLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:periodLabel];
    
    [periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(8);
        make.left.equalTo(cardView).offset(15);
        make.width.equalTo(cardView).multipliedBy(0.5);
        make.height.mas_equalTo(20);
    }];
    
    // 借款用途
    UILabel *purposeLabel = [[UILabel alloc] init];
    purposeLabel.text = [NSString stringWithFormat:@"借款用途：%@", record.purpose];
    purposeLabel.font = [UIFont systemFontOfSize:14];
    purposeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:purposeLabel];
    
    [purposeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(8);
        make.right.equalTo(cardView).offset(-15);
        make.width.equalTo(cardView).multipliedBy(0.5);
        make.height.mas_equalTo(20);
    }];
    
    // 申请时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = [NSString stringWithFormat:@"申请时间：%@", record.createTime];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [cardView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(periodLabel.mas_bottom).offset(8);
        make.left.equalTo(cardView).offset(15);
        make.right.equalTo(cardView).offset(-15);
        make.height.mas_equalTo(15);
    }];
    
    // 状态标签
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = record.statusText;
    statusLabel.font = [UIFont systemFontOfSize:12];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.backgroundColor = [self getStatusColor:record.status];
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
    if ([status isEqualToString:@"pending"]) {
        return [UIColor colorWithHexString:@"#FF9500"];
    } else if ([status isEqualToString:@"approved"]) {
        return [UIColor colorWithHexString:@"#34C759"];
    } else if ([status isEqualToString:@"rejected"]) {
        return [UIColor colorWithHexString:@"#FF3B30"];
    } else {
        return [UIColor colorWithHexString:@"#999999"];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JJRApplyRecordModel *record = self.records[indexPath.row];
    // 跳转到详情页面
    [self showRecordDetail:record];
}

- (void)showRecordDetail:(JJRApplyRecordModel *)record {
    // 显示申请记录详情
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申请详情"
                                                                   message:[NSString stringWithFormat:@"申请编号：%@\n申请金额：%@元\n借款期限：%@\n借款用途：%@\n申请状态：%@\n申请时间：%@", record.applyNo, record.amount, record.period, record.purpose, record.statusText, record.createTime]
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
