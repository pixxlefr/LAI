// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TorchDType) {
    TorchDTypeInt64 = 0,
    TorchDTypeFloat32 = 1
};

@interface TorchTensor : NSObject
+ (instancetype)fromBlob:(void *)data shape:(NSArray<NSNumber *> *)shape dtype:(TorchDType)dtype;
- (void *)data;
- (NSArray<NSNumber *> *)shape;
@end

NS_ASSUME_NONNULL_END
