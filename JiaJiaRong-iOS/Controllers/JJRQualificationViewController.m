//
//  JJRQualificationViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRQualificationViewController.h"
#import "JJRQualificationViewModel.h"
#import "JJRApplicationProgressViewController.h"

typedef NS_ENUM(NSInteger, QualificationSectionType) {
    QualificationSectionTypeHeader = 0,
    QualificationSectionTypeAmount,
    QualificationSectionTypeInstitution,
    QualificationSectionTypeSteps,
    QualificationSectionTypeButton,
    QualificationSectionTypeCount
};

@interface JJRQualificationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JJRQualificationViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAGradientLayer *amountGradientLayer;

@end

@implementation JJRQualificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"资质初审";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViewModel];
    [self setupGradientBackground];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航栏并设置样式
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F2582B"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 恢复导航栏样式
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.titleTextAttributes = nil;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.gradientLayer.frame = self.view.bounds;
}

#pragma mark - Setup

- (void)setupViewModel {
    self.viewModel = [[JJRQualificationViewModel alloc] init];
}

- (void)setupGradientBackground {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#F2582B"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1" alpha:0.0].CGColor
    ];
    self.gradientLayer.startPoint = CGPointMake(0.5, 0);
    self.gradientLayer.endPoint = CGPointMake(0.5, 1);
    self.gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return QualificationSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case QualificationSectionTypeSteps:
            return 1; // 只显示一个cell，包含所有步骤
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    // 清理之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    switch (indexPath.section) {
        case QualificationSectionTypeHeader:
            [self setupHeaderCell:cell];
            break;
        case QualificationSectionTypeAmount:
            [self setupAmountCell:cell];
            break;
        case QualificationSectionTypeInstitution:
            [self setupInstitutionCell:cell];
            break;
        case QualificationSectionTypeSteps:
            [self setupStepCell:cell atIndex:indexPath.row];
            break;
        case QualificationSectionTypeButton:
            [self setupButtonCell:cell];
            break;
    }
    
    return cell;
}

#pragma mark - Cell Setup Methods

- (void)setupHeaderCell:(UITableViewCell *)cell {
    // 盾牌图标
    UIImageView *shieldIcon = [[UIImageView alloc] init];
    shieldIcon.image = [UIImage imageNamed:@"me_ico_ilike_icon"];
    shieldIcon.tintColor = [UIColor whiteColor];
    [cell.contentView addSubview:shieldIcon];
    
    // 用户名和消息
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = [NSString stringWithFormat:@"%@ %@", self.viewModel.userName, self.viewModel.qualificationMessage];
    messageLabel.font = FONT_BOLD(18);
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:messageLabel];
    
    // 提示信息
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"请保持您的电话畅通 30分钟内将有放款申核人员电话复审！";
    subtitleLabel.font = FONT_REGULAR(14);
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.numberOfLines = 2;
    [cell.contentView addSubview:subtitleLabel];
    
    [shieldIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(20);
        make.top.equalTo(cell.contentView).offset(20);
        make.width.height.mas_equalTo(24);
    }];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shieldIcon.mas_right).offset(10);
        make.right.equalTo(cell.contentView).offset(-20);
        make.centerY.equalTo(shieldIcon);
        make.height.mas_equalTo(24);
    }];
    
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(messageLabel);
        make.top.equalTo(messageLabel.mas_bottom).offset(10);
        make.bottom.equalTo(cell.contentView).offset(-20);
        make.height.mas_equalTo(40);
    }];
}

