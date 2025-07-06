#import "AboutUsViewController.h"
#import <Masonry/Masonry.h>

@interface AboutUsViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"关于我们";
    
    // 滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // Logo
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.image = [UIImage systemImageNamed:@"building.2"];
    self.logoImageView.tintColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.logoImageView];
    
    // 应用名称
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.text = @"家家融";
    self.appNameLabel.font = [UIFont boldSystemFontOfSize:24];
    self.appNameLabel.textColor = [UIColor blackColor];
    self.appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.appNameLabel];
    
    // 版本号
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.text = @"版本 1.0.0";
    self.versionLabel.font = [UIFont systemFontOfSize:14];
    self.versionLabel.textColor = [UIColor lightGrayColor];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.versionLabel];
    
    // 信息视图
    self.infoView = [[UIView alloc] init];
    self.infoView.backgroundColor = [UIColor whiteColor];
    self.infoView.layer.cornerRadius = 12;
    [self.contentView addSubview:self.infoView];
    
    // 应用描述
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.text = @"家家融是一款专业的金融服务应用，致力于为用户提供便捷、安全的借贷服务。我们拥有专业的团队和严格的风控体系，为用户提供优质的金融服务体验。";
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    self.descriptionLabel.textColor = [UIColor blackColor];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    [self.infoView addSubview:self.descriptionLabel];
    
    // 设置约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(60);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appNameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionLabel.mas_bottom).offset(40);
        make.left.right.equalTo(self.contentView).inset(20);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.infoView).inset(20);
        make.bottom.equalTo(self.infoView).offset(-20);
    }];
}

@end 