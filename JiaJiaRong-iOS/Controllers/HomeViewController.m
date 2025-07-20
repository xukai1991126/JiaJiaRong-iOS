//
//  HomeViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "HomeViewController.h"
#import "JJRNetworkService.h"
#import "JJRUserManager.h"
#import "LoginViewController.h"
#import "JJRApplyFormViewController.h"
#import "JJRIdCardViewController.h"
#import "JJRAuthorizationViewController.h"
#import "JJRResultViewController.h"
#import "WebViewController.h"
#import "JJRNewFeaturesViewController.h"

// 定义TableView的section类型
typedef NS_ENUM(NSInteger, HomeTableViewSection) {
    HomeTableViewSectionMain = 0,        // 主卡片区域
    HomeTableViewSectionAdvantages,      // 选择我们的优势
    HomeTableViewSectionConditions,     // 申请条件
    HomeTableViewSectionProcess,        // 申请流程
    HomeTableViewSectionNotice,         // 申请须知
    HomeTableViewSectionCount
};

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSString *applyBtnText;
@property (nonatomic, assign) BOOL protocolChecked;

// 数据源
@property (nonatomic, strong) NSArray *advantagesData;
@property (nonatomic, strong) NSArray *conditionsData;
@property (nonatomic, strong) NSArray *processData;

// 主卡片的UI组件（避免重用问题）
@property (nonatomic, strong) UIButton *mainApplyButton;
@property (nonatomic, strong) UIButton *mainCheckboxButton;
@property (nonatomic, strong) UILabel *mainProtocolLabel;

@end

@implementation HomeViewController

