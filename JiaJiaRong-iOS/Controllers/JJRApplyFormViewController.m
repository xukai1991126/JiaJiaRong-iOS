//
//  JJRApplyFormViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRApplyFormViewController.h"
#import "JJRNetworkService.h"
#import "JJRUserManager.h"
#import "JJRIdCardViewController.h"
#import "JJRInputView.h"
#import "JJRCityPickerViewController.h"
#import <YYKit/YYKit.h>
#import <objc/runtime.h>

@interface JJRApplyFormViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *formData;
@property (nonatomic, strong) NSMutableDictionary *formValues;
@property (nonatomic, strong) NSMutableDictionary *selectedOptions;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *loanAmount;

// 折叠面板状态管理
@property (nonatomic, strong) NSMutableSet *expandedSections;

// 身份证弹窗相关
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *idPopupView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idCardTextField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation JJRApplyFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadFormData];
    [self setupIdPopup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setupNavigationBarStyle];
}

- (void)setupNavigationBarStyle {
    // 设置导航栏样式，确保滑动时不变色
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        appearance.shadowColor = [UIColor clearColor];
        
        // 设置所有状态下的导航栏样式
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.compactAppearance = appearance;
        
        // iOS 15+ 需要额外设置
        if (@available(iOS 15.0, *)) {
            self.navigationController.navigationBar.compactScrollEdgeAppearance = appearance;
        }
    } else {
        // iOS 13以下的设置
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
    
    // 确保导航栏不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.opaque = YES;
}

- (void)setupUI {
    self.title = @"信息填写";
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    
    // 初始化数据
    self.formData = [NSMutableArray array];
    self.formValues = [NSMutableDictionary dictionary];
    self.selectedOptions = [NSMutableDictionary dictionary];
    self.cityName = @"请选择城市";
    self.loanAmount = @"";
    
    // 初始化折叠状态管理 - 默认所有面板都折叠
    self.expandedSections = [NSMutableSet set];
    
    // 创建TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadFormData {
    // 获取表单字段配置
    NSString *osType = @"ios";
    
    [[JJRNetworkService sharedInstance] getFormFieldWithOsType:osType 
                                                       success:^(NSDictionary *responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            NSArray *fieldData = responseObject[@"data"];
            [self.formData addObjectsFromArray:fieldData];
            
            // 只添加贷款期限选项，其他数据从服务器获取
            NSDictionary *loanPeriod = @{
                @"conditionList": @[
                    @{@"key": @"3", @"name": @"3期"},
                    @{@"key": @"6", @"name": @"6期"},
                    @{@"key": @"12", @"name": @"12期"},
                    @{@"key": @"24", @"name": @"24期"},
                    @{@"key": @"36", @"name": @"36期"}
                ],
                @"field": @"stageNum",
                @"fieldName": @"贷款期限"
            };
            [self.formData addObject:loanPeriod];
            
            // 初始化表单值
            for (NSDictionary *item in self.formData) {
                self.formValues[item[@"field"]] = @"";
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"加载表单数据失败: %@", error);
        
        // 如果网络请求失败，使用默认数据
        [self loadDefaultFormData];
    }];
}

