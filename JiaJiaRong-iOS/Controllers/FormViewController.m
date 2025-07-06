#import "FormViewController.h"
#import "NetworkService.h"
#import "JJRUserManager.h"
#import <Masonry/Masonry.h>
#import "CityPickerViewController.h"
#import "IDCardViewController.h"

@interface FormViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *stepsView;
@property (nonatomic, strong) UIView *citySelectionView;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UITableView *formTableView;
@property (nonatomic, strong) UIView *amountView;
@property (nonatomic, strong) UITextField *amountTextField;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *idCardPopupButton;
@property (nonatomic, strong) UIView *idCardPopupView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *idNumberTextField;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) NSArray *formFields;
@property (nonatomic, strong) NSMutableDictionary *formData;
@property (nonatomic, strong) NSMutableDictionary *selectedOptions;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSArray *hotCities;

@end

@implementation FormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadFormData];
    [self requestLocationPermission];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.title = @"填写表单";
    
    // 初始化数据
    self.formData = [NSMutableDictionary dictionary];
    self.selectedOptions = [NSMutableDictionary dictionary];
    self.cityName = @"请选择城市";
    
    // 创建滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    // 创建内容视图
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    
    // 使用Masonry设置约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self setupStepsView];
    [self setupCitySelection];
    [self setupTipView];
    [self setupFormTableView];
    [self setupAmountView];
    [self setupNextButton];
    [self setupIDCardPopup];
}

- (void)setupStepsView {
    self.stepsView = [[UIView alloc] init];
    self.stepsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.stepsView];
    
    // 步骤1图标
    UIImageView *step1Image = [[UIImageView alloc] init];
    step1Image.translatesAutoresizingMaskIntoConstraints = NO;
    step1Image.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    step1Image.layer.cornerRadius = 49;
    [self.stepsView addSubview:step1Image];
    
    // 连接线
    UIView *lineView = [[UIView alloc] init];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.backgroundColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    [self.stepsView addSubview:lineView];
    
    // 步骤2图标
    UIImageView *step2Image = [[UIImageView alloc] init];
    step2Image.translatesAutoresizingMaskIntoConstraints = NO;
    step2Image.backgroundColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1.0];
    step2Image.layer.cornerRadius = 49;
    [self.stepsView addSubview:step2Image];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.stepsView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:50],
        [self.stepsView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.stepsView.heightAnchor constraintEqualToConstant:98],
        
        [step1Image.leadingAnchor constraintEqualToAnchor:self.stepsView.leadingAnchor],
        [step1Image.centerYAnchor constraintEqualToAnchor:self.stepsView.centerYAnchor],
        [step1Image.widthAnchor constraintEqualToConstant:98],
        [step1Image.heightAnchor constraintEqualToConstant:98],
        
        [lineView.leadingAnchor constraintEqualToAnchor:step1Image.trailingAnchor constant:10],
        [lineView.centerYAnchor constraintEqualToAnchor:self.stepsView.centerYAnchor],
        [lineView.widthAnchor constraintEqualToConstant:280],
        [lineView.heightAnchor constraintEqualToConstant:2],
        
        [step2Image.leadingAnchor constraintEqualToAnchor:lineView.trailingAnchor constant:10],
        [step2Image.centerYAnchor constraintEqualToAnchor:self.stepsView.centerYAnchor],
        [step2Image.widthAnchor constraintEqualToConstant:98],
        [step2Image.heightAnchor constraintEqualToConstant:98],
        [step2Image.trailingAnchor constraintEqualToAnchor:self.stepsView.trailingAnchor]
    ]];
}

- (void)setupCitySelection {
    self.citySelectionView = [[UIView alloc] init];
    self.citySelectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.citySelectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.citySelectionView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"所在城市";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    [self.citySelectionView addSubview:titleLabel];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.cityLabel.text = self.cityName;
    self.cityLabel.font = [UIFont systemFontOfSize:14];
    self.cityLabel.textColor = [UIColor blackColor];
    [self.citySelectionView addSubview:self.cityLabel];
    
    UIImageView *arrowImage = [[UIImageView alloc] init];
    arrowImage.translatesAutoresizingMaskIntoConstraints = NO;
    arrowImage.image = [UIImage imageNamed:@"go_back"];
    arrowImage.tintColor = [UIColor grayColor];
    [self.citySelectionView addSubview:arrowImage];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(citySelectionTapped)];
    [self.citySelectionView addGestureRecognizer:tapGesture];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.citySelectionView.topAnchor constraintEqualToAnchor:self.stepsView.bottomAnchor constant:24],
        [self.citySelectionView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.citySelectionView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.citySelectionView.heightAnchor constraintEqualToConstant:56],
        
        [titleLabel.leadingAnchor constraintEqualToAnchor:self.citySelectionView.leadingAnchor constant:30],
        [titleLabel.centerYAnchor constraintEqualToAnchor:self.citySelectionView.centerYAnchor],
        
        [self.cityLabel.trailingAnchor constraintEqualToAnchor:arrowImage.leadingAnchor constant:-10],
        [self.cityLabel.centerYAnchor constraintEqualToAnchor:self.citySelectionView.centerYAnchor],
        
        [arrowImage.trailingAnchor constraintEqualToAnchor:self.citySelectionView.trailingAnchor constant:-30],
        [arrowImage.centerYAnchor constraintEqualToAnchor:self.citySelectionView.centerYAnchor],
        [arrowImage.widthAnchor constraintEqualToConstant:14],
        [arrowImage.heightAnchor constraintEqualToConstant:14]
    ]];
}

