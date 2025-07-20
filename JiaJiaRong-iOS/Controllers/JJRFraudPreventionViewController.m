//
//  JJRFraudPreventionViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRFraudPreventionViewController.h"
#import "JJRFraudPreventionViewModel.h"
#import "JJRFraudPreventionModel.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

static NSString * const kPlaceholderText = @"请输入您收到的可疑短信、电话内容或网站链接...";

@interface JJRFraudCaseCell : UITableViewCell
@property (nonatomic, strong) JJRFraudCase *fraudCase;
@property (nonatomic, strong) JJRFraudPreventionViewModel *viewModel;
@end

@interface JJRFraudTipCell : UITableViewCell
@property (nonatomic, strong) JJRFraudPreventionTip *tip;
@end

@interface JJRFraudPreventionViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, JJRBaseViewModelDelegate>

@property (nonatomic, strong) JJRFraudPreventionViewModel *viewModel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 头部区域
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *securityScoreLabel;
@property (nonatomic, strong) UIProgressView *securityProgressView;
@property (nonatomic, strong) UIButton *checkRiskButton;

// 风险检测区域
@property (nonatomic, strong) UIView *riskCheckView;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UIButton *analyzeButton;
@property (nonatomic, strong) UIView *resultView;

// 内容选择器
@property (nonatomic, strong) UISegmentedControl *contentSegment;

// 表格视图
@property (nonatomic, strong) UITableView *tableView;

// 数据
@property (nonatomic, strong) NSArray *currentDisplayData;

@end

@implementation JJRFraudPreventionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 🔧 隐藏底部 TabBar
    self.hidesBottomBarWhenPushed = YES;
    
    self.title = @"防诈骗指南";
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
    
    [self setupViewModel];
    [self setupUI];
    [self setupConstraints];
    [self loadData];
}

- (void)setupViewModel {
    self.viewModel = [[JJRFraudPreventionViewModel alloc] init];
    self.viewModel.delegate = self;
}

- (void)setupUI {
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 设置头部安全评分区域
    [self setupHeaderView];
    
    // 设置风险检测区域
    [self setupRiskCheckView];
    
    // 内容选择器
    self.contentSegment = [[UISegmentedControl alloc] initWithItems:@[@"诈骗案例", @"防范小贴士", @"安全统计"]];
    self.contentSegment.selectedSegmentIndex = 0;
    [self.contentSegment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.contentSegment];
    
    // 表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
}

- (void)setupHeaderView {
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerView.layer.cornerRadius = 12;
    self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.headerView.layer.shadowOpacity = 0.1;
    self.headerView.layer.shadowRadius = 4;
    [self.contentView addSubview:self.headerView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"🛡️ 安全评分";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [self.headerView addSubview:titleLabel];
    
    self.securityScoreLabel = [[UILabel alloc] init];
    self.securityScoreLabel.font = [UIFont boldSystemFontOfSize:24];
    self.securityScoreLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    [self.headerView addSubview:self.securityScoreLabel];
    
    self.securityProgressView = [[UIProgressView alloc] init];
    self.securityProgressView.progressTintColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0];
    [self.headerView addSubview:self.securityProgressView];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:@"更新评分" forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    updateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    updateButton.layer.borderColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0].CGColor;
    updateButton.layer.borderWidth = 1;
    updateButton.layer.cornerRadius = 6;
    [updateButton addTarget:self action:@selector(updateSecurityScore) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:updateButton];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.headerView).offset(16);
    }];
    
    [self.securityScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-16);
        make.centerY.equalTo(titleLabel);
    }];
    
    [self.securityProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headerView).inset(16);
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
        make.height.equalTo(@4);
    }];
    
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-16);
        make.top.equalTo(self.securityProgressView.mas_bottom).offset(12);
        make.bottom.equalTo(self.headerView).offset(-16);
        make.width.equalTo(@80);
        make.height.equalTo(@32);
    }];
}

