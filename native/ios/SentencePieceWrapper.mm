// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

#import "SentencePieceWrapper.h"

#include <sentencepiece_processor.h>

@interface SentencePieceWrapper ()
@end

@implementation SentencePieceWrapper {
    sentencepiece::SentencePieceProcessor *_processor;
}

- (instancetype)initWithModelPath:(NSString *)modelPath error:(NSError **)error {
    self = [super init];
    if (self) {
        _processor = new sentencepiece::SentencePieceProcessor();
        auto status = _processor->Load([modelPath UTF8String]);
        if (!status.ok()) {
            if (error) {
                NSString *message = [NSString stringWithUTF8String:status.ToString().c_str()];
                *error = [NSError errorWithDomain:@"SentencePiece" code:-1 userInfo:@{NSLocalizedDescriptionKey: message}];
            }
            delete _processor;
            _processor = nullptr;
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    if (_processor != nullptr) {
        delete _processor;
        _processor = nullptr;
    }
}

- (NSArray<NSNumber *> *)encode:(NSString *)text {
    std::vector<int> ids;
    _processor->Encode([text UTF8String], &ids);

    NSMutableArray<NSNumber *> *result = [NSMutableArray arrayWithCapacity:ids.size()];
    for (int tokenId : ids) {
        [result addObject:@(tokenId)];
    }
    return result;
}

- (NSString *)decode:(NSArray<NSNumber *> *)ids {
    std::vector<int> input;
    input.reserve(ids.count);
    for (NSNumber *value in ids) {
        input.push_back([value intValue]);
    }

    std::string text;
    _processor->Decode(input, &text);
    return [NSString stringWithUTF8String:text.c_str()];
}

- (int)pieceId:(NSString *)piece {
    return _processor->PieceToId([piece UTF8String]);
}

- (NSString *)piece:(int)pieceId {
    std::string piece;
    _processor->IdToPiece(pieceId, &piece);
    return [NSString stringWithUTF8String:piece.c_str()];
}

@end
