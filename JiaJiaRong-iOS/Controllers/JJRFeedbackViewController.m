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
#import "JJRToastTool.h"
#import <Masonry/Masonry.h>

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
    self.title = @"问题反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.feedbackView = [[JJRFeedbackView alloc] init];
    [self.view addSubview:self.feedbackView];
    
    __weak typeof(self) weakSelf = self;
    self.feedbackView.submitFeedbackBlock = ^(NSString *content) {
        [weakSelf submitFeedback:content];
    };
}

- (void)setupConstraints {
    [self.feedbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)submitFeedback:(NSString *)content {
    if (!content || content.length == 0) {
        [JJRToastTool showToast:@"请输入意见或反馈" inView:self.view];
        return;
    }
    
    NSDictionary *params = @{
        @"content": content
    };
    
    [[JJRNetworkService sharedInstance] submitOpinionWithParams:params success:^(id responseObject) {
        [JJRToastTool showSuccess:@"提交成功" inView:self.view];
        [self.feedbackView clearContent];
        
        // 延迟0.5秒后返回上一页
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [JJRToastTool showError:@"提交失败，请稍后再试" inView:self.view];
    }];
}

@end 
