//
//  HomeTestimonialView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "HomeTestimonialView.h"

@interface HomeTestimonialView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat itemHeight;

@end

@implementation HomeTestimonialView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.itemHeight = 70.0; // 每个条目的高度
    self.currentIndex = 0;
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"她们都在用";
    self.titleLabel.font = FONT_BOLD(16);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.pagingEnabled = NO;
    [self addSubview:self.scrollView];
    
    // 内容容器
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

- (void)updateWithTestimonialData:(NSArray *)testimonialData {
    self.testimonialData = testimonialData;
    
    // 清除之前的视图
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    // 创建证言视图
    UIView *previousView = nil;
    for (NSInteger i = 0; i < testimonialData.count; i++) {
        NSDictionary *testimonial = testimonialData[i];
        UIView *testimonialView = [self createTestimonialViewWithData:testimonial];
        [self.contentView addSubview:testimonialView];
        
        [testimonialView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(self.itemHeight);
            if (previousView) {
                make.top.equalTo(previousView.mas_bottom);
            } else {
                make.top.equalTo(self.contentView);
            }
        }];
        
        previousView = testimonialView;
    }
    
    // 设置内容视图高度
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(previousView ?: self.contentView);
    }];
    
    // 开始自动滚动
    [self startAutoScroll];
}

- (UIView *)createTestimonialViewWithData:(NSDictionary *)data {
    UIView *testimonialView = [[UIView alloc] init];
    testimonialView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    testimonialView.layer.cornerRadius = 8;
    
    // 头像
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.image = [UIImage imageNamed:data[@"avatar"]];
    avatarView.contentMode = UIViewContentModeScaleAspectFit;
    avatarView.layer.cornerRadius = 15;
    avatarView.layer.masksToBounds = YES;
    avatarView.backgroundColor = [UIColor colorWithHexString:@"#FF772C"];
    [testimonialView addSubview:avatarView];
    
    // 姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = data[@"name"];
    nameLabel.font = FONT_BOLD(14);
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [testimonialView addSubview:nameLabel];
    
    // 手机号
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = data[@"phone"];
    phoneLabel.font = FONT_REGULAR(12);
    phoneLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [testimonialView addSubview:phoneLabel];
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = data[@"time"];
    timeLabel.font = FONT_REGULAR(11);
    timeLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    [testimonialView addSubview:timeLabel];
    
    // 状态标签
    UIView *statusContainer = [[UIView alloc] init];
    statusContainer.backgroundColor = [UIColor colorWithHexString:@"#E8F5E8"];
    statusContainer.layer.cornerRadius = 8;
    [testimonialView addSubview:statusContainer];
    
    UIImageView *checkIcon = [[UIImageView alloc] init];
    checkIcon.image = [UIImage imageNamed:@"hud_success"];
    checkIcon.contentMode = UIViewContentModeScaleAspectFit;
    [statusContainer addSubview:checkIcon];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = data[@"status"];
    statusLabel.font = FONT_REGULAR(11);
    statusLabel.textColor = [UIColor colorWithHexString:@"#4CAF50"];
    [statusContainer addSubview:statusLabel];
    
    // 设置约束 - 水平布局
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testimonialView).offset(12);
        make.centerY.equalTo(testimonialView);
        make.width.height.mas_equalTo(30);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).offset(10);
        make.top.equalTo(testimonialView).offset(6);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(2);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(phoneLabel.mas_bottom).offset(2);
    }];
    
    [statusContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(testimonialView).offset(-12);
        make.centerY.equalTo(testimonialView);
        make.height.mas_equalTo(24);
    }];
    
    [checkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusContainer).offset(6);
        make.centerY.equalTo(statusContainer);
        make.width.height.mas_equalTo(12);
    }];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkIcon.mas_right).offset(4);
        make.right.equalTo(statusContainer).offset(-6);
        make.centerY.equalTo(statusContainer);
    }];
    
    return testimonialView;
}

#pragma mark - Auto Scroll

- (void)startAutoScroll {
    [self stopAutoScroll];
    
    if (self.testimonialData.count <= 1) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf scrollToNextItem];
    }];
}

- (void)stopAutoScroll {
    if (self.autoScrollTimer) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

- (void)scrollToNextItem {
    if (self.testimonialData.count <= 1) {
        return;
    }
    
    self.currentIndex++;
    
    // 如果到达最后一个，回到第一个
    if (self.currentIndex >= self.testimonialData.count) {
        self.currentIndex = 0;
    }
    
    CGFloat offsetY = self.currentIndex * self.itemHeight;
    
    // 检查是否需要滚动
    CGFloat maxOffsetY = MAX(0, self.scrollView.contentSize.height - self.scrollView.frame.size.height);
    offsetY = MIN(offsetY, maxOffsetY);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:NO];
    }];
}

- (void)dealloc {
    [self stopAutoScroll];
}

@end 
