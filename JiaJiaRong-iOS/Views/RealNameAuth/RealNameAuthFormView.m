//
//  RealNameAuthFormView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "RealNameAuthFormView.h"
#import "JJRRealNameAuthViewModel.h"

@interface RealNameAuthFormView () <UITextFieldDelegate>

@property (nonatomic, strong) JJRRealNameAuthViewModel *viewModel;
@property (nonatomic, strong) UIView *cardContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *privacyLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *ageTextField;
@property (nonatomic, strong) UIButton *maleButton;
@property (nonatomic, strong) UIButton *femaleButton;
@property (nonatomic, strong) UIButton *cityButton;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation RealNameAuthFormView

- (instancetype)initWithViewModel:(JJRRealNameAuthViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 卡片容器
    self.cardContainer = [[UIView alloc] init];
    self.cardContainer.backgroundColor = [UIColor whiteColor];
    self.cardContainer.layer.cornerRadius = 16;
    self.cardContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardContainer.layer.shadowOpacity = 0.1;
    self.cardContainer.layer.shadowRadius = 8;
    [self addSubview:self.cardContainer];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"请完成本人实名认证，领取专属预估额度";
    self.titleLabel.font = FONT_BOLD(16);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardContainer addSubview:self.titleLabel];
    
    // 副标题
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = @"仅用作资方身份核验不上报征信";
    self.subtitleLabel.font = FONT_REGULAR(14);
    self.subtitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardContainer addSubview:self.subtitleLabel];
    
    // 隐私保护说明
    self.privacyLabel = [[UILabel alloc] init];
    self.privacyLabel.text = @"您的信息将被加密保护";
    self.privacyLabel.font = FONT_REGULAR(14);
    self.privacyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.privacyLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardContainer addSubview:self.privacyLabel];
    
    // 姓名输入框
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.placeholder = @"请输入您的真实姓名（已加密）";
    self.nameTextField.font = FONT_REGULAR(16);
    self.nameTextField.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.nameTextField.layer.cornerRadius = 8;
    self.nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.delegate = self;
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cardContainer addSubview:self.nameTextField];
    
    // 年龄输入框
    self.ageTextField = [[UITextField alloc] init];
    self.ageTextField.placeholder = @"请输入您的年龄";
    self.ageTextField.font = FONT_REGULAR(16);
    self.ageTextField.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.ageTextField.layer.cornerRadius = 8;
    self.ageTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.ageTextField.leftViewMode = UITextFieldViewModeAlways;
    self.ageTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.ageTextField.delegate = self;
    [self.ageTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cardContainer addSubview:self.ageTextField];
    
    // 性别选择按钮
    self.maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.maleButton setTitle:@"男" forState:UIControlStateNormal];
    [self.maleButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.maleButton.titleLabel.font = FONT_REGULAR(16);
    self.maleButton.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.maleButton.layer.cornerRadius = 8;
    self.maleButton.selected = self.viewModel.isMale;
    [self.maleButton addTarget:self action:@selector(maleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.cardContainer addSubview:self.maleButton];
    
    self.femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.femaleButton setTitle:@"女" forState:UIControlStateNormal];
    [self.femaleButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.femaleButton.titleLabel.font = FONT_REGULAR(16);
    self.femaleButton.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.femaleButton.layer.cornerRadius = 8;
    self.femaleButton.selected = !self.viewModel.isMale;
    [self.femaleButton addTarget:self action:@selector(femaleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.cardContainer addSubview:self.femaleButton];
    
    // 城市选择按钮
    self.cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cityButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.cityButton.titleLabel.font = FONT_REGULAR(16);
    self.cityButton.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.cityButton.layer.cornerRadius = 8;
    self.cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.cityButton addTarget:self action:@selector(cityButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.cardContainer addSubview:self.cityButton];
    
    // 城市按钮图标和文字
    UIImageView *locationIcon = [[UIImageView alloc] init];
    locationIcon.image = [UIImage systemImageNamed:@"location.fill"];
    locationIcon.tintColor = [UIColor colorWithHexString:@"#3B82F6"];
    [self.cityButton addSubview:locationIcon];
    
    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.text = @"所在城市：";
    cityLabel.font = FONT_REGULAR(16);
    cityLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.cityButton addSubview:cityLabel];
    
    UILabel *cityNameLabel = [[UILabel alloc] init];
    cityNameLabel.text = self.viewModel.cityName;
    cityNameLabel.font = FONT_REGULAR(16);
    cityNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cityNameLabel.tag = 100; // 用于更新
    [self.cityButton addSubview:cityNameLabel];
    
    UILabel *switchCityLabel = [[UILabel alloc] init];
    switchCityLabel.text = @"切换城市";
    switchCityLabel.font = FONT_REGULAR(14);
    switchCityLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    [self.cityButton addSubview:switchCityLabel];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitButton setTitle:@"领取授信额度" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = FONT_BOLD(16);
    self.submitButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.submitButton.layer.cornerRadius = 23;
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
    
    [self updateGenderButtonsAppearance];
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardContainer).offset(30);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.height.mas_equalTo(46);
    }];
    
    [self.ageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom).offset(15);
        make.left.equalTo(self.cardContainer).offset(20);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(46);
    }];
    
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ageTextField);
        make.right.equalTo(self.cardContainer.mas_centerX).offset(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(46);
    }];
    
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ageTextField);
        make.left.equalTo(self.cardContainer.mas_centerX).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(46);
    }];
    
    [self.cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageTextField.mas_bottom).offset(15);
        make.left.right.equalTo(self.cardContainer).inset(20);
        make.height.mas_equalTo(60);
        make.bottom.equalTo(self.cardContainer).offset(-30);
    }];
    
    // 城市按钮内部布局
    UIImageView *locationIcon = self.cityButton.subviews[0];
    [locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityButton).offset(15);
        make.centerY.equalTo(self.cityButton);
        make.width.height.mas_equalTo(20);
    }];
    
    UILabel *cityLabel = self.cityButton.subviews[1];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationIcon.mas_right).offset(10);
        make.centerY.equalTo(self.cityButton);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *cityNameLabel = self.cityButton.subviews[2];
    [cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityLabel.mas_right).offset(5);
        make.centerY.equalTo(self.cityButton);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *switchCityLabel = self.cityButton.subviews[3];
    [switchCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cityButton).offset(-15);
        make.centerY.equalTo(self.cityButton);
        make.height.mas_equalTo(20);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardContainer.mas_bottom).offset(40);
        make.left.right.equalTo(self).inset(20);
        make.height.mas_equalTo(46);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - Actions

