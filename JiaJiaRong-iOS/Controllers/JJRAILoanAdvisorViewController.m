//
//  JJRAILoanAdvisorViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAILoanAdvisorViewController.h"
#import "JJRAILoanAdvisorViewModel.h"
#import "JJRAILoanAdvice.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface JJRAILoanAdviceCell : UITableViewCell
@property (nonatomic, strong) JJRAILoanAdvice *advice;
@property (nonatomic, strong) JJRAILoanAdvisorViewModel *viewModel;
@end

@interface JJRAILoanAdvisorViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, JJRBaseViewModelDelegate>

@property (nonatomic, strong) JJRAILoanAdvisorViewModel *viewModel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *inputSection;
@property (nonatomic, strong) UIView *resultSection;
@property (nonatomic, strong) UITableView *tableView;

// 输入控件
@property (nonatomic, strong) UITextField *incomeField;
@property (nonatomic, strong) UITextField *expenseField;
@property (nonatomic, strong) UITextField *debtField;
@property (nonatomic, strong) UITextField *creditScoreField;
@property (nonatomic, strong) UITextField *ageField;
@property (nonatomic, strong) UITextField *occupationField;
@property (nonatomic, strong) UITextField *workYearsField;
@property (nonatomic, strong) UITextField *assetsField;
@property (nonatomic, strong) UITextField *loanPurposeField;
@property (nonatomic, strong) UISegmentedControl *employmentTypeSegment;
@property (nonatomic, strong) UISwitch *houseSwitch;
@property (nonatomic, strong) UISwitch *carSwitch;

@property (nonatomic, strong) UIButton *analyzeButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JJRAILoanAdvisorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AI智能贷款顾问";
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
    
    [self setupViewModel];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupViewModel {
    self.viewModel = [[JJRAILoanAdvisorViewModel alloc] init];
    self.viewModel.delegate = self;
}

- (void)setupUI {
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"请填写您的基本信息，AI将为您提供个性化贷款建议";
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    // 输入部分
    [self setupInputSection];
    
    // 分析按钮
    self.analyzeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.analyzeButton setTitle:@"获取AI智能建议" forState:UIControlStateNormal];
    [self.analyzeButton setBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0]];
    self.analyzeButton.layer.cornerRadius = 8;
    self.analyzeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.analyzeButton addTarget:self action:@selector(analyzeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.analyzeButton];
    
    // 结果表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.hidden = YES;
    [self.contentView addSubview:self.tableView];
}

