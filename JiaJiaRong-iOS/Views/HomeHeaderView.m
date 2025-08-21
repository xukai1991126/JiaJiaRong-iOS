//
//  HomeHeaderView.m
//  JiaJiaRong-iOS
//
//  Created by xk on 2025/07/20.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "HomeHeaderView.h"

@interface HomeHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *featureContainerView;

@end

@implementation HomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 标语标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"借钱不求人  用钱找我们";
    self.titleLabel.font = FONT_BOLD(20);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    // 特色容器
    self.featureContainerView = [[UIView alloc] init];
    [self addSubview:self.featureContainerView];
    
    // 设置约束
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(STATUS_BAR_HEIGHT + 40);
        make.left.right.equalTo(self).inset(20);
    }];
    
    [self.featureContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self).inset(60);
        make.height.mas_equalTo(80);
        make.bottom.equalTo(self).offset(-20);
    }];
}

- (void)updateWithFeatureData:(NSArray *)featureData {
    self.featureData = featureData;
    
    // 清除之前的特色视图
    for (UIView *subview in self.featureContainerView.subviews) {
        [subview removeFromSuperview];
    }
    
    // 创建特色视图
    UIView *previousView = nil;
    for (NSInteger i = 0; i < featureData.count; i++) {
        NSDictionary *feature = featureData[i];
        UIView *featureView = [self createFeatureViewWithData:feature];
        [self.featureContainerView addSubview:featureView];
        
        [featureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.featureContainerView);
            make.width.equalTo(self.featureContainerView).multipliedBy(1.0/featureData.count);
            if (previousView) {
                make.left.equalTo(previousView.mas_right);
            } else {
                make.left.equalTo(self.featureContainerView);
            }
        }];
        
        previousView = featureView;
    }
}

- (UIView *)createFeatureViewWithData:(NSDictionary *)data {
    UIView *featureView = [[UIView alloc] init];
    
    // 图标
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:data[@"icon"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [featureView addSubview:iconView];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = data[@"title"];
    titleLabel.font = FONT_MEDIUM(14);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [featureView addSubview:titleLabel];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(featureView);
        make.top.equalTo(featureView).offset(10);
        make.width.height.mas_equalTo(36);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(featureView);
        make.top.equalTo(iconView.mas_bottom).offset(8);
        make.left.right.equalTo(featureView).inset(5);
    }];
    
    return featureView;
}

@end 