- (void)setupTipView {
    self.tipView = [[UIView alloc] init];
    self.tipView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.tipView];
    
    UIImageView *infoIcon = [[UIImageView alloc] init];
    infoIcon.translatesAutoresizingMaskIntoConstraints = NO;
    infoIcon.image = [UIImage systemImageNamed:@"info.circle.fill"];
    infoIcon.tintColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.tipView addSubview:infoIcon];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    tipLabel.text = @"输入正确的城市，更有利于下款";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.tipView addSubview:tipLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tipView.topAnchor constraintEqualToAnchor:self.citySelectionView.bottomAnchor],
        [self.tipView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30],
        [self.tipView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-30],
        [self.tipView.heightAnchor constraintEqualToConstant:40],
        
        [infoIcon.leadingAnchor constraintEqualToAnchor:self.tipView.leadingAnchor],
        [infoIcon.centerYAnchor constraintEqualToAnchor:self.tipView.centerYAnchor],
        [infoIcon.widthAnchor constraintEqualToConstant:14],
        [infoIcon.heightAnchor constraintEqualToConstant:14],
        
        [tipLabel.leadingAnchor constraintEqualToAnchor:infoIcon.trailingAnchor constant:6],
        [tipLabel.centerYAnchor constraintEqualToAnchor:self.tipView.centerYAnchor]
    ]];
}

- (void)setupFormTableView {
    self.formTableView = [[UITableView alloc] init];
    self.formTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.formTableView.delegate = self;
    self.formTableView.dataSource = self;
    self.formTableView.backgroundColor = [UIColor whiteColor];
    self.formTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.formTableView.scrollEnabled = NO;
    [self.contentView addSubview:self.formTableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.formTableView.topAnchor constraintEqualToAnchor:self.tipView.bottomAnchor],
        [self.formTableView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.formTableView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.formTableView.heightAnchor constraintEqualToConstant:400]
    ]];
}

- (void)setupAmountView {
    self.amountView = [[UIView alloc] init];
    self.amountView.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.amountView];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    amountLabel.text = @"贷款金额";
    amountLabel.font = [UIFont systemFontOfSize:15];
    amountLabel.textColor = [UIColor colorWithRed:48.0/255.0 green:49.0/255.0 blue:51.0/255.0 alpha:1.0];
    [self.amountView addSubview:amountLabel];
    
    self.amountTextField = [[UITextField alloc] init];
    self.amountTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.placeholder = @"请输入贷款金额";
    self.amountTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.amountTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.amountView addSubview:self.amountTextField];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.amountView.topAnchor constraintEqualToAnchor:self.formTableView.bottomAnchor],
        [self.amountView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.amountView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.amountView.heightAnchor constraintEqualToConstant:60],
        
        [amountLabel.leadingAnchor constraintEqualToAnchor:self.amountView.leadingAnchor constant:30],
        [amountLabel.centerYAnchor constraintEqualToAnchor:self.amountView.centerYAnchor],
        [amountLabel.widthAnchor constraintEqualToConstant:80],
        
        [self.amountTextField.leadingAnchor constraintEqualToAnchor:amountLabel.trailingAnchor constant:20],
        [self.amountTextField.trailingAnchor constraintEqualToAnchor:self.amountView.trailingAnchor constant:-30],
        [self.amountTextField.centerYAnchor constraintEqualToAnchor:self.amountView.centerYAnchor],
        [self.amountTextField.heightAnchor constraintEqualToConstant:40]
    ]];
}