- (void)setupInputSection {
    self.inputSection = [[UIView alloc] init];
    self.inputSection.backgroundColor = [UIColor whiteColor];
    self.inputSection.layer.cornerRadius = 12;
    self.inputSection.layer.shadowColor = [UIColor blackColor].CGColor;
    self.inputSection.layer.shadowOffset = CGSizeMake(0, 2);
    self.inputSection.layer.shadowOpacity = 0.1;
    self.inputSection.layer.shadowRadius = 4;
    [self.contentView addSubview:self.inputSection];
    
    NSArray *fieldConfigs = @[
        @{@"title": @"月收入(元)", @"placeholder": @"请输入您的月收入", @"keyboardType": @(UIKeyboardTypeNumberPad)},
        @{@"title": @"月支出(元)", @"placeholder": @"请输入您的月支出", @"keyboardType": @(UIKeyboardTypeNumberPad)},
        @{@"title": @"当前负债(元)", @"placeholder": @"请输入您的当前负债", @"keyboardType": @(UIKeyboardTypeNumberPad)},
        @{@"title": @"信用评分", @"placeholder": @"请输入您的信用评分(300-850)", @"keyboardType": @(UIKeyboardTypeNumberPad)},
        @{@"title": @"年龄", @"placeholder": @"请输入您的年龄", @"keyboardType": @(UIKeyboardTypeNumberPad)},
        @{@"title": @"职业", @"placeholder": @"请输入您的职业", @"keyboardType": @(UIKeyboardTypeDefault)},
        @{@"title": @"工作年限", @"placeholder": @"请输入工作年限", @"keyboardType": @(UIKeyboardTypeNumberPad)},
        @{@"title": @"总资产(元)", @"placeholder": @"请输入您的总资产", @"keyboardType": @(UIKeyboardTypeNumberPad)},
        @{@"title": @"贷款用途", @"placeholder": @"请输入贷款用途", @"keyboardType": @(UIKeyboardTypeDefault)}
    ];
    
    NSArray *textFields = @[@"incomeField", @"expenseField", @"debtField", @"creditScoreField", 
                           @"ageField", @"occupationField", @"workYearsField", @"assetsField", @"loanPurposeField"];
    
    UIView *lastView = nil;
    
    for (int i = 0; i < fieldConfigs.count; i++) {
        NSDictionary *config = fieldConfigs[i];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = config[@"title"];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        [self.inputSection addSubview:label];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = config[@"placeholder"];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = [config[@"keyboardType"] integerValue];
        textField.delegate = self;
        [self.inputSection addSubview:textField];
        
        // 设置textField属性
        [self setValue:textField forKey:textFields[i]];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputSection).offset(20);
            make.right.equalTo(self.inputSection).offset(-20);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(20);
            } else {
                make.top.equalTo(self.inputSection).offset(20);
            }
        }];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(label);
            make.top.equalTo(label.mas_bottom).offset(8);
            make.height.equalTo(@44);
        }];
        
        lastView = textField;
    }
    
    // 就业类型选择器
    UILabel *employmentLabel = [[UILabel alloc] init];
    employmentLabel.text = @"就业类型";
    employmentLabel.font = [UIFont systemFontOfSize:16];
    employmentLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [self.inputSection addSubview:employmentLabel];
    
    self.employmentTypeSegment = [[UISegmentedControl alloc] initWithItems:@[@"企业员工", @"公务员", @"个体经营", @"企业主"]];
    self.employmentTypeSegment.selectedSegmentIndex = 0;
    [self.inputSection addSubview:self.employmentTypeSegment];
    
    [employmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inputSection).inset(20);
        make.top.equalTo(lastView.mas_bottom).offset(20);
    }];
    
    [self.employmentTypeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(employmentLabel);
        make.top.equalTo(employmentLabel.mas_bottom).offset(8);
        make.height.equalTo(@32);
    }];
    
    // 房产车辆开关
    UIView *assetView = [[UIView alloc] init];
    [self.inputSection addSubview:assetView];
    
    UILabel *houseLabel = [[UILabel alloc] init];
    houseLabel.text = @"是否有房产";
    houseLabel.font = [UIFont systemFontOfSize:16];
    [assetView addSubview:houseLabel];
    
    self.houseSwitch = [[UISwitch alloc] init];
    [assetView addSubview:self.houseSwitch];
    
    UILabel *carLabel = [[UILabel alloc] init];
    carLabel.text = @"是否有车辆";
    carLabel.font = [UIFont systemFontOfSize:16];
    [assetView addSubview:carLabel];
    
    self.carSwitch = [[UISwitch alloc] init];
    [assetView addSubview:self.carSwitch];
    
    [assetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inputSection).inset(20);
        make.top.equalTo(self.employmentTypeSegment.mas_bottom).offset(20);
        make.bottom.equalTo(self.inputSection).offset(-20);
        make.height.equalTo(@60);
    }];
    
    [houseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(assetView);
        make.top.equalTo(assetView);
    }];
    
    [self.houseSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(assetView);
        make.top.equalTo(assetView);
    }];
    
    [carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(assetView);
        make.bottom.equalTo(assetView);
    }];
    
    [self.carSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(assetView);
        make.bottom.equalTo(assetView);
    }];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(20);
        make.top.equalTo(self.contentView).offset(20);
    }];
    
    [self.inputSection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    
    [self.analyzeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.inputSection.mas_bottom).offset(30);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.analyzeButton.mas_bottom).offset(20);
        make.height.equalTo(@600);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

#pragma mark - Actions

- (void)analyzeButtonTapped {
    if (![self validateInput]) {
        return;
    }
    
    JJRAIUserProfile *profile = [self createUserProfileFromInput];
    [self.viewModel updateUserProfile:profile];
    [self.viewModel generateLoanAdvices];
}

