//
//  JJRRiskInputFormView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRRiskInputFormView.h"

@interface JJRRiskInputFormView () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

// 输入控件
@property (nonatomic, strong) UITextField *ageField;
@property (nonatomic, strong) UITextField *incomeField;
@property (nonatomic, strong) UITextField *debtField;
@property (nonatomic, strong) UITextField *assetField;
@property (nonatomic, strong) UITextField *creditScoreField;
@property (nonatomic, strong) UITextField *workYearsField;

@property (nonatomic, strong) UISegmentedControl *employmentSegment;
@property (nonatomic, strong) UISwitch *houseSwitch;
@property (nonatomic, strong) UISwitch *carSwitch;
@property (nonatomic, strong) UISwitch *insuranceSwitch;

@property (nonatomic, strong) UIButton *assessmentButton;

@end

@implementation JJRRiskInputFormView

- (instancetype)initWithUserProfile:(JJRUserRiskProfile *)profile {
    if (self = [super init]) {
        self.userProfile = profile ?: [[JJRUserRiskProfile alloc] init];
        [self setupUI];
        [self updateFormWithProfile:self.userProfile];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    [self setupFormControls];
    [self setupConstraints];
}

- (void)setupFormControls {
    // 年龄输入
    self.ageField = [self addInputSection:@"📅 年龄" 
                              placeholder:@"请输入年龄"
                             keyboardType:UIKeyboardTypeNumberPad];
    
    // 月收入输入
    self.incomeField = [self addInputSection:@"💰 月收入(元)" 
                                 placeholder:@"请输入月收入"
                                keyboardType:UIKeyboardTypeNumberPad];
    
    // 总负债输入
    self.debtField = [self addInputSection:@"💳 总负债(元)" 
                               placeholder:@"请输入总负债金额"
                              keyboardType:UIKeyboardTypeNumberPad];
    
    // 总资产输入
    self.assetField = [self addInputSection:@"🏦 总资产(元)" 
                                placeholder:@"请输入总资产金额"
                               keyboardType:UIKeyboardTypeNumberPad];
    
    // 信用评分输入
    self.creditScoreField = [self addInputSection:@"📊 信用评分" 
                                       placeholder:@"请输入信用评分(300-850)"
                                      keyboardType:UIKeyboardTypeNumberPad];
    
    // 工作年限输入
    self.workYearsField = [self addInputSection:@"💼 工作年限" 
                                     placeholder:@"请输入工作年限"
                                    keyboardType:UIKeyboardTypeNumberPad];
    
    // 就业类型选择
    self.employmentSegment = [self addSegmentSection:@"👔 就业类型" 
                                               items:@[@"公务员", @"上班族", @"自由职业", @"个体户"]];
    
    // 资产状况开关
    self.houseSwitch = [self addSwitchSection:@"🏠 房产"];
    self.carSwitch = [self addSwitchSection:@"🚗 车辆"];
    self.insuranceSwitch = [self addSwitchSection:@"🛡️ 保险"];
    
    // 评估按钮
    self.assessmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.assessmentButton setTitle:@"开始风险评估" forState:UIControlStateNormal];
    self.assessmentButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.assessmentButton.titleLabel.font = FONT_BOLD(18);
    [self.assessmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.assessmentButton.layer.cornerRadius = 25;
    self.assessmentButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.assessmentButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.assessmentButton.layer.shadowOpacity = 0.1;
    self.assessmentButton.layer.shadowRadius = 4;
    [self.assessmentButton addTarget:self action:@selector(assessmentButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.assessmentButton];
}

- (UITextField *)addInputSection:(NSString *)title 
                     placeholder:(NSString *)placeholder 
                    keyboardType:(UIKeyboardType)keyboardType {
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = FONT_MEDIUM(16);
    titleLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:titleLabel];
    
    // 输入框
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = keyboardType;
    textField.delegate = self;
    textField.font = FONT_REGULAR(16);
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 8;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = BORDER_COLOR.CGColor;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:textField];
    
    // 设置约束
    NSInteger currentIndex = self.contentView.subviews.count / 2 - 1;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(20);
        make.top.equalTo(self.contentView).offset(20 + currentIndex * 80);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.height.equalTo(@44);
    }];
    
    return textField;
}

- (UISegmentedControl *)addSegmentSection:(NSString *)title 
                                    items:(NSArray *)items {
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = FONT_MEDIUM(16);
    titleLabel.textColor = TEXT_COLOR;
    [self.contentView addSubview:titleLabel];
    
    // 分段控制器
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.selectedSegmentIndex = 1; // 默认选择"上班族"
    segment.backgroundColor = [UIColor whiteColor];
    segment.tintColor = [UIColor colorWithHexString:@"#FF772C"];
    [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:segment];
    
    // 设置约束
    NSInteger currentIndex = (self.contentView.subviews.count - 2) / 2;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(20);
        make.top.equalTo(self.contentView).offset(20 + currentIndex * 80);
    }];
    
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.height.equalTo(@36);
    }];
    
    return segment;
}

