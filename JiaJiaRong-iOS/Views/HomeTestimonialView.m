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
@property (nonatomic, strong) UIView *testimonialContainer;

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
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"她们都在用";
    self.titleLabel.font = FONT_BOLD(16);
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    // 证言容器
    self.testimonialContainer = [[UIView alloc] init];
    [self addSubview:self.testimonialContainer];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
    }];
    
    [self.testimonialContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.bottom.equalTo(self).offset(-20);
    }];
}

- (void)updateWithTestimonialData:(NSArray *)testimonialData {
    self.testimonialData = testimonialData;
    
    // 清除之前的视图
    for (UIView *subview in self.testimonialContainer.subviews) {
        [subview removeFromSuperview];
    }
    
    // 创建证言视图
    UIView *previousView = nil;
    for (NSInteger i = 0; i < testimonialData.count; i++) {
        NSDictionary *testimonial = testimonialData[i];
        UIView *testimonialView = [self createTestimonialViewWithData:testimonial];
        [self.testimonialContainer addSubview:testimonialView];
        
        [testimonialView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.testimonialContainer);
            make.width.equalTo(self.testimonialContainer).multipliedBy(1.0/testimonialData.count);
            if (previousView) {
                make.left.equalTo(previousView.mas_right);
            } else {
                make.left.equalTo(self.testimonialContainer);
            }
        }];
        
        previousView = testimonialView;
    }
}

- (UIView *)createTestimonialViewWithData:(NSDictionary *)data {
    UIView *testimonialView = [[UIView alloc] init];
    
    // 头像
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.image = [UIImage imageNamed:data[@"avatar"]];
    avatarView.contentMode = UIViewContentModeScaleAspectFit;
    avatarView.layer.cornerRadius = 20;
    avatarView.layer.masksToBounds = YES;
    [testimonialView addSubview:avatarView];
    
    // 姓名和时间容器
    UIView *infoContainer = [[UIView alloc] init];
    [testimonialView addSubview:infoContainer];
    
    // 姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = data[@"name"];
    nameLabel.font = FONT_BOLD(14);
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [infoContainer addSubview:nameLabel];
    
    // 手机号
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = data[@"phone"];
    phoneLabel.font = FONT_REGULAR(12);
    phoneLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [infoContainer addSubview:phoneLabel];
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = data[@"time"];
    timeLabel.font = FONT_REGULAR(12);
    timeLabel.textColor = [UIColor colorWithHexString:@"#FF772C"];
    [testimonialView addSubview:timeLabel];
    
    // 状态标签
    UIView *statusContainer = [[UIView alloc] init];
    statusContainer.backgroundColor = [UIColor colorWithHexString:@"#E8F5E8"];
    statusContainer.layer.cornerRadius = 10;
    [testimonialView addSubview:statusContainer];
    
    UIImageView *checkIcon = [[UIImageView alloc] init];
    checkIcon.image = [UIImage imageNamed:@"hud_success"];
    checkIcon.contentMode = UIViewContentModeScaleAspectFit;
    [statusContainer addSubview:checkIcon];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.text = data[@"status"];
    statusLabel.font = FONT_REGULAR(12);
    statusLabel.textColor = [UIColor colorWithHexString:@"#4CAF50"];
    [statusContainer addSubview:statusLabel];
    
    // 设置约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testimonialView).offset(10);
        make.top.equalTo(testimonialView).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [infoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarView.mas_right).offset(10);
        make.centerY.equalTo(avatarView);
        make.right.equalTo(testimonialView).offset(-10);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(infoContainer);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(2);
        make.left.bottom.equalTo(infoContainer);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoContainer.mas_bottom).offset(8);
        make.right.equalTo(testimonialView).offset(-10);
    }];
    
    [statusContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(8);
        make.centerX.equalTo(testimonialView);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(testimonialView).offset(-10);
    }];
    
    [checkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusContainer).offset(8);
        make.centerY.equalTo(statusContainer);
        make.width.height.mas_equalTo(12);
    }];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkIcon.mas_right).offset(4);
        make.right.equalTo(statusContainer).offset(-8);
        make.centerY.equalTo(statusContainer);
    }];
    
    return testimonialView;
}

@end 