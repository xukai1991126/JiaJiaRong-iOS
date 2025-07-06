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
#import <Masonry/Masonry.h>
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
            
            // 添加贷款期限选项
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
    }];
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
    self.submitButton.backgroundColor = [UIColor colorWithRed:0.23 green:0.31 blue:0.87 alpha:1.0];
    self.submitButton.layer.cornerRadius = 25;
    [self.submitButton addTarget:self action:@selector(submitForm) forControlEvents:UIControlEventTouchUpInside];
    [self.idPopupView addSubview:self.submitButton];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameTextField);
        make.top.equalTo(tipView.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
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
        return 100; // 步骤区域
    } else if (indexPath.section == 1) {
        return 100; // 城市选择 + 提示
    } else if (indexPath.section == 2) {
        // 表单选项 - 动态高度
        if (indexPath.row < self.formData.count) {
            NSDictionary *item = self.formData[indexPath.row];
            NSArray *options = item[@"conditionList"];
            NSInteger rows = (options.count + 2) / 3; // 每行3个选项
            return 60 + rows * 50; // 标题高度 + 选项高度
        }
        return 60;
    } else if (indexPath.section == 3) {
        return 120; // 贷款金额 + 按钮
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // 步骤区域
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
                make.top.equalTo(cell.contentView).offset(25);
                make.bottom.equalTo(cell.contentView).offset(-10);
                make.height.mas_equalTo(49);
            }];
            
            // 步骤1图片
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
                make.left.equalTo(step1.mas_right).offset(5);
                make.centerY.equalTo(stepView);
                make.width.mas_equalTo(140);
                make.height.mas_equalTo(2);
            }];
            
            // 添加虚线图层
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
            shapeLayer.lineWidth = 2;
            shapeLayer.lineDashPattern = @[@4, @4];
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0, 1)];
            [path addLineToPoint:CGPointMake(140, 1)];
            shapeLayer.path = path.CGPath;
            
            [dashLine.layer addSublayer:shapeLayer];
            
            // 步骤2图片
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
        // 城市选择
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityCell"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"所在城市";
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            titleLabel.tag = 200;
            [cell.contentView addSubview:titleLabel];
            
            UILabel *valueLabel = [[UILabel alloc] init];
            valueLabel.font = [UIFont systemFontOfSize:14];
            valueLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            valueLabel.textAlignment = NSTextAlignmentRight;
            valueLabel.tag = 201;
            [cell.contentView addSubview:valueLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.centerY.equalTo(cell.contentView).offset(-10);
            }];
            
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-30);
                make.centerY.equalTo(cell.contentView).offset(-10);
            }];
            
            // 添加提示信息
            UIView *tipView = [[UIView alloc] init];
            tipView.backgroundColor = [UIColor whiteColor];
            tipView.tag = 202;
            [cell.contentView addSubview:tipView];
            
            [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell.contentView);
                make.top.equalTo(cell.contentView).offset(40);
                make.height.mas_equalTo(40);
            }];
            
            UIImageView *infoIcon = [[UIImageView alloc] init];
            infoIcon.image = [UIImage systemImageNamed:@"info.circle"];
            infoIcon.tintColor = [UIColor colorWithRed:0.23 green:0.31 blue:0.87 alpha:1.0];
            [tipView addSubview:infoIcon];
            
            UILabel *tipLabel = [[UILabel alloc] init];
            tipLabel.text = @"输入正确的城市，更有利于下款";
            tipLabel.font = [UIFont systemFontOfSize:13];
            tipLabel.textColor = [UIColor colorWithRed:0.23 green:0.31 blue:0.87 alpha:1.0];
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
        // 表单选项
        if (indexPath.row < self.formData.count) {
            NSDictionary *item = self.formData[indexPath.row];
            
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
            
            // 标题
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = item[@"fieldName"];
            titleLabel.font = [UIFont systemFontOfSize:15];
            titleLabel.textColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.2 alpha:1.0];
            [cell.contentView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.top.equalTo(cell.contentView).offset(15);
            }];
            
            // 选项值显示
            UILabel *valueLabel = [[UILabel alloc] init];
            NSString *selectedValue = self.selectedOptions[item[@"field"]][@"name"];
            valueLabel.text = selectedValue ?: [NSString stringWithFormat:@"请选择%@", item[@"fieldName"]];
            valueLabel.font = [UIFont systemFontOfSize:14];
            valueLabel.textColor = selectedValue ? [UIColor colorWithRed:0.19 green:0.19 blue:0.2 alpha:1.0] : [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
            [cell.contentView addSubview:valueLabel];
            
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLabel);
                make.top.equalTo(titleLabel.mas_bottom).offset(5);
            }];
            
            // 选项按钮
            NSArray *options = item[@"conditionList"];
            CGFloat buttonWidth = (CGRectGetWidth(self.view.frame) - 60) / 3; // 3列布局，减去左右边距和间距
            
            for (NSInteger i = 0; i < options.count; i++) {
                NSDictionary *option = options[i];
                
                UIButton *optionButton = [[UIButton alloc] init];
                [optionButton setTitle:option[@"name"] forState:UIControlStateNormal];
                [optionButton setTitleColor:[UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0] forState:UIControlStateNormal];
                [optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                optionButton.titleLabel.font = [UIFont systemFontOfSize:14];
                optionButton.backgroundColor = [UIColor whiteColor];
                optionButton.layer.cornerRadius = 20;
                optionButton.layer.borderWidth = 1;
                optionButton.layer.borderColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
                
                // 检查是否已选中
                NSDictionary *selectedOption = self.selectedOptions[item[@"field"]];
                if (selectedOption && [selectedOption[@"key"] isEqualToString:option[@"key"]]) {
                    optionButton.selected = YES;
                    optionButton.backgroundColor = [UIColor colorWithRed:0.23 green:0.31 blue:0.87 alpha:1.0];
                    optionButton.layer.borderColor = [UIColor clearColor].CGColor;
                }
                
                // 使用 objc_setAssociatedObject 绑定数据
                objc_setAssociatedObject(optionButton, @"field", item[@"field"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(optionButton, @"option", option, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                [optionButton addTarget:self action:@selector(selectOption:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:optionButton];
                
                NSInteger row = i / 3;
                NSInteger col = i % 3;
                
                [optionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(15 + col * (buttonWidth + 10));
                    make.top.equalTo(valueLabel.mas_bottom).offset(15 + row * 35);
                    make.width.mas_equalTo(buttonWidth);
                    make.height.mas_equalTo(28);
                }];
            }
            
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
            titleLabel.font = [UIFont systemFontOfSize:15];
            titleLabel.textColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.2 alpha:1.0];
            titleLabel.tag = 300;
            [cell.contentView addSubview:titleLabel];
            
            UITextField *amountField = [[UITextField alloc] init];
            amountField.placeholder = @"请输入贷款金额";
            amountField.font = [UIFont systemFontOfSize:14];
            amountField.textColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.2 alpha:1.0];
            amountField.borderStyle = UITextBorderStyleRoundedRect;
            amountField.keyboardType = UIKeyboardTypeNumberPad;
            amountField.tag = 301;
            [amountField addTarget:self action:@selector(amountChanged:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:amountField];
            
            UIButton *nextButton = [[UIButton alloc] init];
            [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
            [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
            nextButton.backgroundColor = [UIColor colorWithRed:0.23 green:0.31 blue:0.87 alpha:1.0];
            nextButton.layer.cornerRadius = 25;
            nextButton.tag = 302;
            [nextButton addTarget:self action:@selector(showIdPopup) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:nextButton];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.top.equalTo(cell.contentView).offset(15);
                make.width.mas_equalTo(100);
            }];
            
            [amountField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLabel.mas_right).offset(10);
                make.right.equalTo(cell.contentView).offset(-15);
                make.centerY.equalTo(titleLabel);
                make.height.mas_equalTo(35);
            }];
            
            [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell.contentView).inset(16);
                make.top.equalTo(amountField.mas_bottom).offset(20);
                make.height.mas_equalTo(50);
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

- (void)selectOption:(UIButton *)button {
    NSString *field = objc_getAssociatedObject(button, @"field");
    NSDictionary *option = objc_getAssociatedObject(button, @"option");
    
    // 更新选中状态
    self.formValues[field] = option[@"key"];
    self.selectedOptions[field] = option;
    
    // 刷新对应的cell
    NSInteger sectionIndex = 2;
    for (NSInteger i = 0; i < self.formData.count; i++) {
        NSDictionary *item = self.formData[i];
        if ([item[@"field"] isEqualToString:field]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
            // 简化实现：使用 UIAlertController 选择城市
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择城市" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            NSArray *cities = responseObject[@"data"];
            for (NSDictionary *city in cities) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:city[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.cityName = city[@"name"];
                    self.cityCode = city[@"code"];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                }];
                [alert addAction:action];
            }
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"获取城市数据失败: %@", error);
    }];
}