- (void)loadDefaultFormData {
    // 默认表单数据，匹配uni-app的字段
    NSArray *defaultData = @[
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"有"},
                @{@"key": @"0", @"name": @"无"}
            ],
            @"field": @"house",
            @"fieldName": @"房"
        },
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"有"},
                @{@"key": @"0", @"name": @"无"}
            ],
            @"field": @"car",
            @"fieldName": @"车"
        },
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"有"},
                @{@"key": @"0", @"name": @"无"}
            ],
            @"field": @"socialSecurity",
            @"fieldName": @"社保"
        },
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"有"},
                @{@"key": @"0", @"name": @"无"}
            ],
            @"field": @"providentFund",
            @"fieldName": @"公积金"
        },
        @{
            @"conditionList": @[
                @{@"key": @"1", @"name": @"公务员"},
                @{@"key": @"2", @"name": @"上班族"},
                @{@"key": @"3", @"name": @"自由职业"},
                @{@"key": @"4", @"name": @"个体户"},
                @{@"key": @"5", @"name": @"企业主"}
            ],
            @"field": @"occupation",
            @"fieldName": @"职业"
        },
        @{
            @"conditionList": @[
                @{@"key": @"0", @"name": @"无"},
                @{@"key": @"1", @"name": @"0~4000"},
                @{@"key": @"2", @"name": @"4000~8000"},
                @{@"key": @"3", @"name": @"8000~12000"},
                @{@"key": @"4", @"name": @"12000~16000"},
                @{@"key": @"5", @"name": @"16000~20000"},
                @{@"key": @"6", @"name": @"20000~25000"},
                @{@"key": @"7", @"name": @">25000"}
            ],
            @"field": @"monthlyIncome",
            @"fieldName": @"月收入"
        },
        @{
            @"conditionList": @[
                @{@"key": @"3", @"name": @"3期"},
                @{@"key": @"6", @"name": @"6期"},
                @{@"key": @"12", @"name": @"12期"},
                @{@"key": @"24", @"name": @"24期"},
                @{@"key": @"36", @"name": @"36期"}
            ],
            @"field": @"stageNum",
            @"fieldName": @"贷款期限"
        }
    ];
    
    [self.formData addObjectsFromArray:defaultData];
    
    // 初始化表单值
    for (NSDictionary *item in self.formData) {
        self.formValues[item[@"field"]] = @"";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setupIdPopup {
    // 创建遮罩层
    self.overlayView = [[UIView alloc] init];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.overlayView.hidden = YES;
    [self.view addSubview:self.overlayView];
    
    [self.overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 创建弹窗容器
    self.idPopupView = [[UIView alloc] init];
    self.idPopupView.backgroundColor = [UIColor clearColor];
    self.idPopupView.layer.cornerRadius = 20;
    self.idPopupView.layer.masksToBounds = YES;
    [self.overlayView addSubview:self.idPopupView];
    
    [self.idPopupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.overlayView);
        make.height.mas_equalTo(400);
    }];
    
    // 创建渐变背景
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
        (id)[UIColor colorWithRed:1.0 green:0.898 blue:0.859 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.973 blue:0.941 alpha:1.0].CGColor,
        (id)[UIColor whiteColor].CGColor
    ];
    gradientLayer.locations = @[@0.0, @0.44, @1.0];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.idPopupView.layer insertSublayer:gradientLayer atIndex:0];
    
    // 使用 dispatch_async 延迟设置 frame
    dispatch_async(dispatch_get_main_queue(), ^{
        gradientLayer.frame = self.idPopupView.bounds;
    });
    
    // 弹窗图片
    UIImageView *popupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_e002aa6fd3bc"]];
    popupImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.idPopupView addSubview:popupImageView];
    
    
    // 允许子视图超出父视图的边界
    self.idPopupView.clipsToBounds = NO;
    
    [popupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.idPopupView);
        make.top.equalTo(self.idPopupView).offset(-70);
        make.width.height.mas_equalTo(152);
    }];
    
    // 标题文本
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"恭喜你，已经完成90%的认证步骤";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.467 blue:0.176 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.idPopupView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.idPopupView);
        make.top.equalTo(self.idPopupView).offset(100);
    }];
    
    // 副标题文本
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"完成最后的认证，即可获得了解获取到贷款额度";
    subtitleLabel.font = [UIFont systemFontOfSize:13];
    subtitleLabel.textColor = [UIColor colorWithRed:1.0 green:0.467 blue:0.176 alpha:1.0];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.idPopupView addSubview:subtitleLabel];
    
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.idPopupView);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
    }];
    
    // 姓名输入框
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.placeholder = @"请输入您的姓名";
    self.nameTextField.font = [UIFont systemFontOfSize:14];
    self.nameTextField.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0];
    self.nameTextField.layer.cornerRadius = 20;
    self.nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.idPopupView addSubview:self.nameTextField];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.idPopupView).offset(40);
        make.right.equalTo(self.idPopupView).offset(-40);
        make.top.equalTo(subtitleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    // 身份证号输入框
    self.idCardTextField = [[UITextField alloc] init];
    self.idCardTextField.placeholder = @"请输入身份证号";
    self.idCardTextField.font = [UIFont systemFontOfSize:14];
    self.idCardTextField.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0];
    self.idCardTextField.layer.cornerRadius = 20;
    self.idCardTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.idCardTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.idPopupView addSubview:self.idCardTextField];
    
    [self.idCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    // 提示信息
    UIView *tipView = [[UIView alloc] init];
    [self.idPopupView addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.idPopupView);
        make.top.equalTo(self.idCardTextField.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *infoIcon = [[UIImageView alloc] init];
    infoIcon.image = [UIImage systemImageNamed:@"info.circle"];
    infoIcon.tintColor = [UIColor colorWithRed:1.0 green:0.467 blue:0.176 alpha:1.0];
    [tipView addSubview:infoIcon];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"国家级数据加密保护，仅用于贷款审核";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor = [UIColor colorWithRed:1.0 green:0.467 blue:0.176 alpha:1.0];
    [tipView addSubview:tipLabel];
    
    [infoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipView);
        make.centerY.equalTo(tipView);
        make.width.height.mas_equalTo(14);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(infoIcon.mas_right).offset(5);
        make.right.equalTo(tipView);
        make.centerY.equalTo(tipView);
    }];
    
    // 提交按钮
    self.submitButton = [[UIButton alloc] init];
    [self.submitButton setTitle:@"立即提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.submitButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.submitButton.layer.cornerRadius = 25;
    [self.submitButton addTarget:self action:@selector(submitForm) forControlEvents:UIControlEventTouchUpInside];
    [self.idPopupView addSubview:self.submitButton];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField);
        make.top.equalTo(tipView.mas_bottom).offset(20);
        make.height.mas_equalTo(46);
    }];
    
    // 添加点击遮罩关闭弹窗
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideIdPopup)];
    [self.overlayView addGestureRecognizer:tapGesture];
}

