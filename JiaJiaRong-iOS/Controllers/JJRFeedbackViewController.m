//
//  JJRFeedbackViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRFeedbackViewController.h"
#import "JJRFeedbackView.h"
#import "JJRNetworkService.h"
#import "JJRToast.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

@interface JJRFeedbackViewController ()

@property (nonatomic, strong) JJRFeedbackView *feedbackView;

@end

@implementation JJRFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.feedbackView = [[JJRFeedbackView alloc] init];
    [self.view addSubview:self.feedbackView];
    
    __weak typeof(self) weakSelf = self;
    self.feedbackView.submitFeedbackBlock = ^(NSString *content, NSString *contact) {
        [weakSelf submitFeedback:content contact:contact];
    };
}

- (void)setupConstraints {
    [self.feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)submitFeedback:(NSString *)content contact:(NSString *)contact {
    if (!content || content.length == 0) {
        [JJRToast showToast:@"请输入反馈内容"];
        return;
    }
    
    if (content.length < 10) {
        [JJRToast showToast:@"反馈内容不能少于10个字符"];
        return;
    }
    
    [JJRNetworkService showLoading];
    
    NSDictionary *params = @{
        @"content": content,
        @"contact": contact ?: @""
    };
    
    [[JJRNetworkService sharedInstance] submitFeedbackWithParams:params success:^(id responseObject) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:@"反馈提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [JJRNetworkService hideLoading];
        [JJRToast showToast:error.localizedDescription];
    }];
}

@end 