- (void)showIdPopup {
    // 验证表单
    if (!self.cityCode) {
        [self showToast:@"请填写城市"];
        return;
    }
    
    for (NSDictionary *item in self.formData) {
        if (!self.formValues[item[@"field"]] || [self.formValues[item[@"field"]] isEqualToString:@""]) {
            [self showToast:[NSString stringWithFormat:@"%@不能为空", item[@"fieldName"]]];
            return;
        }
    }
    
    if (!self.loanAmount || [self.loanAmount isEqualToString:@""]) {
        [self showToast:@"请输入贷款金额"];
        return;
    }
    
    NSInteger amount = [self.loanAmount integerValue];
    if (amount < 10000) {
        [self showToast:@"贷款金额最低1万起"];
        return;
    }
    
    if (amount > 200000) {
        [self showToast:@"贷款金额不能超过20万"];
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
        [self showToast:@"请填写正确的姓名"];
        return;
    }
    
    if (!self.idCardTextField.text || self.idCardTextField.text.length != 18) {
        [self showToast:@"请填写正确的身份证号码"];
        return;
    }
    
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
            [self showToast:@"提交成功"];
            
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
            [self showToast:responseObject[@"err"][@"msg"] ?: @"提交失败"];
        }
    } failure:^(NSError *error) {
        [self showToast:@"网络错误，请重试"];
        NSLog(@"提交表单失败: %@", error);
    }];
}

- (void)showToast:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    });
}

@end