#pragma mark - TableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4; // 步骤、城市、表单、贷款金额
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1; // 步骤
        case 1: return 1; // 城市
        case 2: return self.formData.count; // 表单选项
        case 3: return 1; // 贷款金额
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60; // 步骤区域
    } else if (indexPath.section == 1) {
        return 80; // 城市选择 + 提示
    } else if (indexPath.section == 2) {
        // 表单选项 - 根据展开/折叠状态计算高度
        if (indexPath.row < self.formData.count) {
            NSDictionary *item = self.formData[indexPath.row];
            NSString *field = item[@"field"];
            
            // 检查当前面板是否展开
            // 如果没有选择值，默认展开；如果有选择值，根据expandedSections来判断
            NSString *selectedValue = self.selectedOptions[field][@"name"];
            BOOL isExpanded;
            if (!selectedValue || selectedValue.length == 0) {
                // 没有选择值，默认展开
                isExpanded = YES;
            } else {
                // 有选择值，根据expandedSections来判断
                isExpanded = [self.expandedSections containsObject:field];
            }
            
            if (isExpanded) {
                // 展开状态：标题(50) + 标题下间距(8) + 提示(24) + 提示下间距(10) + 选项区域 + 底部间距(15) + 分隔线(1)
                NSArray *options = item[@"conditionList"];
                
                // 使用与createOptionsForView相同的列数计算逻辑
                NSInteger actualColumns;
                if (options.count == 2) {
                    actualColumns = 2;
                } else {
                    actualColumns = 3;
                }
                
                NSInteger rows = (options.count + actualColumns - 1) / actualColumns;
                // 实际按钮高度35pt + 行间距8pt，但最后一行不需要间距
                CGFloat optionsHeight = rows * 35 + (rows - 1) * 8; // 精确计算选项区域高度
                
                // 总高度 = 标题高度 + 标题下间距 + 提示高度 + 提示下间距 + 选项高度 + 底部间距 + 分割线高度
                return 50 + 8 + 24 + 10 + optionsHeight + 15 + 1;
            } else {
                // 折叠状态：只显示标题行 + 分隔线
                return 50 + 1; // 增加1px分隔线高度
            }
        }
        return 50 + 1; // 默认高度 + 分隔线
    } else if (indexPath.section == 3) {
        return 150; // 贷款金额
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 步骤区域 - 移动到页面中间位置
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StepCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *stepView = [[UIView alloc] init];
            stepView.tag = 100;
            [cell.contentView addSubview:stepView];
            
            [stepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.contentView);
                make.centerY.equalTo(cell.contentView);
                make.height.mas_equalTo(49);
                make.width.mas_equalTo(300);
            }];
            
            // 步骤1图片 - 高亮状态
            UIImageView *step1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_83692599799e"]];
            step1.contentMode = UIViewContentModeScaleAspectFit;
            [stepView addSubview:step1];
            
            [step1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(stepView);
                make.centerY.equalTo(stepView);
                make.width.height.mas_equalTo(49);
            }];
            
            // 虚线
            UIView *dashLine = [[UIView alloc] init];
            dashLine.backgroundColor = [UIColor clearColor];
            [stepView addSubview:dashLine];
            
            [dashLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(step1.mas_right).offset(10);
                make.right.equalTo(stepView).offset(-59);
                make.centerY.equalTo(stepView);
                make.height.mas_equalTo(2);
            }];
            
            // 添加虚线图层
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
            shapeLayer.lineWidth = 2;
            shapeLayer.lineDashPattern = @[@4, @4];
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.name = @"dashLine";
            [dashLine.layer addSublayer:shapeLayer];
            
            // 延迟设置虚线路径
            dispatch_async(dispatch_get_main_queue(), ^{
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(0, 1)];
                [path addLineToPoint:CGPointMake(dashLine.frame.size.width, 1)];
                shapeLayer.path = path.CGPath;
            });
            
            // 步骤2图片 - 灰色状态
            UIImageView *step2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_3599d1c6faa3"]];
            step2.contentMode = UIViewContentModeScaleAspectFit;
            [stepView addSubview:step2];
            
            [step2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(stepView);
                make.centerY.equalTo(stepView);
                make.width.height.mas_equalTo(49);
            }];
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        // 城市选择区域
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityCell"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // 城市选择行
            UIView *cityRow = [[UIView alloc] init];
            cityRow.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:cityRow];
            
            [cityRow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(cell.contentView);
                make.height.mas_equalTo(56);
            }];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"所在城市";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            titleLabel.tag = 200;
            [cityRow addSubview:titleLabel];
            
            UILabel *valueLabel = [[UILabel alloc] init];
            valueLabel.font = [UIFont systemFontOfSize:16];
            valueLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            valueLabel.textAlignment = NSTextAlignmentRight;
            valueLabel.tag = 201;
            [cityRow addSubview:valueLabel];
            
            UIImageView *arrowIcon = [[UIImageView alloc] init];
            arrowIcon.image = [UIImage imageNamed:@"arrow_right"];
            arrowIcon.contentMode = UIViewContentModeScaleAspectFit;
            [cityRow addSubview:arrowIcon];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cityRow).offset(15);
                make.centerY.equalTo(cityRow);
            }];
            
            [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cityRow).offset(-15);
                make.centerY.equalTo(cityRow);
                make.width.height.mas_equalTo(16);
            }];
            
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(arrowIcon.mas_left).offset(-4);
                make.centerY.equalTo(cityRow);
            }];
            
            // 添加点击手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCitySelection)];
            [cityRow addGestureRecognizer:tapGesture];
            
            // 提示信息
            UIView *tipView = [[UIView alloc] init];
            tipView.backgroundColor = [UIColor whiteColor];
            tipView.tag = 202;
            [cell.contentView addSubview:tipView];
            
            [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell.contentView);
                make.top.equalTo(cityRow.mas_bottom);
                make.height.mas_equalTo(24);
            }];
            
            UIImageView *infoIcon = [[UIImageView alloc] init];
            infoIcon.image = [UIImage systemImageNamed:@"info.circle"];
            infoIcon.tintColor = [UIColor colorWithHexString:@"#FF772C"];
            [tipView addSubview:infoIcon];
            
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.text = @"输入正确的城市，更有利于下款";
            tipLabel.font = [UIFont systemFontOfSize:13];
            tipLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
            [tipView addSubview:tipLabel];
            
            [infoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tipView).offset(15);
                make.centerY.equalTo(tipView);
                make.width.height.mas_equalTo(14);
            }];
            
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(infoIcon.mas_right).offset(5);
                make.centerY.equalTo(tipView);
            }];
        }
        
        UILabel *valueLabel = [cell.contentView viewWithTag:201];
        valueLabel.text = self.cityName;
        
        return cell;
    } else if (indexPath.section == 2) {
        // 表单选项 - 折叠面板样式
        if (indexPath.row < self.formData.count) {
            NSDictionary *item = self.formData[indexPath.row];
            NSString *fieldName = item[@"fieldName"];
            NSString *field = item[@"field"];
            NSArray *options = item[@"conditionList"];
            
            // 检查当前面板是否展开
            // 如果没有选择值，默认展开；如果有选择值，根据expandedSections来判断
            NSString *selectedValue = self.selectedOptions[field][@"name"];
            BOOL isExpanded;
            if (!selectedValue || selectedValue.length == 0) {
                // 没有选择值，默认展开
                isExpanded = YES;
            } else {
                // 有选择值，根据expandedSections来判断
                isExpanded = [self.expandedSections containsObject:field];
            }
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FormCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FormCell"];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // 清除之前的子视图
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
            
            // 标题行 - 可点击的折叠头部
            UIView *headerView = [[UIView alloc] init];
            headerView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:headerView];
            
            [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(cell.contentView);
                make.height.mas_equalTo(50);
            }];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = fieldName;
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            [headerView addSubview:titleLabel];
            
            // 选中值标签
            UILabel *selectedValueLabel = [[UILabel alloc] init];
            NSString *labelSelectedValue = self.selectedOptions[field][@"name"];
            selectedValueLabel.text = labelSelectedValue ?: @"";
            selectedValueLabel.font = [UIFont systemFontOfSize:14];
            selectedValueLabel.textColor = labelSelectedValue ? [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0] : [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
            selectedValueLabel.textAlignment = NSTextAlignmentRight;
            [headerView addSubview:selectedValueLabel];
            
            // 箭头图标
            UIImageView *arrowIcon = [[UIImageView alloc] init];
            arrowIcon.image = [UIImage systemImageNamed:isExpanded ? @"chevron.up" : @"chevron.down"];
            arrowIcon.tintColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
            [headerView addSubview:arrowIcon];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerView).offset(15);
                make.centerY.equalTo(headerView);
            }];
            
            [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headerView).offset(-15);
                make.centerY.equalTo(headerView);
                make.width.height.mas_equalTo(16);
            }];
            
            [selectedValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(arrowIcon.mas_left).offset(-8);
                make.centerY.equalTo(headerView);
                make.left.greaterThanOrEqualTo(titleLabel.mas_right).offset(10);
            }];
            
            // 添加点击手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSection:)];
            [headerView addGestureRecognizer:tapGesture];
            
            // 使用tag传递section信息
            headerView.tag = 1000 + indexPath.row;
            
            if (isExpanded) {
                // 展开状态：显示选择提示和选项按钮
                
                // 选择提示
                UILabel *hintLabel = [[UILabel alloc] init];
                NSString *hintSelectedValue = self.selectedOptions[field][@"name"];
                hintLabel.text = hintSelectedValue ? hintSelectedValue : [NSString stringWithFormat:@"请选择%@", fieldName];
                hintLabel.font = [UIFont systemFontOfSize:14];
                hintLabel.textColor = hintSelectedValue ? [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0] : [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
                [cell.contentView addSubview:hintLabel];
                
                [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(15);
                    make.right.equalTo(cell.contentView).offset(-15);
                    make.top.equalTo(headerView.mas_bottom).offset(8);
                    make.height.mas_equalTo(24);
                }];
                
                // 选项按钮区域
                UIView *optionsView = [[UIView alloc] init];
                [cell.contentView addSubview:optionsView];
                
                // 根据选项数量设置布局
                NSInteger optionCount = options.count;
                if (optionCount == 2) {
                    // 两个选项：左对齐
                    [self createOptionsForView:optionsView options:options field:field columns:2];
                } else {
                    // 三个及以上选项：一行三个
                    [self createOptionsForView:optionsView options:options field:field columns:3];
                }
                
                // 设置optionsView约束 - 不设置bottom约束，让高度由createOptionsForView中的高度约束决定
                [optionsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(cell.contentView);
                    make.top.equalTo(hintLabel.mas_bottom).offset(10);
                }];
            } else {
                // 折叠状态：只显示标题行，不显示选中的值
                // 不添加任何额外的视图，只保留标题行
            }
            
            // 添加底部分隔线（无论展开还是折叠都显示）
            UIView *separatorLine = [[UIView alloc] init];
            separatorLine.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0]; // 浅灰色
            [cell.contentView addSubview:separatorLine];
            
            [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(cell.contentView);
                make.height.mas_equalTo(1);
            }];
            
            return cell;
        }
        
        return [[UITableViewCell alloc] init];
    } else if (indexPath.section == 3) {
        // 贷款金额
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AmountCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AmountCell"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"贷款金额";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            titleLabel.tag = 300;
            [cell.contentView addSubview:titleLabel];
            
            UITextField *amountField = [[UITextField alloc] init];
            amountField.placeholder = @"请输入贷款金额";
            amountField.font = [UIFont systemFontOfSize:14];
            amountField.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            amountField.textAlignment = NSTextAlignmentLeft; // 改为左对齐，更符合输入习惯
            amountField.keyboardType = UIKeyboardTypeNumberPad;
            amountField.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
            amountField.layer.cornerRadius = 8;
            amountField.layer.borderWidth = 1;
            amountField.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
            
            // 设置placeholder颜色
            if (@available(iOS 13.0, *)) {
                amountField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入贷款金额" 
                                                                                    attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]}];
            }
            
            // 添加左右内边距
            UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
            amountField.leftView = leftPaddingView;
            amountField.leftViewMode = UITextFieldViewModeAlways;
            
            UIView *rightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
            amountField.rightView = rightPaddingView;
            amountField.rightViewMode = UITextFieldViewModeAlways;
            
            amountField.tag = 301;
            [amountField addTarget:self action:@selector(amountChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:amountField];
            
            UIButton *nextButton = [[UIButton alloc] init];
            [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
            [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
            nextButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
            nextButton.layer.cornerRadius = 25;
            nextButton.tag = 302;
            [nextButton addTarget:self action:@selector(showIdPopup) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:nextButton];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.top.equalTo(cell.contentView).offset(15);
            }];
            
            [amountField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-15);
                make.centerY.equalTo(titleLabel);
                make.width.mas_equalTo(200);
                make.height.mas_equalTo(40);
            }];
            
            [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell.contentView).inset(20);
                make.top.equalTo(titleLabel.mas_bottom).offset(20);
                make.height.mas_equalTo(46);
                make.bottom.equalTo(cell.contentView).offset(-20);
            }];
        }
        
        UITextField *amountField = [cell.contentView viewWithTag:301];
        amountField.text = self.loanAmount;
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        // 城市选择
        [self showCitySelection];
    }
}

