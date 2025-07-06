#import "RepaymentPlanViewController.h"
#import "NetworkService.h"
#import <Masonry/Masonry.h>

@interface RepaymentPlanViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *totalAmountLabel;
@property (nonatomic, strong) UILabel *totalAmountValueLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *repaymentList;
@property (nonatomic, assign) double totalAmount;
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation RepaymentPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self fetchRepaymentPlan];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"还款计划";
    
    // 头部视图
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.headerView.layer.cornerRadius = 16;
    [self.view addSubview:self.headerView];
    
    // 总金额标题
    self.totalAmountLabel = [[UILabel alloc] init];
    self.totalAmountLabel.text = @"全部待还(元)";
    self.totalAmountLabel.font = [UIFont systemFontOfSize:14];
    self.totalAmountLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:self.totalAmountLabel];
    
    // 总金额数值
    self.totalAmountValueLabel = [[UILabel alloc] init];
    self.totalAmountValueLabel.text = @"0.00";
    self.totalAmountValueLabel.font = [UIFont boldSystemFontOfSize:26];
    self.totalAmountValueLabel.textColor = [UIColor whiteColor];
    [self.headerView addSubview:self.totalAmountValueLabel];
    
    // 表格视图
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    // 空状态视图
    self.emptyView = [[UIView alloc] init];
    [self.view addSubview:self.emptyView];
    
    UIImageView *emptyImageView = [[UIImageView alloc] init];
    emptyImageView.image = [UIImage systemImageNamed:@"creditcard"];
    emptyImageView.tintColor = [UIColor lightGrayColor];
    [self.emptyView addSubview:emptyImageView];
    
    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.text = @"没有还款金额";
    emptyLabel.font = [UIFont systemFontOfSize:16];
    emptyLabel.textColor = [UIColor lightGrayColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:emptyLabel];
    
    // 设置约束
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view).inset(20);
        make.height.mas_equalTo(100);
    }];
    
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(20);
        make.top.equalTo(self.headerView).offset(20);
    }];
    
    [self.totalAmountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(20);
        make.top.equalTo(self.totalAmountLabel.mas_bottom).offset(10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    
    [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(self.emptyView);
        make.width.height.mas_equalTo(100);
    }];
    
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(emptyImageView.mas_bottom).offset(20);
    }];
    
    self.emptyView.hidden = YES;
}

- (void)fetchRepaymentPlan {
    if (!self.loanNo) {
        [self showAlert:@"贷款编号不能为空"];
        return;
    }
    
    [NetworkService showLoading];
    
    NSDictionary *params = @{@"loanNo": self.loanNo};
    [[NetworkService sharedInstance] POST:@"/app/userinfo/repayment/list" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleRepaymentData:response[@"data"] ?: @[]];
        });
    } failure:^(NSError *error) {
        [NetworkService hideLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:@"获取还款计划失败"];
        });
    }];
}