- (BOOL)requiresLogin {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    [self fetchChannelInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self fetchChannelInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Setup

- (void)setupData {
    self.applyBtnText = @"立即测算额度";
    self.protocolChecked = NO;
    
    // 优势数据
    self.advantagesData = @[
        @{@"icon": @"img_08208c762476", @"title": @"安心合规"},
        @{@"icon": @"img_f1d1b5668854", @"title": @"全程无忧"},
        @{@"icon": @"img_80f5ebcf6e04", @"title": @"数据加密"}
    ];
    
    // 申请条件数据
    self.conditionsData = @[
        @{@"icon": @"img_c0521233a331", @"title": @"二十周岁以上"},
        @{@"icon": @"img_2559e5fe7efb", @"title": @"本人身份证"},
        @{@"icon": @"img_c60c14f6750c", @"title": @"本人银行卡"}
    ];
    
    // 申请流程数据
    self.processData = @[
        @{@"icon": @"img_6034a4cb4367", @"title": @"人脸实名"},
        @{@"icon": @"img_1ccf22ec22d9", @"title": @"紧急联系人填写"},
        @{@"icon": @"img_5d69ae6da46f", @"title": @"前往审核中的页面"}
    ];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 设置背景渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = [UIScreen mainScreen].bounds;
    gradientLayer.colors = @[
        (id)[UIColor colorWithHexString:@"#F2582B"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1"].CGColor,
        (id)[UIColor colorWithHexString:@"#FAE9D1" alpha:0.0].CGColor
    ];
    gradientLayer.locations = @[@0.0, @0.8, @1.0];
    
    UIView *backgroundView = [[UIView alloc] init];
    [backgroundView.layer addSublayer:gradientLayer];
    self.tableView.backgroundView = backgroundView;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 设置contentInset，为状态栏留出空间
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(statusBarHeight + 20, 0, 12, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

#pragma mark - Network

- (void)fetchChannelInfo {
    [[JJRNetworkService sharedInstance] getAppChannelWithAppId:@"JJR" 
                                                       client:@"IOS" 
                                                      success:^(NSDictionary *response) {
        self.userInfo = response[@"data"];
        
        // 更新按钮文字
        if ([self.userInfo[@"model"] isEqualToString:@"B"]) {
            self.applyBtnText = @"立即申请";
        } else {
            if ([self.userInfo[@"authority"] boolValue]) {
                self.applyBtnText = @"查看申请进度";
            } else {
                self.applyBtnText = @"立即测算额度";
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新按钮文字
            if (self.mainApplyButton) {
                [self.mainApplyButton setTitle:self.applyBtnText forState:UIControlStateNormal];
            }
            
            // 更新协议区域显示状态
            BOOL shouldShowProtocol = [self.userInfo[@"audit"] integerValue] == 0;
            if (self.mainCheckboxButton) {
                self.mainCheckboxButton.hidden = !shouldShowProtocol;
            }
            if (self.mainProtocolLabel) {
                self.mainProtocolLabel.hidden = !shouldShowProtocol;
            }
            
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        NSLog(@"获取渠道信息失败: %@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HomeTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; // 每个section只有一行
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 清除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    switch (indexPath.section) {
        case HomeTableViewSectionMain:
            [self configureMainCell:cell];
            break;
        case HomeTableViewSectionAdvantages:
            [self configureAdvantagesCell:cell];
            break;
        case HomeTableViewSectionConditions:
            [self configureConditionsCell:cell];
            break;
        case HomeTableViewSectionProcess:
            [self configureProcessCell:cell];
            break;
        case HomeTableViewSectionNotice:
            [self configureNoticeCell:cell];
            break;
    }
    
    return cell;
}

#pragma mark - Cell Configuration

- (void)configureMainCell:(UITableViewCell *)cell {
    // 创建主卡片容器
    UIView *cardContainer = [[UIView alloc] init];
    cardContainer.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:cardContainer];
    
    // 背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"img_68eb3f371d12"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [cardContainer addSubview:backgroundImageView];
    
    // 白色内容区域
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 16;
    contentView.clipsToBounds = YES;
    [cardContainer addSubview:contentView];
    
    // 右上角装饰图片 - 放在白色内容区域之后，确保在最前面
    UIImageView *decorationImageView = [[UIImageView alloc] init];
    decorationImageView.image = [UIImage imageNamed:@"img_3edb7a959f5c"];
    decorationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cardContainer addSubview:decorationImageView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"上市公司旗下融资担保机构";
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    [contentView addSubview:titleLabel];
    
    // 金额标签
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = @"最高可借担保（元）";
    amountLabel.font = [UIFont systemFontOfSize:14];
    amountLabel.textColor = [UIColor colorWithHexString:@"#97999E"];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:amountLabel];
    
    // 金额数字
    UILabel *amountValueLabel = [[UILabel alloc] init];
    amountValueLabel.text = @"20,0000";
    amountValueLabel.font = [UIFont boldSystemFontOfSize:44];
    amountValueLabel.textColor = [UIColor colorWithHexString:@"#FC7507"];
    amountValueLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:amountValueLabel];
    
    // 利率标签
    UILabel *rateLabel = [[UILabel alloc] init];
    rateLabel.text = @"年化利率7.24%起";
    rateLabel.font = [UIFont systemFontOfSize:14];
    rateLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    rateLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:rateLabel];
    
    // 新功能入口按钮
    UIButton *newFeaturesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newFeaturesButton setTitle:@"智慧金融服务" forState:UIControlStateNormal];
    [newFeaturesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newFeaturesButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [newFeaturesButton setBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0]];
    newFeaturesButton.layer.cornerRadius = 20;
    newFeaturesButton.clipsToBounds = YES;
    
    [newFeaturesButton addTarget:self action:@selector(newFeaturesButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:newFeaturesButton];
    
    // 申请按钮
    self.mainApplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mainApplyButton setTitle:self.applyBtnText forState:UIControlStateNormal];
    [self.mainApplyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.mainApplyButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.mainApplyButton setBackgroundColor:[UIColor colorWithHexString:@"#FF772C"]];
    self.mainApplyButton.layer.cornerRadius = 23;
    self.mainApplyButton.clipsToBounds = YES;
    
    [self.mainApplyButton addTarget:self action:@selector(applyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.mainApplyButton];
    
    // 协议区域
    UIView *protocolView = [[UIView alloc] init];
    [contentView addSubview:protocolView];
    
    // 创建一个容器视图来包含复选框，扩大点击区域
    UIView *checkboxContainer = [[UIView alloc] init];
    checkboxContainer.backgroundColor = [UIColor clearColor];
    [protocolView addSubview:checkboxContainer];
    
    // 复选框
    self.mainCheckboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mainCheckboxButton setImage:[UIImage imageNamed:@"img_2a5bf1c39141_unselect"] forState:UIControlStateNormal];
    [self.mainCheckboxButton setImage:[UIImage imageNamed:@"img_2a5bf1c39141"] forState:UIControlStateSelected];
    self.mainCheckboxButton.selected = self.protocolChecked;
    [self.mainCheckboxButton addTarget:self action:@selector(protocolCheckboxTapped:) forControlEvents:UIControlEventTouchUpInside];
    [checkboxContainer addSubview:self.mainCheckboxButton];
    
    // 协议文本容器
    UIView *protocolTextContainer = [[UIView alloc] init];
    [protocolView addSubview:protocolTextContainer];
    
    // 创建"我已阅读并同意"文本
    UILabel *protocolPrefixLabel = [[UILabel alloc] init];
    protocolPrefixLabel.text = @"我已阅读并同意";
    protocolPrefixLabel.font = [UIFont systemFontOfSize:12];
    protocolPrefixLabel.textColor = [UIColor colorWithHexString:@"#97999E"];
    [protocolTextContainer addSubview:protocolPrefixLabel];
    
    // 服务协议按钮
    UIButton *serviceAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serviceAgreementButton setTitle:@" 《服务协议》" forState:UIControlStateNormal];
    [serviceAgreementButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    serviceAgreementButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [serviceAgreementButton addTarget:self action:@selector(serviceAgreementTapped) forControlEvents:UIControlEventTouchUpInside];
    [protocolTextContainer addSubview:serviceAgreementButton];
    
    // 隐私协议按钮
    UIButton *privacyAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [privacyAgreementButton setTitle:@" 《隐私协议》" forState:UIControlStateNormal];
    [privacyAgreementButton setTitleColor:[UIColor colorWithHexString:@"#FF772C"] forState:UIControlStateNormal];
    privacyAgreementButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [privacyAgreementButton addTarget:self action:@selector(privacyAgreementTapped) forControlEvents:UIControlEventTouchUpInside];
    [protocolTextContainer addSubview:privacyAgreementButton];
    
    // 设置约束
    [protocolPrefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(protocolTextContainer);
        make.height.mas_equalTo(20);
    }];
    
    [serviceAgreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(protocolPrefixLabel.mas_right).offset(0);
        make.centerY.equalTo(protocolTextContainer);
        make.height.mas_equalTo(20);
    }];
    
    [privacyAgreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serviceAgreementButton.mas_right).offset(0);
        make.centerY.equalTo(protocolTextContainer);
        make.height.mas_equalTo(20);
        make.right.lessThanOrEqualTo(protocolTextContainer).offset(-10);
    }];
    
    [protocolTextContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainCheckboxButton.mas_right).offset(10);
        make.centerY.equalTo(protocolView);
        make.right.equalTo(protocolView).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    // 给复选框容器也添加点击手势，扩大点击区域
    checkboxContainer.userInteractionEnabled = YES;
    UITapGestureRecognizer *checkboxTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkboxContainerTapped:)];
    [checkboxContainer addGestureRecognizer:checkboxTapGesture];
    
    // 根据audit状态设置协议区域可见性
    BOOL shouldShowProtocol = [self.userInfo[@"audit"] integerValue] == 0;
    self.mainCheckboxButton.hidden = !shouldShowProtocol;
    protocolTextContainer.hidden = !shouldShowProtocol;
    checkboxContainer.hidden = !shouldShowProtocol;
    
    // 设置约束
    [cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(18);
        make.top.equalTo(cell.contentView).offset(20);
        make.bottom.equalTo(cell.contentView).offset(-16);
        make.height.mas_equalTo(shouldShowProtocol ? 300 : 260);
    }];
    
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cardContainer);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(cardContainer).inset(10);
        make.top.equalTo(cardContainer).offset(30);
    }];
    
    [decorationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardContainer).offset(-15);
        make.right.equalTo(cardContainer);
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(74);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(18);
        make.top.equalTo(contentView).offset(14);
    }];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];
    
    [amountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(amountLabel.mas_bottom).offset(8);
    }];
    
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(amountValueLabel.mas_bottom).offset(12);
    }];
    
    // 新功能按钮约束
    [newFeaturesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView).inset(20);
        make.top.equalTo(rateLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(46);
    }];
    
    [self.mainApplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView).inset(20);
        make.top.equalTo(newFeaturesButton.mas_bottom).offset(10);
        make.height.mas_equalTo(46);
    }];
    
    // 复选框容器约束 - 扩大点击区域
    [checkboxContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(protocolView);
        make.centerY.equalTo(protocolView); // 与协议文本中心对齐
        make.width.mas_equalTo(24); // 扩大点击区域
        make.height.equalTo(protocolView); // 与协议文本同高
    }];
    
    // 复选框在容器中居中
    [self.mainCheckboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(checkboxContainer);
        make.centerY.equalTo(checkboxContainer);
        make.width.height.mas_equalTo(16);
    }];
    
    // 协议文本约束
    [self.mainProtocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkboxContainer.mas_right).offset(2);
        make.right.top.bottom.equalTo(protocolView);
    }];
    
    if (shouldShowProtocol) {
        [protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView).inset(23);
            make.top.equalTo(self.mainApplyButton.mas_bottom).offset(14);
            make.bottom.equalTo(contentView).offset(-14);
        }];
    } else {
        [protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView).inset(23);
            make.top.equalTo(self.mainApplyButton.mas_bottom).offset(14);
            make.height.mas_equalTo(0);
        }];
        
        [self.mainApplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.lessThanOrEqualTo(contentView).offset(-14);
        }];
    }
    
}