#pragma mark - Action Methods

- (void)toggleSection:(UITapGestureRecognizer *)gesture {
    UIView *headerView = gesture.view;
    NSInteger row = headerView.tag - 1000;
    
    if (row >= 0 && row < self.formData.count) {
        NSDictionary *item = self.formData[row];
        NSString *field = item[@"field"];
        
        // 切换展开/折叠状态
        if ([self.expandedSections containsObject:field]) {
            [self.expandedSections removeObject:field];
        } else {
            [self.expandedSections addObject:field];
        }
        
        // 刷新对应的cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:2];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)selectOption:(UIButton *)button {
    NSString *field = objc_getAssociatedObject(button, @"field");
    NSDictionary *option = objc_getAssociatedObject(button, @"option");
    
    // 更新选中状态
    self.formValues[field] = option[@"key"];
    self.selectedOptions[field] = option;
    
    // 选择后自动折叠面板
    [self.expandedSections removeObject:field];
    
    // 刷新对应的cell
    NSInteger sectionIndex = 2;
    for (NSInteger i = 0; i < self.formData.count; i++) {
        NSDictionary *item = self.formData[i];
        if ([item[@"field"] isEqualToString:field]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)amountChanged:(UITextField *)textField {
    self.loanAmount = textField.text;
}

- (void)showCitySelection {
    // 获取热门城市数据
    [[JJRNetworkService sharedInstance] getHotCitiesWithSuccess:^(NSDictionary *responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                JJRCityPickerViewController *cityPicker = [[JJRCityPickerViewController alloc] init];
                cityPicker.hotCities = responseObject[@"data"];
                cityPicker.currentCityName = self.cityName;
                cityPicker.modalPresentationStyle = UIModalPresentationPageSheet;
                
                // 设置选择回调
                __weak typeof(self) weakSelf = self;
                cityPicker.citySelectedBlock = ^(NSString *cityName, NSString *cityCode) {
                    weakSelf.cityName = cityName;
                    weakSelf.cityCode = cityCode;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                };
                
                [self presentViewController:cityPicker animated:YES completion:nil];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"获取城市数据失败: %@", error);
    }];
}

- (void)cityPickerDidSelectCity:(NSDictionary *)city {
    self.cityName = city[@"name"];
    self.cityCode = city[@"code"];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showIdPopup {
    [self.view endEditing:YES];
    // 验证表单
    if (!self.cityCode) {
        [JJRToastTool showToast:@"请填写城市"];
        return;
    }
    
    for (NSDictionary *item in self.formData) {
        if (!self.formValues[item[@"field"]] || [self.formValues[item[@"field"]] isEqualToString:@""]) {
            [JJRToastTool showToast:[NSString stringWithFormat:@"%@不能为空", item[@"fieldName"]]];
            return;
        }
    }
    
    if (!self.loanAmount || [self.loanAmount isEqualToString:@""]) {
        [JJRToastTool showToast:@"请输入贷款金额"];
        return;
    }
    
    NSInteger amount = [self.loanAmount integerValue];
    if (amount < 10000) {
        [JJRToastTool showToast:@"贷款金额最低1万起"];
        return;
    }
    
    if (amount > 200000) {
        [JJRToastTool showToast:@"贷款金额不能超过20万"];
        return;
    }
    
    // 显示弹窗
    self.overlayView.hidden = NO;
    self.overlayView.alpha = 0;
    
    // 弹窗动画
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 1;
    }];
}

- (void)hideIdPopup {
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        self.overlayView.hidden = YES;
    }];
}

