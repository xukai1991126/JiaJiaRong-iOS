//
//  JJRAICustomerServiceViewController.m
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import "JJRAICustomerServiceViewController.h"
#import <Masonry/Masonry.h>

@interface JJRChatMessage : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, assign) BOOL isFromUser;
@property (nonatomic, assign) BOOL isTyping;
@end

@implementation JJRChatMessage
@end

@interface JJRChatCell : UITableViewCell
@property (nonatomic, strong) JJRChatMessage *message;
@end

@interface JJRAICustomerServiceViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UIView *inputContainer;
@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) NSMutableArray<JJRChatMessage *> *messages;
@property (nonatomic, strong) UIView *quickRepliesView;
@property (nonatomic, strong) NSArray<NSString *> *quickReplies;

@end

@implementation JJRAICustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AI智能客服";
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
    
    [self setupData];
    [self setupUI];
    [self setupConstraints];
    [self setupInitialMessages];
}

- (void)setupData {
    self.messages = [NSMutableArray array];
    self.quickReplies = @[
        @"我想了解贷款产品",
        @"如何申请贷款？",
        @"贷款利率是多少？",
        @"还款方式有哪些？",
        @"申请条件是什么？",
        @"如何提高通过率？"
    ];
}

- (void)setupUI {
    // 聊天列表
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    self.chatTableView.backgroundColor = [UIColor clearColor];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.allowsSelection = NO;
    [self.view addSubview:self.chatTableView];
    
    // 快捷回复
    [self setupQuickRepliesView];
    
    // 输入容器
    self.inputContainer = [[UIView alloc] init];
    self.inputContainer.backgroundColor = [UIColor whiteColor];
    self.inputContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.inputContainer.layer.shadowOffset = CGSizeMake(0, -1);
    self.inputContainer.layer.shadowOpacity = 0.1;
    self.inputContainer.layer.shadowRadius = 2;
    [self.view addSubview:self.inputContainer];
    
    // 输入框
    self.messageTextField = [[UITextField alloc] init];
    self.messageTextField.placeholder = @"请输入您的问题...";
    self.messageTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.messageTextField.delegate = self;
    self.messageTextField.returnKeyType = UIReturnKeySend;
    [self.inputContainer addSubview:self.messageTextField];
    
    // 发送按钮
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0]];
    self.sendButton.layer.cornerRadius = 6;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.inputContainer addSubview:self.sendButton];
}

- (void)setupQuickRepliesView {
    self.quickRepliesView = [[UIView alloc] init];
    self.quickRepliesView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.quickRepliesView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"常见问题";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    [self.quickRepliesView addSubview:titleLabel];
    
    CGFloat buttonWidth = (CGRectGetWidth([UIScreen mainScreen].bounds) - 48) / 2;
    UIView *lastButton = titleLabel;
    
    for (int i = 0; i < self.quickReplies.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.quickReplies[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.borderColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 6;
        button.tag = i;
        [button addTarget:self action:@selector(quickReplyTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.quickRepliesView addSubview:button];
        
        if (i % 2 == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.quickRepliesView).offset(16);
                make.top.equalTo(lastButton.mas_bottom).offset(12);
                make.width.equalTo(@(buttonWidth));
                make.height.equalTo(@36);
            }];
            lastButton = button;
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.quickRepliesView).offset(-16);
                make.top.equalTo(lastButton);
                make.width.equalTo(@(buttonWidth));
                make.height.equalTo(@36);
            }];
        }
    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.quickRepliesView).offset(16);
    }];
}

- (void)setupConstraints {
    [self.quickRepliesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.height.equalTo(@120);
    }];
    
    [self.inputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    
    [self.messageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputContainer).offset(16);
        make.centerY.equalTo(self.inputContainer);
        make.right.equalTo(self.sendButton.mas_left).offset(-12);
        make.height.equalTo(@40);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputContainer).offset(-16);
        make.centerY.equalTo(self.inputContainer);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.quickRepliesView.mas_bottom);
        make.bottom.equalTo(self.inputContainer.mas_top);
    }];
}

- (void)setupInitialMessages {
    JJRChatMessage *welcomeMessage = [[JJRChatMessage alloc] init];
    welcomeMessage.content = @"您好！我是佳佳融智能客服小助手🤖\n\n我可以为您解答：\n• 贷款产品咨询\n• 申请流程指导\n• 还款相关问题\n• 账户操作帮助\n\n请选择下方常见问题或直接输入您的问题~";
    welcomeMessage.timestamp = [NSDate date];
    welcomeMessage.isFromUser = NO;
    [self.messages addObject:welcomeMessage];
    
    [self.chatTableView reloadData];
    [self scrollToBottom];
}

