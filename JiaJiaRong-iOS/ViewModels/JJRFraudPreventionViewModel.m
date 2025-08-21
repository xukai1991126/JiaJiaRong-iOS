//
//  JJRFraudPreventionViewModel.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRFraudPreventionViewModel.h"
#import <UIKit/UIKit.h>

@interface JJRFraudPreventionViewModel ()

@property (nonatomic, strong) NSArray<JJRFraudCase *> *fraudCases;
@property (nonatomic, strong) NSArray<JJRFraudPreventionTip *> *preventionTips;
@property (nonatomic, strong) JJRSecurityScore *securityScore;

@end

@implementation JJRFraudPreventionViewModel

- (instancetype)init {
    if (self = [super init]) {
        _fraudCases = @[];
        _preventionTips = @[];
        _securityScore = [[JJRSecurityScore alloc] init];
        [self loadMockData];
    }
    return self;
}

- (void)loadFraudCases {
    [self startLoading];
    
    // 模拟网络请求延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self generateMockFraudCases];
        [self finishLoading];
        [self updateData];
    });
}

- (void)loadPreventionTips {
    [self startLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self generateMockPreventionTips];
        [self finishLoading];
        [self updateData];
    });
}

- (void)loadMockData {
    [self generateMockFraudCases];
    [self generateMockPreventionTips];
    [self generateMockSecurityScore];
}

- (void)generateMockFraudCases {
    NSMutableArray *cases = [NSMutableArray array];
    
    // 钓鱼诈骗案例
    JJRFraudCase *case1 = [[JJRFraudCase alloc] init];
    case1.fraudType = JJRFraudTypePhishing;
    case1.riskLevel = JJRRiskLevelHigh;
    case1.title = @"虚假银行短信钓鱼诈骗";
    case1.caseDescription = @"受害人收到伪造的银行短信，声称账户异常需要点击链接验证，结果个人信息被盗取";
    case1.fraudMethod = @"伪造官方短信，诱导点击恶意链接";
    case1.warningSignals = @[@"短信发送方非官方号码", @"要求点击可疑链接", @"催促立即操作", @"索要密码和验证码"];
    case1.preventionTips = @[@"核实发送方身份", @"不点击可疑链接", @"通过官方渠道验证", @"保护个人信息"];
    case1.victimLoss = @"¥15,000";
    case1.source = @"警方通报";
    [cases addObject:case1];
    
    // 虚假贷款案例
    JJRFraudCase *case2 = [[JJRFraudCase alloc] init];
    case2.fraudType = JJRFraudTypeFakeLoan;
    case2.riskLevel = JJRRiskLevelCritical;
    case2.title = @"零门槛贷款预付费诈骗";
    case2.caseDescription = @"诈骗分子承诺零门槛放贷，要求受害人先支付手续费、保证金等费用";
    case2.fraudMethod = @"以低门槛吸引客户，要求预付各种费用";
    case2.warningSignals = @[@"承诺零门槛放贷", @"要求预付费用", @"利率过低不合理", @"无正规资质"];
    case2.preventionTips = @[@"选择正规金融机构", @"不预付任何费用", @"查验放贷资质", @"了解合理利率水平"];
    case2.victimLoss = @"¥8,000";
    case2.source = @"消费者投诉";
    [cases addObject:case2];
    
    // 身份盗用案例
    JJRFraudCase *case3 = [[JJRFraudCase alloc] init];
    case3.fraudType = JJRFraudTypeIdentityTheft;
    case3.riskLevel = JJRRiskLevelHigh;
    case3.title = @"身份信息被盗用申请贷款";
    case3.caseDescription = @"不法分子获取他人身份信息后，冒名申请贷款，导致受害人征信受损";
    case3.fraudMethod = @"通过各种渠道获取身份信息，冒名申请";
    case3.warningSignals = @[@"征信报告出现陌生贷款", @"收到未申请的贷款通知", @"个人信息泄露"];
    case3.preventionTips = @[@"保护身份证等证件", @"定期查询征信报告", @"发现异常及时报警", @"谨慎提供个人信息"];
    case3.victimLoss = @"征信受损";
    case3.source = @"征信中心提醒";
    [cases addObject:case3];
    
    // 电话诈骗案例
    JJRFraudCase *case4 = [[JJRFraudCase alloc] init];
    case4.fraudType = JJRFraudTypePhoneCall;
    case4.riskLevel = JJRRiskLevelMedium;
    case4.title = @"冒充银行客服电话诈骗";
    case4.caseDescription = @"诈骗分子冒充银行客服，以账户安全为由要求转账到安全账户";
    case4.fraudMethod = @"冒充官方客服，制造紧急情况诱导转账";
    case4.warningSignals = @[@"主动来电要求操作", @"催促紧急转账", @"要求提供密码", @"声称账户异常"];
    case4.preventionTips = @[@"挂断后拨打官方电话核实", @"银行不会要求转账", @"不透露账户密码", @"保持冷静思考"];
    case4.victimLoss = @"¥25,000";
    case4.source = @"反诈中心";
    [cases addObject:case4];
    
    // 虚假APP案例
    JJRFraudCase *case5 = [[JJRFraudCase alloc] init];
    case5.fraudType = JJRFraudTypeFakeApp;
    case5.riskLevel = JJRRiskLevelHigh;
    case5.title = @"山寨贷款APP诈骗";
    case5.caseDescription = @"下载使用了山寨贷款APP，个人信息被盗取，还被要求支付各种费用";
    case5.fraudMethod = @"制作高仿真APP，收集用户信息并收费";
    case5.warningSignals = @[@"来源不明的APP", @"要求过多权限", @"收费项目繁多", @"客服联系困难"];
    case5.preventionTips = @[@"从官方渠道下载APP", @"查看APP评价和权限", @"核实公司资质", @"谨慎提供信息"];
    case5.victimLoss = @"¥5,000";
    case5.source = @"用户举报";
    [cases addObject:case5];
    
    self.fraudCases = [cases copy];
}