- (void)setupRiskCheckView {
    self.riskCheckView = [[UIView alloc] init];
    self.riskCheckView.backgroundColor = [UIColor whiteColor];
    self.riskCheckView.layer.cornerRadius = 12;
    self.riskCheckView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.riskCheckView.layer.shadowOffset = CGSizeMake(0, 2);
    self.riskCheckView.layer.shadowOpacity = 0.1;
    self.riskCheckView.layer.shadowRadius = 4;
    [self.contentView addSubview:self.riskCheckView];
    
    UILabel *checkTitleLabel = [[UILabel alloc] init];
    checkTitleLabel.text = @"🔍 智能风险检测";
    checkTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    checkTitleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [self.riskCheckView addSubview:checkTitleLabel];
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"输入可疑信息，AI帮您分析风险";
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    [self.riskCheckView addSubview:hintLabel];
    
    self.inputTextView = [[UITextView alloc] init];
    self.inputTextView.text = kPlaceholderText;
    self.inputTextView.textColor = [UIColor lightGrayColor];
    self.inputTextView.font = [UIFont systemFontOfSize:16];
    self.inputTextView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    self.inputTextView.layer.borderWidth = 1;
    self.inputTextView.layer.cornerRadius = 8;
    self.inputTextView.delegate = self;
    [self.riskCheckView addSubview:self.inputTextView];
    
    self.analyzeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.analyzeButton setTitle:@"分析风险" forState:UIControlStateNormal];
    [self.analyzeButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
    self.analyzeButton.layer.cornerRadius = 8;
    self.analyzeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.analyzeButton addTarget:self action:@selector(analyzeRisk) forControlEvents:UIControlEventTouchUpInside];
    [self.riskCheckView addSubview:self.analyzeButton];
    
    self.resultView = [[UIView alloc] init];
    self.resultView.hidden = YES;
    [self.riskCheckView addSubview:self.resultView];
    
    [checkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.riskCheckView).offset(16);
    }];
    
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.riskCheckView).offset(16);
        make.top.equalTo(checkTitleLabel.mas_bottom).offset(4);
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.riskCheckView).inset(16);
        make.top.equalTo(hintLabel.mas_bottom).offset(16);
        make.height.equalTo(@80);
    }];
    
    [self.analyzeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.riskCheckView).offset(-16);
        make.top.equalTo(self.inputTextView.mas_bottom).offset(12);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.riskCheckView).inset(16);
        make.top.equalTo(self.analyzeButton.mas_bottom).offset(16);
        make.bottom.equalTo(self.riskCheckView).offset(-16);
        make.height.equalTo(@0);
    }];
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.contentView).offset(100); // 增加顶部间距避免导航栏遮挡
    }];
    
    [self.riskCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.headerView.mas_bottom).offset(16);
    }];
    
    [self.contentSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.riskCheckView.mas_bottom).offset(16);
        make.height.equalTo(@32);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentSegment.mas_bottom).offset(16);
        make.height.equalTo(@600);
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
}

- (void)loadData {
    [self.viewModel loadFraudCases];
    [self.viewModel loadPreventionTips];
    [self updateSecurityScoreDisplay];
    [self segmentChanged:self.contentSegment];
}

- (void)updateSecurityScoreDisplay {
    JJRSecurityScore *score = self.viewModel.securityScore;
    self.securityScoreLabel.text = [NSString stringWithFormat:@"%ld分", (long)score.totalScore];
    self.securityProgressView.progress = score.totalScore / 100.0;
    
    if (score.totalScore >= 90) {
        self.securityProgressView.progressTintColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
    } else if (score.totalScore >= 70) {
        self.securityProgressView.progressTintColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
    } else {
        self.securityProgressView.progressTintColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
    }
}

#pragma mark - Actions

- (void)segmentChanged:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0: // 诈骗案例
            self.currentDisplayData = self.viewModel.fraudCases;
            break;
        case 1: // 防范小贴士
            self.currentDisplayData = self.viewModel.preventionTips;
            break;
        case 2: // 安全统计
            self.currentDisplayData = @[[self.viewModel getFraudStatistics]];
            break;
        default:
            self.currentDisplayData = @[];
            break;
    }
    
    [self.tableView reloadData];
}

- (void)updateSecurityScore {
    [self.viewModel updateSecurityScore];
}

