//
//  JJRApplicationProgressViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRApplicationProgressViewController.h"
#import "JJRApplicationProgressViewModel.h"

typedef NS_ENUM(NSInteger, ProgressSectionType) {
    ProgressSectionTypeSuccess = 0,
    ProgressSectionTypeAmount,
    ProgressSectionTypeInstitution,
    ProgressSectionTypeReminder,
    ProgressSectionTypeSteps,
    ProgressSectionTypeContact,
    ProgressSectionTypeCount
};

@interface JJRApplicationProgressViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JJRApplicationProgressViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation JJRApplicationProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请进度";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViewModel];
    [self setupGradientBackground];
    [self setupTableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.gradientLayer.frame = self.view.bounds;
}

#pragma mark - Setup

- (void)setupViewModel {
    self.viewModel = [[JJRApplicationProgressViewModel alloc] init];
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
    return ProgressSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case ProgressSectionTypeSteps:
            return self.viewModel.progressSteps.count;
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
        case ProgressSectionTypeSuccess:
            [self setupSuccessCell:cell];
            break;
        case ProgressSectionTypeAmount:
            [self setupAmountCell:cell];
            break;
        case ProgressSectionTypeInstitution:
            [self setupInstitutionCell:cell];
            break;
        case ProgressSectionTypeReminder:
            [self setupReminderCell:cell];
            break;
        case ProgressSectionTypeSteps:
            [self setupStepCell:cell atIndex:indexPath.row];
            break;
        case ProgressSectionTypeContact:
            [self setupContactCell:cell];
            break;
    }
    
    return cell;
}

#pragma mark - Cell Setup Methods

- (void)setupSuccessCell:(UITableViewCell *)cell {
    // 成功卡片
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 12;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 8;
    [cell.contentView addSubview:cardView];
    
    // 成功图标
    UIImageView *successIcon = [[UIImageView alloc] init];
    successIcon.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
    successIcon.tintColor = [UIColor colorWithHexString:@"#4CAF50"];
    [cardView addSubview:successIcon];
    
    // 成功消息
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = self.viewModel.successMessage;
    messageLabel.font = FONT_BOLD(16);
    messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    messageLabel.numberOfLines = 2;
    [cardView addSubview:messageLabel];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(20);
        make.top.bottom.equalTo(cell.contentView).inset(10);
    }];
    
    [successIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.centerY.equalTo(cardView);
        make.width.height.mas_equalTo(24);
    }];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(successIcon.mas_right).offset(10);
        make.right.equalTo(cardView).offset(-20);
        make.centerY.equalTo(cardView);
        make.height.mas_equalTo(44);
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
    
    // 额度数字
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = self.viewModel.approvedAmount;
    amountLabel.font = FONT_BOLD(48);
    amountLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    amountLabel.textAlignment = NSTextAlignmentLeft;
    [cardView addSubview:amountLabel];
    
    // 时间信息
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = [NSString stringWithFormat:@"%@", self.viewModel.processingTime];
    timeLabel.font = FONT_BOLD(48);
    timeLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [cardView addSubview:timeLabel];
    
    // 额度说明
    UILabel *amountDescLabel = [[UILabel alloc] init];
    amountDescLabel.text = @"预授信额度（元）";
    amountDescLabel.font = FONT_REGULAR(14);
    amountDescLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    amountDescLabel.textAlignment = NSTextAlignmentLeft;
    [cardView addSubview:amountDescLabel];
    
    // 时间说明
    UILabel *timeDescLabel = [[UILabel alloc] init];
    timeDescLabel.text = @"最快放款时间";
    timeDescLabel.font = FONT_REGULAR(14);
    timeDescLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    timeDescLabel.textAlignment = NSTextAlignmentRight;
    [cardView addSubview:timeDescLabel];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(20);
        make.top.bottom.equalTo(cell.contentView).inset(10);
    }];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.top.equalTo(cardView).offset(20);
        make.width.mas_equalTo(SCREEN_WIDTH/2 - 40);
        make.height.mas_equalTo(60);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-20);
        make.centerY.equalTo(amountLabel);
        make.width.mas_equalTo(SCREEN_WIDTH/2 - 40);
        make.height.mas_equalTo(60);
    }];
    
    [amountDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountLabel);
        make.top.equalTo(amountLabel.mas_bottom).offset(5);
        make.bottom.equalTo(cardView).offset(-20);
        make.height.mas_equalTo(22);
    }];
    
    [timeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeLabel);
        make.centerY.equalTo(amountDescLabel);
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
    
    // 机构图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"img_29938b72a413"];
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
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(20);
        make.top.bottom.equalTo(cell.contentView).inset(10);
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.centerY.equalTo(cardView);
        make.width.height.mas_equalTo(50);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(15);
        make.right.equalTo(cardView).offset(-20);
        make.top.equalTo(iconView).offset(5);
        make.height.mas_equalTo(24);
    }];
    
    [fullNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
}

