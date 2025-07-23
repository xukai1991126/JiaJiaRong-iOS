//
//  JJRRiskAssessmentViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRRiskAssessmentViewController.h"
#import "JJRRiskAssessmentViewModel.h"
#import "JJRRiskInputFormView.h"

@interface JJRRiskResultHeaderView : UIView

@property (nonatomic, strong) JJRRiskAssessmentResult *result;
@property (nonatomic, strong) JJRRiskAssessmentViewModel *viewModel;

- (instancetype)initWithResult:(JJRRiskAssessmentResult *)result viewModel:(JJRRiskAssessmentViewModel *)viewModel;

@end

@interface JJRRiskFactorCell : UITableViewCell

@property (nonatomic, strong) JJRRiskFactor *riskFactor;
@property (nonatomic, strong) JJRRiskAssessmentViewModel *viewModel;

- (void)configureWithRiskFactor:(JJRRiskFactor *)factor viewModel:(JJRRiskAssessmentViewModel *)viewModel;

@end

@interface JJRRiskRecommendationCell : UITableViewCell

@property (nonatomic, strong) NSString *recommendation;

- (void)configureWithRecommendation:(NSString *)recommendation;

@end

@interface JJRRiskAssessmentViewController () <UITableViewDataSource, UITableViewDelegate, JJRRiskAssessmentViewModelDelegate, JJRRiskInputFormViewDelegate>

@property (nonatomic, strong) JJRRiskAssessmentViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JJRRiskInputFormView *inputFormView;
@property (nonatomic, strong) JJRRiskResultHeaderView *resultHeaderView;

@end

@implementation JJRRiskAssessmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 🔧 隐藏底部 TabBar
    self.hidesBottomBarWhenPushed = YES;
    
    self.title = @"风险评估";
    
    [self setupViewModel];
    [self setupUI];
    [self setupGradientBackground];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateGradientFrame];
}

#pragma mark - Setup

- (void)setupViewModel {
    self.viewModel = [[JJRRiskAssessmentViewModel alloc] init];
    self.viewModel.delegate = self;
}

- (void)setupUI {
    // 设置表格视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    // 设置自动行高
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 50.0;
    
    [self.view addSubview:self.tableView];
    
    // 设置约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 注册Cell
    [self.tableView registerClass:[JJRRiskFactorCell class] forCellReuseIdentifier:@"RiskFactorCell"];
    [self.tableView registerClass:[JJRRiskRecommendationCell class] forCellReuseIdentifier:@"RecommendationCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InputFormCell"];
    
    // 设置输入表单
    [self setupInputForm];
}

- (void)setupInputForm {
    // 重置ViewModel状态
    self.viewModel.assessmentResult = nil;
    
    self.inputFormView = [[JJRRiskInputFormView alloc] initWithUserProfile:self.viewModel.userProfile];
    self.inputFormView.delegate = self;
    
    // 计算合适的高度 (更紧凑的布局)
    CGFloat formHeight = 20 + 6 * 70 + 50 + 3 * 55 + 80; // 优化间距：输入框70，选择器50，开关55，底部80
    
    // 设置表格头部视图
    self.inputFormView.frame = CGRectMake(0, 0, SCREEN_WIDTH, formHeight);
    self.tableView.tableHeaderView = self.inputFormView;
    
    // 清除结果头部视图
    self.resultHeaderView = nil;
}