- (void)setupAmountCell:(UITableViewCell *)cell {
    // 卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 12;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 8;
    [cell.contentView addSubview:cardView];
    
    // 装饰线
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    leftLine.layer.cornerRadius = 1;
    [cardView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    rightLine.layer.cornerRadius = 1;
    [cardView addSubview:rightLine];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"您的预估额度为（元）";
    titleLabel.font = FONT_REGULAR(16);
    titleLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:titleLabel];
    
    // 额度背景
    UIView *amountBg = [[UIView alloc] init];
    amountBg.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    amountBg.layer.cornerRadius = 8;
    [cardView addSubview:amountBg];
    
    // 额度数字
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = self.viewModel.estimatedAmount;
    amountLabel.font = FONT_BOLD(36);
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [amountBg addSubview:amountLabel];
    
    // 说明文字
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.text = @"*具体审批额度以实际放款为准";
    noteLabel.font = FONT_REGULAR(12);
    noteLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:noteLabel];
    
    // 期限和利率信息
    UILabel *periodLabel = [[UILabel alloc] init];
    periodLabel.text = [NSString stringWithFormat:@"预估办理期限：%@", self.viewModel.loanPeriod];
    periodLabel.font = FONT_REGULAR(14);
    periodLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:periodLabel];
    
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.text = [NSString stringWithFormat:@"年化（年利）：%@", self.viewModel.yearlyRate];
    rateLabel.font = FONT_REGULAR(14);
    rateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:rateLabel];
    
    // 约束设置
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(20);
        make.top.bottom.equalTo(cell.contentView).inset(10);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.centerY.equalTo(titleLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-20);
        make.centerY.equalTo(titleLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(20);
        make.centerX.equalTo(cardView);
        make.height.mas_equalTo(22);
    }];
    
    [amountBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.right.equalTo(cardView).inset(20);
        make.height.mas_equalTo(80);
    }];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(amountBg);
        make.height.mas_equalTo(40);
    }];
    
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountBg.mas_bottom).offset(10);
        make.centerX.equalTo(cardView);
        make.height.mas_equalTo(20);
    }];
    
    [periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noteLabel.mas_bottom).offset(15);
        make.left.equalTo(cardView).offset(20);
        make.height.mas_equalTo(22);
    }];
    
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(periodLabel);
        make.right.equalTo(cardView).offset(-20);
        make.bottom.equalTo(cardView).offset(-20);
        make.height.mas_equalTo(22);
    }];
}

- (void)setupInstitutionCell:(UITableViewCell *)cell {
    // 卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 12;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 8;
    [cell.contentView addSubview:cardView];
    
    // 装饰线
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    leftLine.layer.cornerRadius = 1;
    [cardView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    rightLine.layer.cornerRadius = 1;
    [cardView addSubview:rightLine];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"本次助贷服务机构";
    titleLabel.font = FONT_REGULAR(16);
    titleLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:titleLabel];
    
    // 机构图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"img_akfjfkjakjfjk"];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.layer.cornerRadius = 25;
    [cardView addSubview:iconView];
    
    // 机构名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.viewModel.institutionName;
    nameLabel.font = FONT_BOLD(18);
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [cardView addSubview:nameLabel];
    
    // 机构全称
    UILabel *fullNameLabel = [[UILabel alloc] init];
    fullNameLabel.text = self.viewModel.institutionFullName;
    fullNameLabel.font = FONT_REGULAR(14);
    fullNameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cardView addSubview:fullNameLabel];
    
    // 特别提醒背景容器
    UIView *reminderBgView = [[UIView alloc] init];
    reminderBgView.backgroundColor = [UIColor colorWithHexString:@"#FFF8E1"];
    reminderBgView.layer.cornerRadius = 8;
    reminderBgView.layer.borderWidth = 1;
    reminderBgView.layer.borderColor = [UIColor colorWithHexString:@"#FFE082"].CGColor;
    [cardView addSubview:reminderBgView];
    
    // 提醒图标
    UIImageView *warningIcon = [[UIImageView alloc] init];
    warningIcon.image = [UIImage systemImageNamed:@"exclamationmark.triangle.fill"];
    warningIcon.tintColor = [UIColor colorWithHexString:@"#FF8C00"];
    [reminderBgView addSubview:warningIcon];
    
    // 特别提醒标题
    UILabel *warningTitleLabel = [[UILabel alloc] init];
    warningTitleLabel.text = @"特别提醒";
    warningTitleLabel.font = FONT_BOLD(16);
    warningTitleLabel.textColor = [UIColor colorWithHexString:@"#FF8C00"];
    [reminderBgView addSubview:warningTitleLabel];
    
    // 提醒内容
    UILabel *reminderLabel = [[UILabel alloc] init];
    reminderLabel.text = self.viewModel.reminderText;
    reminderLabel.font = FONT_REGULAR(14);
    reminderLabel.textColor = [UIColor colorWithHexString:@"#E65100"];
    reminderLabel.numberOfLines = 2;
    [reminderBgView addSubview:reminderLabel];
    
    // 约束设置
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(20);
        make.top.bottom.equalTo(cell.contentView).inset(10);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.centerY.equalTo(titleLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-20);
        make.centerY.equalTo(titleLabel);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(2);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(20);
        make.centerX.equalTo(cardView);
        make.height.mas_equalTo(22);
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.width.height.mas_equalTo(50);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(15);
        make.top.equalTo(iconView);
        make.right.equalTo(cardView).offset(-20);
        make.height.mas_equalTo(24);
    }];
    
    [fullNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [reminderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cardView).inset(20);
        make.top.equalTo(iconView.mas_bottom).offset(20);
        make.bottom.equalTo(cardView).offset(-20);
    }];
    
    [warningIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reminderBgView).offset(15);
        make.top.equalTo(reminderBgView).offset(15);
        make.width.height.mas_equalTo(20);
    }];
    
    [warningTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(warningIcon.mas_right).offset(8);
        make.centerY.equalTo(warningIcon);
        make.height.mas_equalTo(22);
    }];
    
    [reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reminderBgView).offset(15);
        make.right.equalTo(reminderBgView).offset(-15);
        make.top.equalTo(warningTitleLabel.mas_bottom).offset(8);
        make.bottom.equalTo(reminderBgView).offset(-15);
        make.height.mas_equalTo(40);
    }];
}

