//
//  JJRInputView.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRInputView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "JJREnums.h"
#import <YYKit/YYKit.h>

@interface JJRInputView () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) JJRInputType inputType;
@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);
@property (nonatomic, copy) void(^rightButtonClickBlock)(void);
@property (nonatomic, copy) BOOL(^validationBlock)(NSString *text);

@end

@implementation JJRInputView

- (instancetype)initWithType:(JJRInputType)type {
    self = [super init];
    if (self) {
        self.inputType = type;
        [self setupUI];
        [self setupConstraints];
        [self setupInputType:type];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder type:(JJRInputType)type {
    self = [self initWithType:type];
    if (self) {
        [self setTitle:title];
        [self setPlaceholder:placeholder];
    }
    return self;
}

- (void)setupUI {
    // 标题标签
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:self.titleLabel];
    
    // 输入框
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.textColor = [UIColor colorWithHexString:@"#333333"];
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];
    
    // 底部线条
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    [self addSubview:self.bottomLine];
    
    // 错误提示标签
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.font = [UIFont systemFontOfSize:12];
    self.errorLabel.textColor = [UIColor colorWithHexString:@"#FF3B30"];
    self.errorLabel.hidden = YES;
    [self addSubview:self.errorLabel];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    // 右侧按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightButton];
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.textField);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.equalTo(self.rightButton.mas_left).offset(-8);
        make.height.mas_equalTo(44);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.textField);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).offset(4);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(16);
        make.bottom.equalTo(self);
    }];
}

- (void)setupInputType:(JJRInputType)type {
    switch (type) {
        case JJRInputTypeText:
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.secureTextEntry = NO;
            break;
            
        case JJRInputTypePassword: {
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.secureTextEntry = YES;
            @weakify(self)
            [self setRightButtonTitle:@"显示" action:^{
                @strongify(self)
                [self togglePasswordVisibility];
            }];
        }
            break;
            
        case JJRInputTypePhone:
            self.textField.keyboardType = UIKeyboardTypePhonePad;
            self.textField.secureTextEntry = NO;
            break;
            
        case JJRInputTypeNumber:
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.secureTextEntry = NO;
            break;
            
        case JJRInputTypeEmail:
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
            self.textField.secureTextEntry = NO;
            break;
            
        case JJRInputTypeIDCard:
            self.textField.keyboardType = UIKeyboardTypeASCIICapable;
            self.textField.secureTextEntry = NO;
            break;
            
        case JJRInputTypeBankCard:
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.textField.secureTextEntry = NO;
            break;
        default:
            break;
    }
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setIcon:(UIImage *)icon {
    self.iconImageView.image = icon;
    self.iconImageView.hidden = (icon == nil);
}

- (void)setRightButtonTitle:(NSString *)title action:(void(^)(void))action {
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    self.rightButtonClickBlock = action;
    self.rightButton.hidden = (title == nil);
}

- (void)setRightButtonImage:(UIImage *)image action:(void(^)(void))action {
    [self.rightButton setImage:image forState:UIControlStateNormal];
    self.rightButtonClickBlock = action;
    self.rightButton.hidden = (image == nil);
}

- (void)setErrorText:(NSString *)errorText {
    self.errorLabel.text = errorText;
    self.errorLabel.hidden = (errorText == nil || errorText.length == 0);
    
    if (errorText && errorText.length > 0) {
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#FF3B30"];
    } else {
        self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    }
}

- (void)setEnabled:(BOOL)enabled {
    self.textField.enabled = enabled;
    self.alpha = enabled ? 1.0 : 0.5;
}

- (void)setTextChangeBlock:(void(^)(NSString *text))block {
    self.textChangeBlock = block;
}

- (void)setValidationBlock:(BOOL(^)(NSString *text))block {
    self.validationBlock = block;
}

- (void)setMaxLength:(NSInteger)maxLength {
    if (maxLength > 0) {
        // 添加字符限制
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self.textField];
    }
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.textField.keyboardType = keyboardType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    self.textField.returnKeyType = returnKeyType;
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode {
    self.textField.clearButtonMode = clearButtonMode;
}

- (void)setLeftView:(UIView *)leftView {
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setRightView:(UIView *)rightView {
    self.textField.rightView = rightView;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.textField.backgroundColor = backgroundColor;
}

- (void)setTextColor:(UIColor *)textColor {
    self.textField.textColor = textColor;
}

- (void)setPlaceholderColor:(UIColor *)color {
    [self.textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setFont:(UIFont *)font {
    self.textField.font = font;
}

- (void)setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}

- (void)setBottomLineColor:(UIColor *)color {
    self.bottomLine.backgroundColor = color;
}

- (void)setErrorColor:(UIColor *)color {
    self.errorLabel.textColor = color;
}

- (void)setErrorFont:(UIFont *)font {
    self.errorLabel.font = font;
}

- (void)setRightButtonColor:(UIColor *)color {
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
}

- (void)setRightButtonFont:(UIFont *)font {
    self.rightButton.titleLabel.font = font;
}

- (void)becomeFirstResponder {
    [self.textField becomeFirstResponder];
}

- (void)resignFirstResponder {
    [self.textField resignFirstResponder];
}

- (BOOL)isFirstResponder {
    return [self.textField isFirstResponder];
}

- (void)clearText {
    self.textField.text = @"";
    [self setErrorText:nil];
}

- (BOOL)validate {
    if (self.validationBlock) {
        return self.validationBlock(self.textField.text);
    }
    return YES;
}

#pragma mark - Private Methods

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.textChangeBlock) {
        self.textChangeBlock(textField.text);
    }
    
    // 清除错误提示
    if (self.errorLabel.text.length > 0) {
        [self setErrorText:nil];
    }
}

- (void)rightButtonClicked {
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }
}

- (void)togglePasswordVisibility {
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    NSString *title = self.textField.secureTextEntry ? @"显示" : @"隐藏";
    [self.rightButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputViewShouldBeginEditing:)]) {
        return [self.delegate inputViewShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
    
    if ([self.delegate respondsToSelector:@selector(inputViewDidBeginEditing:)]) {
        [self.delegate inputViewDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputViewShouldEndEditing:)]) {
        return [self.delegate inputViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    
    if ([self.delegate respondsToSelector:@selector(inputViewDidEndEditing:)]) {
        [self.delegate inputViewDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(inputView:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate inputView:self shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputViewShouldClear:)]) {
        return [self.delegate inputViewShouldClear:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputViewShouldReturn:)]) {
        return [self.delegate inputViewShouldReturn:self];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end 