- (void)submitForm {
    // 验证身份证信息
    if (!self.nameTextField.text || self.nameTextField.text.length == 0) {
        [JJRToastTool showToast:@"请填写正确的姓名"];
        return;
    }
    
    if (!self.idCardTextField.text || self.idCardTextField.text.length != 18) {
        [JJRToastTool showToast:@"请填写正确的身份证号码"];
        return;
    }
    
    // 显示费用说明确认弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"费用说明"
                                                                   message:@"本平台不收取任何隐藏费用，所有费用均透明公开。最终利率以金融机构审批为准，您有权拒绝任何不合理的收费。确认继续申请吗？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认申请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performFormSubmission];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)performFormSubmission {
    // 构建提交参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:self.formValues];
    params[@"cityCode"] = self.cityCode;
    params[@"loanAmount"] = self.loanAmount;
    params[@"idName"] = self.nameTextField.text;
    params[@"idNo"] = self.idCardTextField.text;
    params[@"ios"] = @YES;
    
    // 提交表单
    [[JJRNetworkService sharedInstance] submitFormApplyWithParams:params success:^(NSDictionary *responseObject) {
        if ([responseObject[@"code"] integerValue] == 0) {
            [JJRToastTool showSuccess:@"提交成功"];
            
            // 更新用户信息
            NSDictionary *userInfo = [[JJRUserManager sharedManager] userInfo];
            NSMutableDictionary *updatedUserInfo = [userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
            updatedUserInfo[@"form"] = @YES;
            [[JJRUserManager sharedManager] updateUserInfo:updatedUserInfo];
            
            // 延迟跳转到身份证验证页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideIdPopup];
                JJRIdCardViewController *idCardVC = [[JJRIdCardViewController alloc] init];
                [self.navigationController pushViewController:idCardVC animated:YES];
            });
        } else {
            [JJRToastTool showError:responseObject[@"err"][@"msg"] ?: @"提交失败"];
        }
    } failure:^(NSError *error) {
        NSString *errorMessage = error.localizedDescription;
        if (!errorMessage || errorMessage.length == 0) {
            errorMessage = @"提交失败，请重试";
        }
        [JJRToastTool showError:errorMessage];
    }];
}