- (void)analyzeRisk {
    NSString *inputText = self.inputTextView.text;
    if (inputText.length == 0 || [inputText isEqualToString:kPlaceholderText]) {
        [self showAlert:@"请输入要分析的内容"];
        return;
    }
    
    [self.viewModel checkSecurityRisk:inputText completion:^(JJRFraudCheckResult *result) {
        [self showRiskResult:result];
    }];
}

- (void)showRiskResult:(JJRFraudCheckResult *)result {
    // 清除之前的结果
    for (UIView *view in self.resultView.subviews) {
        [view removeFromSuperview];
    }
    
    // 风险等级标题
    UILabel *riskLabel = [[UILabel alloc] init];
    riskLabel.text = [NSString stringWithFormat:@"风险等级：%@", [self.viewModel riskLevelDescription:result.overallRisk]];
    riskLabel.font = [UIFont boldSystemFontOfSize:16];
    riskLabel.textColor = [self.viewModel riskLevelColor:result.overallRisk];
    [self.resultView addSubview:riskLabel];
    
    // 风险评分
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = [NSString stringWithFormat:@"风险评分：%.0f/100", result.riskScore];
    scoreLabel.font = [UIFont systemFontOfSize:14];
    scoreLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    [self.resultView addSubview:scoreLabel];
    
    // 结果摘要
    UILabel *summaryLabel = [[UILabel alloc] init];
    summaryLabel.text = result.resultSummary;
    summaryLabel.font = [UIFont systemFontOfSize:14];
    summaryLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    summaryLabel.numberOfLines = 0;
    [self.resultView addSubview:summaryLabel];
    
    // 风险因素
    if (result.riskFactors.count > 0) {
        UILabel *factorsTitle = [[UILabel alloc] init];
        factorsTitle.text = @"发现的风险因素：";
        factorsTitle.font = [UIFont boldSystemFontOfSize:14];
        factorsTitle.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        [self.resultView addSubview:factorsTitle];
        
        NSString *factorsText = [result.riskFactors componentsJoinedByString:@"\n• "];
        UILabel *factorsLabel = [[UILabel alloc] init];
        factorsLabel.text = [NSString stringWithFormat:@"• %@", factorsText];
        factorsLabel.font = [UIFont systemFontOfSize:13];
        factorsLabel.textColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1.0];
        factorsLabel.numberOfLines = 0;
        [self.resultView addSubview:factorsLabel];
        
        [factorsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.resultView);
            make.top.equalTo(summaryLabel.mas_bottom).offset(12);
        }];
        
        [factorsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.resultView);
            make.top.equalTo(factorsTitle.mas_bottom).offset(4);
        }];
    }
    
    [riskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.resultView);
        make.top.equalTo(self.resultView);
    }];
    
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.resultView);
        make.top.equalTo(riskLabel.mas_bottom).offset(4);
    }];
    
    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.resultView);
        make.top.equalTo(scoreLabel.mas_bottom).offset(8);
    }];
    
    // 更新结果视图高度
    [self.resultView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(120 + result.riskFactors.count * 15));
    }];
    
    self.resultView.hidden = NO;
    
    // 动画显示结果
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
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
    [self.tableView reloadData];
    [self updateSecurityScoreDisplay];
}