- (UISwitch *)addSwitchSection:(NSString *)title {
    // 容器视图
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 8;
    containerView.layer.borderWidth = 1;
    containerView.layer.borderColor = BORDER_COLOR.CGColor;
    [self.contentView addSubview:containerView];
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = FONT_MEDIUM(16);
    titleLabel.textColor = TEXT_COLOR;
    [containerView addSubview:titleLabel];
    
    // 开关
    UISwitch *switchControl = [[UISwitch alloc] init];
    switchControl.onTintColor = [UIColor colorWithHexString:@"#FF772C"];
    [switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [containerView addSubview:switchControl];
    
    // 设置约束
    NSInteger currentIndex = self.contentView.subviews.count - 1;
    NSInteger baseOffset = 20 + 6 * 80; // 前6个输入框的高度
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(20);
        make.top.equalTo(self.contentView).offset(baseOffset + (currentIndex - 12) * 60);
        make.height.equalTo(@50);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(16);
        make.centerY.equalTo(containerView);
    }];
    
    [switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(-16);
        make.centerY.equalTo(containerView);
    }];
    
    return switchControl;
}

- (void)setupConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 评估按钮约束
    CGFloat totalHeight = 20 + 6 * 80 + 3 * 60 + 80; // 计算总高度
    
    [self.assessmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(40);
        make.top.equalTo(self.contentView).offset(totalHeight);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
}

- (void)updateFormWithProfile:(JJRUserRiskProfile *)profile {
    self.ageField.text = [NSString stringWithFormat:@"%ld", (long)profile.age];
    self.incomeField.text = [NSString stringWithFormat:@"%.0f", profile.monthlyIncome];
    self.debtField.text = [NSString stringWithFormat:@"%.0f", profile.totalDebt];
    self.assetField.text = [NSString stringWithFormat:@"%.0f", profile.totalAssets];
    self.creditScoreField.text = [NSString stringWithFormat:@"%ld", (long)profile.creditScore];
    self.workYearsField.text = [NSString stringWithFormat:@"%ld", (long)profile.employmentYears];
    
    // 设置就业类型
    NSArray *types = @[@"公务员", @"上班族", @"自由职业", @"个体户"];
    NSInteger index = [types indexOfObject:profile.employmentType];
    if (index != NSNotFound) {
        self.employmentSegment.selectedSegmentIndex = index;
    }
    
    self.houseSwitch.on = profile.hasHouse;
    self.carSwitch.on = profile.hasCar;
    self.insuranceSwitch.on = profile.hasInsurance;
}

- (void)updateAssessmentButtonState:(BOOL)isLoading {
    self.assessmentButton.enabled = !isLoading;
    
    if (isLoading) {
        [self.assessmentButton setTitle:@"正在评估中..." forState:UIControlStateNormal];
        self.assessmentButton.alpha = 0.7;
    } else {
        [self.assessmentButton setTitle:@"开始风险评估" forState:UIControlStateNormal];
        self.assessmentButton.alpha = 1.0;
    }
}

#pragma mark - Actions

- (void)assessmentButtonTapped {
    [self updateUserProfileFromForm];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(riskInputFormViewDidTapAssessment:)]) {
        [self.delegate riskInputFormViewDidTapAssessment:self];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self updateUserProfileFromForm];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(riskInputFormView:didUpdateProfile:)]) {
        [self.delegate riskInputFormView:self didUpdateProfile:self.userProfile];
    }
}

- (void)segmentValueChanged:(UISegmentedControl *)segment {
    [self updateUserProfileFromForm];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(riskInputFormView:didUpdateProfile:)]) {
        [self.delegate riskInputFormView:self didUpdateProfile:self.userProfile];
    }
}

- (void)switchValueChanged:(UISwitch *)switchControl {
    [self updateUserProfileFromForm];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(riskInputFormView:didUpdateProfile:)]) {
        [self.delegate riskInputFormView:self didUpdateProfile:self.userProfile];
    }
}

- (void)updateUserProfileFromForm {
    self.userProfile.age = [self.ageField.text integerValue];
    self.userProfile.monthlyIncome = [self.incomeField.text floatValue];
    self.userProfile.totalDebt = [self.debtField.text floatValue];
    self.userProfile.totalAssets = [self.assetField.text floatValue];
    self.userProfile.creditScore = [self.creditScoreField.text integerValue];
    self.userProfile.employmentYears = [self.workYearsField.text integerValue];
    
    NSArray *types = @[@"公务员", @"上班族", @"自由职业", @"个体户"];
    if (self.employmentSegment.selectedSegmentIndex < types.count) {
        self.userProfile.employmentType = types[self.employmentSegment.selectedSegmentIndex];
    }
    
    self.userProfile.hasHouse = self.houseSwitch.on;
    self.userProfile.hasCar = self.carSwitch.on;
    self.userProfile.hasInsurance = self.insuranceSwitch.on;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end 