- (void)generateMockPreventionTips {
    NSMutableArray *tips = [NSMutableArray array];
    
    JJRFraudPreventionTip *tip1 = [[JJRFraudPreventionTip alloc] init];
    tip1.title = @"如何识别正规贷款机构";
    tip1.content = @"1. 查看是否有金融许可证\n2. 核实公司注册信息\n3. 了解实际经营地址\n4. 查询监管部门备案\n5. 关注用户评价和投诉";
    tip1.category = @"机构识别";
    tip1.priority = 1;
    tip1.isOfficial = YES;
    tip1.keywords = @[@"正规", @"许可证", @"备案"];
    [tips addObject:tip1];
    
    JJRFraudPreventionTip *tip2 = [[JJRFraudPreventionTip alloc] init];
    tip2.title = @"贷款申请注意事项";
    tip2.content = @"1. 不要预付任何费用\n2. 仔细阅读合同条款\n3. 了解真实利率水平\n4. 保留所有相关证据\n5. 量力而行，理性借贷";
    tip2.category = @"申请安全";
    tip2.priority = 1;
    tip2.isOfficial = YES;
    tip2.keywords = @[@"申请", @"合同", @"利率"];
    [tips addObject:tip2];
    
    JJRFraudPreventionTip *tip3 = [[JJRFraudPreventionTip alloc] init];
    tip3.title = @"个人信息保护指南";
    tip3.content = @"1. 妥善保管身份证件\n2. 不随意提供个人信息\n3. 定期更换密码\n4. 谨慎使用公共WiFi\n5. 及时关注征信报告";
    tip3.category = @"信息保护";
    tip3.priority = 2;
    tip3.isOfficial = YES;
    tip3.keywords = @[@"信息", @"保护", @"征信"];
    [tips addObject:tip3];
    
    JJRFraudPreventionTip *tip4 = [[JJRFraudPreventionTip alloc] init];
    tip4.title = @"遇到诈骗如何处理";
    tip4.content = @"1. 立即停止一切操作\n2. 保存相关证据\n3. 及时报警求助\n4. 联系银行冻结账户\n5. 通知亲友防范";
    tip4.category = @"应急处理";
    tip4.priority = 1;
    tip4.isOfficial = YES;
    tip4.keywords = @[@"诈骗", @"报警", @"处理"];
    [tips addObject:tip4];
    
    JJRFraudPreventionTip *tip5 = [[JJRFraudPreventionTip alloc] init];
    tip5.title = @"网络安全防护措施";
    tip5.content = @"1. 使用正版杀毒软件\n2. 及时更新系统补丁\n3. 不点击可疑链接\n4. 定期备份重要数据\n5. 使用复杂密码";
    tip5.category = @"网络安全";
    tip5.priority = 2;
    tip5.isOfficial = NO;
    tip5.keywords = @[@"网络", @"安全", @"防护"];
    [tips addObject:tip5];
    
    self.preventionTips = [tips copy];
}