- (void)configureAdvantagesCell:(UITableViewCell *)cell {
    [self configureFeatureCard:cell 
                         title:@"选择我们的优势" 
                      subtitle:nil 
                          data:self.advantagesData 
                    layoutType:0]; // 0: 横向布局
}

- (void)configureConditionsCell:(UITableViewCell *)cell {
    [self configureFeatureCard:cell 
                         title:@"申请条件" 
                      subtitle:@"满足以下条件即可进行申请" 
                          data:self.conditionsData 
                    layoutType:0]; // 0: 横向布局
}

- (void)configureProcessCell:(UITableViewCell *)cell {
    [self configureFeatureCard:cell 
                         title:@"申请流程" 
                      subtitle:nil 
                          data:self.processData 
                    layoutType:1]; // 1: 纵向布局
}

- (void)configureNoticeCell:(UITableViewCell *)cell {
    // 创建卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 16;
    [cell.contentView addSubview:cardView];
    
    // 风险提示标题 - 红色醒目
    UILabel *riskTitleLabel = [[UILabel alloc] init];
    riskTitleLabel.text = @"⚠️ 风险提示";
    riskTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    riskTitleLabel.textColor = [UIColor redColor];
    riskTitleLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:riskTitleLabel];
    
    // 风险提示内容
    UILabel *riskContentLabel = [[UILabel alloc] init];
    riskContentLabel.text = @"借款有风险，请谨慎申请。请根据个人实际情况合理借贷，避免过度负债。如遇困难，请及时联系我们寻求帮助。";
    riskContentLabel.font = [UIFont systemFontOfSize:14];
    riskContentLabel.textColor = [UIColor redColor];
    riskContentLabel.numberOfLines = 0;
    riskContentLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:riskContentLabel];
    
    // 分隔线
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    [cardView addSubview:separatorLine];
    
    // 申请须知标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"申请须知";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:titleLabel];
    
    // 内容文本
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"本平台仅提供融资担保增信服务，协助对接持牌金融机构(最终额度、费率以机构审批为准)。若对方案（金额、费率、合同）有异议，请立即终止申请并联系客服核实；您可自主选择申请渠道，平台不强制使用且无隐藏费用。";
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor colorWithHexString:@"#97999E"];
    contentLabel.numberOfLines = 0;
    [cardView addSubview:contentLabel];
    
    // 设置约束
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(18);
        make.top.equalTo(cell.contentView).offset(16);
        make.bottom.equalTo(cell.contentView).offset(-16);
    }];
    
    [riskTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(20);
        make.left.right.equalTo(cardView).inset(18);
    }];
    
    [riskContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(riskTitleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(cardView).inset(18);
    }];
    
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(riskContentLabel.mas_bottom).offset(15);
        make.left.right.equalTo(cardView).inset(18);
        make.height.mas_equalTo(1);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separatorLine.mas_bottom).offset(15);
        make.left.right.equalTo(cardView).inset(18);
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(cardView).inset(18);
        make.bottom.equalTo(cardView).offset(-20);
    }];
}