- (void)setupGradientBackground {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#F2582B"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1" alpha:0.0].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)updateGradientFrame {
    // 更新渐变背景的frame
    for (CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.view.bounds;
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.assessmentResult) {
        // 显示评估结果
        switch (indexPath.section) {
            case 0: {
                // 总体评估结果 - 使用header view显示，这里返回空cell
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputFormCell" forIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            case 1: {
                // 风险因子
                JJRRiskFactorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RiskFactorCell" forIndexPath:indexPath];
                JJRRiskFactor *factor = self.viewModel.assessmentResult.riskFactors[indexPath.row];
                [cell configureWithRiskFactor:factor viewModel:self.viewModel];
                return cell;
            }
            case 2: {
                // 建议
                JJRRiskRecommendationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendationCell" forIndexPath:indexPath];
                NSString *recommendation = self.viewModel.assessmentResult.recommendations[indexPath.row];
                [cell configureWithRecommendation:recommendation];
                return cell;
            }
            default: {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputFormCell" forIndexPath:indexPath];
                return cell;
            }
        }
    } else {
        // 显示输入表单 - 表单在header view中
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputFormCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.viewModel.assessmentResult && section == 0) {
        // 总体评估结果头部视图
        if (!self.resultHeaderView) {
            self.resultHeaderView = [[JJRRiskResultHeaderView alloc] initWithResult:self.viewModel.assessmentResult viewModel:self.viewModel];
        }
        return self.resultHeaderView;
    }
    
    // 其他section的标题
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [self.viewModel titleForSection:section];
    titleLabel.font = FONT_BOLD(18);
    titleLabel.textColor = TEXT_COLOR;
    [headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(20);
        make.centerY.equalTo(headerView);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.viewModel.assessmentResult && section == 0) {
        return 200; // 结果头部视图高度
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.assessmentResult) {
        if (indexPath.section == 0) {
            return 0; // 总体结果在header中显示
        }
        return UITableViewAutomaticDimension;
    } else {
        return 0; // 输入表单在header中显示
    }
}

#pragma mark - JJRRiskAssessmentViewModelDelegate

- (void)riskAssessmentDidStartAnalyzing {
    [self.inputFormView updateAssessmentButtonState:YES];
}

- (void)riskAssessmentDidFinishWithResult:(JJRRiskAssessmentResult *)result {
    [self.inputFormView updateAssessmentButtonState:NO];
    
    // 完全隐藏输入表单
    self.tableView.tableHeaderView = nil;
    self.inputFormView = nil;
    
    // 创建结果头部视图
    self.resultHeaderView = [[JJRRiskResultHeaderView alloc] initWithResult:result viewModel:self.viewModel];
    
    // 重新加载数据以显示结果
    [self.tableView reloadData];
    
    // 滚动到顶部
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)riskAssessmentDidFailWithError:(NSError *)error {
    [self.inputFormView updateAssessmentButtonState:NO];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"评估失败" 
                                                                   message:error.localizedDescription 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - JJRRiskInputFormViewDelegate

- (void)riskInputFormView:(JJRRiskInputFormView *)formView didUpdateProfile:(JJRUserRiskProfile *)profile {
    [self.viewModel updateUserProfile:profile];
}

- (void)riskInputFormViewDidTapAssessment:(JJRRiskInputFormView *)formView {
    [self.viewModel startRiskAssessment];
}

@end

#pragma mark - JJRRiskResultHeaderView

@implementation JJRRiskResultHeaderView

- (instancetype)initWithResult:(JJRRiskAssessmentResult *)result viewModel:(JJRRiskAssessmentViewModel *)viewModel {
    if (self = [super init]) {
        self.result = result;
        self.viewModel = viewModel;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 16;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 4);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 8;
    [self addSubview:cardView];
    
    // 风险等级标签
    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.text = [NSString stringWithFormat:@"风险等级：%@", self.result.levelDescription];
    levelLabel.font = FONT_BOLD(20);
    levelLabel.textColor = [self.viewModel colorForRiskLevel:self.result.overallLevel];
    [cardView addSubview:levelLabel];
    
    // 评分标签
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = [NSString stringWithFormat:@"综合评分：%.0f分", self.result.overallScore];
    scoreLabel.font = FONT_MEDIUM(18);
    scoreLabel.textColor = TEXT_COLOR;
    [cardView addSubview:scoreLabel];
    
    // 评估时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = [NSString stringWithFormat:@"评估时间：%@", [formatter stringFromDate:self.result.assessmentDate]];
    timeLabel.font = FONT_REGULAR(14);
    timeLabel.textColor = PLACEHOLDER_COLOR;
    [cardView addSubview:timeLabel];
    
    // 重新评估按钮
    UIButton *reAssessButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reAssessButton setTitle:@"重新评估" forState:UIControlStateNormal];
    reAssessButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    reAssessButton.titleLabel.font = FONT_MEDIUM(16);
    [reAssessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reAssessButton.layer.cornerRadius = 20;
    [reAssessButton addTarget:self action:@selector(reAssessButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:reAssessButton];
    
    // 设置约束
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).inset(20);
    }];
    
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(cardView).offset(20);
    }];
    
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.top.equalTo(levelLabel.mas_bottom).offset(8);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.top.equalTo(scoreLabel.mas_bottom).offset(8);
    }];
    
    [reAssessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-20);
        make.centerY.equalTo(cardView);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
}

