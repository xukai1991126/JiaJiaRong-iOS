//
//  JJRAboutUsViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/7/5.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAboutUsViewController.h"
#import "JJRAboutUsView.h"
#import <Masonry/Masonry.h>

@interface JJRAboutUsViewController ()

@property (nonatomic, strong) JJRAboutUsView *aboutUsView;

@end

@implementation JJRAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupUI {
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.aboutUsView = [[JJRAboutUsView alloc] init];
    [self.view addSubview:self.aboutUsView];
}

- (void)setupConstraints {
    [self.aboutUsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end 