- (BOOL)validateInput {
    if (self.incomeField.text.length == 0) {
        [self showAlert:@"请输入月收入"];
        return NO;
    }
    
    if (self.creditScoreField.text.length == 0) {
        [self showAlert:@"请输入信用评分"];
        return NO;
    }
    
    NSInteger creditScore = [self.creditScoreField.text integerValue];
    if (creditScore < 300 || creditScore > 850) {
        [self showAlert:@"信用评分范围应在300-850之间"];
        return NO;
    }
    
    return YES;
}

- (JJRAIUserProfile *)createUserProfileFromInput {
    JJRAIUserProfile *profile = [[JJRAIUserProfile alloc] init];
    
    profile.monthlyIncome = @([self.incomeField.text floatValue]);
    profile.monthlyExpense = @([self.expenseField.text floatValue]);
    profile.currentDebt = @([self.debtField.text floatValue]);
    profile.creditScore = @([self.creditScoreField.text floatValue]);
    profile.age = [self.ageField.text integerValue];
    profile.occupation = self.occupationField.text;
    profile.workYears = [self.workYearsField.text integerValue];
    profile.assets = @([self.assetsField.text floatValue]);
    profile.loanPurpose = self.loanPurposeField.text;
    profile.hasHouse = self.houseSwitch.isOn;
    profile.hasCar = self.carSwitch.isOn;
    
    NSArray *employmentTypes = @[@"企业员工", @"公务员", @"个体经营", @"企业主"];
    profile.employmentType = employmentTypes[self.employmentTypeSegment.selectedSegmentIndex];
    
    return profile;
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - JJRBaseViewModelDelegate

- (void)viewModelDidStartLoading {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewModelDidFinishLoading {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewModelDidUpdateData {
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    
    // 滚动到结果区域
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.adjustedContentInset.bottom);
        if (bottomOffset.y > 0) {
            [self.scrollView setContentOffset:bottomOffset animated:NO];
        }
    }];
}

- (void)viewModelDidFailWithError:(NSError *)error {
    [self showAlert:error.localizedDescription];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.loanAdvices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"JJRAILoanAdviceCell";
    JJRAILoanAdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[JJRAILoanAdviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.advice = self.viewModel.loanAdvices[indexPath.row];
    cell.viewModel = self.viewModel;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JJRAILoanAdvice *advice = self.viewModel.loanAdvices[indexPath.row];
    [self showLoanDetailWithAdvice:advice];
}

- (void)showLoanDetailWithAdvice:(JJRAILoanAdvice *)advice {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"贷款详情" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *detail = [NSString stringWithFormat:@"推荐金额：%@\n贷款期限：%ld个月\n利率：%@\n月还款：%@\n\n推荐理由：\n%@\n\n风险分析：\n%@",
                       [self.viewModel formatAmount:advice.recommendedAmount],
                       (long)advice.recommendedTerm,
                       [self.viewModel formatInterestRate:advice.interestRate],
                       [self.viewModel formatAmount:advice.monthlyPayment],
                       advice.reason,
                       advice.riskAnalysis];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    textView.text = detail;
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:14];
    
    [alert setValue:textView forKey:@"contentViewController"];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"查看还款计划" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showRepaymentPlanWithAdvice:advice];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showRepaymentPlanWithAdvice:(JJRAILoanAdvice *)advice {
    NSArray *plan = [self.viewModel calculateRepaymentPlan:advice];
    
    NSMutableString *planText = [NSMutableString stringWithFormat:@"%@还款计划\n\n", [self.viewModel loanTypeDescription:advice.loanType]];
    
    for (int i = 0; i < MIN(6, plan.count); i++) {
        NSDictionary *month = plan[i];
        [planText appendFormat:@"第%@期：还款%@元\n", month[@"month"], [self.viewModel formatAmount:month[@"monthlyPayment"]]];
    }
    
    if (plan.count > 6) {
        [planText appendString:@"...\n(显示前6期，实际按计划执行)"];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"还款计划" message:planText preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

#pragma mark - JJRAILoanAdviceCell

@implementation JJRAILoanAdviceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 12;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 8;
    [self.contentView addSubview:cardView];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.bottom.equalTo(self.contentView).inset(8);
    }];
}