- (void)configureFeatureCard:(UITableViewCell *)cell 
                       title:(NSString *)title 
                    subtitle:(NSString *)subtitle 
                        data:(NSArray *)data 
                  layoutType:(NSInteger)layoutType {
    
    // 创建卡片容器
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 16;
    [cell.contentView addSubview:cardView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:titleLabel];
    
    // 处理标题中的特殊样式
    if ([title containsString:@"优势"]) {
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedTitle addAttribute:NSForegroundColorAttributeName 
                                value:[UIColor colorWithHexString:@"#FF772C"]
                                range:[title rangeOfString:@"优势"]];
        titleLabel.attributedText = attributedTitle;
    } else {
        titleLabel.text = title;
    }
    
    UIView *lastView = titleLabel;
    
    // 副标题（如果有）
    UILabel *subtitleLabel = nil;
    if (subtitle) {
        subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.text = subtitle;
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.textColor = [UIColor colorWithHexString:@"#767676"];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [cardView addSubview:subtitleLabel];
        lastView = subtitleLabel;
    }
    
    // 根据布局类型创建内容视图
    if (layoutType == 0) {
        // 横向布局
        UIView *containerView = [[UIView alloc] init];
        [cardView addSubview:containerView];
        
        UIView *previousView = nil;
        for (NSInteger i = 0; i < data.count; i++) {
            NSDictionary *item = data[i];
            UIView *itemView = [self createFeatureItemView:item];
            [containerView addSubview:itemView];
            
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(containerView);
                make.width.equalTo(containerView).multipliedBy(1.0/data.count);
                if (previousView) {
                    make.left.equalTo(previousView.mas_right);
                } else {
                    make.left.equalTo(containerView);
                }
            }];
            
            previousView = itemView;
        }
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cardView);
            make.top.equalTo(lastView.mas_bottom).offset(14);
            make.height.mas_equalTo(80);
        }];
        
        lastView = containerView;
        
    } else {
        // 纵向布局（申请流程）
        UIView *previousItemView = nil;
        for (NSInteger i = 0; i < data.count; i++) {
            NSDictionary *item = data[i];
            UIView *itemView = [self createProcessItemView:item];
            [cardView addSubview:itemView];
            
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cardView).inset(20);
                make.height.mas_equalTo(60);
                if (previousItemView) {
                    make.top.equalTo(previousItemView.mas_bottom).offset(12);
                } else {
                    make.top.equalTo(lastView.mas_bottom).offset(14);
                }
            }];
            
            previousItemView = itemView;
        }
        
        lastView = previousItemView;
    }
    
    // 设置卡片约束
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell.contentView).inset(18);
        make.top.equalTo(cell.contentView).offset(16);
        make.bottom.equalTo(cell.contentView).offset(-16);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardView);
        make.top.equalTo(cardView).offset(16);
    }];
    
    if (subtitleLabel) {
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cardView);
            make.top.equalTo(titleLabel.mas_bottom).offset(14);
        }];
    }
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardView).offset(-16);
    }];
}