- (void)viewModelDidFailWithError:(NSError *)error {
    [self showAlert:error.localizedDescription];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentDisplayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.currentDisplayData[indexPath.row];
    
    if ([item isKindOfClass:[JJRFraudCase class]]) {
        static NSString *cellId = @"JJRFraudCaseCell";
        JJRFraudCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[JJRFraudCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.fraudCase = item;
        cell.viewModel = self.viewModel;
        return cell;
    } else if ([item isKindOfClass:[JJRFraudPreventionTip class]]) {
        static NSString *cellId = @"JJRFraudTipCell";
        JJRFraudTipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[JJRFraudTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.tip = item;
        return cell;
    } else {
        // 统计信息
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatCell"];
        cell.textLabel.text = @"诈骗统计信息";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = self.currentDisplayData[indexPath.row];
    
    if ([item isKindOfClass:[JJRFraudCase class]]) {
        return 200;
    } else if ([item isKindOfClass:[JJRFraudPreventionTip class]]) {
        return 120;
    } else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id item = self.currentDisplayData[indexPath.row];
    
    if ([item isKindOfClass:[JJRFraudCase class]]) {
        [self showFraudCaseDetail:item];
    } else if ([item isKindOfClass:[JJRFraudPreventionTip class]]) {
        [self showTipDetail:item];
    }
}

- (void)showFraudCaseDetail:(JJRFraudCase *)fraudCase {
    // 🔧 使用安全的方式替代私有API，创建专门的详情页面
    [self showFraudCaseDetailViewController:fraudCase];
}

- (void)showFraudCaseDetailViewController:(JJRFraudCase *)fraudCase {
    // 🔧 安全检查
    if (!fraudCase) {
        NSLog(@"⚠️ fraudCase is nil, cannot show detail");
        return;
    }
    
    // 创建详情页面
    UIViewController *detailVC = [[UIViewController alloc] init];
    detailVC.title = fraudCase.title ?: @"诈骗案例详情";
    detailVC.view.backgroundColor = [UIColor whiteColor];
    
    // 创建导航控制器
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    // 添加关闭按钮
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" 
                                                                    style:UIBarButtonItemStylePlain 
                                                                   target:self 
                                                                   action:@selector(dismissDetailViewController)];
    detailVC.navigationItem.rightBarButtonItem = closeButton;
    
    // 创建滚动视图和内容
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    [detailVC.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    
    // 构建详细内容 - 添加安全检查
    NSMutableString *detail = [NSMutableString string];
    
    // 安全地获取描述信息
    NSString *typeDesc = [self.viewModel fraudTypeDescription:fraudCase.fraudType] ?: @"未知";
    NSString *riskDesc = [self.viewModel riskLevelDescription:fraudCase.riskLevel] ?: @"未知";
    NSString *caseDesc = fraudCase.caseDescription ?: @"暂无描述";
    NSString *methodDesc = fraudCase.fraudMethod ?: @"暂无信息";
    
    [detail appendFormat:@"类型：%@\n\n", typeDesc];
    [detail appendFormat:@"风险等级：%@\n\n", riskDesc];
    [detail appendFormat:@"案例描述：\n%@\n\n", caseDesc];
    [detail appendFormat:@"诈骗手段：\n%@\n\n", methodDesc];
    
    // 安全地处理数组
    if (fraudCase.warningSignals && fraudCase.warningSignals.count > 0) {
        [detail appendFormat:@"预警信号：\n• %@\n\n", [fraudCase.warningSignals componentsJoinedByString:@"\n• "]];
    } else {
        [detail appendString:@"预警信号：\n暂无信息\n\n"];
    }
    
    if (fraudCase.preventionTips && fraudCase.preventionTips.count > 0) {
        [detail appendFormat:@"防范措施：\n• %@", [fraudCase.preventionTips componentsJoinedByString:@"\n• "]];
    } else {
        [detail appendString:@"防范措施：\n暂无信息"];
    }
    
    // 创建文本视图
    UITextView *textView = [[UITextView alloc] init];
    textView.text = detail;
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:16];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor blackColor];
    [contentView addSubview:textView];
    
    // 设置约束
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(detailVC.view);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView).inset(16);
        make.height.mas_greaterThanOrEqualTo(500);
    }];
    
    // 模态展示 - 兼容不同iOS版本
    if (@available(iOS 13.0, *)) {
        navController.modalPresentationStyle = UIModalPresentationPageSheet;
    } else {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)dismissDetailViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTipDetail:(JJRFraudPreventionTip *)tip {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tip.title message:tip.content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:kPlaceholderText]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = kPlaceholderText;
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    // 可以在这里添加实时分析逻辑
}

@end

#pragma mark - JJRFraudCaseCell

@implementation JJRFraudCaseCell

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
    cardView.layer.shadowRadius = 4;
    [self.contentView addSubview:cardView];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.bottom.equalTo(self.contentView).inset(8);
    }];
}

- (void)setFraudCase:(JJRFraudCase *)fraudCase {
    _fraudCase = fraudCase;
    [self updateUI];
}