- (void)setAdvice:(JJRAILoanAdvice *)advice {
    _advice = advice;
    [self updateUI];
}

- (void)updateUI {
    // 清除之前的子视图
    for (UIView *view in self.contentView.subviews.firstObject.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *cardView = self.contentView.subviews.firstObject;
    
    // 类型标签
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.text = [self.viewModel loanTypeDescription:self.advice.loanType];
    typeLabel.font = [UIFont boldSystemFontOfSize:18];
    typeLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    [cardView addSubview:typeLabel];
    
    // 推荐标识
    if (self.advice.confidence > 0.7) {
        UILabel *recommendLabel = [[UILabel alloc] init];
        recommendLabel.text = @"AI推荐";
        recommendLabel.font = [UIFont systemFontOfSize:12];
        recommendLabel.textColor = [UIColor whiteColor];
        recommendLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
        recommendLabel.textAlignment = NSTextAlignmentCenter;
        recommendLabel.layer.cornerRadius = 8;
        recommendLabel.layer.masksToBounds = YES;
        [cardView addSubview:recommendLabel];
        
        [recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cardView).offset(-16);
            make.top.equalTo(cardView).offset(16);
            make.width.equalTo(@60);
            make.height.equalTo(@24);
        }];
    }
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(cardView).offset(16);
    }];
    
    // 金额和期限
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = [NSString stringWithFormat:@"推荐金额：%@", [self.viewModel formatAmount:self.advice.recommendedAmount]];
    amountLabel.font = [UIFont systemFontOfSize:16];
    amountLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [cardView addSubview:amountLabel];
    
    UILabel *termLabel = [[UILabel alloc] init];
    termLabel.text = [NSString stringWithFormat:@"期限：%ld个月", (long)self.advice.recommendedTerm];
    termLabel.font = [UIFont systemFontOfSize:16];
    termLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [cardView addSubview:termLabel];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(typeLabel.mas_bottom).offset(12);
    }];
    
    [termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(amountLabel.mas_bottom).offset(8);
    }];
    
    // 利率和月还款
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.text = [NSString stringWithFormat:@"利率：%@", [self.viewModel formatInterestRate:self.advice.interestRate]];
    rateLabel.font = [UIFont systemFontOfSize:16];
    rateLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [cardView addSubview:rateLabel];
    
    UILabel *paymentLabel = [[UILabel alloc] init];
    paymentLabel.text = [NSString stringWithFormat:@"月还款：%@", [self.viewModel formatAmount:self.advice.monthlyPayment]];
    paymentLabel.font = [UIFont boldSystemFontOfSize:16];
    paymentLabel.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    [cardView addSubview:paymentLabel];
    
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(termLabel.mas_bottom).offset(8);
    }];
    
    [paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(rateLabel.mas_bottom).offset(8);
    }];
    
    // 信心度进度条
    UILabel *confidenceLabel = [[UILabel alloc] init];
    confidenceLabel.text = [NSString stringWithFormat:@"AI信心度：%.0f%%", self.advice.confidence * 100];
    confidenceLabel.font = [UIFont systemFontOfSize:14];
    confidenceLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [cardView addSubview:confidenceLabel];
    
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.progress = self.advice.confidence;
    progressView.progressTintColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0];
    [cardView addSubview:progressView];
    
    [confidenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(paymentLabel.mas_bottom).offset(12);
    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cardView).inset(16);
        make.top.equalTo(confidenceLabel.mas_bottom).offset(8);
    }];
    
    // 优势标签
    NSString *advantagesText = [self.advice.advantages componentsJoinedByString:@" • "];
    UILabel *advantagesLabel = [[UILabel alloc] init];
    advantagesLabel.text = [NSString stringWithFormat:@"优势：%@", advantagesText];
    advantagesLabel.font = [UIFont systemFontOfSize:14];
    advantagesLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0];
    advantagesLabel.numberOfLines = 0;
    [cardView addSubview:advantagesLabel];
    
    [advantagesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cardView).inset(16);
        make.top.equalTo(progressView.mas_bottom).offset(12);
        make.bottom.lessThanOrEqualTo(cardView).offset(-16);
    }];
}

@end 