- (void)generateMockSecurityScore {
    JJRSecurityScore *score = [[JJRSecurityScore alloc] init];
    
    // 随机生成一些分数，实际应用中这些数据来自用户行为分析
    score.identitySecurityScore = 78 + arc4random_uniform(20);
    score.deviceSecurityScore = 82 + arc4random_uniform(15);
    score.behaviorSecurityScore = 85 + arc4random_uniform(12);
    score.networkSecurityScore = 75 + arc4random_uniform(18);
    
    score.totalScore = (score.identitySecurityScore + score.deviceSecurityScore + 
                       score.behaviorSecurityScore + score.networkSecurityScore) / 4;
    
    NSMutableArray *recommendations = [NSMutableArray array];
    
    if (score.identitySecurityScore < 80) {
        [recommendations addObject:@"建议完善身份验证信息"];
    }
    if (score.deviceSecurityScore < 80) {
        [recommendations addObject:@"建议更新设备安全设置"];
    }
    if (score.behaviorSecurityScore < 80) {
        [recommendations addObject:@"建议提高安全意识，谨慎操作"];
    }
    if (score.networkSecurityScore < 80) {
        [recommendations addObject:@"建议加强网络环境安全"];
    }
    
    if (recommendations.count == 0) {
        [recommendations addObject:@"您的安全状况良好，请继续保持"];
    }
    
    score.recommendations = [recommendations copy];
    self.securityScore = score;
}

- (void)checkSecurityRisk:(NSString *)inputText completion:(void(^)(JJRFraudCheckResult *result))completion {
    [self startLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JJRFraudCheckResult *result = [self analyzeSecurityRisk:inputText];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishLoading];
            if (completion) {
                completion(result);
            }
        });
    });
}

- (JJRFraudCheckResult *)analyzeSecurityRisk:(NSString *)inputText {
    JJRFraudCheckResult *result = [[JJRFraudCheckResult alloc] init];
    
    NSMutableArray *riskFactors = [NSMutableArray array];
    NSMutableArray *suggestions = [NSMutableArray array];
    CGFloat riskScore = 0.0;
    
    // 分析关键词风险
    NSArray *highRiskKeywords = @[@"零门槛", @"预付费", @"保证金", @"手续费", @"急需用钱", @"无需审核"];
    NSArray *mediumRiskKeywords = @[@"快速放款", @"低利率", @"无抵押", @"当天到账"];
    
    NSString *lowercaseText = [inputText lowercaseString];
    
    for (NSString *keyword in highRiskKeywords) {
        if ([lowercaseText containsString:[keyword lowercaseString]]) {
            [riskFactors addObject:[NSString stringWithFormat:@"包含高风险关键词：%@", keyword]];
            riskScore += 25.0;
        }
    }
    
    for (NSString *keyword in mediumRiskKeywords) {
        if ([lowercaseText containsString:[keyword lowercaseString]]) {
            [riskFactors addObject:[NSString stringWithFormat:@"包含中风险关键词：%@", keyword]];
            riskScore += 15.0;
        }
    }
    
    // 分析文本模式
    if ([lowercaseText containsString:@"点击链接"] || [lowercaseText containsString:@"扫描二维码"]) {
        [riskFactors addObject:@"要求点击链接或扫码"];
        riskScore += 20.0;
    }
    
    if ([lowercaseText containsString:@"验证码"] || [lowercaseText containsString:@"密码"]) {
        [riskFactors addObject:@"索要验证码或密码"];
        riskScore += 30.0;
    }
    
    if ([inputText rangeOfString:@"\\d{4}" options:NSRegularExpressionSearch].location != NSNotFound) {
        [riskFactors addObject:@"包含疑似验证码数字"];
        riskScore += 15.0;
    }
    
    // 确定风险等级
    if (riskScore >= 70) {
        result.overallRisk = JJRRiskLevelCritical;
        result.resultSummary = @"极高风险：强烈建议不要继续操作，可能是诈骗行为";
        [suggestions addObject:@"立即停止所有操作"];
        [suggestions addObject:@"联系官方客服核实"];
        [suggestions addObject:@"如有损失及时报警"];
    } else if (riskScore >= 40) {
        result.overallRisk = JJRRiskLevelHigh;
        result.resultSummary = @"高风险：请谨慎处理，建议通过官方渠道核实";
        [suggestions addObject:@"通过官方渠道核实信息"];
        [suggestions addObject:@"不要提供个人敏感信息"];
        [suggestions addObject:@"保持警惕，谨慎操作"];
    } else if (riskScore >= 15) {
        result.overallRisk = JJRRiskLevelMedium;
        result.resultSummary = @"中等风险：存在一定风险，建议提高警惕";
        [suggestions addObject:@"提高安全防范意识"];
        [suggestions addObject:@"核实对方身份和资质"];
        [suggestions addObject:@"保留相关证据"];
    } else {
        result.overallRisk = JJRRiskLevelLow;
        result.resultSummary = @"低风险：暂未发现明显风险，但仍需保持警惕";
        [suggestions addObject:@"继续保持安全意识"];
        [suggestions addObject:@"定期关注安全提醒"];
    }
    
    result.riskFactors = [riskFactors copy];
    result.suggestions = [suggestions copy];
    result.riskScore = MIN(100.0, riskScore);
    
    return result;
}

