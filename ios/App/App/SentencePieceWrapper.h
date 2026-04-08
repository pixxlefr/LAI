// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SentencePieceWrapper : NSObject
- (instancetype)initWithModelPath:(NSString *)modelPath error:(NSError **)error;
- (NSArray<NSNumber *> *)encode:(NSString *)text;
- (NSString *)decode:(NSArray<NSNumber *> *)ids;
- (int)pieceId:(NSString *)piece;
- (NSString *)piece:(int)pieceId;
@end

NS_ASSUME_NONNULL_END
