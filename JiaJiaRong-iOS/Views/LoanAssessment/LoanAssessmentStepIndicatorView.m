//
//  LoanAssessmentStepIndicatorView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "LoanAssessmentStepIndicatorView.h"

@interface LoanAssessmentStepIndicatorView ()

@property (nonatomic, strong) NSArray<UIView *> *stepDots;
@property (nonatomic, strong) NSArray<UIView *> *stepLines;

@end

@implementation LoanAssessmentStepIndicatorView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSMutableArray *dots = [NSMutableArray array];
    NSMutableArray *lines = [NSMutableArray array];
    
    // 创建4个步骤点和3条连接线
    for (int i = 0; i < 4; i++) {
        // 步骤点
        UIView *dot = [[UIView alloc] init];
        dot.layer.cornerRadius = 6;
        dot.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        [self addSubview:dot];
        [dots addObject:dot];
        
        // 连接线（最后一个点不需要连接线）
        if (i < 3) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
            [self addSubview:line];
            [lines addObject:line];
        }
    }
    
    self.stepDots = [dots copy];
    self.stepLines = [lines copy];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    CGFloat dotSize = 12;
    CGFloat lineWidth = 20;
    
    for (int i = 0; i < self.stepDots.count; i++) {
        UIView *dot = self.stepDots[i];
        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(dotSize);
            
            if (i == 0) {
                make.left.equalTo(self);
            } else {
                UIView *prevLine = self.stepLines[i - 1];
                make.left.equalTo(prevLine.mas_right);
            }
        }];
        
        // 连接线
        if (i < self.stepLines.count) {
            UIView *line = self.stepLines[i];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(dot.mas_right);
                make.width.mas_equalTo(lineWidth);
                make.height.mas_equalTo(2);
            }];
        }
    }
    
    // 设置最后一个点的右约束
    UIView *lastDot = self.stepDots.lastObject;
    [lastDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
    }];
}

- (void)updateWithCurrentStep:(LoanAssessmentStep)currentStep {
    for (int i = 0; i < self.stepDots.count; i++) {
        UIView *dot = self.stepDots[i];
        
        if (i <= currentStep) {
            // 当前步骤和已完成步骤：高亮
            dot.backgroundColor = [UIColor whiteColor];
        } else {
            // 未来步骤：半透明
            dot.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        }
    }
    
    for (int i = 0; i < self.stepLines.count; i++) {
        UIView *line = self.stepLines[i];
        
        if (i < currentStep) {
            // 已完成的连接线：高亮
            line.backgroundColor = [UIColor whiteColor];
        } else {
            // 未完成的连接线：半透明
            line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        }
    }
}

@end 