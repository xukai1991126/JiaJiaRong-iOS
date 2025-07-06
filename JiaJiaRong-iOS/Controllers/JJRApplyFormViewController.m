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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 确保导航栏显示且样式正确
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    // 重新设置导航栏样式，防止被其他页面影响
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        appearance.shadowColor = [UIColor clearColor];
        
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupUI {
    self.title = @"信息填写";
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    
    // 设置导航栏样式，参考uni-app配置
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor]; // 白色背景
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]}; // 黑色标题
        appearance.shadowColor = [UIColor clearColor]; // 去除阴影
        
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        // iOS 13以下的设置
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    // 确保导航栏不透明且固定显示
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    
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
            
            // 简化虚线实现 - 固定140pt宽度
            UIView *dashLine = [[UIView alloc] init];
            dashLine.backgroundColor = [UIColor clearColor];
            [stepView addSubview:dashLine];
            
            [dashLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(step1.mas_right).offset(5);
                make.centerY.equalTo(stepView);
                make.width.mas_equalTo(140); // 固定140pt宽度
                make.height.mas_equalTo(2);
            }];
            
            // 添加虚线图层 - 简化实现
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0].CGColor;
            shapeLayer.lineWidth = 2;
            shapeLayer.lineDashPattern = @[@4, @4];
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            
            // 直接设置路径，不需要动态计算
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
        
        // 虚线使用固定宽度，不需要动态更新
        
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
                make.centerY.equalTo(cell.contentView);
            }];
            
            [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-30);
                make.centerY.equalTo(cell.contentView);
            }];
            
            // 添加提示信息
            UIView *tipView = [[UIView alloc] init];
            tipView.backgroundColor = [UIColor whiteColor];
            tipView.tag = 202;
            [cell.contentView addSubview:tipView];
            
            [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(cell.contentView);
                make.top.equalTo(cell.contentView).offset(56);
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
                
                // 标题标签
                UILabel *titleLabel = [[UILabel alloc] init];
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
                titleLabel.tag = 300;
                [cell.contentView addSubview:titleLabel];
                
                // 选项容器
                UIView *optionsContainer = [[UIView alloc] init];
                optionsContainer.tag = 301;
                [cell.contentView addSubview:optionsContainer];
                
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(15);
                    make.top.equalTo(cell.contentView).offset(15);
                }];
                
                [optionsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(15);
                    make.right.equalTo(cell.contentView).offset(-15);
                    make.top.equalTo(titleLabel.mas_bottom).offset(10);
                    make.bottom.equalTo(cell.contentView).offset(-15);
                }];
            }
            
            // 更新内容
            UILabel *titleLabel = [cell.contentView viewWithTag:300];
            titleLabel.text = item[@"fieldName"];
            
            UIView *optionsContainer = [cell.contentView viewWithTag:301];
            
            // 清除之前的选项按钮
            for (UIView *subview in optionsContainer.subviews) {
                [subview removeFromSuperview];
            }
            
            // 创建选项按钮
            NSArray *conditionList = item[@"conditionList"];
            NSString *fieldName = item[@"field"];
            NSString *currentValue = self.formValues[fieldName] ?: @"";
            
            if (conditionList.count > 0) {
                CGFloat buttonWidth = 80;
                CGFloat buttonHeight = 35;
                CGFloat spacing = 10;
                NSInteger buttonsPerRow = 3;
                
                for (NSInteger i = 0; i < conditionList.count; i++) {
                    NSDictionary *option = conditionList[i];
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.titleLabel.font = [UIFont systemFontOfSize:13];
                    [button setTitle:option[@"name"] forState:UIControlStateNormal];
                    button.layer.cornerRadius = 14;
                    button.layer.borderWidth = 1;
                    
                    // 判断是否选中
                    BOOL isSelected = [currentValue isEqualToString:option[@"key"]];
                    if (isSelected) {
                        button.backgroundColor = [UIColor colorWithRed:0.23 green:0.31 blue:0.87 alpha:1.0];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        button.layer.borderColor = [UIColor colorWithRed:0.23 green:0.31 blue:0.87 alpha:1.0].CGColor;
                    } else {
                        button.backgroundColor = [UIColor whiteColor];
                        [button setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
                        button.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
                    }
                    
                    // 设置按钮的关联信息
                    objc_setAssociatedObject(button, "fieldName", fieldName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    objc_setAssociatedObject(button, "optionKey", option[@"key"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    objc_setAssociatedObject(button, "optionName", option[@"name"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    
                    [button addTarget:self action:@selector(formOptionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [optionsContainer addSubview:button];
                    
                    // 计算位置
                    NSInteger row = i / buttonsPerRow;
                    NSInteger col = i % buttonsPerRow;
                    
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(optionsContainer).offset(col * (buttonWidth + spacing));
                        make.top.equalTo(optionsContainer).offset(row * (buttonHeight + spacing));
                        make.width.mas_equalTo(buttonWidth);
                        make.height.mas_equalTo(buttonHeight);
                    }];
                }
                
                // 更新容器高度
                NSInteger totalRows = (conditionList.count + buttonsPerRow - 1) / buttonsPerRow;
                CGFloat containerHeight = totalRows * buttonHeight + (totalRows - 1) * spacing;
                
                [optionsContainer mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(containerHeight);
                }];
            }
            
            return cell;
        }
    } else if (indexPath.section == 3) {
        // 贷款金额
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AmountCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AmountCell"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = @"贷款金额";
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            titleLabel.tag = 400;
            [cell.contentView addSubview:titleLabel];
            
            UITextField *amountField = [[UITextField alloc] init];
            amountField.placeholder = @"请输入贷款金额";
            amountField.font = [UIFont systemFontOfSize:14];
            amountField.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
            amountField.keyboardType = UIKeyboardTypeNumberPad;
            amountField.layer.cornerRadius = 15;
            amountField.layer.borderWidth = 1;
            amountField.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
            amountField.backgroundColor = [UIColor whiteColor];
            amountField.tag = 401;
            
            // 设置左边距
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];
            amountField.leftView = leftView;
            amountField.leftViewMode = UITextFieldViewModeAlways;
            
            [amountField addTarget:self action:@selector(amountFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            
            [cell.contentView addSubview:amountField];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.top.equalTo(cell.contentView).offset(15);
            }];
            
            [amountField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.right.equalTo(cell.contentView).offset(-15);
                make.top.equalTo(titleLabel.mas_bottom).offset(10);
                make.height.mas_equalTo(40);
                make.bottom.equalTo(cell.contentView).offset(-15);
            }];
        }
        
        UITextField *amountField = [cell.contentView viewWithTag:401];
        amountField.text = self.loanAmount;
        
        return cell;
    }
    
    return nil;
}
