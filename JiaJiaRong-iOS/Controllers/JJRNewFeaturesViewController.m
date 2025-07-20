//
//  JJRNewFeaturesViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRNewFeaturesViewController.h"
#import "JJRAILoanAdvisorViewController.h"
#import "JJRFraudPreventionViewController.h"
#import "JJRLoanCalculatorViewController.h"
#import "JJRAICustomerServiceViewController.h"
#import <Masonry/Masonry.h>

@interface JJRFeatureItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) Class viewControllerClass;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL isNew;
@end

@implementation JJRFeatureItem
@end



@interface JJRNewFeaturesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<JJRFeatureItem *> *features;
@property (nonatomic, strong) UILabel *headerLabel;

@end

@implementation JJRNewFeaturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"智慧金融";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupFeatures];
    [self setupSimpleUI];
}



- (void)setupFeatures {
    NSMutableArray *features = [NSMutableArray array];
    
    // AI智能贷款顾问
    JJRFeatureItem *aiAdvisor = [[JJRFeatureItem alloc] init];
    aiAdvisor.title = @"AI智能贷款顾问";
    aiAdvisor.subtitle = @"个性化贷款方案推荐";
    aiAdvisor.icon = @"🤖";
    aiAdvisor.viewControllerClass = [JJRAILoanAdvisorViewController class];
    aiAdvisor.backgroundColor = [UIColor colorWithHexString:@"#3396FF"];
    aiAdvisor.isNew = YES;
    [features addObject:aiAdvisor];
    
    // 防诈骗指南
    JJRFeatureItem *fraudPrevention = [[JJRFeatureItem alloc] init];
    fraudPrevention.title = @"防诈骗指南";
    fraudPrevention.subtitle = @"智能风险识别与防护";
    fraudPrevention.icon = @"🛡️";
    fraudPrevention.viewControllerClass = [JJRFraudPreventionViewController class];
    fraudPrevention.backgroundColor = [UIColor colorWithHexString:@"#FF8000"];
    fraudPrevention.isNew = YES;
    [features addObject:fraudPrevention];
    
    // 信用评估工具
    JJRFeatureItem *creditAssessment = [[JJRFeatureItem alloc] init];
    creditAssessment.title = @"信用评估工具";
    creditAssessment.subtitle = @"专业信用分析报告";
    creditAssessment.icon = @"📊";
    creditAssessment.viewControllerClass = nil; // 待实现
    creditAssessment.backgroundColor = [UIColor colorWithHexString:@"#33CC66"];
    creditAssessment.isNew = YES;
    [features addObject:creditAssessment];
    
    // 贷款计算器
    JJRFeatureItem *calculator = [[JJRFeatureItem alloc] init];
    calculator.title = @"贷款计算器";
    calculator.subtitle = @"精确计算还款方案";
    calculator.icon = @"🧮";
    calculator.viewControllerClass = [JJRLoanCalculatorViewController class];
    calculator.backgroundColor = [UIColor colorWithHexString:@"#CC33CC"];
    calculator.isNew = YES;
    [features addObject:calculator];
    
    // 财务规划助手
    JJRFeatureItem *financialPlanner = [[JJRFeatureItem alloc] init];
    financialPlanner.title = @"财务规划助手";
    financialPlanner.subtitle = @"个人财务管理建议";
    financialPlanner.icon = @"💰";
    financialPlanner.viewControllerClass = nil;
    financialPlanner.backgroundColor = [UIColor colorWithHexString:@"#FF9900"];
    financialPlanner.isNew = YES;
    [features addObject:financialPlanner];
    
    // 风险评估
    JJRFeatureItem *riskAssessment = [[JJRFeatureItem alloc] init];
    riskAssessment.title = @"风险评估";
    riskAssessment.subtitle = @"智能风险分析";
    riskAssessment.icon = @"⚠️";
    riskAssessment.viewControllerClass = nil;
    riskAssessment.backgroundColor = [UIColor colorWithHexString:@"#FF4D4D"];
    riskAssessment.isNew = YES;
    [features addObject:riskAssessment];
    
    // 教育中心
    JJRFeatureItem *educationCenter = [[JJRFeatureItem alloc] init];
    educationCenter.title = @"金融教育中心";
    educationCenter.subtitle = @"金融知识学习";
    educationCenter.icon = @"📚";
    educationCenter.viewControllerClass = nil;
    educationCenter.backgroundColor = [UIColor colorWithHexString:@"#6699FF"];
    educationCenter.isNew = YES;
    [features addObject:educationCenter];
    
    // 智能客服
    JJRFeatureItem *aiCustomerService = [[JJRFeatureItem alloc] init];
    aiCustomerService.title = @"AI智能客服";
    aiCustomerService.subtitle = @"24小时在线咨询";
    aiCustomerService.icon = @"💬";
    aiCustomerService.viewControllerClass = [JJRAICustomerServiceViewController class];
    aiCustomerService.backgroundColor = [UIColor colorWithHexString:@"#99CC33"];
    aiCustomerService.isNew = YES;
    [features addObject:aiCustomerService];
    
    // 数据分析仪表板
    JJRFeatureItem *dataDashboard = [[JJRFeatureItem alloc] init];
    dataDashboard.title = @"数据分析仪表板";
    dataDashboard.subtitle = @"个人贷款数据分析";
    dataDashboard.icon = @"📈";
    dataDashboard.viewControllerClass = nil;
    dataDashboard.backgroundColor = [UIColor colorWithHexString:@"#CC6699"];
    dataDashboard.isNew = YES;
    [features addObject:dataDashboard];
    
    // 社区论坛
    JJRFeatureItem *communityForum = [[JJRFeatureItem alloc] init];
    communityForum.title = @"社区论坛";
    communityForum.subtitle = @"用户交流平台";
    communityForum.icon = @"👥";
    communityForum.viewControllerClass = nil;
    communityForum.backgroundColor = [UIColor colorWithHexString:@"#3399CC"];
    communityForum.isNew = YES;
    [features addObject:communityForum];
    
    // 投资理财建议
    JJRFeatureItem *investmentAdvisor = [[JJRFeatureItem alloc] init];
    investmentAdvisor.title = @"投资理财建议";
    investmentAdvisor.subtitle = @"理财产品推荐";
    investmentAdvisor.icon = @"💎";
    investmentAdvisor.viewControllerClass = nil;
    investmentAdvisor.backgroundColor = [UIColor colorWithHexString:@"#FFCC00"];
    investmentAdvisor.isNew = YES;
    [features addObject:investmentAdvisor];
    
    // 紧急贷款助手
    JJRFeatureItem *emergencyLoan = [[JJRFeatureItem alloc] init];
    emergencyLoan.title = @"紧急贷款助手";
    emergencyLoan.subtitle = @"应急资金快速申请";
    emergencyLoan.icon = @"🚨";
    emergencyLoan.viewControllerClass = nil;
    emergencyLoan.backgroundColor = [UIColor colorWithHexString:@"#CC3333"];
    emergencyLoan.isNew = YES;
    [features addObject:emergencyLoan];
    
    self.features = [features copy];
    NSLog(@"🚀 数据源: %lu 个功能", (unsigned long)self.features.count);
}

