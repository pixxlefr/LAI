// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

#import <Foundation/Foundation.h>
#import "TorchTensor.h"

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject
- (nullable instancetype)initWithFileAtPath:(NSString *)filePath;
- (nullable TorchTensor *)forward:(NSArray<TorchTensor *> *)inputs;
@end

NS_ASSUME_NONNULL_END