- (void)setupReminderCell:(UITableViewCell *)cell {
    // 提醒卡片
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor colorWithHexString:@"#FFF8E1"];
    cardView.layer.cornerRadius = 12;
    cardView.layer.borderWidth = 1;
    cardView.layer.borderColor = [UIColor colorWithHexString:@"#FFB74D"].CGColor;
    [cell.contentView addSubview:cardView];
    
    // 提醒图标
    UIImageView *warningIcon = [[UIImageView alloc] init];
    warningIcon.image = [UIImage systemImageNamed:@"exclamationmark.triangle.fill"];
    warningIcon.tintColor = [UIColor colorWithHexString:@"#FF8C00"];
    [cardView addSubview:warningIcon];
    
    // 提醒文字
    UILabel *reminderLabel = [[UILabel alloc] init];
    reminderLabel.text = self.viewModel.phoneReminderText;
    reminderLabel.font = FONT_MEDIUM(16);
    reminderLabel.textColor = [UIColor colorWithHexString:@"#E65100"];
    reminderLabel.numberOfLines = 2;
    [cardView addSubview:reminderLabel];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(20);
        make.top.bottom.equalTo(cell.contentView).inset(10);
    }];
    
    [warningIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.centerY.equalTo(cardView);
        make.width.height.mas_equalTo(24);
    }];
    
    [reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(warningIcon.mas_right).offset(10);
        make.right.equalTo(cardView).offset(-20);
        make.centerY.equalTo(cardView);
        make.height.mas_equalTo(44);
    }];
}

- (void)setupStepCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
    if (index == 0) {
        // 第一个步骤cell包含卡片和标题
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
        
        // 添加所有步骤
        for (NSInteger i = 0; i < self.viewModel.progressSteps.count; i++) {
            [self addStepToContainer:stepsContainer atIndex:i];
        }
        
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
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
            make.left.right.equalTo(cardView);
            make.bottom.equalTo(cardView).offset(-20);
        }];
    }
}