- (void)quickReplyTapped:(UIButton *)sender {
    NSString *question = self.quickReplies[sender.tag];
    [self sendUserMessage:question];
}

- (void)sendMessage {
    NSString *message = [self.messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (message.length == 0) {
        return;
    }
    
    [self sendUserMessage:message];
    self.messageTextField.text = @"";
}

- (void)sendUserMessage:(NSString *)message {
    // 添加用户消息
    JJRChatMessage *userMessage = [[JJRChatMessage alloc] init];
    userMessage.content = message;
    userMessage.timestamp = [NSDate date];
    userMessage.isFromUser = YES;
    [self.messages addObject:userMessage];
    
    // 添加AI正在输入提示
    JJRChatMessage *typingMessage = [[JJRChatMessage alloc] init];
    typingMessage.content = @"AI正在思考中...";
    typingMessage.timestamp = [NSDate date];
    typingMessage.isFromUser = NO;
    typingMessage.isTyping = YES;
    [self.messages addObject:typingMessage];
    
    [self.chatTableView reloadData];
    [self scrollToBottom];
    
    // 模拟AI回复
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.messages removeLastObject]; // 移除typing消息
        
        NSString *aiResponse = [self generateAIResponse:message];
        JJRChatMessage *aiMessage = [[JJRChatMessage alloc] init];
        aiMessage.content = aiResponse;
        aiMessage.timestamp = [NSDate date];
        aiMessage.isFromUser = NO;
        [self.messages addObject:aiMessage];
        
        [self.chatTableView reloadData];
        [self scrollToBottom];
    });
}

- (NSString *)generateAIResponse:(NSString *)userMessage {
    NSString *lowerMessage = [userMessage lowercaseString];
    
    if ([lowerMessage containsString:@"贷款产品"] || [lowerMessage containsString:@"产品"]) {
        return @"我们提供多种贷款产品：\n\n💳 个人消费贷款\n• 额度：1-50万\n• 利率：年化4.5%-18%\n• 期限：3-60个月\n\n🏠 房屋抵押贷款\n• 额度：10-500万\n• 利率：年化3.8%-8%\n• 期限：1-30年\n\n💼 经营贷款\n• 额度：5-1000万\n• 利率：年化4%-15%\n• 期限：6-60个月\n\n您想了解哪种产品呢？";
    }
    
    if ([lowerMessage containsString:@"申请"] || [lowerMessage containsString:@"流程"]) {
        return @"贷款申请流程很简单：\n\n1️⃣ 在线申请\n• 填写基本信息\n• 上传身份证件\n\n2️⃣ 系统审核\n• AI智能评估\n• 人工复核\n\n3️⃣ 签约放款\n• 电子签约\n• 快速到账\n\n整个流程通常1-3个工作日完成。现在就可以在首页开始申请哦！";
    }
    
    if ([lowerMessage containsString:@"利率"] || [lowerMessage containsString:@"费用"]) {
        return @"我们的利率非常有竞争力：\n\n📊 利率范围：\n• 个人消费贷：4.5%-18%\n• 房屋抵押贷：3.8%-8%\n• 经营贷款：4%-15%\n\n✨ 具体利率根据：\n• 个人信用状况\n• 收入水平\n• 抵押物价值\n• 贷款期限\n\n使用我们的AI智能顾问可以获得个性化利率预估！";
    }
    
    if ([lowerMessage containsString:@"还款"] || [lowerMessage containsString:@"方式"]) {
        return @"我们提供灵活的还款方式：\n\n💰 还款方式：\n• 等额本息：月供固定\n• 等额本金：递减还款\n• 先息后本：按月付息\n• 一次性还款：到期还本\n\n📅 还款渠道：\n• 自动扣款（推荐）\n• 网银转账\n• 手机银行\n• 柜台还款\n\n建议使用贷款计算器提前规划还款方案！";
    }
    
    if ([lowerMessage containsString:@"条件"] || [lowerMessage containsString:@"要求"]) {
        return @"申请条件说明：\n\n✅ 基本条件：\n• 年龄：22-65周岁\n• 身份：中国大陆居民\n• 收入：有稳定收入来源\n\n📋 所需材料：\n• 身份证\n• 收入证明\n• 银行流水\n• 征信报告\n\n🎯 加分项：\n• 良好征信记录\n• 稳定工作单位\n• 房产车产等资产\n\n符合条件即可申请，通过率很高哦！";
    }
    
    if ([lowerMessage containsString:@"通过率"] || [lowerMessage containsString:@"提高"]) {
        return @"提高贷款通过率的小技巧：\n\n⭐ 征信优化：\n• 按时还款，维护征信\n• 减少征信查询次数\n• 结清不必要的小额贷款\n\n💪 资料完善：\n• 提供完整真实资料\n• 补充收入证明\n• 提供资产证明\n\n🎯 智能建议：\n• 使用AI智能顾问\n• 根据建议优化申请\n• 选择合适的贷款产品\n\n我们的AI系统会为您匹配最合适的方案！";
    }
    
    // 默认回复
    return @"感谢您的咨询！😊\n\n我可能没有完全理解您的问题，您可以：\n\n1️⃣ 尝试选择上方的常见问题\n2️⃣ 换个方式重新描述您的问题\n3️⃣ 联系人工客服：400-888-8888\n\n我会继续学习，为您提供更好的服务！";
}