- (void)setupStepCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
    // 只在第一个cell中显示所有内容
    if (index == 0) {
        // 卡片容器
        UIView *cardView = [[UIView alloc] init];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.layer.cornerRadius = 12;
        cardView.layer.shadowColor = [UIColor blackColor].CGColor;
        cardView.layer.shadowOffset = CGSizeMake(0, 2);
        cardView.layer.shadowOpacity = 0.1;
        cardView.layer.shadowRadius = 8;
        [cell.contentView addSubview:cardView];
        
        // 装饰线
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
        leftLine.layer.cornerRadius = 1;
        [cardView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
        rightLine.layer.cornerRadius = 1;
        [cardView addSubview:rightLine];
        
        // 标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"仅需三步  轻松拿钱";
        titleLabel.font = FONT_BOLD(16);
        titleLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cardView addSubview:titleLabel];
        
        // 步骤容器
        UIView *stepsContainer = [[UIView alloc] init];
        [cardView addSubview:stepsContainer];
        
        // 添加所有三个步骤
        for (NSInteger i = 0; i < self.viewModel.processSteps.count; i++) {
            [self addStepToContainer:stepsContainer atIndex:i];
        }
        
        // 约束设置
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cell.contentView).inset(20);
            make.top.bottom.equalTo(cell.contentView).inset(5);
        }];
        
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cardView).offset(20);
            make.centerY.equalTo(titleLabel);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
        }];
        
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cardView).offset(-20);
            make.centerY.equalTo(titleLabel);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(2);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cardView).offset(20);
            make.centerX.equalTo(cardView);
            make.height.mas_equalTo(22);
        }];
        
        [stepsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(30);
            make.left.right.equalTo(cardView);
            make.bottom.equalTo(cardView).offset(-20);
            make.height.mas_equalTo(120);
        }];
    }
}

