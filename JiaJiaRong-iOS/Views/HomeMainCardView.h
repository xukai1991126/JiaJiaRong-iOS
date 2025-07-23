//
//  HomeMainCardView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/20.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeMainCardViewDelegate <NSObject>

- (void)mainCardViewDidTapLoginButton;
- (void)mainCardViewDidToggleProtocol:(BOOL)checked;
- (void)mainCardViewDidTapServiceAgreement;
- (void)mainCardViewDidTapPrivacyAgreement;

@end

@interface HomeMainCardView : UIView

@property (nonatomic, weak) id<HomeMainCardViewDelegate> delegate;
@property (nonatomic, strong) NSString *maxAmount;
@property (nonatomic, strong) NSString *maxPeriod;
@property (nonatomic, strong) NSString *loginButtonTitle;
@property (nonatomic, assign) BOOL showProtocolCheckbox;
@property (nonatomic, assign) BOOL protocolChecked;

- (void)updateCardContent;

@end

NS_ASSUME_NONNULL_END 