//
//  JJRBaseViewModel.m
//  JiaJiaRong-iOS
//
//  Created by xinglei on 2025/10719.
//  Copyright © 2025年 JiaJiaRong. All rights reserved.
//

#import "JJRBaseViewModel.h"

@interface JJRBaseViewModel ()

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSError *lastError;

@end

@implementation JJRBaseViewModel

- (void)startLoading {
    self.isLoading = YES;
    self.lastError = nil;
    
    if ([self.delegate respondsToSelector:@selector(viewModelDidStartLoading)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate viewModelDidStartLoading];
        });
    }
}

- (void)finishLoading {
    self.isLoading = NO;
    
    if ([self.delegate respondsToSelector:@selector(viewModelDidFinishLoading)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate viewModelDidFinishLoading];
        });
    }
}

- (void)failWithError:(NSError *)error {
    self.isLoading = NO;
    self.lastError = error;
    
    if ([self.delegate respondsToSelector:@selector(viewModelDidFailWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate viewModelDidFailWithError:error];
        });
    }
}

- (void)updateData {
    if ([self.delegate respondsToSelector:@selector(viewModelDidUpdateData)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate viewModelDidUpdateData];
        });
    }
}

@end 
