//
//  JJRAIUserInputView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAIUserInputView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface JJRAIUserInputView () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;

// 输入字段
@property (nonatomic, strong) UITextField *ageTextField;
@property (nonatomic, strong) UITextField *incomeTextField;
@property (nonatomic, strong) UITextField *expenseTextField;
@property (nonatomic, strong) UITextField *debtTextField;
@property (nonatomic, strong) UITextField *employmentTextField;
@property (nonatomic, strong) UITextField *workYearsTextField;
@property (nonatomic, strong) UITextField *creditScoreTextField;

// 选择器数据
@property (nonatomic, strong) NSArray *employmentTypes;
@property (nonatomic, strong) UIPickerView *employmentPicker;

@end

@implementation JJRAIUserInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupData];
    }
    return self;
}

- (void)setupData {
    self.userProfile = [[JJRAIUserProfile alloc] init];
    self.employmentTypes = @[@"企业员工", @"公务员", @"教师", @"医生", @"个体经营", @"企业主", @"自由职业", @"其他"];
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 16;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 8;
    
    [self setupScrollView];
    [self setupContentView];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setupContentView {
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"💼 个人信息";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    [self.contentView addSubview:self.titleLabel];
    
    // 创建输入字段
    [self setupInputFields];
    
    [self setupConstraints];
}

- (void)setupInputFields {
    // 年龄
    self.ageTextField = [self createTextFieldWithPlaceholder:@"年龄" keyboardType:UIKeyboardTypeNumberPad];
    
    // 月收入
    self.incomeTextField = [self createTextFieldWithPlaceholder:@"月收入（元）" keyboardType:UIKeyboardTypeNumberPad];
    
    // 月支出
    self.expenseTextField = [self createTextFieldWithPlaceholder:@"月支出（元）" keyboardType:UIKeyboardTypeNumberPad];
    
    // 现有债务
    self.debtTextField = [self createTextFieldWithPlaceholder:@"现有债务（元）" keyboardType:UIKeyboardTypeNumberPad];
    
    // 职业类型
    self.employmentTextField = [self createTextFieldWithPlaceholder:@"职业类型" keyboardType:UIKeyboardTypeDefault];
    [self setupEmploymentPicker];
    
    // 工作年限
    self.workYearsTextField = [self createTextFieldWithPlaceholder:@"工作年限（年）" keyboardType:UIKeyboardTypeNumberPad];
    
    // 信用评分
    self.creditScoreTextField = [self createTextFieldWithPlaceholder:@"信用评分（300-850）" keyboardType:UIKeyboardTypeNumberPad];
}

- (UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:16];
    textField.keyboardType = keyboardType;
    textField.delegate = self;
    textField.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    textField.layer.borderColor = [UIColor colorWithHexString:@"#E9ECEF"].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.layer.cornerRadius = 8;
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.contentView addSubview:textField];
    return textField;
}

- (void)setupEmploymentPicker {
    self.employmentPicker = [[UIPickerView alloc] init];
    self.employmentPicker.delegate = self;
    self.employmentPicker.dataSource = self;
    self.employmentTextField.inputView = self.employmentPicker;
    
    // 添加工具栏
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(employmentPickerDone)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(employmentPickerCancel)];
    
    toolbar.items = @[cancelButton, flexSpace, doneButton];
    self.employmentTextField.inputAccessoryView = toolbar;
}

- (void)setupConstraints {
    UIView *lastView = self.titleLabel;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    NSArray *textFields = @[
        self.ageTextField,
        self.incomeTextField,
        self.expenseTextField,
        self.debtTextField,
        self.employmentTextField,
        self.workYearsTextField,
        self.creditScoreTextField
    ];
    
    for (UITextField *textField in textFields) {
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(16);
            make.left.right.equalTo(self.contentView).inset(20);
            make.height.mas_equalTo(44);
        }];
        lastView = textField;
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(20);
    }];
}

#pragma mark - Actions

- (void)employmentPickerDone {
    NSInteger selectedIndex = [self.employmentPicker selectedRowInComponent:0];
    self.employmentTextField.text = self.employmentTypes[selectedIndex];
    [self.employmentTextField resignFirstResponder];
    [self updateUserProfile];
}

- (void)employmentPickerCancel {
    [self.employmentTextField resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self updateUserProfile];
}

- (void)updateUserProfile {
    self.userProfile.age = [self.ageTextField.text integerValue];
    self.userProfile.monthlyIncome = @([self.incomeTextField.text doubleValue]);
    self.userProfile.monthlyExpense = @([self.expenseTextField.text doubleValue]);
    self.userProfile.currentDebt = @([self.debtTextField.text doubleValue]);
    self.userProfile.employmentType = self.employmentTextField.text ?: @"";
    self.userProfile.workYears = [self.workYearsTextField.text integerValue];
    self.userProfile.creditScore = @([self.creditScoreTextField.text integerValue]);
    
    if ([self.delegate respondsToSelector:@selector(userInputView:didUpdateUserProfile:)]) {
        [self.delegate userInputView:self didUpdateUserProfile:self.userProfile];
    }
}

#pragma mark - Public Methods

- (void)resetInputs {
    self.ageTextField.text = @"";
    self.incomeTextField.text = @"";
    self.expenseTextField.text = @"";
    self.debtTextField.text = @"";
    self.employmentTextField.text = @"";
    self.workYearsTextField.text = @"";
    self.creditScoreTextField.text = @"";
    
    self.userProfile = [[JJRAIUserProfile alloc] init];
}

- (BOOL)validateInputs {
    if (self.userProfile.age < 18 || self.userProfile.age > 70) {
        return NO;
    }
    
    if ([self.userProfile.monthlyIncome doubleValue] <= 0) {
        return NO;
    }
    
    if (self.userProfile.employmentType.length == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UIPickerViewDataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.employmentTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.employmentTypes[row];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end 