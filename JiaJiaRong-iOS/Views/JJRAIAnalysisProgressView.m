//
//  JJRAIAnalysisProgressView.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRAIAnalysisProgressView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface JJRAIAnalysisProgressView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *aiIconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *progressBarBackground;
@property (nonatomic, strong) UIView *progressBarFill;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) CGFloat animatedProgress;

@end

@implementation JJRAIAnalysisProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.progress = 0.0;
        self.statusMessage = @"AI正在分析您的资料...";
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 16;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 4);
    self.layer.shadowOpacity = 0.15;
    self.layer.shadowRadius = 12;
    
    // 容器视图
    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    // AI图标
    self.aiIconView = [[UIImageView alloc] init];
    self.aiIconView.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.aiIconView.layer.cornerRadius = 35; // 调整圆角以匹配新的尺寸
    self.aiIconView.clipsToBounds = YES;
    
    // 确保图标不被压缩
    self.aiIconView.contentMode = UIViewContentModeCenter;
    
    // 创建AI图标文字
    UILabel *aiLabel = [[UILabel alloc] init];
    aiLabel.text = @"AI";
    aiLabel.font = [UIFont boldSystemFontOfSize:26]; // 增加字体大小
    aiLabel.textColor = [UIColor whiteColor];
    aiLabel.textAlignment = NSTextAlignmentCenter;
    [self.aiIconView addSubview:aiLabel];
    
    [aiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.aiIconView);
        make.size.equalTo(self.aiIconView);
    }];
    
    [self.containerView addSubview:self.aiIconView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"AI智能分析中";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.titleLabel];
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.numberOfLines = 2;
    [self.containerView addSubview:self.statusLabel];
    
    // 进度条背景
    self.progressBarBackground = [[UIView alloc] init];
    self.progressBarBackground.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    self.progressBarBackground.layer.cornerRadius = 4;
    [self.containerView addSubview:self.progressBarBackground];
    
    // 进度条填充
    self.progressBarFill = [[UIView alloc] init];
    self.progressBarFill.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    self.progressBarFill.layer.cornerRadius = 4;
    [self.progressBarBackground addSubview:self.progressBarFill];
    
    // 进度标签
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.font = [UIFont boldSystemFontOfSize:14];
    self.progressLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.progressLabel];
    
    [self setupConstraints];
    [self updateProgress];
}

- (void)setupConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).inset(16);
    }];
    
    [self.aiIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(24);
        make.centerX.equalTo(self.containerView);
        make.width.height.mas_equalTo(70); // 增加尺寸以确保清晰显示
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aiIconView.mas_bottom).offset(18);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@40);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@20);
    }];
    
    [self.progressBarBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(28);
        make.left.right.equalTo(self.containerView).inset(20);
        make.height.mas_equalTo(8);
    }];
    
    [self.progressBarFill mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.progressBarBackground);
        make.width.equalTo(self.progressBarBackground).multipliedBy(0.0);
    }];
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressBarBackground.mas_bottom).offset(16);
        make.left.right.equalTo(self.containerView).inset(20);
        make.height.mas_equalTo(22);
        make.bottom.lessThanOrEqualTo(self.containerView).offset(-24);
    }];
}

#pragma mark - Public Methods

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(0.0, MIN(1.0, progress));
    [self updateProgress];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    _progress = MAX(0.0, MIN(1.0, progress));
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateProgressBar];
        }];
    } else {
        [self updateProgress];
    }
}

- (void)setStatusMessage:(NSString *)statusMessage {
    _statusMessage = statusMessage;
    self.statusLabel.text = statusMessage;
}

- (void)startAnimation {
    NSLog(@"🚀 启动进度动画");
    [self stopAnimation];
    
    // 确保视图可见
    self.hidden = NO;
    
    // 重置进度
    self.animatedProgress = 0.0;
    [self setProgress:0.0 animated:NO];
    
    // 重置状态消息
    self.statusMessage = @"准备开始分析...";
    
    // 图标旋转动画
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.toValue = @(M_PI * 2);
    rotation.duration = 2.0;
    rotation.repeatCount = HUGE_VALF;
    [self.aiIconView.layer addAnimation:rotation forKey:@"rotation"];
    
    // 模拟进度更新
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAnimatedProgress) userInfo:nil repeats:YES];
    
    NSLog(@"✅ 进度动画已启动");
}

- (void)stopAnimation {
    NSLog(@"🛑 停止进度动画");
    [self.aiIconView.layer removeAllAnimations];
    
    if (self.animationTimer) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
    
    // 注意：不在这里隐藏视图，只停止动画
    // 视图的隐藏应该由父控制器管理
}

#pragma mark - Private Methods

- (void)updateProgress {
    [self updateProgressBar];
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.progress * 100];
}

- (void)updateProgressBar {
    [self.progressBarFill mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.progressBarBackground).multipliedBy(self.progress);
    }];
    [self layoutIfNeeded];
}

- (void)updateAnimatedProgress {
    // 模拟渐进式分析进度
    NSArray *statusMessages = @[
        @"正在读取个人信息...",
        @"分析收入状况...",
        @"评估信用风险...",
        @"匹配最佳方案...",
        @"计算还款计划...",
        @"生成AI建议..."
    ];
    NSArray *progressPoints = @[@0.15, @0.35, @0.55, @0.75, @0.9, @1.0];
    
    // 根据当前进度确定应该显示的状态
    NSInteger targetIndex = -1;
    for (NSInteger i = 0; i < progressPoints.count; i++) {
        if (self.animatedProgress < [progressPoints[i] floatValue]) {
            targetIndex = i;
            break;
        }
    }
    
    if (targetIndex >= 0) {
        CGFloat targetProgress = [progressPoints[targetIndex] floatValue];
        
        if (self.animatedProgress < targetProgress) {
            self.animatedProgress += 0.02;
            [self setProgress:self.animatedProgress animated:YES];
            
            // 更新状态消息
            if (targetIndex < statusMessages.count) {
                self.statusMessage = statusMessages[targetIndex];
            }
        }
    } else {
        // 完成
        [self setProgress:1.0 animated:YES];
        self.statusMessage = @"分析完成！";
        [self stopAnimation];
        
        // 延迟一下再通知完成，让用户看到100%
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JJRAIAnalysisCompleted" object:nil];
        });
    }
}

- (void)dealloc {
    [self stopAnimation];
}

@end 