- (UIView *)createFeatureItemView:(NSDictionary *)item {
    UIView *itemView = [[UIView alloc] init];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:item[@"icon"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addSubview:iconView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = item[@"title"];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [itemView addSubview:textLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView);
        make.top.equalTo(itemView);
        make.width.height.mas_equalTo(44);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemView);
        make.top.equalTo(iconView.mas_bottom).offset(10);
        make.left.right.equalTo(itemView).inset(8);
    }];
    
    return itemView;
}

- (UIView *)createProcessItemView:(NSDictionary *)item {
    UIView *itemView = [[UIView alloc] init];
    itemView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:241.0/255.0 blue:255.0/255.0 alpha:1.0];
    itemView.layer.cornerRadius = 12;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:item[@"icon"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addSubview:iconView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = item[@"title"];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    [itemView addSubview:textLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemView).offset(13);
        make.centerY.equalTo(itemView);
        make.width.height.mas_equalTo(44);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(12);
        make.centerY.equalTo(itemView);
        make.right.equalTo(itemView).offset(-13);
    }];
    
    return itemView;
}

#pragma mark - Actions

- (void)protocolCheckboxTapped:(UIButton *)sender {
    NSLog(@"🎯 复选框被点击");
    self.protocolChecked = !self.protocolChecked;
    sender.selected = self.protocolChecked;
    NSLog(@"🎯 协议勾选状态: %@", self.protocolChecked ? @"已勾选" : @"未勾选");
}

