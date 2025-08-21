//
//  JJRLoanCalculatorViewController.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRLoanCalculatorViewController.h"
#import <Masonry/Masonry.h>

@interface JJRLoanCalculatorViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 输入区域
@property (nonatomic, strong) UITextField *amountField;
@property (nonatomic, strong) UITextField *rateField;
@property (nonatomic, strong) UITextField *termField;
@property (nonatomic, strong) UISegmentedControl *termTypeSegment;
@property (nonatomic, strong) UISegmentedControl *repaymentTypeSegment;

// 计算按钮
@property (nonatomic, strong) UIButton *calculateButton;

// 结果显示区域
@property (nonatomic, strong) UIView *resultView;
@property (nonatomic, strong) UILabel *monthlyPaymentLabel;
@property (nonatomic, strong) UILabel *totalPaymentLabel;
@property (nonatomic, strong) UILabel *totalInterestLabel;

// 还款计划表格
@property (nonatomic, strong) UITableView *planTableView;
@property (nonatomic, strong) NSArray *repaymentPlan;

@end

@implementation JJRLoanCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 🔧 隐藏底部 TabBar
    self.hidesBottomBarWhenPushed = YES;
    
    self.title = @"贷款计算器";
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
    
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    [self setupInputSection];
    [self setupResultSection];
    [self setupPlanTableView];
}

- (void)setupInputSection {
    UIView *inputSection = [[UIView alloc] init];
    inputSection.backgroundColor = [UIColor whiteColor];
    inputSection.layer.cornerRadius = 12;
    inputSection.layer.shadowColor = [UIColor blackColor].CGColor;
    inputSection.layer.shadowOffset = CGSizeMake(0, 2);
    inputSection.layer.shadowOpacity = 0.1;
    inputSection.layer.shadowRadius = 4;
    [self.contentView addSubview:inputSection];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"🧮 贷款参数设置";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [inputSection addSubview:titleLabel];
    
    // 贷款金额
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = @"贷款金额(元)";
    amountLabel.font = [UIFont systemFontOfSize:16];
    [inputSection addSubview:amountLabel];
    
    self.amountField = [[UITextField alloc] init];
    self.amountField.placeholder = @"请输入贷款金额";
    self.amountField.borderStyle = UITextBorderStyleRoundedRect;
    self.amountField.keyboardType = UIKeyboardTypeNumberPad;
    self.amountField.delegate = self;
    [inputSection addSubview:self.amountField];
    
    // 年利率
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.text = @"年利率(%)";
    rateLabel.font = [UIFont systemFontOfSize:16];
    [inputSection addSubview:rateLabel];
    
    self.rateField = [[UITextField alloc] init];
    self.rateField.placeholder = @"请输入年利率，如4.5";
    self.rateField.borderStyle = UITextBorderStyleRoundedRect;
    self.rateField.keyboardType = UIKeyboardTypeDecimalPad;
    self.rateField.delegate = self;
    [inputSection addSubview:self.rateField];
    
    // 贷款期限
    UILabel *termLabel = [[UILabel alloc] init];
    termLabel.text = @"贷款期限";
    termLabel.font = [UIFont systemFontOfSize:16];
    [inputSection addSubview:termLabel];
    
    self.termField = [[UITextField alloc] init];
    self.termField.placeholder = @"请输入期限数值";
    self.termField.borderStyle = UITextBorderStyleRoundedRect;
    self.termField.keyboardType = UIKeyboardTypeNumberPad;
    self.termField.delegate = self;
    [inputSection addSubview:self.termField];
    
    self.termTypeSegment = [[UISegmentedControl alloc] initWithItems:@[@"年", @"月"]];
    self.termTypeSegment.selectedSegmentIndex = 0;
    [inputSection addSubview:self.termTypeSegment];
    
    // 还款方式
    UILabel *repaymentLabel = [[UILabel alloc] init];
    repaymentLabel.text = @"还款方式";
    repaymentLabel.font = [UIFont systemFontOfSize:16];
    [inputSection addSubview:repaymentLabel];
    
    self.repaymentTypeSegment = [[UISegmentedControl alloc] initWithItems:@[@"等额本息", @"等额本金"]];
    self.repaymentTypeSegment.selectedSegmentIndex = 0;
    [inputSection addSubview:self.repaymentTypeSegment];
    
    // 计算按钮
    self.calculateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.calculateButton setTitle:@"开始计算" forState:UIControlStateNormal];
    [self.calculateButton setBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0]];
    self.calculateButton.layer.cornerRadius = 8;
    self.calculateButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.calculateButton addTarget:self action:@selector(calculateLoan) forControlEvents:UIControlEventTouchUpInside];
    [inputSection addSubview:self.calculateButton];
    
    // 布局
    [inputSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.contentView).offset(100); // 增加顶部间距避免导航栏遮挡
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(inputSection).offset(16);
    }];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputSection).offset(16);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];
    
    [self.amountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputSection).inset(16);
        make.top.equalTo(amountLabel.mas_bottom).offset(8);
        make.height.equalTo(@44);
    }];
    
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputSection).offset(16);
        make.top.equalTo(self.amountField.mas_bottom).offset(16);
    }];
    
    [self.rateField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputSection).inset(16);
        make.top.equalTo(rateLabel.mas_bottom).offset(8);
        make.height.equalTo(@44);
    }];
    
    [termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputSection).offset(16);
        make.top.equalTo(self.rateField.mas_bottom).offset(16);
    }];
    
    [self.termField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputSection).offset(16);
        make.top.equalTo(termLabel.mas_bottom).offset(8);
        make.right.equalTo(self.termTypeSegment.mas_left).offset(-8);
        make.height.equalTo(@44);
    }];
    
    [self.termTypeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputSection).offset(-16);
        make.centerY.equalTo(self.termField);
        make.width.equalTo(@100);
        make.height.equalTo(@32);
    }];
    
    [repaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputSection).offset(16);
        make.top.equalTo(self.termField.mas_bottom).offset(16);
    }];
    
    [self.repaymentTypeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputSection).inset(16);
        make.top.equalTo(repaymentLabel.mas_bottom).offset(8);
        make.height.equalTo(@32);
    }];
    
    [self.calculateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputSection).inset(16);
        make.top.equalTo(self.repaymentTypeSegment.mas_bottom).offset(20);
        make.bottom.equalTo(inputSection).offset(-16);
        make.height.equalTo(@50);
    }];
}

