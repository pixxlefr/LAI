// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

#import "TorchModule.h"

#include <torch/script.h>
#include <torch/csrc/jit/mobile/import.h>

@interface TorchModule ()
@end

@interface TorchTensor ()
- (instancetype)initWithTensor:(at::Tensor &&)tensor;
- (at::Tensor)tensor;
@end

@implementation TorchModule {
    torch::jit::mobile::Module _module;
    bool _loaded;
}

- (instancetype)initWithFileAtPath:(NSString *)filePath {
    self = [super init];
    if (self) {
        try {
            _module = torch::jit::_load_for_mobile(filePath.UTF8String);
            _loaded = true;
        } catch (const std::exception &e) {
            NSLog(@"[LAI] Failed to load model: %s", e.what());
            _loaded = false;
            return nil;
        }
    }
    return self;
}

- (TorchTensor *)forward:(NSArray<TorchTensor *> *)inputs {
    if (!_loaded) {
        return nil;
    }

    std::vector<torch::jit::IValue> ivals;
    ivals.reserve(inputs.count);
    for (TorchTensor *input in inputs) {
        ivals.push_back([input tensor]);
    }

    try {
        torch::jit::IValue output = _module.forward(ivals);
        if (output.isTensor()) {
            at::Tensor tensor = output.toTensor();
            return [[TorchTensor alloc] initWithTensor:std::move(tensor)];
        }
        if (output.isTuple()) {
            auto tuple = output.toTuple();
            if (!tuple->elements().empty() && tuple->elements()[0].isTensor()) {
                at::Tensor tensor = tuple->elements()[0].toTensor();
                return [[TorchTensor alloc] initWithTensor:std::move(tensor)];
            }
        }
    } catch (const std::exception &e) {
        NSLog(@"[LAI] Forward failed: %s", e.what());
    }

    return nil;
}

@end
