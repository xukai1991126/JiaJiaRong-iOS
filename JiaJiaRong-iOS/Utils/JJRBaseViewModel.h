//
//  JJRBaseViewModel.h
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JJRBaseViewModelDelegate <NSObject>

@optional
- (void)viewModelDidStartLoading;
- (void)viewModelDidFinishLoading;
- (void)viewModelDidFailWithError:(NSError *)error;
- (void)viewModelDidUpdateData;

@end

@interface JJRBaseViewModel : NSObject

@property (nonatomic, weak) id<JJRBaseViewModelDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, strong, readonly) NSError *lastError;

- (void)startLoading;
- (void)finishLoading;
- (void)failWithError:(NSError *)error;
- (void)updateData;

@end

NS_ASSUME_NONNULL_END 