- (void)setupResultSection {
    self.resultView = [[UIView alloc] init];
    self.resultView.backgroundColor = [UIColor whiteColor];
    self.resultView.layer.cornerRadius = 12;
    self.resultView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.resultView.layer.shadowOffset = CGSizeMake(0, 2);
    self.resultView.layer.shadowOpacity = 0.1;
    self.resultView.layer.shadowRadius = 4;
    self.resultView.hidden = YES;
    [self.contentView addSubview:self.resultView];
    
    UILabel *resultTitleLabel = [[UILabel alloc] init];
    resultTitleLabel.text = @"📊 计算结果";
    resultTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    resultTitleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [self.resultView addSubview:resultTitleLabel];
    
    self.monthlyPaymentLabel = [[UILabel alloc] init];
    self.monthlyPaymentLabel.font = [UIFont boldSystemFontOfSize:16];
    self.monthlyPaymentLabel.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    [self.resultView addSubview:self.monthlyPaymentLabel];
    
    self.totalPaymentLabel = [[UILabel alloc] init];
    self.totalPaymentLabel.font = [UIFont systemFontOfSize:16];
    self.totalPaymentLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [self.resultView addSubview:self.totalPaymentLabel];
    
    self.totalInterestLabel = [[UILabel alloc] init];
    self.totalInterestLabel.font = [UIFont systemFontOfSize:16];
    self.totalInterestLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [self.resultView addSubview:self.totalInterestLabel];
    
    [resultTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.resultView).offset(16);
    }];
    
    [self.monthlyPaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.resultView).inset(16);
        make.top.equalTo(resultTitleLabel.mas_bottom).offset(16);
    }];
    
    [self.totalPaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.resultView).inset(16);
        make.top.equalTo(self.monthlyPaymentLabel.mas_bottom).offset(8);
    }];
    
    [self.totalInterestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.resultView).inset(16);
        make.top.equalTo(self.totalPaymentLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.resultView).offset(-16);
    }];
}

- (void)setupPlanTableView {
    self.planTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.planTableView.dataSource = self;
    self.planTableView.delegate = self;
    self.planTableView.backgroundColor = [UIColor whiteColor];
    self.planTableView.layer.cornerRadius = 12;
    self.planTableView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.planTableView.layer.shadowOffset = CGSizeMake(0, 2);
    self.planTableView.layer.shadowOpacity = 0.1;
    self.planTableView.layer.shadowRadius = 4;
    self.planTableView.hidden = YES;
    [self.contentView addSubview:self.planTableView];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.contentView.subviews.firstObject.mas_bottom).offset(16);
    }];
    
    [self.planTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.resultView.mas_bottom).offset(16);
        make.height.equalTo(@300);
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
}