- (void)reAssessButtonTapped {
    // 通知父控制器重新开始评估
    UIViewController *parentVC = [self findViewController];
    if ([parentVC isKindOfClass:[JJRRiskAssessmentViewController class]]) {
        JJRRiskAssessmentViewController *riskVC = (JJRRiskAssessmentViewController *)parentVC;
        [riskVC setupInputForm];
        [riskVC.tableView reloadData];
    }
}

- (UIViewController *)findViewController {
    UIResponder *responder = self;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end

#pragma mark - JJRRiskFactorCell

@implementation JJRRiskFactorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithRiskFactor:(JJRRiskFactor *)factor viewModel:(JJRRiskAssessmentViewModel *)viewModel {
    self.riskFactor = factor;
    self.viewModel = viewModel;
    
    // 清除之前的子视图
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    // 卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 12;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 4;
    [self.contentView addSubview:cardView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = factor.title;
    titleLabel.font = FONT_BOLD(16);
    titleLabel.textColor = TEXT_COLOR;
    [cardView addSubview:titleLabel];
    
    // 描述
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = factor.factorDescription;
    descLabel.font = FONT_REGULAR(14);
    descLabel.textColor = PLACEHOLDER_COLOR;
    [cardView addSubview:descLabel];
    
    // 评分
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = [NSString stringWithFormat:@"%.0f分", factor.score];
    scoreLabel.font = FONT_BOLD(16);
    scoreLabel.textColor = [viewModel colorForRiskLevel:factor.level];
    [cardView addSubview:scoreLabel];
    
    // 风险等级
    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.text = [viewModel riskLevelDescription:factor.level];
    levelLabel.font = FONT_MEDIUM(14);
    levelLabel.textColor = [viewModel colorForRiskLevel:factor.level];
    [cardView addSubview:levelLabel];
    
    // 建议
    UILabel *suggestionLabel = [[UILabel alloc] init];
    suggestionLabel.text = factor.suggestion;
    suggestionLabel.font = FONT_REGULAR(12);
    suggestionLabel.textColor = TEXT_COLOR;
    suggestionLabel.numberOfLines = 0;
    [cardView addSubview:suggestionLabel];
    
    // 设置约束
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(8, 20, 8, 20));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(cardView).offset(16);
    }];
    
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-16);
        make.top.equalTo(cardView).offset(16);
    }];
    
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-16);
        make.top.equalTo(scoreLabel.mas_bottom).offset(4);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(16);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.right.lessThanOrEqualTo(scoreLabel.mas_left).offset(-16);
    }];
    
    [suggestionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cardView).inset(16);
        make.top.equalTo(descLabel.mas_bottom).offset(12);
        make.bottom.equalTo(cardView).offset(-16);
    }];
}

@end

#pragma mark - JJRRiskRecommendationCell

@implementation JJRRiskRecommendationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithRecommendation:(NSString *)recommendation {
    self.recommendation = recommendation;
    
    // 清除之前的子视图
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    // 卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 12;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 4;
    [self.contentView addSubview:cardView];
    
    // 建议文本
    UILabel *recommendationLabel = [[UILabel alloc] init];
    recommendationLabel.text = recommendation;
    recommendationLabel.font = FONT_REGULAR(15);
    recommendationLabel.textColor = TEXT_COLOR;
    recommendationLabel.numberOfLines = 0;
    [cardView addSubview:recommendationLabel];
    
    // 设置约束
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(4, 20, 4, 20));
    }];
    
    [recommendationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cardView).inset(16);
    }];
}

@end 