- (void)setupNextButton {
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.nextButton.layer.cornerRadius = 25;
    [self.nextButton addTarget:self action:@selector(nextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.nextButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.nextButton.topAnchor constraintEqualToAnchor:self.amountView.bottomAnchor constant:32],
        [self.nextButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:32],
        [self.nextButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-32],
        [self.nextButton.heightAnchor constraintEqualToConstant:46],
        [self.nextButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-30]
    ]];
}

- (void)setupIDCardPopup {
    self.idCardPopupView = [[UIView alloc] init];
    self.idCardPopupView.translatesAutoresizingMaskIntoConstraints = NO;
    self.idCardPopupView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.idCardPopupView.hidden = YES;
    [self.view addSubview:self.idCardPopupView];
    
    UIView *popupContent = [[UIView alloc] init];
    popupContent.translatesAutoresizingMaskIntoConstraints = NO;
    popupContent.backgroundColor = [UIColor whiteColor];
    popupContent.layer.cornerRadius = 12;
    [self.idCardPopupView addSubview:popupContent];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"恭喜你，已经完成90%的认证步骤";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [popupContent addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subtitleLabel.text = @"完成最后的认证，即可获得了解获取到贷款额度";
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.textColor = [UIColor grayColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 0;
    [popupContent addSubview:subtitleLabel];
    
    // 姓名输入框
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameTextField.placeholder = @"请输入您的姓名";
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [popupContent addSubview:self.nameTextField];
    
    // 身份证号输入框
    self.idNumberTextField = [[UITextField alloc] init];
    self.idNumberTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.idNumberTextField.placeholder = @"请输入身份证号";
    self.idNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    [popupContent addSubview:self.idNumberTextField];
    
    // 提示信息
    UIView *tipContainer = [[UIView alloc] init];
    tipContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [popupContent addSubview:tipContainer];
    
    UIImageView *tipIcon = [[UIImageView alloc] init];
    tipIcon.translatesAutoresizingMaskIntoConstraints = NO;
    tipIcon.image = [UIImage systemImageNamed:@"info.circle.fill"];
    tipIcon.tintColor = [UIColor colorWithRed:255.0/255.0 green:119.0/255.0 blue:44.0/255.0 alpha:1.0];
    [tipContainer addSubview:tipIcon];
    
    UILabel *tipText = [[UILabel alloc] init];
    tipText.translatesAutoresizingMaskIntoConstraints = NO;
    tipText.text = @"国家级数据加密保护，仅用于贷款审核";
    tipText.font = [UIFont systemFontOfSize:12];
    tipText.textColor = [UIColor colorWithRed:255.0/255.0 green:119.0/255.0 blue:44.0/255.0 alpha:1.0];
    [tipContainer addSubview:tipText];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.submitButton setTitle:@"立即提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:79.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.submitButton.layer.cornerRadius = 25;
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [popupContent addSubview:self.submitButton];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton setTitle:@"✕" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [closeButton addTarget:self action:@selector(closeIDCardPopup) forControlEvents:UIControlEventTouchUpInside];
    [popupContent addSubview:closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.idCardPopupView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.idCardPopupView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.idCardPopupView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.idCardPopupView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [popupContent.centerXAnchor constraintEqualToAnchor:self.idCardPopupView.centerXAnchor],
        [popupContent.centerYAnchor constraintEqualToAnchor:self.idCardPopupView.centerYAnchor],
        [popupContent.widthAnchor constraintEqualToConstant:300],
        [popupContent.heightAnchor constraintEqualToConstant:400],
        
        [closeButton.topAnchor constraintEqualToAnchor:popupContent.topAnchor constant:10],
        [closeButton.trailingAnchor constraintEqualToAnchor:popupContent.trailingAnchor constant:-10],
        [closeButton.widthAnchor constraintEqualToConstant:30],
        [closeButton.heightAnchor constraintEqualToConstant:30],
        
        [titleLabel.topAnchor constraintEqualToAnchor:popupContent.topAnchor constant:40],
        [titleLabel.leadingAnchor constraintEqualToAnchor:popupContent.leadingAnchor constant:20],
        [titleLabel.trailingAnchor constraintEqualToAnchor:popupContent.trailingAnchor constant:-20],
        
        [subtitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
        [subtitleLabel.leadingAnchor constraintEqualToAnchor:popupContent.leadingAnchor constant:20],
        [subtitleLabel.trailingAnchor constraintEqualToAnchor:popupContent.trailingAnchor constant:-20],
        
        [self.nameTextField.topAnchor constraintEqualToAnchor:subtitleLabel.bottomAnchor constant:30],
        [self.nameTextField.leadingAnchor constraintEqualToAnchor:popupContent.leadingAnchor constant:20],
        [self.nameTextField.trailingAnchor constraintEqualToAnchor:popupContent.trailingAnchor constant:-20],
        [self.nameTextField.heightAnchor constraintEqualToConstant:40],
        
        [self.idNumberTextField.topAnchor constraintEqualToAnchor:self.nameTextField.bottomAnchor constant:15],
        [self.idNumberTextField.leadingAnchor constraintEqualToAnchor:popupContent.leadingAnchor constant:20],
        [self.idNumberTextField.trailingAnchor constraintEqualToAnchor:popupContent.trailingAnchor constant:-20],
        [self.idNumberTextField.heightAnchor constraintEqualToConstant:40],
        
        [tipContainer.topAnchor constraintEqualToAnchor:self.idNumberTextField.bottomAnchor constant:15],
        [tipContainer.leadingAnchor constraintEqualToAnchor:popupContent.leadingAnchor constant:20],
        [tipContainer.trailingAnchor constraintEqualToAnchor:popupContent.trailingAnchor constant:-20],
        [tipContainer.heightAnchor constraintEqualToConstant:30],
        
        [tipIcon.leadingAnchor constraintEqualToAnchor:tipContainer.leadingAnchor],
        [tipIcon.centerYAnchor constraintEqualToAnchor:tipContainer.centerYAnchor],
        [tipIcon.widthAnchor constraintEqualToConstant:14],
        [tipIcon.heightAnchor constraintEqualToConstant:14],
        
        [tipText.leadingAnchor constraintEqualToAnchor:tipIcon.trailingAnchor constant:6],
        [tipText.centerYAnchor constraintEqualToAnchor:tipContainer.centerYAnchor],
        
        [self.submitButton.topAnchor constraintEqualToAnchor:tipContainer.bottomAnchor constant:30],
        [self.submitButton.leadingAnchor constraintEqualToAnchor:popupContent.leadingAnchor constant:20],
        [self.submitButton.trailingAnchor constraintEqualToAnchor:popupContent.trailingAnchor constant:-20],
        [self.submitButton.heightAnchor constraintEqualToConstant:50],
        [self.submitButton.bottomAnchor constraintEqualToAnchor:popupContent.bottomAnchor constant:-20]
    ]];
}

#pragma mark - Data Loading

- (void)loadFormData {
    NSString *platform = [[UIDevice currentDevice] systemName];
    NSString *ostype = [platform isEqualToString:@"iPhone OS"] ? @"ios" : @"android";
    
    NSDictionary *params = @{@"ostype": ostype};
    
    [[NetworkService sharedInstance] POST:@"/app/form/field" 
                                   params:params 
                                 success:^(NSDictionary *response) {
        NSMutableArray *fields = [NSMutableArray arrayWithArray:response[@"data"]];
        
        // 添加贷款期限选项
        NSDictionary *stageField = @{
            @"conditionList": @[
                @{@"key": @"3", @"name": @"3期"},
                @{@"key": @"6", @"name": @"6期"},
                @{@"key": @"12", @"name": @"12期"},
                @{@"key": @"24", @"name": @"24期"},
                @{@"key": @"36", @"name": @"36期"}
            ],
            @"field": @"stageNum",
            @"fieldName": @"贷款期限"
        };
        
        // 添加贷款金额字段
        NSDictionary *amountField = @{
            @"field": @"loanAmount",
            @"fieldName": @"贷款金额"
        };
        
        [fields addObject:stageField];
        [fields addObject:amountField];
        
        self.formFields = [fields copy];
        
        // 初始化表单数据
        for (NSDictionary *field in self.formFields) {
            NSString *fieldName = field[@"field"];
            self.formData[fieldName] = @"";
            self.selectedOptions[fieldName] = @{};
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.formTableView reloadData];
        });
    } failure:^(NSError *error) {
        NSLog(@"加载表单数据失败: %@", error);
    }];
}

