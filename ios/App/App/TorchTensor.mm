// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

#import "TorchTensor.h"

#include <torch/torch.h>

@interface TorchTensor ()
@end

@implementation TorchTensor {
    at::Tensor _tensor;
}

+ (instancetype)fromBlob:(void *)data shape:(NSArray<NSNumber *> *)shape dtype:(TorchDType)dtype {
    std::vector<int64_t> dims;
    dims.reserve(shape.count);
    for (NSNumber *value in shape) {
        dims.push_back(value.longLongValue);
    }

    at::ScalarType scalarType = at::kLong;
    if (dtype == TorchDTypeFloat32) {
        scalarType = at::kFloat;
    }

    at::Tensor tensor = torch::from_blob(data, dims, torch::TensorOptions().dtype(scalarType)).clone();
    TorchTensor *wrapper = [[TorchTensor alloc] initWithTensor:std::move(tensor)];
    return wrapper;
}

- (instancetype)initWithTensor:(at::Tensor &&)tensor {
    self = [super init];
    if (self) {
        _tensor = std::move(tensor);
    }
    return self;
}

- (void *)data {
    _tensor = _tensor.to(torch::kCPU).contiguous();
    return _tensor.data_ptr();
}

- (NSArray<NSNumber *> *)shape {
    NSMutableArray<NSNumber *> *result = [NSMutableArray arrayWithCapacity:_tensor.dim()];
    for (auto dim : _tensor.sizes()) {
        [result addObject:@(dim)];
    }
    return result;
}

- (at::Tensor)tensor {
    return _tensor;
}

@end