- (void)addStepToContainer:(UIView *)container atIndex:(NSInteger)index {
    NSDictionary *stepInfo = self.viewModel.progressSteps[index];
    
    // 步骤图标
    UIImageView *stepIcon = [[UIImageView alloc] init];
    if ([stepInfo[@"status"] isEqualToString:@"completed"]) {
        stepIcon.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
        stepIcon.tintColor = [UIColor colorWithHexString:@"#4CAF50"];
    } else if ([stepInfo[@"status"] isEqualToString:@"current"]) {
        stepIcon.image = [UIImage systemImageNamed:@"phone.circle.fill"];
        stepIcon.tintColor = [UIColor colorWithHexString:@"#3B82F6"];
    } else {
        stepIcon.image = [UIImage systemImageNamed:@"dollarsign.circle"];
        stepIcon.tintColor = [UIColor colorWithHexString:@"#CCCCCC"];
    }
    [container addSubview:stepIcon];
    
    // 步骤标题
    UILabel *stepLabel = [[UILabel alloc] init];
    stepLabel.text = stepInfo[@"title"];
    stepLabel.font = FONT_MEDIUM(14);
    stepLabel.textColor = [stepInfo[@"status"] isEqualToString:@"pending"] ? 
                         [UIColor colorWithHexString:@"#999999"] : 
                         [UIColor colorWithHexString:@"#333333"];
    stepLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:stepLabel];
    
    // 状态标签
    UILabel *statusLabel = [[UILabel alloc] init];
    if ([stepInfo[@"status"] isEqualToString:@"completed"]) {
        statusLabel.text = @"已通过";
        statusLabel.textColor = [UIColor colorWithHexString:@"#4CAF50"];
    } else if ([stepInfo[@"status"] isEqualToString:@"current"]) {
        statusLabel.text = @"请保持电话畅通";
        statusLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    } else {
        statusLabel.text = @"放款到账";
        statusLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    statusLabel.font = FONT_REGULAR(12);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:statusLabel];
    
    // 箭头（除了最后一个步骤）
    if (index < self.viewModel.progressSteps.count - 1) {
        UIImageView *arrowIcon = [[UIImageView alloc] init];
        arrowIcon.image = [UIImage systemImageNamed:@"chevron.right"];
        arrowIcon.tintColor = [UIColor colorWithHexString:@"#FF772C"];
        [container addSubview:arrowIcon];
        
        CGFloat arrowX = 80 + index * 110 + 50;
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container).offset(arrowX);
            make.centerY.equalTo(stepIcon);
            make.width.height.mas_equalTo(16);
        }];
    }
    
    CGFloat stepX = 60 + index * 110;
    
    [stepIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(stepX);
        make.top.equalTo(container).offset(10);
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
        make.bottom.equalTo(container).offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(18);
    }];
}

- (void)setupContactCell:(UITableViewCell *)cell {
    // 联系卡片
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 12;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowOpacity = 0.1;
    cardView.layer.shadowRadius = 8;
    [cell.contentView addSubview:cardView];
    
    // 电话图标
    UIImageView *phoneIcon = [[UIImageView alloc] init];
    phoneIcon.image = [UIImage systemImageNamed:@"phone.circle.fill"];
    phoneIcon.tintColor = [UIColor colorWithHexString:@"#3B82F6"];
    [cardView addSubview:phoneIcon];
    
    // 联系信息
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.text = self.viewModel.servicePhone;
    contactLabel.font = FONT_MEDIUM(16);
    contactLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [cardView addSubview:contactLabel];
    
    // 位置图标
    UIImageView *locationIcon = [[UIImageView alloc] init];
    locationIcon.image = [UIImage systemImageNamed:@"location.circle.fill"];
    locationIcon.tintColor = [UIColor colorWithHexString:@"#3B82F6"];
    [cardView addSubview:locationIcon];
    
    // 位置信息
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.text = self.viewModel.serviceLocation;
    locationLabel.font = FONT_MEDIUM(16);
    locationLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    [cardView addSubview:locationLabel];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(20);
        make.top.bottom.equalTo(cell.contentView).inset(10);
    }];
    
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardView).offset(20);
        make.centerY.equalTo(cardView);
        make.width.height.mas_equalTo(24);
    }];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIcon.mas_right).offset(10);
        make.centerY.equalTo(cardView);
        make.height.mas_equalTo(22);
    }];
    
    [locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(locationLabel.mas_left).offset(-10);
        make.centerY.equalTo(cardView);
        make.width.height.mas_equalTo(24);
    }];
    
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardView).offset(-20);
        make.centerY.equalTo(cardView);
        make.height.mas_equalTo(22);
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ProgressSectionTypeSuccess:
            return 80;
        case ProgressSectionTypeAmount:
            return 120;
        case ProgressSectionTypeInstitution:
            return 100;
        case ProgressSectionTypeReminder:
            return 80;
        case ProgressSectionTypeSteps:
            return indexPath.row == 0 ? 160 : 0; // 只显示第一个，包含所有步骤
        case ProgressSectionTypeContact:
            return 80;
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

@end 