- (void)updateUI {
    // 清除之前的子视图
    UIView *cardView = self.contentView.subviews.firstObject;
    for (UIView *view in cardView.subviews) {
        [view removeFromSuperview];
    }
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.fraudCase.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    titleLabel.numberOfLines = 2;
    [cardView addSubview:titleLabel];
    
    // 风险等级标签
    UILabel *riskLabel = [[UILabel alloc] init];
    riskLabel.text = [self.viewModel riskLevelDescription:self.fraudCase.riskLevel];
    riskLabel.font = [UIFont systemFontOfSize:12];
    riskLabel.textColor = [UIColor whiteColor];
    riskLabel.backgroundColor = [self.viewModel riskLevelColor:self.fraudCase.riskLevel];
    riskLabel.textAlignment = NSTextAlignmentCenter;
    riskLabel.layer.cornerRadius = 8;
    riskLabel.layer.masksToBounds = YES;
    [cardView addSubview:riskLabel];
    
    // 类型标签
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.text = [self.viewModel fraudTypeDescription:self.fraudCase.fraudType];
    typeLabel.font = [UIFont systemFontOfSize:14];
    typeLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [cardView addSubview:typeLabel];
    
    // 描述
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = self.fraudCase.caseDescription;
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    descLabel.numberOfLines = 3;
    [cardView addSubview:descLabel];
    
    // 受害者损失
    UILabel *lossLabel = [[UILabel alloc] init];
    lossLabel.text = [NSString stringWithFormat:@"损失：%@", self.fraudCase.victimLoss];
    lossLabel.font = [UIFont systemFontOfSize:12];
    lossLabel.textColor = [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0];
    [cardView addSubview:lossLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(cardView).offset(16);
        make.right.equalTo(riskLabel.mas_left).offset(-8);
    }];
    
    [riskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-16);
        make.top.equalTo(cardView).offset(16);
        make.width.equalTo(@60);
        make.height.equalTo(@24);
    }];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cardView).inset(16);
        make.top.equalTo(typeLabel.mas_bottom).offset(8);
    }];
    
    [lossLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-16);
        make.bottom.equalTo(cardView).offset(-16);
    }];
}

@end

#pragma mark - JJRFraudTipCell

@implementation JJRFraudTipCell

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
    cardView.layer.shadowRadius = 4;
    [self.contentView addSubview:cardView];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.bottom.equalTo(self.contentView).inset(8);
    }];
}

- (void)setTip:(JJRFraudPreventionTip *)tip {
    _tip = tip;
    [self updateUI];
}

- (void)updateUI {
    // 清除之前的子视图
    UIView *cardView = self.contentView.subviews.firstObject;
    for (UIView *view in cardView.subviews) {
        [view removeFromSuperview];
    }
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.tip.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [cardView addSubview:titleLabel];
    
    // 官方标识
    if (self.tip.isOfficial) {
        UILabel *officialLabel = [[UILabel alloc] init];
        officialLabel.text = @"官方";
        officialLabel.font = [UIFont systemFontOfSize:10];
        officialLabel.textColor = [UIColor whiteColor];
        officialLabel.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
        officialLabel.textAlignment = NSTextAlignmentCenter;
        officialLabel.layer.cornerRadius = 6;
        officialLabel.layer.masksToBounds = YES;
        [cardView addSubview:officialLabel];
        
        [officialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cardView).offset(-16);
            make.top.equalTo(cardView).offset(16);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
    }
    
    // 分类
    UILabel *categoryLabel = [[UILabel alloc] init];
    categoryLabel.text = [NSString stringWithFormat:@"📂 %@", self.tip.category];
    categoryLabel.font = [UIFont systemFontOfSize:14];
    categoryLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [cardView addSubview:categoryLabel];
    
    // 内容预览
    UILabel *contentLabel = [[UILabel alloc] init];
    NSString *preview = self.tip.content;
    if (preview.length > 80) {
        preview = [[preview substringToIndex:80] stringByAppendingString:@"..."];
    }
    contentLabel.text = preview;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    contentLabel.numberOfLines = 2;
    [cardView addSubview:contentLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(cardView).offset(16);
        make.right.equalTo(cardView).offset(-60);
    }];
    
    [categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cardView).inset(16);
        make.top.equalTo(categoryLabel.mas_bottom).offset(8);
        make.bottom.lessThanOrEqualTo(cardView).offset(-16);
    }];
}

@end 