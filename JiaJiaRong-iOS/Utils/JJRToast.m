//
//  JJRToast.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRToast.h"

@interface JJRToastView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NSTimer *hideTimer;

- (void)showWithTitle:(NSString *)title 
                 icon:(NSString * _Nullable)icon 
             duration:(NSTimeInterval)duration;

@end

@implementation JJRToastView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 与 uni-app 一致的样式：半透明黑色背景，圆角
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.layer.cornerRadius = 6.0;
    self.layer.masksToBounds = YES;
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    // 标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 12.0;
    CGFloat iconSize = 20.0;
    CGFloat maxWidth = self.frame.size.width - padding * 2;
    
    if (self.iconImageView.image) {
        // 有图标时的布局
        self.iconImageView.frame = CGRectMake(padding, padding, iconSize, iconSize);
        
        CGFloat labelX = padding + iconSize + 8.0;
        CGFloat labelWidth = maxWidth - iconSize - 8.0;
        
        CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(labelX, 
                                         (self.frame.size.height - labelSize.height) / 2,
                                         labelWidth, 
                                         labelSize.height);
    } else {
        // 无图标时的布局
        CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(padding,
                                         (self.frame.size.height - labelSize.height) / 2,
                                         maxWidth,
                                         labelSize.height);
    }
}

- (void)showWithTitle:(NSString *)title 
                 icon:(NSString * _Nullable)icon 
             duration:(NSTimeInterval)duration {
    
    self.titleLabel.text = title;
    
    // 设置图标
    if ([icon isEqualToString:@"success"]) {
        self.iconImageView.image = [self createSuccessIcon];
    } else if ([icon isEqualToString:@"error"]) {
        self.iconImageView.image = [self createErrorIcon];
    } else if ([icon isEqualToString:@"warning"]) {
        self.iconImageView.image = [self createWarningIcon];
    } else {
        self.iconImageView.image = nil;
    }
    
    // 计算合适的尺寸
    CGFloat padding = 12.0;
    CGFloat iconSize = 20.0;
    CGFloat maxWidth = 280.0;
    
    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(maxWidth - padding * 2, CGFLOAT_MAX)];
    
    CGFloat toastWidth, toastHeight;
    if (self.iconImageView.image) {
        toastWidth = MIN(labelSize.width + iconSize + 8.0 + padding * 2, maxWidth);
        toastHeight = MAX(labelSize.height, iconSize) + padding * 2;
    } else {
        toastWidth = MIN(labelSize.width + padding * 2, maxWidth);
        toastHeight = labelSize.height + padding * 2;
    }
    
    self.frame = CGRectMake(0, 0, toastWidth, toastHeight);
    [self setNeedsLayout];
    
    // 设置定时器
    if (self.hideTimer) {
        [self.hideTimer invalidate];
    }
    
    if (duration > 0) {
        self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:duration 
                                                          target:self 
                                                        selector:@selector(hide) 
                                                        userInfo:nil 
                                                         repeats:NO];
    }
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Icon Creation

- (UIImage *)createSuccessIcon {
    CGSize size = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, 4, 10);
    CGContextAddLineToPoint(context, 8, 14);
    CGContextAddLineToPoint(context, 16, 6);
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)createErrorIcon {
    CGSize size = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    CGContextMoveToPoint(context, 6, 6);
    CGContextAddLineToPoint(context, 14, 14);
    CGContextMoveToPoint(context, 14, 6);
    CGContextAddLineToPoint(context, 6, 14);
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)createWarningIcon {
    CGSize size = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextMoveToPoint(context, 10, 3);
    CGContextAddLineToPoint(context, 17, 17);
    CGContextAddLineToPoint(context, 3, 17);
    CGContextClosePath(context);
    
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(9, 5, 2, 2));
    CGContextFillRect(context, CGRectMake(9, 9, 2, 6));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation JJRToast

static JJRToastView *currentToast = nil;

+ (void)showToast:(NSString *)title {
    [self showToast:title icon:@"none" duration:2.0];
}

+ (void)showToast:(NSString *)title 
             icon:(NSString * _Nullable)icon 
         duration:(NSTimeInterval)duration {
    
    // 隐藏当前 Toast
    [self hideToast];
    
    // 获取主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows firstObject];
    }
    
    if (!window) {
        return;
    }
    
    // 创建新的 Toast
    JJRToastView *toast = [[JJRToastView alloc] init];
    [toast showWithTitle:title icon:icon duration:duration];
    
    // 设置位置（屏幕中央，与 uni-app 一致）
    CGFloat screenWidth = window.frame.size.width;
    CGFloat screenHeight = window.frame.size.height;
    
    toast.center = CGPointMake(screenWidth / 2, screenHeight / 2);
    toast.alpha = 0.0;
    toast.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    [window addSubview:toast];
    currentToast = toast;
    
    // 显示动画
    [UIView animateWithDuration:0.3 animations:^{
        toast.alpha = 1.0;
        toast.transform = CGAffineTransformIdentity;
    }];
}

+ (void)showSuccess:(NSString *)title {
    [self showToast:title icon:@"success" duration:2.0];
}

+ (void)showError:(NSString *)title {
    [self showToast:title icon:@"error" duration:2.0];
}

+ (void)showWarning:(NSString *)title {
    [self showToast:title icon:@"warning" duration:2.0];
}

+ (void)hideToast {
    if (currentToast) {
        [currentToast hide];
        currentToast = nil;
    }
}

@end 