- (void)maleButtonTapped {
    self.viewModel.isMale = YES;
    [self updateGenderButtonsAppearance];
}

- (void)femaleButtonTapped {
    self.viewModel.isMale = NO;
    [self updateGenderButtonsAppearance];
}

- (void)cityButtonTapped {
    if ([self.delegate respondsToSelector:@selector(formViewDidTapCitySelection)]) {
        [self.delegate formViewDidTapCitySelection];
    }
}

- (void)submitButtonTapped {
    if ([self.delegate respondsToSelector:@selector(formViewDidTapSubmit)]) {
        [self.delegate formViewDidTapSubmit];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.nameTextField) {
        self.viewModel.realName = textField.text;
    } else if (textField == self.ageTextField) {
        self.viewModel.age = textField.text;
    }
}

#pragma mark - Public Methods

- (void)updateCityDisplay {
    UILabel *cityNameLabel = [self.cityButton viewWithTag:100];
    cityNameLabel.text = self.viewModel.cityName;
}

#pragma mark - Private Methods

- (void)updateGenderButtonsAppearance {
    if (self.viewModel.isMale) {
        self.maleButton.selected = YES;
        self.maleButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
        self.femaleButton.selected = NO;
        self.femaleButton.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    } else {
        self.maleButton.selected = NO;
        self.maleButton.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        self.femaleButton.selected = YES;
        self.femaleButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    }
}

@end 