- (void)updateSecurityScore {
    [self startLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self generateMockSecurityScore];
        [self finishLoading];
        [self updateData];
    });
}

#pragma mark - Search and Filter

- (NSArray<JJRFraudCase *> *)searchCases:(NSString *)keyword {
    if (!keyword || keyword.length == 0) {
        return self.fraudCases;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ OR caseDescription CONTAINS[cd] %@", keyword, keyword];
    return [self.fraudCases filteredArrayUsingPredicate:predicate];
}

- (NSArray<JJRFraudCase *> *)filterCasesByType:(JJRFraudType)type {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fraudType == %ld", (long)type];
    return [self.fraudCases filteredArrayUsingPredicate:predicate];
}

- (NSArray<JJRFraudCase *> *)filterCasesByRiskLevel:(JJRRiskLevel)riskLevel {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"riskLevel == %ld", (long)riskLevel];
    return [self.fraudCases filteredArrayUsingPredicate:predicate];
}

- (NSArray<JJRFraudPreventionTip *> *)getRecommendedTips {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority <= 2"];
    NSArray *filteredTips = [self.preventionTips filteredArrayUsingPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:YES];
    return [filteredTips sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray<JJRFraudCase *> *)getHighRiskCases {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"riskLevel >= %ld", (long)JJRRiskLevelHigh];
    return [self.fraudCases filteredArrayUsingPredicate:predicate];
}

#pragma mark - Utility Methods

- (NSString *)fraudTypeDescription:(JJRFraudType)type {
    switch (type) {
        case JJRFraudTypePhishing: return @"钓鱼诈骗";
        case JJRFraudTypeFakeLoan: return @"虚假贷款";
        case JJRFraudTypeIdentityTheft: return @"身份盗用";
        case JJRFraudTypeAdvanceFee: return @"预付费诈骗";
        case JJRFraudTypePhoneCall: return @"电话诈骗";
        case JJRFraudTypeFakeApp: return @"虚假APP";
        case JJRFraudTypePersonalInfo: return @"信息泄露";
        default: return @"未知类型";
    }
}

- (NSString *)riskLevelDescription:(JJRRiskLevel)level {
    switch (level) {
        case JJRRiskLevelLow: return @"低风险";
        case JJRRiskLevelMedium: return @"中风险";
        case JJRRiskLevelHigh: return @"高风险";
        case JJRRiskLevelCritical: return @"极高风险";
        default: return @"未知";
    }
}

- (UIColor *)riskLevelColor:(JJRRiskLevel)level {
    switch (level) {
        case JJRRiskLevelLow: return [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:1.0];
        case JJRRiskLevelMedium: return [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
        case JJRRiskLevelHigh: return [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
        case JJRRiskLevelCritical: return [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0];
        default: return [UIColor grayColor];
    }
}

- (NSDictionary *)getFraudStatistics {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    
    // 按类型统计
    NSMutableDictionary *typeStats = [NSMutableDictionary dictionary];
    for (JJRFraudCase *fraudCase in self.fraudCases) {
        NSString *typeKey = [self fraudTypeDescription:fraudCase.fraudType];
        NSNumber *count = typeStats[typeKey] ?: @0;
        typeStats[typeKey] = @([count integerValue] + 1);
    }
    stats[@"typeStats"] = typeStats;
    
    // 按风险等级统计
    NSMutableDictionary *riskStats = [NSMutableDictionary dictionary];
    for (JJRFraudCase *fraudCase in self.fraudCases) {
        NSString *riskKey = [self riskLevelDescription:fraudCase.riskLevel];
        NSNumber *count = riskStats[riskKey] ?: @0;
        riskStats[riskKey] = @([count integerValue] + 1);
    }
    stats[@"riskStats"] = riskStats;
    
    stats[@"totalCases"] = @(self.fraudCases.count);
    stats[@"totalTips"] = @(self.preventionTips.count);
    
    return [stats copy];
}

@end 
