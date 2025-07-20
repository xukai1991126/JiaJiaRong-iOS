//
//  JJRAIQuickInputView.h
//  JiaJiaRong-iOS
//
//  Created by Assistant on 2024/12/19.
//  Copyright © 2024年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRAILoanAdvice.h"

NS_ASSUME_NONNULL_BEGIN

@class JJRAIQuickInputView;

@protocol JJRAIQuickInputViewDelegate <NSObject>

- (void)quickInputView:(JJRAIQuickInputView *)view didUpdateUserProfile:(JJRAIUserProfile *)profile;

@end

@interface JJRAIQuickInputView : UIView

@property (nonatomic, weak) id<JJRAIQuickInputViewDelegate> delegate;
@property (nonatomic, strong, readonly) JJRAIUserProfile *userProfile;

- (BOOL)hasValidSelection;
- (void)resetToDefault;

@end

NS_ASSUME_NONNULL_END 