- (void)requestLocationPermission {
    // 检查定位权限
    BOOL isLocationStore = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLocationStore"];
    if (!isLocationStore) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLocationStore"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAlert:@"佳佳融对定位权限申请说明：便于您使用该功能用于获取定位信息以及认证表单填写的功能。"];
        });
    }
    
    [self getCurrentLocation];
}

- (void)getCurrentLocation {
    // 这里需要集成定位服务，暂时使用模拟数据
    self.cityName = @"北京市";
    self.cityCode = @"110000";
    self.cityLabel.text = self.cityName;
    self.formData[@"cityCode"] = self.cityCode;
}

#pragma mark - Actions

- (void)citySelectionTapped {
    [[NetworkService sharedInstance] POST:@"/app/form/city/hot" 
                                   params:@{} 
                                 success:^(NSDictionary *response) {
        self.hotCities = response[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showCityPicker];
        });
    } failure:^(NSError *error) {
        NSLog(@"获取热门城市失败: %@", error);
    }];
}

- (void)showCityPicker {
    CityPickerViewController *cityPicker = [[CityPickerViewController alloc] init];
    cityPicker.hotCities = self.hotCities;
    cityPicker.modalPresentationStyle = UIModalPresentationPageSheet;
    
    __weak typeof(self) weakSelf = self;
    cityPicker.citySelectedBlock = ^(NSString *cityName, NSString *cityCode) {
        weakSelf.cityName = cityName;
        weakSelf.cityCode = cityCode;
        weakSelf.cityLabel.text = cityName;
        weakSelf.formData[@"cityCode"] = cityCode;
    };
    
    [self presentViewController:cityPicker animated:YES completion:nil];
}

