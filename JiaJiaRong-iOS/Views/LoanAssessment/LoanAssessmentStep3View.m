//
//  LoanAssessmentStep3View.m
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "LoanAssessmentStep3View.h"
#import "JJRLoanAssessmentViewModel.h"

@interface LoanAssessmentStep3View ()

@property (nonatomic, strong) JJRLoanAssessmentViewModel *viewModel;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIView *cardContainer;
@property (nonatomic, strong) NSMutableArray<UIButton *> *optionButtons;
@property (nonatomic, strong) UIView *buttonContainer;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation LoanAssessmentStep3View

- (instancetype)initWithViewModel:(JJRLoanAssessmentViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        _optionButtons = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 白色卡片容器
    self.cardContainer = [[UIView alloc] init];
    self.cardContainer.backgroundColor = [UIColor whiteColor];
    self.cardContainer.layer.cornerRadius = 16;
    self.cardContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardContainer.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardContainer.layer.shadowOpacity = 0.1;
    self.cardContainer.layer.shadowRadius = 8;
    [self addSubview:self.cardContainer];
    
    // 多选题标签
    UILabel *multiChoiceLabel = [[UILabel alloc] init];
    multiChoiceLabel.text = @"多选题";
    multiChoiceLabel.font = FONT_REGULAR(14);
    multiChoiceLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    multiChoiceLabel.backgroundColor = [UIColor colorWithHexString:@"#EFF6FF"];
    multiChoiceLabel.textAlignment = NSTextAlignmentCenter;
    multiChoiceLabel.layer.cornerRadius = 12;
    multiChoiceLabel.clipsToBounds = YES;
    [self.cardContainer addSubview:multiChoiceLabel];
    
    // 提示标签
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"至少选一项，资产越多，通过率越高，额度越大";
    hintLabel.font = FONT_REGULAR(12);
    hintLabel.textColor = [UIColor colorWithHexString:@"#3B82F6"];
    [self.cardContainer addSubview:hintLabel];
    
    // 问题标题
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.text = @"3. 您的个人资产情况是？";
    self.questionLabel.font = FONT_BOLD(18);
    self.questionLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    self.questionLabel.numberOfLines = 0;
    [self.cardContainer addSubview:self.questionLabel];
    
    // 创建选项按钮
    [self createOptionButtons];
    
    // 按钮容器
    self.buttonContainer = [[UIView alloc] init];
    [self addSubview:self.buttonContainer];
    
    // 上一步按钮
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousButton setTitle:@"上一步" forState:UIControlStateNormal];
    [self.previousButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.previousButton.titleLabel.font = FONT_BOLD(16);
    self.previousButton.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.previousButton.layer.cornerRadius = 25;
    [self.previousButton addTarget:self action:@selector(previousButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:self.previousButton];
    
    // 下一步按钮
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = FONT_BOLD(16);
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.nextButton.layer.cornerRadius = 25;
    self.nextButton.enabled = NO;
    self.nextButton.alpha = 0.6;
    [self.nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:self.nextButton];
    
    [self setupConstraints];
}

- (void)createOptionButtons {
    NSArray<NSString *> *options = self.viewModel.allOptions[2]; // 直接使用第三步的选项
    
    for (int i = 0; i < options.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:options[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = FONT_REGULAR(16);
        button.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        button.layer.cornerRadius = 8;
        button.tag = i;
        [button addTarget:self action:@selector(optionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.cardContainer addSubview:button];
        [self.optionButtons addObject:button];
    }
}

- (void)setupConstraints {
    [self.cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self).inset(20);
    }];
    
    UILabel *multiChoiceLabel = self.cardContainer.subviews[0];
    [multiChoiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardContainer).offset(20);
        make.left.equalTo(self.cardContainer).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *hintLabel = self.cardContainer.subviews[1];
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(multiChoiceLabel);
        make.left.equalTo(multiChoiceLabel.mas_right).offset(12);
        make.right.lessThanOrEqualTo(self.cardContainer).offset(-20);
    }];
    
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(multiChoiceLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.cardContainer).inset(20);
    }];
    
    // 选项按钮约束
    UIButton *previousButton = nil;
    for (UIButton *button in self.optionButtons) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (previousButton) {
                make.top.equalTo(previousButton.mas_bottom).offset(12);
            } else {
                make.top.equalTo(self.questionLabel.mas_bottom).offset(30);
            }
            make.left.right.equalTo(self.cardContainer).inset(20);
            make.height.mas_equalTo(50);
        }];
        previousButton = button;
    }
    
    // 设置卡片容器的底部约束
    UIButton *lastButton = self.optionButtons.lastObject;
    [self.cardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastButton.mas_bottom).offset(30);
    }];
    
    [self.buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardContainer.mas_bottom).offset(40);
        make.left.right.equalTo(self).inset(20);
        make.height.mas_equalTo(50);
        make.bottom.lessThanOrEqualTo(self).offset(-40);
    }];
    
    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.buttonContainer);
        make.width.mas_equalTo(120);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.buttonContainer);
        make.left.equalTo(self.previousButton.mas_right).offset(16);
    }];
}

#pragma mark - Actions

- (void)optionButtonTapped:(UIButton *)sender {
    NSInteger selectedIndex = sender.tag;
    
    // 多选逻辑：切换按钮状态
    if (sender.selected) {
        // 取消选中
        sender.selected = NO;
        sender.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.viewModel deselectOptionAtIndex:selectedIndex];
    } else {
        // 选中
        sender.selected = YES;
        sender.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
        [self.viewModel selectOptionAtIndex:selectedIndex];
    }
    
    // 更新下一步按钮状态
    [self updateNextButtonState];
}

- (void)previousButtonTapped {
    [self.viewModel goToPreviousStep];
}

- (void)nextButtonTapped {
    if ([self.viewModel canProceedToNextStep]) {
        [self.viewModel goToNextStep];
    }
}

- (void)updateNextButtonState {
    BOOL canProceed = [self.viewModel canProceedToNextStep];
    self.nextButton.enabled = canProceed;
    self.nextButton.alpha = canProceed ? 1.0 : 0.6;
}

- (void)updateDisplay {
    // 更新选项按钮状态（多选）
    id selected = [self.viewModel selectedForCurrentStep];
    NSMutableSet *selectedSet = [selected isKindOfClass:[NSMutableSet class]] ? selected : [NSMutableSet set];
    
    for (int i = 0; i < self.optionButtons.count; i++) {
        UIButton *button = self.optionButtons[i];
        if ([selectedSet containsObject:@(i)]) {
            button.selected = YES;
            button.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
        } else {
            button.selected = NO;
            button.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        }
    }
    
    [self updateNextButtonState];
}

@end 
