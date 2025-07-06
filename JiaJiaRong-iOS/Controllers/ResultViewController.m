#import "ResultViewController.h"
#import "NetworkService.h"
#import "MainTabBarController.h"
#import <Masonry/Masonry.h>

@interface ResultViewController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UILabel *resultTitleLabel;
@property (nonatomic, strong) UILabel *resultSubtitleLabel;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *periodLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) UIButton *homeButton;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadResultData];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"申请结果";
    
    // 隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    
    // 结果图标
    self.resultImageView = [[UIImageView alloc] init];
    self.resultImageView.image = [UIImage systemImageNamed:@"checkmark.circle.fill"];
    self.resultImageView.tintColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.contentView addSubview:self.resultImageView];
    
    // 结果标题
    self.resultTitleLabel = [[UILabel alloc] init];
    self.resultTitleLabel.text = @"申请提交成功";
    self.resultTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.resultTitleLabel.textColor = [UIColor blackColor];
    self.resultTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.resultTitleLabel];
    
    // 结果副标题
    self.resultSubtitleLabel = [[UILabel alloc] init];
    self.resultSubtitleLabel.text = @"我们将在1-3个工作日内完成审核";
    self.resultSubtitleLabel.font = [UIFont systemFontOfSize:14];
    self.resultSubtitleLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    self.resultSubtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.resultSubtitleLabel];
    
    // 信息视图
    self.infoView = [[UIView alloc] init];
    self.infoView.backgroundColor = [UIColor whiteColor];
    self.infoView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.infoView];
    
    // 申请金额
    UIView *amountContainer = [[UIView alloc] init];
    amountContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoView addSubview:amountContainer];
    
    UILabel *amountTitleLabel = [[UILabel alloc] init];
    amountTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    amountTitleLabel.text = @"申请金额";
    amountTitleLabel.font = [UIFont systemFontOfSize:14];
    amountTitleLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    [amountContainer addSubview:amountTitleLabel];
    
    self.amountLabel = [[UILabel alloc] init];
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountLabel.text = @"¥50,000";
    self.amountLabel.font = [UIFont boldSystemFontOfSize:18];
    self.amountLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    [amountContainer addSubview:self.amountLabel];
    
    // 申请期限
    UIView *periodContainer = [[UIView alloc] init];
    periodContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoView addSubview:periodContainer];
    
    UILabel *periodTitleLabel = [[UILabel alloc] init];
    periodTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    periodTitleLabel.text = @"申请期限";
    periodTitleLabel.font = [UIFont systemFontOfSize:14];
    periodTitleLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    [periodContainer addSubview:periodTitleLabel];
    
    self.periodLabel = [[UILabel alloc] init];
    self.periodLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.periodLabel.text = @"12个月";
    self.periodLabel.font = [UIFont boldSystemFontOfSize:16];
    self.periodLabel.textColor = [UIColor blackColor];
    [periodContainer addSubview:self.periodLabel];
    
    // 年化利率
    UIView *rateContainer = [[UIView alloc] init];
    rateContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoView addSubview:rateContainer];
    
    UILabel *rateTitleLabel = [[UILabel alloc] init];
    rateTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    rateTitleLabel.text = @"年化利率";
    rateTitleLabel.font = [UIFont systemFontOfSize:14];
    rateTitleLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    [rateContainer addSubview:rateTitleLabel];
    
    self.rateLabel = [[UILabel alloc] init];
    self.rateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.rateLabel.text = @"12.5%";
    self.rateLabel.font = [UIFont boldSystemFontOfSize:16];
    self.rateLabel.textColor = [UIColor blackColor];
    [rateContainer addSubview:self.rateLabel];
    
    // 立即申请按钮
    self.applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    [self.applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.applyButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.applyButton.layer.cornerRadius = 25;
    [self.applyButton addTarget:self action:@selector(applyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.applyButton];
    
    // 返回首页按钮
    self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.homeButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [self.homeButton setTitleColor:[UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.homeButton.backgroundColor = [UIColor whiteColor];
    self.homeButton.layer.borderColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
    self.homeButton.layer.borderWidth = 1;
    self.homeButton.layer.cornerRadius = 25;
    [self.homeButton addTarget:self action:@selector(homeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.homeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.contentView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [self.resultImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.resultImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:60],
        [self.resultImageView.widthAnchor constraintEqualToConstant:80],
        [self.resultImageView.heightAnchor constraintEqualToConstant:80],
        
        [self.resultTitleLabel.topAnchor constraintEqualToAnchor:self.resultImageView.bottomAnchor constant:20],
        [self.resultTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.resultTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        
        [self.resultSubtitleLabel.topAnchor constraintEqualToAnchor:self.resultTitleLabel.bottomAnchor constant:10],
        [self.resultSubtitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.resultSubtitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        
        [self.infoView.topAnchor constraintEqualToAnchor:self.resultSubtitleLabel.bottomAnchor constant:30],
        [self.infoView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.infoView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        [self.infoView.heightAnchor constraintEqualToConstant:150],
        
        [amountContainer.topAnchor constraintEqualToAnchor:self.infoView.topAnchor constant:20],
        [amountContainer.leadingAnchor constraintEqualToAnchor:self.infoView.leadingAnchor constant:20],
        [amountContainer.trailingAnchor constraintEqualToAnchor:self.infoView.trailingAnchor constant:-20],
        [amountContainer.heightAnchor constraintEqualToConstant:40],
        
        [amountTitleLabel.leadingAnchor constraintEqualToAnchor:amountContainer.leadingAnchor],
        [amountTitleLabel.centerYAnchor constraintEqualToAnchor:amountContainer.centerYAnchor],
        
        [self.amountLabel.trailingAnchor constraintEqualToAnchor:amountContainer.trailingAnchor],
        [self.amountLabel.centerYAnchor constraintEqualToAnchor:amountContainer.centerYAnchor],
        
        [periodContainer.topAnchor constraintEqualToAnchor:amountContainer.bottomAnchor constant:15],
        [periodContainer.leadingAnchor constraintEqualToAnchor:self.infoView.leadingAnchor constant:20],
        [periodContainer.trailingAnchor constraintEqualToAnchor:self.infoView.trailingAnchor constant:-20],
        [periodContainer.heightAnchor constraintEqualToConstant:30],
        
        [periodTitleLabel.leadingAnchor constraintEqualToAnchor:periodContainer.leadingAnchor],
        [periodTitleLabel.centerYAnchor constraintEqualToAnchor:periodContainer.centerYAnchor],
        
        [self.periodLabel.trailingAnchor constraintEqualToAnchor:periodContainer.trailingAnchor],
        [self.periodLabel.centerYAnchor constraintEqualToAnchor:periodContainer.centerYAnchor],
        
        [rateContainer.topAnchor constraintEqualToAnchor:periodContainer.bottomAnchor constant:15],
        [rateContainer.leadingAnchor constraintEqualToAnchor:self.infoView.leadingAnchor constant:20],
        [rateContainer.trailingAnchor constraintEqualToAnchor:self.infoView.trailingAnchor constant:-20],
        [rateContainer.heightAnchor constraintEqualToConstant:30],
        
        [rateTitleLabel.leadingAnchor constraintEqualToAnchor:rateContainer.leadingAnchor],
        [rateTitleLabel.centerYAnchor constraintEqualToAnchor:rateContainer.centerYAnchor],
        
        [self.rateLabel.trailingAnchor constraintEqualToAnchor:rateContainer.trailingAnchor],
        [self.rateLabel.centerYAnchor constraintEqualToAnchor:rateContainer.centerYAnchor],
        
        [self.applyButton.topAnchor constraintEqualToAnchor:self.infoView.bottomAnchor constant:40],
        [self.applyButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.applyButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        [self.applyButton.heightAnchor constraintEqualToConstant:50],
        
        [self.homeButton.topAnchor constraintEqualToAnchor:self.applyButton.bottomAnchor constant:20],
        [self.homeButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.homeButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        [self.homeButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)loadResultData {
    // 加载申请结果数据
    [[NetworkService sharedInstance] GET:@"/app/application/result" 
                                  params:@{} 
                                success:^(NSDictionary *response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithData:response];
        });
    } failure:^(NSError *error) {
        // 使用默认数据
        [self updateUIWithData:@{
            @"amount": @"50000",
            @"period": @"12",
            @"rate": @"12.5"
        }];
    }];
}

- (void)updateUIWithData:(NSDictionary *)data {
    self.amountLabel.text = [NSString stringWithFormat:@"¥%@", data[@"amount"]];
    self.periodLabel.text = [NSString stringWithFormat:@"%@个月", data[@"period"]];
    self.rateLabel.text = [NSString stringWithFormat:@"%@%%", data[@"rate"]];
}

#pragma mark - Actions

- (void)applyButtonTapped {
    // 提交申请
    [[NetworkService sharedInstance] POST:@"/app/application/submit" 
                                   params:@{} 
                                 success:^(NSDictionary *response) {
        [self showAlert:@"申请提交成功" completion:^{
            [self homeButtonTapped];
        }];
    } failure:^(NSError *error) {
        [self showAlert:@"申请提交失败"];
    }];
}

- (void)homeButtonTapped {
    // 返回首页
    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
}

#pragma mark - Helper

- (void)showAlert:(NSString *)message {
    [self showAlert:message completion:nil];
}

- (void)showAlert:(NSString *)message completion:(void(^)(void))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end 