- (void)handleRepaymentData:(NSArray *)data {
    if (data.count == 0) {
        self.repaymentList = @[];
        self.emptyView.hidden = NO;
        self.tableView.hidden = YES;
        return;
    }
    
    // 处理数据，添加选中状态
    NSMutableArray *processedData = [NSMutableArray array];
    self.totalAmount = 0;
    
    for (NSDictionary *item in data) {
        NSMutableDictionary *processedItem = [NSMutableDictionary dictionaryWithDictionary:item];
        processedItem[@"selected"] = @NO;
        [processedData addObject:processedItem];
        
        // 计算总金额（只计算未还款的）
        if ([item[@"status"] integerValue] == 1) {
            self.totalAmount += [item[@"totalAmt"] doubleValue];
        }
    }
    
    // 默认展开第一项
    if (processedData.count > 0) {
        processedData[0][@"selected"] = @YES;
    }
    
    self.repaymentList = processedData;
    self.totalAmountValueLabel.text = [NSString stringWithFormat:@"%.2f", self.totalAmount];
    
    self.emptyView.hidden = YES;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repaymentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RepaymentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.cornerRadius = 12;
        cell.layer.masksToBounds = YES;
        
        // 还款日期
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.tag = 100;
        dateLabel.font = [UIFont systemFontOfSize:14];
        dateLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:dateLabel];
        
        // 应还金额
        UILabel *amountLabel = [[UILabel alloc] init];
        amountLabel.tag = 101;
        amountLabel.font = [UIFont boldSystemFontOfSize:16];
        amountLabel.textColor = [UIColor colorWithRed:225.0/255.0 green:80.0/255.0 blue:0.0/255.0 alpha:1.0];
        [cell.contentView addSubview:amountLabel];
        
        // 箭头
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.tag = 102;
        arrowImageView.image = [UIImage systemImageNamed:@"chevron.down"];
        arrowImageView.tintColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:arrowImageView];
        
        // 详细信息容器
        UIView *detailContainer = [[UIView alloc] init];
        detailContainer.tag = 103;
        detailContainer.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        detailContainer.layer.cornerRadius = 8;
        [cell.contentView addSubview:detailContainer];
        
        // 统计周期
        UILabel *periodLabel = [[UILabel alloc] init];
        periodLabel.tag = 104;
        periodLabel.font = [UIFont systemFontOfSize:12];
        periodLabel.textColor = [UIColor lightGrayColor];
        [detailContainer addSubview:periodLabel];
        
        // 还款日
        UILabel *payDateLabel = [[UILabel alloc] init];
        payDateLabel.tag = 105;
        payDateLabel.font = [UIFont systemFontOfSize:12];
        payDateLabel.textColor = [UIColor lightGrayColor];
        [detailContainer addSubview:payDateLabel];
        
        // 费用明细
        UILabel *principalLabel = [[UILabel alloc] init];
        principalLabel.tag = 106;
        principalLabel.font = [UIFont systemFontOfSize:12];
        [detailContainer addSubview:principalLabel];
        
        UILabel *interestLabel = [[UILabel alloc] init];
        interestLabel.tag = 107;
        interestLabel.font = [UIFont systemFontOfSize:12];
        [detailContainer addSubview:interestLabel];
        
        UILabel *serviceFeeLabel = [[UILabel alloc] init];
        serviceFeeLabel.tag = 108;
        serviceFeeLabel.font = [UIFont systemFontOfSize:12];
        [detailContainer addSubview:serviceFeeLabel];
        
        UILabel *guaranteeFeeLabel = [[UILabel alloc] init];
        guaranteeFeeLabel.tag = 109;
        guaranteeFeeLabel.font = [UIFont systemFontOfSize:12];
        [detailContainer addSubview:guaranteeFeeLabel];
        
        UILabel *otherFeeLabel = [[UILabel alloc] init];
        otherFeeLabel.tag = 110;
        otherFeeLabel.font = [UIFont systemFontOfSize:12];
        [detailContainer addSubview:otherFeeLabel];
        
        // 设置约束
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.top.equalTo(cell.contentView).offset(15);
        }];
        
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
            make.top.equalTo(dateLabel.mas_bottom).offset(5);
        }];
        
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
            make.width.height.mas_equalTo(20);
        }];
        
        [detailContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(amountLabel.mas_bottom).offset(15);
            make.left.right.equalTo(cell.contentView).inset(15);
            make.bottom.equalTo(cell.contentView).offset(-15);
        }];
        
        [periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(detailContainer).offset(10);
        }];
        
        [payDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(periodLabel.mas_bottom).offset(5);
            make.left.equalTo(detailContainer).offset(10);
        }];
        
        [principalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(payDateLabel.mas_bottom).offset(10);
            make.left.right.equalTo(detailContainer).inset(10);
        }];
        
        [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(principalLabel.mas_bottom).offset(5);
            make.left.right.equalTo(detailContainer).inset(10);
        }];
        
        [serviceFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(interestLabel.mas_bottom).offset(5);
            make.left.right.equalTo(detailContainer).inset(10);
        }];
        
        [guaranteeFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(serviceFeeLabel.mas_bottom).offset(5);
            make.left.right.equalTo(detailContainer).inset(10);
        }];
        
        [otherFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(guaranteeFeeLabel.mas_bottom).offset(5);
            make.left.right.equalTo(detailContainer).inset(10);
        }];
    }
    
    // 配置数据
    NSDictionary *item = self.repaymentList[indexPath.row];
    
    UILabel *dateLabel = [cell.contentView viewWithTag:100];
    UILabel *amountLabel = [cell.contentView viewWithTag:101];
    UIImageView *arrowImageView = [cell.contentView viewWithTag:102];
    UIView *detailContainer = [cell.contentView viewWithTag:103];
    UILabel *periodLabel = [cell.contentView viewWithTag:104];
    UILabel *payDateLabel = [cell.contentView viewWithTag:105];
    UILabel *principalLabel = [cell.contentView viewWithTag:106];
    UILabel *interestLabel = [cell.contentView viewWithTag:107];
    UILabel *serviceFeeLabel = [cell.contentView viewWithTag:108];
    UILabel *guaranteeFeeLabel = [cell.contentView viewWithTag:109];
    UILabel *otherFeeLabel = [cell.contentView viewWithTag:110];
    
    // 设置基本信息
    dateLabel.text = [NSString stringWithFormat:@"还款日：%@", item[@"payDate"] ?: @""];
    amountLabel.text = [NSString stringWithFormat:@"应还金额：%.2f", [item[@"totalAmt"] doubleValue]];
    
    // 设置展开/收起状态
    BOOL isSelected = [item[@"selected"] boolValue];
    arrowImageView.image = [UIImage systemImageNamed:isSelected ? @"chevron.up" : @"chevron.down"];
    detailContainer.hidden = !isSelected;
    
    if (isSelected) {
        // 设置详细信息
        NSString *payDate = item[@"payDate"] ?: @"";
        NSString *nextMonth = [self addOneMonth:payDate];
        periodLabel.text = [NSString stringWithFormat:@"统计周期：%@至%@", payDate, nextMonth];
        payDateLabel.text = [NSString stringWithFormat:@"本期还款日：%@", payDate];
        
        principalLabel.text = [NSString stringWithFormat:@"应还本金：%.2f", [item[@"totalAmt"] doubleValue]];
        interestLabel.text = [NSString stringWithFormat:@"应还利息：%.2f", [item[@"interest"] doubleValue]];
        serviceFeeLabel.text = [NSString stringWithFormat:@"服务费：%.2f", [item[@"serviceFee"] doubleValue]];
        guaranteeFeeLabel.text = [NSString stringWithFormat:@"担保费：%.2f", [item[@"guaranteeFee"] doubleValue]];
        otherFeeLabel.text = [NSString stringWithFormat:@"其他费用：%.2f", [item[@"otherFee"] doubleValue]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = self.repaymentList[indexPath.row];
    BOOL isSelected = [item[@"selected"] boolValue];
    return isSelected ? 280 : 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 切换展开/收起状态
    NSMutableArray *mutableList = [NSMutableArray arrayWithArray:self.repaymentList];
    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:mutableList[indexPath.row]];
    item[@"selected"] = @(![item[@"selected"] boolValue]);
    mutableList[indexPath.row] = item;
    self.repaymentList = mutableList;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Helper

- (NSString *)addOneMonth:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonth = [calendar dateByAddingComponents:components toDate:date options:0];
    
    return [formatter stringFromDate:nextMonth];
}

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