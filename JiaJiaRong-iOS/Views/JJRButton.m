//
//  JJRButton.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRButton.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import <pop/pop.h>

@interface JJRButton ()

@property (nonatomic, assign) JJRButtonType jjrButtonType;
@property (nonatomic, assign) JJRButtonSize buttonSize;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, copy) void(^clickAction)(JJRButton *button);
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger countdownSeconds;
@property (nonatomic, strong) NSString *originalTitle;

@end

@implementation JJRButton

- (instancetype)initWithType:(JJRButtonType)type {
    return [self initWithType:type size:JJRButtonSizeMedium];
}

- (instancetype)initWithType:(JJRButtonType)type size:(JJRButtonSize)size {
    self = [super init];
    if (self) {
        self.jjrButtonType = type;
        self.buttonSize = size;
        [self setupUI];
        [self setupConstraints];
        [self setupButtonType:type];
        [self setupButtonSize:size];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title type:(JJRButtonType)type {
    self = [self initWithType:type];
    if (self) {
        [self setTitle:title];
    }
    return self;
}

- (void)setupUI {
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingIndicator.hidesWhenStopped = YES;
    [self addSubview:self.loadingIndicator];
    
    // 加载文字
    self.loadingLabel = [[UILabel alloc] init];
    self.loadingLabel.font = [UIFont systemFontOfSize:14];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.loadingLabel];
    
    // 添加点击事件
    [self addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraints {
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loadingIndicator.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
}

- (void)setupButtonType:(JJRButtonType)type {
    switch (type) {
        case JJRButtonTypePrimary:
            [self setBackgroundColor:[UIColor colorWithHexString:@"#007AFF"] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor colorWithHexString:@"#0056CC"] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
            
        case JJRButtonTypeSecondary:
            [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor colorWithHexString:@"#F2F2F2"] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor colorWithHexString:@"#007AFF"] forState:UIControlStateNormal];
            self.layer.borderWidth = 1;
            self.layer.borderColor = [UIColor colorWithHexString:@"#007AFF"].CGColor;
            break;
            
        case JJRButtonTypeDanger:
            [self setBackgroundColor:[UIColor colorWithHexString:@"#FF3B30"] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor colorWithHexString:@"#CC2E26"] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
            
        case JJRButtonTypeSuccess:
            [self setBackgroundColor:[UIColor colorWithHexString:@"#34C759"] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor colorWithHexString:@"#2AA44C"] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
            
        case JJRButtonTypeWarning:
            [self setBackgroundColor:[UIColor colorWithHexString:@"#FF9500"] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor colorWithHexString:@"#CC7700"] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
            
        case JJRButtonTypeText:
            [self setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
            [self setBackgroundColor:[UIColor colorWithHexString:@"#F2F2F2"] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor colorWithHexString:@"#007AFF"] forState:UIControlStateNormal];
            break;
    }
}

- (void)setupButtonSize:(JJRButtonSize)size {
    switch (size) {
        case JJRButtonSizeSmall:
            self.titleLabel.font = [UIFont systemFontOfSize:12];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(32);
            }];
            break;
            
        case JJRButtonSizeMedium:
            self.titleLabel.font = [UIFont systemFontOfSize:16];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
            break;
            
        case JJRButtonSizeLarge:
            self.titleLabel.font = [UIFont systemFontOfSize:18];
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(56);
            }];
            break;
    }
}

#pragma mark - Public Methods
- (void)setJjrButtonType:(JJRButtonType)jjrButtonType {
    _jjrButtonType = jjrButtonType;
    [self setupButtonType:jjrButtonType];
}


- (void)setButtonSize:(JJRButtonSize)size {
    _buttonSize = size;
    [self setupButtonSize:size];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title forState:UIControlStateNormal];
    self.originalTitle = title;
}

- (void)setImage:(UIImage *)image {
    [super setImage:image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image {
    [self setTitle:title];
    [self setImage:image];
}

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[self imageWithColor:color] forState:state];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    [super setTitleColor:color forState:state];
}

- (void)setLoading:(BOOL)loading {
    [self setLoading:loading title:nil];
}

- (void)setLoading:(BOOL)loading title:(NSString *)title {
    if (loading) {
        self.enabled = NO;
        self.loadingIndicator.hidden = NO;
        self.loadingLabel.hidden = NO;
        [self.loadingIndicator startAnimating];
        
        if (title) {
            self.loadingLabel.text = title;
        } else {
            self.loadingLabel.text = @"加载中...";
        }
        
        // 隐藏原始标题
        [self setTitle:@"" forState:UIControlStateNormal];
    } else {
        self.enabled = YES;
        self.loadingIndicator.hidden = YES;
        self.loadingLabel.hidden = YES;
        [self.loadingIndicator stopAnimating];
        
        // 恢复原始标题
        if (self.originalTitle) {
            [self setTitle:self.originalTitle forState:UIControlStateNormal];
        }
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.alpha = enabled ? 1.0 : 0.5;
}

- (void)setGradientColors:(NSArray<UIColor *> *)colors direction:(JJRGradientDirection)direction {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    // 转换UIColor数组为CGColor数组
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    gradientLayer.colors = cgColors;
    
    // 根据方向设置渐变起点和终点
    switch (direction) {
        case JJRGradientDirectionHorizontal:
            gradientLayer.startPoint = CGPointMake(0, 0.5);
            gradientLayer.endPoint = CGPointMake(1, 0.5);
            break;
        case JJRGradientDirectionVertical:
            gradientLayer.startPoint = CGPointMake(0.5, 0);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
            break;
        case JJRGradientDirectionDiagonalUp:
            gradientLayer.startPoint = CGPointMake(0, 1);
            gradientLayer.endPoint = CGPointMake(1, 0);
            break;
        case JJRGradientDirectionDiagonalDown:
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 1);
            break;
    }
    
    [self.layer insertSublayer:gradientLayer atIndex:0];

}

- (void)setCornerRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setClickEffect:(BOOL)enabled {
    if (enabled) {
        [self addTarget:self action:@selector(buttonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(buttonTouchUp) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    }
}

- (void)startCountdown:(NSInteger)seconds title:(NSString *)title {
    self.countdownSeconds = seconds;
    self.originalTitle = title ?: [self titleForState:UIControlStateNormal];
    [self setEnabled:NO];
    [self updateCountdownDisplay];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

- (void)stopCountdown {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    [self setEnabled:YES];
    if (self.originalTitle) {
        [self setTitle:self.originalTitle forState:UIControlStateNormal];
    }
}

#pragma mark - Private Methods

- (void)buttonTapped {
    if (self.clickAction) {
        self.clickAction(self);
    }
}

- (void)buttonTouchDown {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95, 0.95)];
    scaleAnimation.springBounciness = 10;
    [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)buttonTouchUp {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.springBounciness = 10;
    [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)updateCountdown {
    self.countdownSeconds--;
    if (self.countdownSeconds <= 0) {
        [self stopCountdown];
    } else {
        [self updateCountdownDisplay];
    }
}

- (void)updateCountdownDisplay {
    [self setTitle:[NSString stringWithFormat:@"%@(%lds)", self.originalTitle, (long)self.countdownSeconds] forState:UIControlStateNormal];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end 