- (void)scrollToBottom {
    if (self.messages.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ChatCell";
    JJRChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[JJRChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.message = self.messages[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JJRChatMessage *message = self.messages[indexPath.row];
    
    CGFloat width = CGRectGetWidth(tableView.frame) - 120; // 减去头像和边距
    CGFloat height = [message.content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}
                                                   context:nil].size.height;
    
    return MAX(60, height + 40); // 最小高度60，内容高度+边距
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    return YES;
}

@end

#pragma mark - JJRChatCell

@implementation JJRChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setMessage:(JJRChatMessage *)message {
    _message = message;
    [self updateUI];
}

- (void)updateUI {
    // 清除之前的子视图
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    // 头像
    UILabel *avatarLabel = [[UILabel alloc] init];
    avatarLabel.text = self.message.isFromUser ? @"👤" : @"🤖";
    avatarLabel.font = [UIFont systemFontOfSize:24];
    avatarLabel.textAlignment = NSTextAlignmentCenter;
    avatarLabel.backgroundColor = self.message.isFromUser ? 
        [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.1] : 
        [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    avatarLabel.layer.cornerRadius = 20;
    avatarLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:avatarLabel];
    
    // 消息气泡
    UIView *bubbleView = [[UIView alloc] init];
    bubbleView.backgroundColor = self.message.isFromUser ? 
        [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0] : 
        [UIColor whiteColor];
    bubbleView.layer.cornerRadius = 12;
    bubbleView.layer.shadowColor = [UIColor blackColor].CGColor;
    bubbleView.layer.shadowOffset = CGSizeMake(0, 1);
    bubbleView.layer.shadowOpacity = 0.1;
    bubbleView.layer.shadowRadius = 2;
    [self.contentView addSubview:bubbleView];
    
    // 消息内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = self.message.content;
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.textColor = self.message.isFromUser ? [UIColor whiteColor] : [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    contentLabel.numberOfLines = 0;
    if (self.message.isTyping) {
        contentLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        contentLabel.font = [UIFont italicSystemFontOfSize:16];
    }
    [bubbleView addSubview:contentLabel];
    
    // 时间标签
    UILabel *timeLabel = [[UILabel alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    timeLabel.text = [formatter stringFromDate:self.message.timestamp];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    [self.contentView addSubview:timeLabel];
    
    // 布局
    if (self.message.isFromUser) {
        // 用户消息居右
        [avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-16);
            make.top.equalTo(self.contentView).offset(12);
            make.width.height.equalTo(@40);
        }];
        
        [bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(avatarLabel.mas_left).offset(-8);
            make.top.equalTo(self.contentView).offset(12);
            make.left.greaterThanOrEqualTo(self.contentView).offset(80);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bubbleView);
            make.top.equalTo(bubbleView.mas_bottom).offset(4);
        }];
    } else {
        // AI消息居左
        [avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.contentView).offset(12);
            make.width.height.equalTo(@40);
        }];
        
        [bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(avatarLabel.mas_right).offset(8);
            make.top.equalTo(self.contentView).offset(12);
            make.right.lessThanOrEqualTo(self.contentView).offset(-80);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bubbleView);
            make.top.equalTo(bubbleView.mas_bottom).offset(4);
        }];
    }
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bubbleView).inset(12);
    }];
}

@end 