- (void)checkboxContainerTapped:(UITapGestureRecognizer *)gesture {
    NSLog(@"🎯 复选框容器被点击");
    self.protocolChecked = !self.protocolChecked;
    self.mainCheckboxButton.selected = self.protocolChecked;
    NSLog(@"🎯 协议勾选状态: %@", self.protocolChecked ? @"已勾选" : @"未勾选");
}

- (void)serviceAgreementTapped {
    NSLog(@"🎯 服务协议被点击");
    [self handleAgreement:@"user" title:@"服务协议"];
}

- (void)privacyAgreementTapped {
    NSLog(@"🎯 隐私协议被点击");
    [self handleAgreement:@"privacy" title:@"隐私协议"];
}

- (void)handleAgreement:(NSString *)type title:(NSString *)title {
    NSLog(@"🎯 打开协议页面: %@", title);
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.agreementType = type;
    webVC.title = title;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)newFeaturesButtonTapped {
    NSLog(@"🚀 新功能按钮被点击，切换到智能服务Tab");
    // 切换到TabBar的智能服务标签（假设是第2个tab，index为1）
    if (self.tabBarController) {
        self.tabBarController.selectedIndex = 1;
    }
}

- (void)applyButtonTapped {
    NSLog(@"🎯 申请按钮被点击");
    
    // 检查协议勾选
    if (!self.protocolChecked && [self.userInfo[@"audit"] integerValue] == 0) {
        [JJRToastTool showToast:@"请同意并勾选协议"];
        return;
    }
    
    // 检查登录状态
    if (![[JJRUserManager sharedManager] isLoggedIn]) {
        NSLog(@"🎯 用户未登录，跳转到登录页面");
        [self navigateToLogin];
        return;
    }
    
    NSLog(@"🎯 用户已登录，继续业务流程");
    
    // 根据用户状态跳转不同页面
    if (![self.userInfo[@"form"] boolValue]) {
        [self navigateToForm];
    } else if (![self.userInfo[@"identity"] boolValue]) {
        [self navigateToIDCard];
    } else if (![self.userInfo[@"authority"] boolValue]) {
        [self navigateToAuthorization];
    } else {
        if ([self.userInfo[@"model"] isEqualToString:@"A"]) {
            [self navigateToResult];
        }
    }
}

#pragma mark - Navigation

- (void)navigateToLogin {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)navigateToForm {
    JJRApplyFormViewController *formVC = [[JJRApplyFormViewController alloc] init];
    formVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:formVC animated:YES];
}

- (void)navigateToIDCard {
    JJRIdCardViewController *idCardVC = [[JJRIdCardViewController alloc] init];
    idCardVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:idCardVC animated:YES];
}

- (void)navigateToAuthorization {
    JJRAuthorizationViewController *authVC = [[JJRAuthorizationViewController alloc] init];
    authVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authVC animated:YES];
}

- (void)navigateToResult {
    JJRResultViewController *resultVC = [[JJRResultViewController alloc] init];
    resultVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resultVC animated:YES];
}

@end 