#pragma mark - Helper Methods

- (void)createOptionsForView:(UIView *)containerView options:(NSArray *)options field:(NSString *)field columns:(NSInteger)columns {
    CGFloat containerWidth = CGRectGetWidth(self.view.frame) - 30; // 减去左右边距
    CGFloat buttonSpacing = 10;
    CGFloat buttonWidth;
    NSInteger actualColumns;
    
    // 统一按钮宽度：都按照三列布局计算宽度
    buttonWidth = (containerWidth - 2 * buttonSpacing) / 3; // 三列布局的单个按钮宽度
    
    // 根据选项数量调整布局
    if (options.count == 2) {
        // 两个选项时：左对齐，使用和三列一样的宽度
        actualColumns = 2;
    } else {
        // 三个及以上选项时：一行放三个
        actualColumns = 3;
    }
    
    CGFloat buttonHeight = 35;
    CGFloat rowSpacing = 8;
    
    for (NSInteger i = 0; i < options.count; i++) {
        NSDictionary *option = options[i];
        
        UIButton *optionButton = [[UIButton alloc] init];
        [optionButton setTitle:option[@"name"] forState:UIControlStateNormal];
        [optionButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
        [optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        optionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        optionButton.backgroundColor = [UIColor whiteColor];
        optionButton.layer.cornerRadius = 18;
        optionButton.layer.borderWidth = 1;
        optionButton.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
        
        // 检查是否已选中
        NSDictionary *selectedOption = self.selectedOptions[field];
        if (selectedOption && [selectedOption[@"key"] isEqualToString:option[@"key"]]) {
            optionButton.selected = YES;
            optionButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
            optionButton.layer.borderColor = [UIColor colorWithHexString:@"#FF772C"].CGColor;
        }
        
        // 使用 objc_setAssociatedObject 绑定数据
        objc_setAssociatedObject(optionButton, @"field", field, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(optionButton, @"option", option, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [optionButton addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:optionButton];
        
        NSInteger row = i / actualColumns;
        NSInteger col = i % actualColumns;
        
        // 左对齐布局，按钮宽度统一
        CGFloat leftOffset = 15 + col * (buttonWidth + buttonSpacing);
        CGFloat topOffset = row * (buttonHeight + rowSpacing);
        
        optionButton.frame = CGRectMake(leftOffset, topOffset, buttonWidth, buttonHeight);
    }
    
    // 计算总高度：行数 × 按钮高度 + (行数-1) × 行间距
    NSInteger totalRows = (options.count + actualColumns - 1) / actualColumns;
    CGFloat totalHeight = totalRows * buttonHeight + (totalRows - 1) * rowSpacing;
    
    // 设置容器的固定高度
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
}

@end