- (void)addStepToContainer:(UIView *)container atIndex:(NSInteger)index {
    NSDictionary *stepInfo = self.viewModel.processSteps[index];
    
    // 步骤图标
    UIImageView *stepIcon = [[UIImageView alloc] init];
    if ([stepInfo[@"status"] isEqualToString:@"completed"]) {
        stepIcon.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
        stepIcon.tintColor = [UIColor colorWithHexString:@"#4CAF50"];
    } else {
        stepIcon.image = [UIImage systemImageNamed:@"circle"];
        stepIcon.tintColor = [UIColor colorWithHexString:@"#CCCCCC"];
    }
    [container addSubview:stepIcon];
    
    // 步骤标题
    UILabel *stepLabel = [[UILabel alloc] init];
    stepLabel.text = stepInfo[@"title"];
    stepLabel.font = FONT_MEDIUM(14);
    stepLabel.textColor = [stepInfo[@"status"] isEqualToString:@"completed"] ? 
                         [UIColor colorWithHexString:@"#333333"] : 
                         [UIColor colorWithHexString:@"#999999"];
    stepLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:stepLabel];
    
    // 状态标签
    UILabel *statusLabel = [[UILabel alloc] init];
    if ([stepInfo[@"status"] isEqualToString:@"completed"]) {
        statusLabel.text = @"已通过";
        statusLabel.textColor = [UIColor colorWithHexString:@"#4CAF50"];
    } else {
        statusLabel.text = @"请保持电话畅通";
        statusLabel.textColor = [UIColor colorWithHexString:@"#FF8C00"];
    }
    statusLabel.font = FONT_REGULAR(12);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:statusLabel];
    
    // 箭头（除了最后一个步骤）
    if (index < self.viewModel.processSteps.count - 1) {
        UIImageView *arrowIcon = [[UIImageView alloc] init];
        arrowIcon.image = [UIImage systemImageNamed:@"chevron.right"];
        arrowIcon.tintColor = [UIColor colorWithHexString:@"#FF772C"];
        [container addSubview:arrowIcon];
        
        CGFloat arrowX = 40 + index * 100 + 45; // 调整箭头位置
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container).offset(arrowX);
            make.centerY.equalTo(stepIcon);
            make.width.height.mas_equalTo(16);
        }];
    }
    
    // 计算每个步骤的X位置，确保在屏幕内合理分布
    CGFloat stepWidth = (SCREEN_WIDTH - 80) / 3; // 减去左右边距
    CGFloat stepX = 20 + index * stepWidth + stepWidth / 2 - 20; // 居中对齐
    
    [stepIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(stepX);
        make.top.equalTo(container).offset(20);
        make.width.height.mas_equalTo(40);
    }];
    
    [stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stepIcon);
        make.top.equalTo(stepIcon.mas_bottom).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(stepIcon);
        make.top.equalTo(stepLabel.mas_bottom).offset(5);
        make.bottom.equalTo(container).offset(-20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(18);
    }];
}

- (void)setupButtonCell:(UITableViewCell *)cell {
    // 协议checkbox
    UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkboxButton.backgroundColor = [UIColor clearColor];
    [checkboxButton setImage:[UIImage systemImageNamed:@"square"] forState:UIControlStateNormal];
    [checkboxButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateSelected];
    checkboxButton.tintColor = [UIColor colorWithHexString:@"#3B82F6"];
    checkboxButton.selected = self.viewModel.isAgreementChecked;
    [checkboxButton addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:checkboxButton];
    
    // 协议文字
    UILabel *agreementLabel = [[UILabel alloc] init];
    agreementLabel.text = [NSString stringWithFormat:@"请您仔细阅读以下信息 %@", self.viewModel.agreementTitle];
    agreementLabel.font = FONT_REGULAR(14);
    agreementLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [cell.contentView addSubview:agreementLabel];
    
    // 提交按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"立即领取额度" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = FONT_BOLD(18);
    submitButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    submitButton.layer.cornerRadius = 25;
    [submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:submitButton];
    
    [checkboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(20);
        make.top.equalTo(cell.contentView).offset(20);
        make.width.height.mas_equalTo(24);
    }];
    
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkboxButton.mas_right).offset(10);
        make.right.equalTo(cell.contentView).offset(-20);
        make.centerY.equalTo(checkboxButton);
        make.height.mas_equalTo(22);
    }];
    
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(20);
        make.top.equalTo(checkboxButton.mas_bottom).offset(30);
        make.bottom.equalTo(cell.contentView).offset(-40);
        make.height.mas_equalTo(46);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case QualificationSectionTypeHeader:
            return 120;
        case QualificationSectionTypeAmount:
            return 200;
        case QualificationSectionTypeInstitution:
            return 250;
        case QualificationSectionTypeSteps:
            return indexPath.row == 0 ? 200 : 0; // 只显示第一个，其他步骤在同一个cell中
        case QualificationSectionTypeButton:
            return 150;
        default:
            return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Actions

- (void)checkboxTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.viewModel.isAgreementChecked = sender.selected;
}

- (void)submitButtonTapped {
    if (!self.viewModel.isAgreementChecked) {
        [JJRToastTool showToast:@"请先同意协议"];
        return;
    }
    
    // 跳转到申请进度页面
    JJRApplicationProgressViewController *progressVC = [[JJRApplicationProgressViewController alloc] init];
    progressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:progressVC animated:YES];
}

@end 