- (void)nextButtonTapped {
    // 验证表单
    if (!self.formData[@"cityCode"]) {
        [self showAlert:@"请填写城市"];
        return;
    }
    
    for (NSDictionary *field in self.formFields) {
        NSString *fieldName = field[@"field"];
        if (!self.formData[fieldName] || [self.formData[fieldName] length] == 0) {
            [self showAlert:[NSString stringWithFormat:@"%@不能为空", field[@"fieldName"]]];
            return;
        }
    }
    
    NSString *amount = self.amountTextField.text;
    if (amount.length > 0) {
        NSInteger amountValue = [amount integerValue];
        if (amountValue < 10000) {
            [self showAlert:@"贷款金额最低1万起"];
            return;
        }
        if (amountValue > 200000) {
            [self showAlert:@"贷款金额不能超过20万"];
            return;
        }
        self.formData[@"loanAmount"] = amount;
    }
    
    // 显示身份证弹窗
    self.idCardPopupView.hidden = NO;
}

- (void)submitButtonTapped {
    // 验证身份证信息
    if (!self.nameTextField.text || self.nameTextField.text.length == 0) {
        [self showAlert:@"请填写正确的姓名"];
        return;
    }
    
    if (!self.idNumberTextField.text || self.idNumberTextField.text.length != 18) {
        [self showAlert:@"请填写正确的身份证号码"];
        return;
    }
    
    // 合并表单数据
    NSMutableDictionary *submitData = [NSMutableDictionary dictionaryWithDictionary:self.formData];
    submitData[@"idName"] = self.nameTextField.text;
    submitData[@"idNo"] = self.idNumberTextField.text;
    submitData[@"ios"] = @YES;
    
    [[NetworkService sharedInstance] POST:@"/app/form/apply" 
                                   params:submitData 
                                 success:^(NSDictionary *response) {
        if ([response[@"code"] integerValue] != 0) {
            [self showAlert:response[@"err"][@"msg"]];
            return;
        }
        
        [self showAlert:@"提交成功" completion:^{
            // 更新用户信息（使用JJRUserManager）
            JJRUserManager *userManager = [JJRUserManager sharedManager];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:userManager.userInfo];
            userInfo[@"form"] = @YES;
            [userManager updateUserInfo:userInfo];
            NSLog(@"🎯 FormViewController - 更新用户表单状态");
            
            // 跳转到身份证认证页面
            IDCardViewController *idCardVC = [[IDCardViewController alloc] init];
            idCardVC.hidesBottomBarWhenPushed = YES; // 隐藏tabbar
            [self.navigationController pushViewController:idCardVC animated:YES];
        }];
    } failure:^(NSError *error) {
        [self showAlert:@"提交失败"];
    }];
}

- (void)closeIDCardPopup {
    self.idCardPopupView.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.formFields.count - 1; // 减去贷款金额字段，因为单独处理
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"FormCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *field = self.formFields[indexPath.row];
    cell.textLabel.text = field[@"fieldName"];
    
    NSString *selectedValue = self.selectedOptions[field[@"field"]][@"name"];
    if (selectedValue) {
        cell.detailTextLabel.text = selectedValue;
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"请选择%@", field[@"fieldName"]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *field = self.formFields[indexPath.row];
    [self showOptionsForField:field];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)showOptionsForField:(NSDictionary *)field {
    NSArray *options = field[@"conditionList"];
    if (!options) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:field[@"fieldName"] 
                                                                   message:nil 
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSDictionary *option in options) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:option[@"name"] 
                                                         style:UIAlertActionStyleDefault 
                                                       handler:^(UIAlertAction * _Nonnull action) {
            NSString *fieldName = field[@"field"];
            self.formData[fieldName] = option[@"key"];
            self.selectedOptions[fieldName] = option;
            [self.formTableView reloadData];
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
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