- (void)setupSimpleUI {
    NSLog(@"🚀 开始创建UI，features数量: %lu", (unsigned long)self.features.count);
    
    // 计算安全区域
    CGFloat topSafeArea = 0;
    CGFloat bottomSafeArea = 0;
    if (@available(iOS 11.0, *)) {
        topSafeArea = self.view.safeAreaInsets.top;
        bottomSafeArea = self.view.safeAreaInsets.bottom;
    }
    if (topSafeArea == 0) topSafeArea = 64; // 默认导航栏高度
    
    // TableView从安全区域顶部开始
    CGFloat tableY = topSafeArea;
    CGFloat tableHeight = self.view.bounds.size.height - tableY - bottomSafeArea;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, self.view.bounds.size.width, tableHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    
    NSLog(@"🚀 UI创建完成，TableView frame: %@", NSStringFromCGRect(self.tableView.frame));
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"🚀 返回行数: %lu", (unsigned long)self.features.count);
    return self.features.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SimpleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    JJRFeatureItem *feature = self.features[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", feature.icon, feature.title];
    cell.detailTextLabel.text = feature.subtitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 统一白色背景
    cell.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"🚀 创建cell[%ld]: %@", (long)indexPath.row, feature.title);
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JJRFeatureItem *item = self.features[indexPath.row];
    
    NSLog(@"🚀 点击了: %@", item.title);
    
    if (item.viewControllerClass) {
        UIViewController *vc = [[item.viewControllerClass alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self showComingSoonAlert:item.title];
    }
}

- (void)showComingSoonAlert:(NSString *)featureName {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"功能开发中" 
                                                                   message:[NSString stringWithFormat:@"%@功能正在开发中，敬请期待！", featureName] 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



@end

 
 