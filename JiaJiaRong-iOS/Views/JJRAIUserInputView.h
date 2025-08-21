//
//  JJRAIUserInputView.h
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJRAILoanAdvice.h"

NS_ASSUME_NONNULL_BEGIN

@class JJRAIUserInputView;

@protocol JJRAIUserInputViewDelegate <NSObject>

- (void)userInputView:(JJRAIUserInputView *)view didUpdateUserProfile:(JJRAIUserProfile *)profile;

@end

@interface JJRAIUserInputView : UIView

@property (nonatomic, weak) id<JJRAIUserInputViewDelegate> delegate;
@property (nonatomic, strong) JJRAIUserProfile *userProfile;

- (void)resetInputs;
- (BOOL)validateInputs;

@end

NS_ASSUME_NONNULL_END 