- (void)calculateLoan {
    if (![self validateInput]) {
        return;
    }
    
    CGFloat amount = [self.amountField.text floatValue];
    CGFloat annualRate = [self.rateField.text floatValue] / 100.0;
    NSInteger term = [self.termField.text integerValue];
    
    // 转换为月数
    if (self.termTypeSegment.selectedSegmentIndex == 0) {
        term = term * 12;
    }
    
    CGFloat monthlyRate = annualRate / 12.0;
    BOOL isEqualPayment = (self.repaymentTypeSegment.selectedSegmentIndex == 0);
    
    NSMutableArray *plan = [NSMutableArray array];
    CGFloat totalPayment = 0;
    CGFloat totalInterest = 0;
    
    if (isEqualPayment) {
        // 等额本息
        CGFloat monthlyPayment = amount * (monthlyRate * pow(1 + monthlyRate, term)) / (pow(1 + monthlyRate, term) - 1);
        totalPayment = monthlyPayment * term;
        totalInterest = totalPayment - amount;
        
        CGFloat remainingAmount = amount;
        for (int i = 1; i <= term; i++) {
            CGFloat interestPayment = remainingAmount * monthlyRate;
            CGFloat principalPayment = monthlyPayment - interestPayment;
            remainingAmount -= principalPayment;
            
            NSDictionary *monthData = @{
                @"month": @(i),
                @"monthlyPayment": @(monthlyPayment),
                @"principalPayment": @(principalPayment),
                @"interestPayment": @(interestPayment),
                @"remainingAmount": @(MAX(0, remainingAmount))
            };
            [plan addObject:monthData];
        }
        
        self.monthlyPaymentLabel.text = [NSString stringWithFormat:@"月还款额：¥%.2f", monthlyPayment];
    } else {
        // 等额本金
        CGFloat principalPayment = amount / term;
        
        for (int i = 1; i <= term; i++) {
            CGFloat remainingAmount = amount - principalPayment * (i - 1);
            CGFloat interestPayment = remainingAmount * monthlyRate;
            CGFloat monthlyPayment = principalPayment + interestPayment;
            totalPayment += monthlyPayment;
            totalInterest += interestPayment;
            
            NSDictionary *monthData = @{
                @"month": @(i),
                @"monthlyPayment": @(monthlyPayment),
                @"principalPayment": @(principalPayment),
                @"interestPayment": @(interestPayment),
                @"remainingAmount": @(amount - principalPayment * i)
            };
            [plan addObject:monthData];
        }
        
        CGFloat firstMonthPayment = [[plan.firstObject objectForKey:@"monthlyPayment"] floatValue];
        CGFloat lastMonthPayment = [[plan.lastObject objectForKey:@"monthlyPayment"] floatValue];
        self.monthlyPaymentLabel.text = [NSString stringWithFormat:@"首月还款：¥%.2f，末月还款：¥%.2f", firstMonthPayment, lastMonthPayment];
    }
    
    self.totalPaymentLabel.text = [NSString stringWithFormat:@"还款总额：¥%.2f", totalPayment];
    self.totalInterestLabel.text = [NSString stringWithFormat:@"利息总额：¥%.2f", totalInterest];
    
    self.repaymentPlan = [plan copy];
    
    // 显示结果
    self.resultView.hidden = NO;
    self.planTableView.hidden = NO;
    [self.planTableView reloadData];
    
    // 滚动到结果区域
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.adjustedContentInset.bottom);
        if (bottomOffset.y > 0) {
            [self.scrollView setContentOffset:bottomOffset animated:NO];
        }
    }];
}

- (BOOL)validateInput {
    if (self.amountField.text.length == 0 || [self.amountField.text floatValue] <= 0) {
        [self showAlert:@"请输入有效的贷款金额"];
        return NO;
    }
    
    if (self.rateField.text.length == 0 || [self.rateField.text floatValue] <= 0) {
        [self showAlert:@"请输入有效的年利率"];
        return NO;
    }
    
    if (self.termField.text.length == 0 || [self.termField.text integerValue] <= 0) {
        [self showAlert:@"请输入有效的贷款期限"];
        return NO;
    }
    
    return YES;
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(12, self.repaymentPlan.count); // 只显示前12期
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"PlanCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    NSDictionary *monthData = self.repaymentPlan[indexPath.row];
    NSInteger month = [[monthData objectForKey:@"month"] integerValue];
    CGFloat monthlyPayment = [[monthData objectForKey:@"monthlyPayment"] floatValue];
    CGFloat principalPayment = [[monthData objectForKey:@"principalPayment"] floatValue];
    CGFloat interestPayment = [[monthData objectForKey:@"interestPayment"] floatValue];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld期：¥%.2f", (long)month, monthlyPayment];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"本金：¥%.2f  利息：¥%.2f", principalPayment, interestPayment];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"还款计划表（前12期）";
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end 
